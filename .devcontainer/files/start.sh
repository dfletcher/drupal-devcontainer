#!/bin/bash

. /workspace/.env

BASEHTML="/var/www/html"
DOCROOT="/var/www/html/web"
DRUSH="/.composer/vendor/drush/drush/drush"
GRPID=$(stat -c "%g" /var/lib/mysql/)
LOCAL_IP=$(hostname -I| awk '{print $1}')
HOSTIP=$(/sbin/ip route | awk '/default/ { print $3 }')
echo "${HOSTIP} dockerhost" >> /etc/hosts
echo "Started Container: $(date)"

DEV_MODULES_ENABLED+=($(ls /workspace/modules))
DEV_MODULES_ENABLED+=($(ls /workspace/.base/modules))
DEV_MODULES_ENABLED+=($(ls /workspace/features))
DEV_MODULES_ENABLED+=($(ls /workspace/.base/features))
DEV_THEMES_ENABLED+=($(ls /workspace/themes))
DEV_THEMES_ENABLED+=($(ls /workspace/.base/themes))

# Create a basic mysql install
if [ ! -d /var/lib/mysql/mysql ]; then
  echo "**** No MySQL data found. Creating data on /var/lib/mysql/ ****"
  mysqld --initialize-insecure
else
  echo "**** MySQL data found on /var/lib/mysql/ ****"
fi

# Start supervisord
supervisord -c /etc/supervisor/conf.d/supervisord.conf -l /tmp/supervisord.log

# Run composer install or composer create-project
cd ${BASEHTML}
echo "**** composer install ****"
if [ ! -f ${DOCROOT}/index.php ]; then
  echo "**** No Drupal found, setting up directories. ****"
  #rm -rf /var/www/drupal
  composer create-project --no-interaction 2>&1 | tee /tmp/composer-create-project.log
  chmod a+w ${DOCROOT}/sites/default;
  mkdir ${DOCROOT}/sites/default/files;
  wget "http://www.adminer.org/latest.php" -O ${DOCROOT}/adminer.php
  chown -R www-data:${GRPID} ${DOCROOT}
  chmod -R ug+w ${DOCROOT}
else
  echo "**** ${DOCROOT}/index.php found. ****"
  composer install --no-interaction | tee /tmp/composer-install.log
fi

# Setup Drupal if services.yml or settings.php is missing
if ( ! grep -q 'database.*=>.*drupal' ${DOCROOT}/sites/default/settings.php 2>/dev/null); then
  # Generate random passwords
  DRUPAL_DB="drupal"
  DEBPASS=$(grep password /etc/mysql/debian.cnf |head -n1|awk '{print $3}')
  ROOT_PASSWORD=`pwgen -c -n -1 12`
  DRUPAL_PASSWORD=`pwgen -c -n -1 12`
  echo ${ROOT_PASSWORD} > /var/lib/mysql/mysql/mysql-root-pw.txt
  echo ${DRUPAL_PASSWORD} > /var/lib/mysql/mysql/drupal-db-pw.txt
  # Wait for mysql
  echo -n "Waiting for mysql "
  while ! mysqladmin status >/dev/null 2>&1;
     do echo -n . ; sleep 1;
  done;
  echo;
  # Create and change MySQL creds
  mysqladmin -u root password ${ROOT_PASSWORD} 2>/dev/null
  mysql -uroot -p${ROOT_PASSWORD} -e \
        "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY '$DEBPASS';" 2>/dev/null
  mysql -uroot -p${ROOT_PASSWORD} -e \
        "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'%' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;" 2>/dev/null
  cd ${DOCROOT}
  cp sites/default/default.settings.php sites/default/settings.php
  ${DRUSH} site-install standard -y --account-name=admin --account-pass=admin \
           --db-url="mysql://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal" \
           --site-name="${SITE_NAME}" | grep -v 'continue?' 2>/dev/null
else
  echo "**** ${DOCROOT}/sites/default/settings.php database found ****"
  ROOT_PASSWORD=$(cat /var/lib/mysql/mysql/mysql-root-pw.txt)
  DRUPAL_PASSWORD=$(cat /var/lib/mysql/mysql/drupal-db-pw.txt)
fi

# Change root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Clear caches and reset files perms
chown -R www-data:${GRPID} ${DOCROOT}/sites/default/
chmod -R ug+w ${DOCROOT}/sites/default/
chown -R mysql:${GRPID} /var/lib/mysql/
chmod -R ug+w /var/lib/mysql/

for x in ${DEV_MODULES_ENABLED[@]}; do
  ${DRUSH} pm-enable "${x}"
done

for x in ${DEV_MODULES_ENABLED[@]}; do
  ${DRUSH} pm-uninstall "${x}"
done

for x in ${DEV_MODULES_ENABLED[@]}; do
  ${DRUSH} pm-enable "${x}"
done

for x in ${DEV_THEMES_DISABLED[@]}; do
  ${DRUSH} pm-uninstall "${x}"
done

find -type d -exec chmod +xr {} \;
(sleep 3; drush --root=${DOCROOT}/ cache-rebuild 2>/dev/null) &

# echo
# echo "---------------------- USERS CREDENTIALS ($(date +%T)) -------------------------------"
# echo
# echo "    DRUPAL:  http://${LOCAL_IP}              with user/pass: admin/admin"
# echo
# echo "    MYSQL :  http://${LOCAL_IP}/adminer.php  drupal/${DRUPAL_PASSWORD} or root/${ROOT_PASSWORD}"
# echo "    SSH   :  ssh root@${LOCAL_IP}            with user/pass: root/${ROOT_PASSWORD}"
# echo
# echo "  Please report any issues to https://github.com/ricardoamaro/drupal8-docker-app"
# echo "  USE CTRL+C TO STOP THIS APP"
# echo
# echo "------------------------------ STARTING SERVICES ---------------------------------------"

# tail -f /tmp/supervisord.log

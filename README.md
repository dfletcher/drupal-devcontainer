# Drupal Devcontainer

Full featured IDE for Drupal based on VSCode and Docker Desktop. Drupal and all system deps in a development container, project management tools, text editor, debugger, shell, version control, and preview all in one integrated environment.

![Drupal Devcontainer in action](https://i.imgur.com/5l0Fbgq.png)


##### :warning: Do not clone this repository. Fork it first!
>
> **Note:** This repository is designed to be used as the basis of a Drupal website project. Therefore you should fork the repository, set this repository as "upstream" remote, and commit changes to your own repository. See [start a project](#start-a-project) section below. If your intention is to test out this system without creating a new project, then feel free to clone directly. Detailed usage instructions follow. 

### Contents

1. [Requirements](#requirements)
1. [Features](#features)
1. [Directory layout](#directory-layout)
1. [Supported workflows](#supported-workflows)

### Requirements
:ballot_box_with_check:  Install [Docker Desktop](https://www.docker.com/products/docker-desktop). Note that Docker Desktop is not supported in all versions of Windows unfortunately.

:ballot_box_with_check: Install [VSCode](https://code.visualstudio.com/).

:ballot_box_with_check: From the VSCode extension manager, install the [Remote Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.

:ballot_box_with_check: Additionally, you may need to configure the disk your project directory lives on as a Docker Desktop shared drive. If some shell (eg PowerShell) code appears when you enable a share, it is important to run that code in a terminal.

:warning: This software is brand new and is currently only tested in Windows 10 Pro. It should run on MacOS but this is untested. Feedback welcome via issue queue or pull request.

### Features

- Complete Drupal IDE
- Primary support for familiar tools: Composer, Drush, Drupal console
- One touch up development virtual machine
- Important working directories live in project root
- Lightweight: Drupal is not installed into project repository
- Extensible... other kinds of Drupal setups are supported with base features, modules, or themes
- Deployment to shared hosts or cloud (planned)

These goals are achieved using [Docker Desktop](https://www.docker.com/products/docker-desktop) and [Microsoft's VSCode](https://code.visualstudio.com/). The development virtual machine Docker code is based on [Ricardo Amaro's drupal8-docker-app](https://github.com/ricardoamaro/drupal8-docker-app). It uses Ubuntu, Apache, Mysql, Memcached. This stack may eventually change to a lighter weight setup using Alpine and Nginx.

[Primary supported workflows](#workflows) are documented below.

See [Directory layout](#directory-layout) for details on the repository files and directories.

### Directory layout:

`./modules` Custom modules for the site. All modules in this directory will be automatically enabled on container build.

`./themes` Custom themes for the site. All themes in this directory will be automatically enabled on container build.

`./features` Configuration via Features that should be applied to all environments (dev, qa, staging, production etc). All feature modules in this directory will be automatically enabled on container build. When generating features from development environment, specify output directory `/var/www/html/web/modules/custom_features`.

`./ENV` Environment variables file. In here you can specify your site name, local admin credentials, modules that should be enabled at installation time, etc.

`./.composer.json` Project composer file. This repository contains a default composer.json. It can be extended / modified for your website project and through [forks](#create-an-extended-drupal-devcontainer-for-reuse) of this project.

`./.base` This directory can contain modules, themes, features that are not the primary target of the current website. It is meant to create reusable distributions based on forks of Drupal Devcontainer. TODO: examples e.g. commerce focused setup.

`./.devcontainer, ./.vscode` These contain VSCode development files. Only needs changes if you intend to modify the development stack (Ubuntu, Apache, PHP, MariaDB, Memcached) or installation procedures.

### Supported workflows:
 - [Start a project](#start-a-project)
 - [Create a new theme](#create-a-new-theme)
 - [Create a new module](#create-a-new-module)
 - [Install a third party theme](#install-a-third-party-theme)
 - [Install a third party module](#install-a-third-party-module)
 - [Use mysql in development VM](#use-mysql-in-development-vm)
 - [Dump devlopment VM database](#dump-devlopment-vm-database)
 - [Update modules](#update-modules)
 - [Update Drupal core](#update-drupal-core)
 - [Update Drupal Devcontainer](#update-drupal-devcontainer)
 - [Create an extended Drupal Devcontainer for reuse](#create-an-extended-drupal-devcontainer-for-reuse)

Planned but not yet available:
 - Auto-import project SQL file into development VM database
 - Automatically generate projects with a generator tool
 - Unit, functional, system tests
 - [Deploy to remote server](#deploy-to-remote-server)

Don't see a workflow that is important to you? Pull requests and discussion is welcome!

### Start a project:

:ballot_box_with_check: [Fork this project](https://github.com/dfletcher/drupal-devcontainer) named for new website. Private websites should use a private fork or otherwise privately hosted repository.

:ballot_box_with_check: Clone your new fork.

:ballot_box_with_check: Add this repository as "upstream" remote. 

```bash
    $ git remote add upstream https://github.com/dfletcher/drupal-devcontainer.git
```

:ballot_box_with_check: Edit `ENV` file `SITE_NAME` and other optional details. Add commit push your `ENV` changes.

:ballot_box_with_check: In VSCode, open the cloned folder using the `File -> Open folder...` menu. The following dialog box should appear. Click "Reopen in Container".

![Reopen in container dialog](https://i.imgur.com/gbxhzh4.png)

If this dialog is not open, you can do the same thing under the `F1` menu or the green button lower left of VSCode, select "Remote-Containers: Reopen Folder in container".

- Wait a while until you see the project files again.

- Browse to http://localhost and start building your site!

A generator is in the works to make this process easier. Check back soon for details.

### Create a new theme

#### Use Drush to create new theme

#### Add third party theme as dependency

### Create a new module

#### Use Drush to create new module

#### Add third party modules as dependencies

### Install a third party theme

:warning: If the theme you are installing is a requirement, a base theme for your custom theme you are building, consider [adding it as a theme dependency](#add-third-party-theme-as-dependency) instead of adding it to the top level `composer.json` as described here.

:ballot_box_with_check: Perform the following commands, replace `acmetheme` with the project name of the theme as given on drupal.org. 

```bash
    $ cd /var/www/html
    $ composer require drupal/acmetheme
    $ drush en acmetheme
    $ drush cr
```

:ballot_box_with_check: Add and commit the changes to `composer.json` into Git with a message about adding a new third party theme.

### Install a third party module

:warning: If the module you are installing is a requirement for a custom module you are building, consider [adding it as a module dependency](#add-third-party-module-as-dependency) instead of adding it to the top level `composer.json` as described here.

:ballot_box_with_check: Perform the following commands, replace `acmewidget` with the project name of the module as given on drupal.org. 

```bash
    $ cd /var/www/html
    $ composer require drupal/acmewidget
    $ drush en acmewidget
    $ drush cr
```

:ballot_box_with_check: Add and commit the changes to `composer.json` into Git with a message about adding a new third party module and the purpose of it.

### Use mysql in development VM

:ballot_box_with_check: Perform the following command.

```bash
    $ drupaldb
```

This `mysql` shortcut script with user credentials and database name lives in `/usr/local/bin/drupaldb`.

### Dump devlopment VM database

:ballot_box_with_check: Perform the following commands. Replace `acmewidgets_com` with an approriate file name.

```bash
    $ cd /workspace
    $ drupaldbdump > acmewidgets_com.sql
```

This `mysqldump` shortcut script with user credentials and database name lives in `/usr/local/bin/drupaldbdump`. The script dumps SQL to stdout.

### Deploy to remote server

**Under construction.** This is a complex topic that will receive more attention when the basics are more nailed down. It will certainly involve external tools not currently mentioned in this document. The basic idea will be the ability to quickly deploy Drupal Devcontainer projects and all deps to external shared or dedicated hosts.

### Update modules

:ballot_box_with_check: Run the following commands in a terminal [as described on drupal.org](https://www.drupal.org/docs/8/update/update-modules):

```bash
    $ cd /var/www/html
    $ composer outdated 'drupal/*'
    $ drush pm:security
```

These commands will give you a list of modules that need to be updated.

:ballot_box_with_check: For each outdated module, run the following command, replacing "modulename" with the project name of the outdated module.

```bash
    $ composer update drupal/modulename --with-dependencies
```

:ballot_box_with_check: Test your development site. If all is well, add commit push your changes:

```bash
    $ cd /workspace
    $ git add .
    $ git commit -m "Modules update."
    $ git push origin master
```

### Update Drupal core

:ballot_box_with_check: Run the following commands in a terminal [as described on drupal.org](https://www.drupal.org/docs/8/update/update-core-via-composer):

    $ composer outdated "drupal/*"
    $ composer update --dry-run
    $ composer outdated "drupal/*"

:ballot_box_with_check: If there is no line starting with `drupal/core`, Composer isn't aware of any update. If there is an update, continue with commands below.

```bash
    $ composer update drupal/core --with-dependencies
    $ drush updatedb
    $ drush cr
```

:ballot_box_with_check: Test your development site. If all is well, add commit push your changes:

```bash
    $ cd /workspace
    $ git add .
    $ git commit -m "Drupal core update to [VERSION]."
    $ git push origin master
```

### Update Drupal Devcontainer

:ballot_box_with_check: Ensure you have created an "upstream" remote as described above under [Start a project](#start-a-project).

:ballot_box_with_check: Pull upstream changes to the dev environment using:

```bash
    $ cd /workspace
    $ git pull upstream master
    $ git commit -m "Merged upstream."
    $ git push origin master
```

### Create an extended Drupal Devcontainer for reuse

Drupal Devcontainer is designed to be extended.

:ballot_box_with_check: Fork and set upstream remote the same way as [described above](#start-a-project).

:ballot_box_with_check: Create a `composer.json` that describes your base setup. This includes any third party modules and themes that all sites using the project template will need. For example, for Drupal Commerce related setups `composer.json` would contain drupal/commerce and related modules for payment gateways and shipping.

:ballot_box_with_check: Capture any module configuration using Features (Configuration -> Development -> Features). When generating the features module, use `modules/custom_base_features` as the output path. Write modules directly into there instead of using the "Download" button. Generated features will appear outside the VM in `.base/features`.

:ballot_box_with_check: Put any custom themes or modules (that are not available on drupal.org) into `.base/themes` and `.base/modules`, respectively.

:ballot_box_with_check: Modify `ENV`. Change `SITE_NAME` to the name of your extended Drupal Devcontainer. Add any modules you want enabled by default to `DEV_MODULES_ENABLED` etc.

:ballot_box_with_check: If possible, avoid changing `.devcontainer/Dockerfile` and `.devcontainer/files/*`. If these remain unchanged, the Docker image `davefletcher/drupal-devcontainer` specified in `docker-compose.yml` will work fine. If you do change it, comment out `image:` and uncomment the `build:` lines below it in `docker-compose.yml` to get Docker Desktop / VSCode to rebuild the image locally. After testing, configure https://cloud.docker.com/ to build an image from your repository. Once the image is ready, uncomment `image:` again but specify your new image and disable the `build:` block again. Do not distribute `docker-compose.yml` with the build instructions uncommented as it results in *extremely* slow builds. *Note: this is only necessary if you want to change the system stack.* 

:ballot_box_with_check: Add commit push your changes in git.

```bash
    $ cd /workspace
    $ git add .
    $ git commit -m "Initial git import."
    $ git push origin master
```

:ballot_box_with_check: To use your extended Drupal Devcontainer in a website project, follow the instructions above under [start a project](#start-a-project) except fork your fork, not the original!

:ballot_box_with_check: Test thoroughly and publish your customized Drupal Devcontainer on Github, Gitlab, or BitBucket! Note: in the near future a generator will become available which will help users choose an approriate setup. Keep an eye on here for upcoming details on how to submit your fork as a selection for this generator tool.


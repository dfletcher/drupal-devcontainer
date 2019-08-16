#!/bin/bash

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf -l /tmp/supervisord.log
/usr/bin/tail -f /tmp/supervisord.log

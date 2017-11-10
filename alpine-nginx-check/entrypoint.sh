#!/bin/bash

crond -l 8 -L /tmp/cron.log

nginx -c /etc/nginx/conf/nginx.conf -g 'daemon off;'

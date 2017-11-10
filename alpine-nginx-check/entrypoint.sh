#!/bin/bash

crond -l 8 -L /tmp/cron.log

nginx -g 'daemon off;'

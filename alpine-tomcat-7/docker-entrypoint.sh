#!/bin/bash

set -e

if [[ ! -d /opt/htdocs/webapp ]] && [[ ! -d /opt/htdocs/logs ]]; then
  mkdir -p /opt/htdocs/{webapp,logs}
fi

if [[ -n "$MOXMS" ]] && [[ -n "$MOXMX" ]]; then
   echo "MOXMS: $MOXMS "
   echo "MOXMX: $MOXMX "
else
   echo " [Error] MOXMS OR MOXMX NULL "
fi

echo "-------------------------------------------------------------------------------"
CMD="/opt/local/tomcat/bin/catalina.sh run"
trap "kill -15 -1" EXIT KILL
exec $CMD

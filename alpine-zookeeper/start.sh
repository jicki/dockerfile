#!/bin/bash

echo ${NODE_ID:-1} >/opt/zookeeper/data/myid
echo "NODES: $NODES"
# update config regarding env variables
if [[ -n "$NODES" ]]; then
  i=0
  for n in $(echo $NODES | awk  'BEGIN {RS=","}{print}'); do
    ((i++))
    node="$(echo $n | cut -d: -f1)"
    p2="$(echo $n: | cut -d: -f2)"
    p3="$(echo $n: | cut -d: -f3)"
    echo "server.$i=${node}:${p2:-2888}:${p3:-3888}" >> conf/zoo.cfg
  done
fi
echo "-------------------------------------------------------------------------------"
echo "zookeeper.properties file"
cat conf/zoo.cfg
echo "-------------------------------------------------------------------------------"
CMD="/opt/zookeeper/bin/zkServer.sh start-foreground conf/zoo.cfg"
trap "kill -15 -1" EXIT KILL

exec $CMD

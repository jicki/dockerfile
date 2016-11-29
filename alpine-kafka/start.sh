#!/bin/bash


echo "NODE_ID: $NODE_ID"
# update config env
if [[ -n "$NODE_ID" ]]; then
  sed -i "s/broker.id=0/broker.id=$NODE_ID/g" /opt/kafka/config/server.properties
fi

echo "ZK_NODES: $ZK_NODES"
# update config regarding env variables
if [[ -n "$ZK_NODES" ]]; then
  sed -i 's/zookeeper.connect/#zookeeper.connect/g' /opt/kafka/config/server.properties
    echo zookeeper.connect=$ZK_NODES |awk -F, '{$NF=$NF":"2181}1' OFS=":2181," >> /opt/kafka/config/server.properties
fi
echo "-------------------------------------------------------------------------------"
echo "server.properties file"
cat /opt/kafka/config/server.properties
echo "-------------------------------------------------------------------------------"
CMD="/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties"
trap "kill -15 -1" EXIT KILL

exec $CMD
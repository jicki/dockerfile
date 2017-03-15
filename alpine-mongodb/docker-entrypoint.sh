#!/bin/bash
set -e

if [ "${1:0:1}" = '-' ]; then
    set -- mongod "$@"
fi

if [ ! -d "/opt/local/mongodb/data/shard" ]; then
    mkdir -p /opt/local/mongodb/data/shard 
    mkdir -p /opt/local/mongodb/data/logs
    mkdir -p /opt/local/mongodb/data/config
fi

# allow the container to be started with `--user`
# all mongo* commands should be dropped to the correct user
if [[ "$1" == mongo* ]] && [ "$(id -u)" = '0' ]; then
    if [ "$1" = 'mongod' ]; then
        chown -R mongodb /opt/local/mongodb
    fi
    exec gosu mongodb "$BASH_SOURCE" "$@"
fi

# you should use numactl to start your mongod instances, including the config servers, mongos instances, and any clients.
# https://docs.mongodb.com/manual/administration/production-notes/#configuring-numa-on-linux
if [[ "$1" == mongo* ]]; then
    numa='numactl --interleave=all'
    if $numa true &> /dev/null; then
        set -- $numa "$@"
    fi
fi

exec "$@"

# Create mongodb Replica Set

#echo "NODE_ID: $NODE_ID  MO_NODE: $MO_NODE "

#if [[ -n "$NODE_ID" ]] || [ "$NODE_ID" == 1 ] || [[ -n "$MO_NODE" ]]; then
#  i=0
#  for n in $(echo $MO_NODE | awk  'BEGIN {RS=","}{print}'); do
#    ((i++))
#    node="$(echo $n)"
#    eval host$i=$node
#  done
#sql="config= {_id: 'shard1', members: [ {_id:0,host:'$host1'},{_id:1,host:'$host2'},{_id:2,host:'$host3'},]};rs.initiate(config);"
#   echo $sql | mongo admin --shell
#fi

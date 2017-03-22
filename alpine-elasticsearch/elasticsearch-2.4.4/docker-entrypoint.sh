#!/bin/bash

set -e

if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

if [ "$1" = 'elasticsearch' -a "$(id -u)" = '0' ]; then
	# Change the ownership of user-mutable directories to elasticsearch
	for path in \
		/usr/share/elasticsearch/data \
		/usr/share/elasticsearch/logs \
	; do
		chown -R elasticsearch:elasticsearch "$path"
	done
	
	set -- su-exec elasticsearch "$@"
	#exec su-exec elasticsearch "$BASH_SOURCE" "$@"
fi

echo "cluster_name: $cluster_name"
echo "node_name: $node_name"
echo "cluster_list: $cluster_list" 
master_minimum=1

if  [ -n "$cluster_name" ] && [ -n "$node_name" ] && [ -n "$cluster_list" ];then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
cluster.name: $cluster_name
node.name: "$node_name"
node.master: true
node.data: true
network.publish_host: ${HOSTNAME}
network.host: 0.0.0.0
discovery.zen.ping.unicast.hosts: [$cluster_list]
discovery.zen.minimum_master_nodes: $[$master_minimum/2+1]
marvel.agent.enabled: false
action.auto_create_index: false
index.mapper.dynamic: false
EOF

else
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
network.host: 0.0.0.0
marvel.agent.enabled: false
action.auto_create_index: false
index.mapper.dynamic: false
EOF
fi

exec "$@"

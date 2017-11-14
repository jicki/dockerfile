#!/bin/bash

set -e

# Add elasticsearch as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- elasticsearch "$@"
fi

# Drop root privileges if we are running elasticsearch
# allow the container to be started with `--user`
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

echo "----------------ENV------------------------"

        echo "cluster_name: $cluster_name"
        echo "node_name: $node_name"
        echo "cluster_list: $cluster_list" 
        echo "master_minimum: $master_minimum"
        echo "http_cors_enabled: $http_cors_enabled"

echo "----------------ENV------------------------"


if  [ -n "$cluster_name" ] && [ -n "$node_name" ] && [ -n "$cluster_list" ] && [ -n "$master_minimum" ] && [ -n "$http_cors_enabled" ];then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
cluster.name: $cluster_name
node.name: "$node_name"
node.master: true
node.data: true
network.publish_host: ${HOSTNAME}
network.host: 0.0.0.0
discovery.zen.ping.unicast.hosts: [$cluster_list]
discovery.zen.minimum_master_nodes: $[$master_minimum/2+1]
action.auto_create_index: false
http.cors.enabled: true
http.cors.allow-origin: "*"
EOF

elif  [ -n "$cluster_name" ] && [ -n "$node_name" ] && [ -n "$cluster_list" ] && [ -n "$master_minimum" ];then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
cluster.name: $cluster_name
node.name: "$node_name"
node.master: true
node.data: true
network.publish_host: ${HOSTNAME}
network.host: 0.0.0.0
discovery.zen.ping.unicast.hosts: [$cluster_list]
discovery.zen.minimum_master_nodes: $[$master_minimum/2+1]
action.auto_create_index: false
EOF

else
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
network.host: 0.0.0.0
action.auto_create_index: false
EOF
fi

# for example a `bash` shell to explore this image
exec "$@"

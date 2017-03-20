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

if  [ -n "$cluster_name" ] && [ -n "$node_name" ] && [ -n "$web_user" ] && [ -n "$web_passwd" ] ;then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
cluster.name: $cluster_name
node.name: "$node_name"
node.master: true
node.data: true
network.publish_host: ${HOSTNAME}
marvel.agent.enabled: false
http.basic.enabled: true
http.basic.user: $web_user
http.basic.password: $web_passwd
action.auto_create_index: false
index.mapper.dynamic: false
EOF
elif [ ! -n "$cluster_name" ] && [ ! -n "$node_name" ] && [ -n "$web_user" ] && [ -n "$web_passwd" ];then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
marvel.agent.enabled: false
http.basic.enabled: true
http.basic.user: $web_user
http.basic.password: $web_passwd
action.auto_create_index: false
index.mapper.dynamic: false
EOF
elif [ -n "$cluster_name" ] && [ -n "$node_name" ] && [ ! -n "$web_user" ] && [ ! -n "$web_passwd" ] ;then
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
cluster.name: $cluster_name
node.name: "$node_name"
node.master: true
node.data: true
network.publish_host: ${HOSTNAME}
marvel.agent.enabled: false
http.basic.enabled: true
http.basic.user: admin
http.basic.password: moxian
action.auto_create_index: false
index.mapper.dynamic: false
EOF
else
cat > /usr/share/elasticsearch/config/elasticsearch.yml << EOF
marvel.agent.enabled: false
http.basic.enabled: true
http.basic.user: admin
http.basic.password: moxian
action.auto_create_index: false
index.mapper.dynamic: false
EOF
fi

exec "$@"

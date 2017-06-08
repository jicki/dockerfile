#!/bin/bash

set -e

echo "CODIS_TYPE: $CODIS_TYPE"

if [ $CODIS_TYPE = "codis_dashboard" ];
then

echo "coordinator : ${coord_name}"
echo "zk : ${coord_list}"
echo "product : ${prd_name}"
echo "password : ${prd_auth}"
echo "dashboard_name : ${prd_dashboard}"
echo "POD IP : ${POD_IP}"

cat > /opt/local/codis/config/config.ini << EOF
##################################################
#                                                #
#                  Codis-Dashboard               #
#                                                #
##################################################

# Set Coordinator, only accept "zookeeper" & "etcd" & "filesystem".
coordinator=${coord_name}
zk=${coord_list}

# Set Codis Product Name/Auth.
product=${prd_name}
dashboard_addr=${prd_dashboard}:18087
password=${prd_auth}

# Set configs.
backend_ping_period=5
session_max_timeout=1800
session_max_bufsize=131072
session_max_pipeline=1024
zk_session_timeout=30000
proxy_id=
EOF
 
echo "-------------------------------------------------------------------------------"
echo "dashboard config file"
cat /opt/local/codis/config/config.ini
echo "-------------------------------------------------------------------------------"

CMD="/opt/local/codis/bin/codis-config -c /opt/local/codis/config/config.ini -L /opt/local/codis/logs/dashboard.log dashboard --addr=${POD_IP}:18087 --http-log=/opt/local/codis/logs/requests.log"

elif [ $CODIS_TYPE = "codis_proxy" ];
then

echo "coordinator : ${coord_name}"
echo "zk : ${coord_list}"
echo "product : ${prd_name}"
echo "password : ${prd_auth}"
echo "proxy_id : ${prd_proxy}" 
echo "dashboard_name : ${prd_dashboard}"
echo "POD IP : ${POD_IP}"

cat > /opt/local/codis/config/config.ini << EOF
##################################################
#                                                #
#                  Codis_Proxy                   #
#                                                #
##################################################

# Set Coordinator, only accept "zookeeper" & "etcd" & "filesystem".
coordinator=${coord_name}
zk=${coord_list}

# Set Codis Product Name/Auth.
product=${prd_name}
dashboard_addr=${prd_dashboard}:18087
password=${prd_auth}

# Set configs.
backend_ping_period=5
session_max_timeout=1800
session_max_bufsize=131072
session_max_pipeline=1024
zk_session_timeout=30000
proxy_id=${prd_proxy}
EOF

echo "-------------------------------------------------------------------------------"
echo "------------------------------proxy config file--------------------------------"
cat /opt/local/codis/config/config.ini
echo "-------------------------------------------------------------------------------"

CMD="/opt/local/codis/bin/codis-proxy --log-level info -c /opt/local/codis/config/config.ini -L /opt/local/codis/logs/proxy.log  --cpu=4 --addr=${POD_IP}:19000 --http-addr=${POD_IP}:11000"

elif [ $CODIS_TYPE = "codis_server" ];
then
echo "maxmemory : ${MAXMEMORY}"

sed -i "s/^maxmemory.*$/maxmemory ${MAXMEMORY}/g" /opt/local/codis/config/redis.conf

echo "-------------------------------------------------------------------------------"
echo "-----------------------------redis.conf file-----------------------------------"
cat /opt/local/codis/config/redis.conf
echo "-------------------------------------------------------------------------------"

CMD="/opt/local/codis/bin/codis-server /opt/local/codis/config/redis.conf"

else
  echo " [Error] CODIS_TYPE Null OR MAXMEMORY Null"
  exit
fi

exec $CMD

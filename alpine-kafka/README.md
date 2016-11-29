
启动命令：

单机启动：
docker run -d -h="kafka-1" --name kafka-1 -e "ZK_NODES=zookeeper-1,zookeeper-2,zookeeper-3" --restart=always alpine-kafka


集群启动：
docker run -d -h="kafka-1" --name kafka-1 -e "NODE_ID=1" -e "ZK_NODES=zookeeper-1,zookeeper-2,zookeeper-3" --net=ovr0 --restart=always alpine-kafka

集群需要修改: NODE_ID 

-v  /opt/kafka/logs


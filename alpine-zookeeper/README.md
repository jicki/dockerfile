
启动命令：

docker <= 1.11 ：
docker run -d -h="zookeeper-1" --name zookeeper-1 -e "NODE_ID=1" -e "NODES=zookeeper-1,zookeeper-2,zookeeper-3" --net=ovr0 --restart=always alpine-zookeeper

docker >= 1.12 service ：
docker service create --name zookeeper-2 -e "NODE_ID=2" -e "NODES=zookeeper-1,zookeeper-2,zookeeper-3" --network ovr0 --endpoint-mode dnsrr  alpine-zookeeper


kubernetes 里：

在 k8s 里面  NODE_ID=1 , NODES="0.0.0.0,zookeeper-2,zookeeper-3"  




需要修改:  -h    --name    NODE_ID 

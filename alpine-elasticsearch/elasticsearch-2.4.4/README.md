
# 单机运行

```
docker run -d --name elasticsearch -p 9200:9200 elasticsearch 



#集群启动 集群必须配置 hostname (-h), master_minumin 等于 master 个数

docker run -d --name elasticsearch-1 -h elasticsearch-1 -e cluster_name=elasticsearch -e node_name=node-1 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minumin=3 --net=overlay -p 9200:9200 elasticsearch

docker run -d --name elasticsearch-2 -h elasticsearch-2 -e cluster_name=elasticsearch -e node_name=node-2 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minumin=3 --net=overlay -p 9200:9200 elasticsearch

docker run -d --name elasticsearch-3 -h elasticsearch-3 -e cluster_name=elasticsearch -e node_name=node-3 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minumin=3 --net=overlay -p 9200:9200 elasticsearch

```


# 集群部署

```
# docker-compose  集群必须配置 hostname , 且 hostname 名称必须 集群内可以通信

        elasticsearch-1:
                image: elasticsearch
                networks:
                        network-test:
                                aliases:
                                        - elasticsearch
                hostname: elasticsearch-1
                container_name: elasticsearch-1
                environment:
                - cluster_name=elasticsearch
                - node_name=node-1
                - master_minumin=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                volumes:
                - /opt/upload/elasticsearch-1/data:/usr/share/elasticsearch/data
                - /opt/upload/elasticsearch-1/logs:/usr/share/elasticsearch/logs

        elasticsearch-2:
                image: elasticsearch
                networks:
                        network-test:
                                aliases:
                                        - elasticsearch
                hostname: elasticsearch-2
                container_name: elasticsearch-2
                environment:
                - cluster_name=elasticsearch
                - node_name=node-2
                - master_minumin=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                volumes:
                - /opt/upload/elasticsearch-2/data:/usr/share/elasticsearch/data
                - /opt/upload/elasticsearch-2/logs:/usr/share/elasticsearch/logs

        elasticsearch-3:
                image: elasticsearch
                networks:
                        network-test:
                                aliases:
                                        - elasticsearch
                hostname: elasticsearch-3
                container_name: elasticsearch-3
                environment:
                - cluster_name=elasticsearch
                - node_name=node-3
                - master_minumin=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                volumes:
                - /opt/upload/elasticsearch-3/data:/usr/share/elasticsearch/data
                - /opt/upload/elasticsearch-3/logs:/usr/share/elasticsearch/logs

```

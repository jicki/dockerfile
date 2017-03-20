
# 单机运行

```
# WEB 默认帐号admin  密码 moxian

docker run -d --name elasticsearch -p 9200:9200 elasticsearch 


# 设置密码
docker run -d --name elasticsearch -e web_user=jicki -e web_passwd=jicki -p 9200:9200 elasticsearch

```


# 集群部署

```
# docker-compose

elasticsearch-1:
        image: elasticsearch
        networks:
                network-pro:
                       aliases:
                                - elasticsearch
        container_name: elasticsearch-1
        environment:
        - cluster_name = elasticsearch
	- node_name = node-1
	- web_user = jicki
	- web_passwd = jicki
        volumes:
        - /opt/upload/elasticsearch-1/data:/usr/share/elasticsearch/data
        - /opt/upload/elasticsearch-1/logs:/usr/share/elasticsearch/logs

elasticsearch-2:
        image: elasticsearch
        networks:
                network-pro:
                       aliases:
                                - elasticsearch
        container_name: elasticsearch-2
        environment:
        - cluster_name = elasticsearch
        - node_name = node-2
        - web_user = jicki
        - web_passwd = jicki
        volumes:
        - /opt/upload/elasticsearch-2/data:/usr/share/elasticsearch/data
        - /opt/upload/elasticsearch-2/logs:/usr/share/elasticsearch/logs

elasticsearch-3:
        image: elasticsearch
        networks:
                network-pro:
                       aliases:
                                - elasticsearch
        container_name: elasticsearch-3
        environment:
        - cluster_name = elasticsearch
        - node_name = node-3
        - web_user = jicki
        - web_passwd = jicki
        volumes:
        - /opt/upload/elasticsearch-3/data:/usr/share/elasticsearch/data
        - /opt/upload/elasticsearch-3/logs:/usr/share/elasticsearch/logs

```

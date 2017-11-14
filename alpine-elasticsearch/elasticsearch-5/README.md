
# 设置 vm.max_map_count

```
#系统默认 vm.max_map_count 为 65530 必须设置大于等于 262144

vi /etc/sysctl.conf

vm.max_map_count = 262144


# 执行 

sysctl -p


```




# 单机运行

```
docker run -d --name elasticsearch -p 9200:9200 elasticsearch 


```


# 单机伪集群

```

# 集群启动 集群必须配置 hostname (-h), master_minimum 等于 master 个数

docker run -d --name elasticsearch-1 -h elasticsearch-1 -e cluster_name=elasticsearch -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e node_name=node-1 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minimum=3 --net=overlay -p 9200:9200 elasticsearch

docker run -d --name elasticsearch-2 -h elasticsearch-2 -e cluster_name=elasticsearch -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e node_name=node-2 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minimum=3 --net=overlay -p 9200:9200 elasticsearch

docker run -d --name elasticsearch-3 -h elasticsearch-3 -e cluster_name=elasticsearch -e ES_JAVA_OPTS="-Xms512m -Xmx512m" -e node_name=node-3 -e cluster_list='"elasticsearch-1","elasticsearch-2","elasticsearch-3"' -e master_minimum=3 --net=overlay -p 9200:9200 elasticsearch

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
                - master_minimum=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                - ES_JAVA_OPTS="-Xms512m -Xmx512m"
                - bootstrap.memory_lock=true
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
                - master_minimum=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                - ES_JAVA_OPTS="-Xms512m -Xmx512m"
                - bootstrap.memory_lock=true
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
                - master_minimum=3
                - cluster_list="elasticsearch-1","elasticsearch-2","elasticsearch-3"
                - ES_JAVA_OPTS="-Xms512m -Xmx512m"
                - bootstrap.memory_lock=true
                volumes:
                - /opt/upload/elasticsearch-3/data:/usr/share/elasticsearch/data
                - /opt/upload/elasticsearch-3/logs:/usr/share/elasticsearch/logs

```


# k8s 集群部署



```

apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: elasticsearch
spec:
  serviceName: "elasticsearch"
  replicas: 3
  template:
    metadata:
      labels:
        app: elasticsearch
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: elasticsearch
          image: jicki/elasticsearch:5
          env:
            - name: cluster_name
              value: elasticsearch
            - name: node_name
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: master_minimum
              value: "3"
            - name: cluster_list
              value: '"elasticsearch-0.elasticsearch","elasticsearch-1.elasticsearch","elasticsearch-2.elasticsearch"'
            - name: ES_JAVA_OPTS
              value: '-Xms512m -Xmx512m'
          ports:
            - name: http
              containerPort: 9200
            - name: transport
              containerPort: 9300
          volumeMounts:
            - name: datadir
              mountPath: /usr/share/elasticsearch/data
      volumes:
        - name: datadir
          emptyDir: {}

---

apiVersion: v1
kind: Service
metadata:
  name: elasticsearch
spec:
  ports:
  - port: 9200
    name: http
  - port: 9300
    name: transport
  clusterIP: None
  selector:
    app: elasticsearch

```


# 启动命令：


## ENV 说明


```
ZOO_TICK_TIME    默认 2000 毫秒


ZOO_INIT_LIMIT   默认 5


ZOO_SYNC_LIMIT   默认 2


ZOO_MY_ID        集群唯一标识


ZOO_SERVERS      集群列表

```


## 数据 与 日志


```
数据目录保存在 /data 目录中


日志目录保存在 /datalog 目录中


```



## docker 单机版

```
docker run --name zookeeper --restart always -d jicki/zookeeper-statefulset:3.4.10

```

## docker 集群版

```
version: '2'
services:
    zookeeper-1:
        image: jicki/zookeeper-statefulset:3.4.10
        restart: always
        ports:
            - 2181:2181
        environment:
            ZOO_MY_ID: 1
            ZOO_SERVERS: server.1=zookeeper-1:2888:3888 server.2=zookeeper-2:2888:3888 server.3=zookeeper-3:2888:3888

    zookeeper-2:
        image: jicki/zookeeper-statefulset:3.4.10
        restart: always
        ports:
            - 2182:2181
        environment:
            ZOO_MY_ID: 2
            ZOO_SERVERS: server.1=zookeeper-1:2888:3888 server.2=zookeeper-2:2888:3888 server.3=zookeeper-3:2888:3888

    zookeeper-3:
        image: jicki/zookeeper-statefulset:3.4.10
        restart: always
        ports:
            - 2183:2181
        environment:
            ZOO_MY_ID: 3
            ZOO_SERVERS: server.1=zookeeper-1:2888:3888 server.2=zookeeper-2:2888:3888 server.3=zookeeper-3:2888:3888

```




## k8s 集群版


```

apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: zoo
spec:
  serviceName: "zoo"
  replicas: 5
  template:
    metadata:
      labels:
        app: zookeeper
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: zookeeper
          image: jicki/zookeeper-statefulset:3.4.10
          env:
            - name: ZOO_SERVERS
              value: server.1=zoo-0.zoo:2888:3888:participant server.2=zoo-1.zoo:2888:3888:participant server.3=zoo-2.zoo:2888:3888:participant server.4=zoo-3.zoo:2888:3888:participant server.5=zoo-4.zoo:2888:3888:participant
          ports:
            - containerPort: 2181
              name: client
            - containerPort: 2888
              name: peer
            - containerPort: 3888
              name: leader-election
          volumeMounts:
            - name: datadir
              mountPath: /data
      volumes:
        - name: datadir
          emptyDir: {}


---

apiVersion: v1
kind: Service
metadata:
  name: zookeeper
spec:
  ports:
  - port: 2181
    name: client
  selector:
    app: zookeeper

---

apiVersion: v1
kind: Service
metadata:
  name: zoo
spec:
  ports:
  - port: 2888
    name: peer
  - port: 3888
    name: leader-election
  clusterIP: None
  selector:
    app: zookeeper

```

# kafka docker




## 单机版部署

```
version: '2'
services:
  kafka:
    image: jicki/kafka-statefulset:0.11.0.0
    hostname: kafka-1
    container_name: kafka-1
    ports:
      - "9092"
    environment:
      KAFKA_ADVERTISED_HOST_NAME: "hostname | awk -F'-' '{print $2}'"
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181

```


## k8s 集群 部署


```
apiVersion: apps/v1beta1
kind: StatefulSet
metadata:
  name: kafka
spec:
  serviceName: "broker"
  replicas: 3
  template:
    metadata:
      labels:
        app: kafka
    spec:
      terminationGracePeriodSeconds: 10
      containers:
        - name: broker
          image: jicki/kafka-statefulset:0.11.0.0
          env:
            - name: BROKER_ID_COMMAND
              value: "hostname | awk -F'-' '{print $2}'"
            - name: KAFKA_ZOOKEEPER_CONNECT
              value: "zookeeper:2181"
            - name: KAFKA_PORT
              value: "9092"
            - name: KAFKA_CREATE_TOPICS
              value: "Topic1:1:3,Topic2:1:1:compact" 
            - name: KAFKA_JMX_OPTS
              value: "-Xmx512m -Xms256m"
            - name: KAFKA_LOG_DIRS
              value: "/opt/kafka/data"
          ports:
            - containerPort: 9092
          volumeMounts:
            - name: datadir
              mountPath: /opt/kafka/data
      volumes:
        - name: datadir
          emptyDir: {}
---

apiVersion: v1
kind: Service
metadata:
  name: broker
spec:
  ports:
  - port: 9092
  clusterIP: None
  selector:
    app: kafka

---
apiVersion: v1
kind: Service
metadata:
  name: kafka
spec:
  ports:
  - port: 9092
  selector:
    app: kafka

```

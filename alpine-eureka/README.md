# 镜像下载

```
docker pull jicki/eureka-server

```


```
# 参数说明

    environment:
    - LOGS_NAME=eureka-1
    - INSTANCE_HOSTNAME=eureka-1
    - EUREKA_SERVER_LIST=http://eureka-2:8761/eureka/,http://eureka-3:8761/eureka/


# LOGS_NAME 生成日志的目录
# INSTANCE_HOSTNAME instance.hostname 名称，配置集群高可用需要配置
# EUREKA_SERVER_LIST 集群列表，配置配置除自己以外的节点。
```

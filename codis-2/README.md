# codis

## codis-Dashboard 使用

```
# 启动参数

CODIS_TYPE     # 启动类型
prd_name       # Codis集群名称
prd_auth       # Codis 验证，必须与其他proxy一致，可以为空
coord_name     # 服务选择 zookeeper 或者 ETCD
coord_list     # zk/etcd 集群地址，如: 127.0.0.1:2181
prd_dashboard  # dashboard 名称

```

```
# 单机启动命令

docker run -d --name codis-dashboard-1 -e CODIS_TYPE=codis_dashboard -e prd_name=codis-test -e coord_name=zookeeper -e prd_dashboard=codis-dashboard-1 -e coord_list=127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183 codis

# 挂载日志目录

-v local:/opt/local/codis/logs

```


## codis-proxy 使用


```
# 启动参数

CODIS_TYPE     # 启动类型
prd_name       # Codis集群名称
prd_auth       # Codis 验证，必须与其他proxy一致，可以为空
coord_name     # 服务选择 zookeeper 或者 ETCD
coord_list     # zk/etcd 集群地址，如: 127.0.0.1:2181
prd_dashboard  # dashboard 名称
prd_proxy      # proxy 名称

```


```
# 单机启动命令

docker run -d --name codis-proxy-1 -e CODIS_TYPE=codis_proxy -e prd_name=codis-test -e coord_name=zookeeper -e prd_dashboard=codis-dashboard-1 -e coord_list=127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183 -e prd_proxy=codis-proxy-1 codis

# 挂载日志目录

-v local:/opt/local/codis/logs

```


## codis-server 使用

```
# 启动参数

CODIS_TYPE # 启动类型
MAXMEMORY  # redis 最大使用内存

```

```
# 单机启动命令

docker run -d --name codis-server -e CODIS_TYPE=codis_server -e MAXMEMORY=10gb codis


# 挂载日志目录

-v local:/opt/local/codis/logs
-v local:/opt/local/codis/data

```

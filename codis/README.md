# codis

## codis-Dashboard 使用

```
# 启动参数

CODIS_TYPE # 启动类型
prd_name   # Codis集群名称
prd_auth   # Codis 验证，必须与其他proxy一致，可以为空
coord_name # 服务选择 zookeeper 或者 ETCD
coord_list # zk/etcd 集群地址，如: 127.0.0.1:2181

```

```
# 单机启动命令

docker run -d --name codis-dashboard -e CODIS_TYPE=codis_dashboard -e prd_name=codis-test -e coord_name=zookeeper -e coord_list=127.0.0.1:2181,127.0.0.1:2182,127.0.0.1:2183 codis

# 挂载日志目录

-v local:/opt/local/codis/logs

```


## codis-proxy 使用


```
# 启动参数

CODIS_TYPE # 启动类型
prd_name   # Codis集群名称
prd_auth   # Codis 验证，必须与其他dashboard一致，可以为空
coord_name # 服务选择 zookeeper 或者 ETCD
coord_list # zk/etcd 集群地址，如: 127.0.0.1:2181

```


```
# 单机启动命令

docker run -d --name codis-proxy -e CODIS_TYPE=codis_proxy -e prd_name=codis-test -e coord_name=zookeeper -e coord_list=127.0.0.1:2181 codis

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

## codis-sentinel 使用

```
# 启动参数
CODIS_TYPE # 启动类型


```


```
# 单机启动命令

docker run -d --name codis-sentinel -e CODIS_TYPE=codis_sentinel codis


# 挂载日志目录

-v local:/opt/local/codis/logs

```


## codis-fe 使用


```
# 启动参数

CODIS_TYPE # 启动类型
coord_list # zk/etcd 集群地址

```


```
# 单机启动命令

docker run -d --name codis-fe -e CODIS_TYPE=codis_fe -e coord_list=127.0.0.1:2181 codis

# 挂载日志目录

-v local:/opt/local/codis/logs

```

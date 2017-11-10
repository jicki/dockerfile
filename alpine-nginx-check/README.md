# Nginx Config Check

> 使用 Cron 每1 分钟 check 一次 nginx.conf 的 md5 值
如果 md5 值不相同，自动执行 nginx reload


```
docker pull jicki/nginx:check


```

```
nginx.conf  path /etcd/nginx/conf/nginx.conf


```

```
# docker

docker run -d -v .nginx.conf:/etc/nginx/conf/nginx.conf nginx


# kubernetes

使用 configmap 挂载到 deployment , rc 中。


```

```
# 思路


可自行将 nginx.conf 放到 git 中。


check 脚本，可更改为 先 git pull ，然后再执行 check


```

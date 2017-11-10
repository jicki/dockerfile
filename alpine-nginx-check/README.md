# Nginx Config Check

> 使用 Cron 每1 分钟 check 一次 nginx.conf 的 md5 值
如果 md5 值不相同，自动执行 nginx reload


```
# docker

docker run -d -v .nginx.conf:/etc/nginx/nginx.conf nginx


# kubernetes

使用 configmap 挂载到 deployment , rc 中。


```


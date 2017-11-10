# Nginx Config Check

> 使用 Cron 每1 分钟 check 一次 nginx.conf 的 md5 值
如果 md5 值不相同，自动执行 nginx reload


```
docker pull jicki/nginx:check


```

```
nginx.conf  path /etc/nginx/conf/nginx.conf


```

```
# docker

docker run -d -v .nginx.conf:/etc/nginx/conf/nginx.conf jicki/nginx:check


# kubernetes

使用 configmap 挂载到 deployment , rc 中。

configmap  更新以后， pod 中 config 更新需要一点时间，不是实时更新


```


## kubernetes 例子

```
---
kind: ConfigMap
apiVersion: v1
metadata:
  name: nginx-config
  namespace: default
data:
  nginx.conf: |
    user nginx nginx;
    
    worker_processes auto;
    
    error_log /var/log/nginx/nginx_error.log warn;
    
    pid     /var/run/nginx.pid;
    
    #Specifies the value for maximum file descriptors that can be opened by this process.
    worker_rlimit_nofile 65535;
    
    events
    {
    use epoll;
    worker_connections 65535;
    }
    
    http
    {
    include     /etc/nginx/mime.types;
    default_type application/octet-stream;
    
    #charset gb2312;
    
    server_names_hash_bucket_size 128;
    client_header_buffer_size 32k;
    large_client_header_buffers 4 32k;
    client_max_body_size 100m;
    sendfile on;
    server_tokens off;
    tcp_nopush   on;
    keepalive_timeout 120;
    tcp_nodelay on;
    
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;
    
    gzip on;
    gzip_min_length 1k;
    gzip_buffers   4 16k;
    gzip_http_version 1.0;
    gzip_comp_level 2;
    gzip_types     text/plain application/x-javascript text/css application/xml;
    gzip_vary on;
    
    #limit_zone crawler $binary_remote_addr 10m;
     
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" $http_x_forwarded_for  "$request_time"';
    server {
        listen       80;
        server_name  localhost;
    
        location / {
            root   /usr/share/nginx/html;
            index  index.html index.htm;
         }
        # error ststus
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
         }
      }
    }
---

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-dm
spec:
  replicas: 3
  template:
    metadata:
      labels:
        name: nginx
    spec:
      containers:
        - name: nginx
          image: jicki/nginx:check
          imagePullPolicy: Always
          ports:
            - containerPort: 80
          volumeMounts:
            - name: config-volume
              mountPath: /etc/nginx/conf
              readOnly: true
          resources:
            limits:
              cpu: 500m
              memory: 1024Mi
      volumes:
        - name: config-volume
          configMap:
            name: nginx-config

---

apiVersion: v1 
kind: Service
metadata: 
  name: nginx-svc 
spec: 
  ports: 
    - port: 80
      targetPort: 80
      protocol: TCP 
  selector: 
    name: nginx

---

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - host: nginx.jicki.me
    http:
      paths:
      - backend:
          serviceName: nginx-svc
          servicePort: 80

```





## 思路

```
可自行将 nginx.conf 放到 git 中。


check 脚本，可更改为 先 git pull ，然后再执行 check


```





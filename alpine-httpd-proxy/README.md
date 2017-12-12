# Httpd 2.4 反向代理

## 启动命令：

> docker-compose

```
version: '2'
services:
  httpd-1:
    image: httpd:alpine
    hostname: httpd-1
    container_name: httpd-1
    restart: always
  httpd-2:
    image: httpd:alpine
    hostname: httpd-2
    container_name: httpd-2
    restart: always
  httpd-3:
    image: httpd:alpine
    hostname: httpd-3
    container_name: httpd-3
    restart: always
  httpd-4:
    image: httpd:alpine
    hostname: httpd-4
    container_name: httpd-4
    restart: always
  httpd:
    image: httpd:alpine
    hostname: httpd
    container_name: httpd
    restart: always
    ports:
    - 80:80
    volumes:
    - /etc/localtime:/etc/localtime
    - .logs:/usr/local/apache2/logs
    - .conf/httpd.conf:/usr/local/apache2/conf/httpd.conf
    - .conf/httpd-proxy.conf:/usr/local/apache2/conf/extra/httpd-proxy.conf
    - .conf/httpd-vhosts.conf:/usr/local/apache2/conf/extra/httpd-vhosts.conf
    depends_on:
    - httpd-1
    - httpd-2
    - httpd-3
    - httpd-4

```

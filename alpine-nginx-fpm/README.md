# Nginx + PHP-FPM



## Version

```
NGINX_VERSION 1.14.0

PHP_VERSION  7.2.4


```





## volumes


```
# vhost

-v localpath:/etc/nginx/sites-enabled

# logs

-v localpath:/var/logs/nginx


# 项目目录

-v localpath:/var/www/html


```

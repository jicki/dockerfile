启动命令：

docker run -d -h="nginx" --name nginx --restart=always alpine-nginx

可选择挂载:
	/etc/nginx/nginx.conf
	/etc/nginx/vhost
	/etc/nginx/upstream.conf

配置servce日志目录 /opt/nginx/logs

挂载日志目录：
	/opt/nginx/logs

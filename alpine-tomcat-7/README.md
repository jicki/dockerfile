
# 启动命令：

## 单机启动：

```
docker run -d -h="tomcat" --name tomcat -e MOXMS=1024m -e MOXMX=2048m --restart=always tomcat
```


```
# 项目目录：

-v  /opt/htdocs/webapp
-v  /opt/htdocs/logs
```


```
# 说明 catalina 日志使用 cronolog 按照每天切割

```

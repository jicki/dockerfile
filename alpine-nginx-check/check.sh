#!/bin/bash

confmd5=`md5sum /etc/nginx/nginx.conf|awk {'print $1'}`

reloadmd5=`cat /tmp/md5.txt`

if [ "$confmd5" != "$reloadmd5" ];then

/usr/sbin/nginx -t 2> /tmp/status.txt
status=`cat /tmp/status.txt`

	if [[ $status =~ "syntax is ok" ]] && [[ $status =~ "successful" ]];then
	/usr/sbin/nginx reload
	echo "$confmd5" > /tmp/md5.txt
        echo "=========nginx reload================"
        else
        echo "Config Error"
   fi
fi

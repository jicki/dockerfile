**MariaDB 10.1 Galera CentOS 7**
==================

CentOS 7 MariaDB 10.1 Galera cluster installation from the official MariaDB repository. Uses rsync for state transfer. Image wil automatically run any sql scripts present in /docker-entrypoint-initdb.d as part of startup. 

# Required Variables
* **CLUSTER**=Can be either BOOTSTRAP, STANDALONE or a comma-separated list of container names
* **MYSQL_ROOT_PASSWORD**=The MariaDB root database password (or alternately, $MYSQL_ALLOW_EMPTY_PASSWORD or $MYSQL_RANDOM_ROOT_PASSWORD)
* **WSREP_OPTS**=Additional wsrep_provider_options (such as "gmcast.segment=1" for defining a segment for clusters across datacenters)
* **EXTRA_ARGS**=Any arbitrary additional args to pass to mariadb when starting

## To run a standalone instance

~~~
docker run -d --name db-standalone -p 3306:3306 -e CLUSTER=STANDALONE -e MYSQL_ROOT_PASSWORD=password -v /your/data/dir:/var/lib/mysql dayreiner/centos7-MariaDB-10.1-galera:latest
~~~

## Bootstrap initial cluster

~~~
docker run -d --name db1 -p 3306:3306 -e CLUSTER=BOOTSTRAP -e MYSQL_ROOT_PASSWORD=password -v /your/data/dir:/var/lib/mysql dayreiner/centos7-MariaDB-10.1-galera:latest
docker logs db1
~~~

Once the initial cluster instance is bootstrapped, you can start the remaining cluster members by specifying the list of possible nodes in the run command. Below assumes you're running all three nodes on the same system for testing purposes:

~~~
docker run -d --name db2 -p 3307:3306 -e CLUSTER=db1,db2,db3 -e MYSQL_ROOT_PASSWORD=password -v /your/data/dir:/var/lib/mysql dayreiner/centos7-MariaDB-10.1-galera:latest

docker run -d --name db3 -p 3308:3306 -e CLUSTER=db1,db2,db3 -e MYSQL_ROOT_PASSWORD=password -v /your/data/dir:/var/lib/mysql dayreiner/centos7-MariaDB-10.1-galera:latest
~~~

Check the logs of your cluster containers to ensure they have joined the cluster. You can also log in to each member to confirm the cluster is syncrhonized via:

~~~
docker exec -ti db1 mysql -u root --password=password -e "show status like 'wsrep_local_state_comment'"

+---------------------------+--------+
| Variable_name             | Value  |
+---------------------------+--------+
| wsrep_local_state_comment | Synced |
+---------------------------+--------+
~~~

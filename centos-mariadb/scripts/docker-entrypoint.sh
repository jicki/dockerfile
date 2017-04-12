#!/bin/bash
set -eo pipefail

preflight () {
    if [[ -z ${CLUSTER_NAME+x} ]]; then
        echo >&2 "########### CLUSTER_NAME variable must be set."
        exit 1
   fi
}


initialize_db () {

# Taken from https://github.com/docker-library/mariadb/blob/c64262339972ac2a8dadaf8141e012aa8ddb8c23/10.1/docker-entrypoint.sh

# if command starts with an option, prepend mysqld
if [ "${1:0:1}" = '-' ]; then
	set -- mysqld "$@"
fi

# skip setup if they want an option that stops mysqld
wantHelp=
for arg; do
	case "$arg" in
		-'?'|--help|--print-defaults|-V|--version)
			wantHelp=1
			break
			;;
	esac
done

if [ "$1" = 'mysqld' -a -z "$wantHelp" ]; then
	# Get config
	DATADIR="$("$@" --verbose --help --log-bin-index=`mktemp -u` 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"

	if [ ! -d "$DATADIR/mysql" ]; then
		if [ -z "$MYSQL_ROOT_PASSWORD" -a -z "$MYSQL_ALLOW_EMPTY_PASSWORD" -a -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			echo >&2 'error: database is uninitialized and password option is not specified '
			echo >&2 '  You need to specify one of MYSQL_ROOT_PASSWORD, MYSQL_ALLOW_EMPTY_PASSWORD and MYSQL_RANDOM_ROOT_PASSWORD'
			exit 1
		fi

		mkdir -p "$DATADIR"
		chown -R mysql:mysql "$DATADIR"

		echo 'Initializing database'
		mysql_install_db --user=mysql --datadir="$DATADIR" --rpm
		echo 'Database initialized'

		"$@" --skip-networking &
		pid="$!"

		mysql=( mysql --protocol=socket -uroot )

		for i in {30..0}; do
			if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
				break
			fi
			echo 'MySQL init process in progress...'
			sleep 1
		done
		if [ "$i" = 0 ]; then
			echo >&2 'MySQL init process failed.'
			exit 1
		fi

		if [ -z "$MYSQL_INITDB_SKIP_TZINFO" ]; then
			# sed is for https://bugs.mysql.com/bug.php?id=20545
			mysql_tzinfo_to_sql /usr/share/zoneinfo | sed 's/Local time zone must be set--see zic manual page/FCTY/' | "${mysql[@]}" mysql
		fi

		if [ ! -z "$MYSQL_RANDOM_ROOT_PASSWORD" ]; then
			MYSQL_ROOT_PASSWORD="$(pwgen -1 32)"
			echo "GENERATED ROOT PASSWORD: $MYSQL_ROOT_PASSWORD"
		fi
		"${mysql[@]}" <<-EOSQL
			-- What's done in this file shouldn't be replicated
			--  or products like mysql-fabric won't work
			SET @@SESSION.SQL_LOG_BIN=0;

			DELETE FROM mysql.user ;
			CREATE USER 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
			GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION ;
			DROP DATABASE IF EXISTS test ;
			FLUSH PRIVILEGES ;
		EOSQL

		if [ ! -z "$MYSQL_ROOT_PASSWORD" ]; then
			mysql+=( -p"${MYSQL_ROOT_PASSWORD}" )
		fi

		if [ "$MYSQL_DATABASE" ]; then
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` ;" | "${mysql[@]}"
			mysql+=( "$MYSQL_DATABASE" )
		fi

		if [ "$MYSQL_USER" -a "$MYSQL_PASSWORD" ]; then
			echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' ;" | "${mysql[@]}"

			if [ "$MYSQL_DATABASE" ]; then
				echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' ;" | "${mysql[@]}"
			fi

			echo 'FLUSH PRIVILEGES ;' | "${mysql[@]}"
		fi

		echo
		for f in /docker-entrypoint-initdb.d/*; do
			case "$f" in
				*.sh)     echo "$0: running $f"; . "$f" ;;
				*.sql)    echo "$0: running $f"; "${mysql[@]}" < "$f"; echo ;;
				*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | "${mysql[@]}"; echo ;;
				*)        echo "$0: ignoring $f" ;;
			esac
			echo
		done

		if ! kill -s TERM "$pid" || ! wait "$pid"; then
			echo >&2 'MySQL init process failed.'
			exit 1
		fi

		echo
		echo 'MySQL init process done. Ready for start up.'
		echo
	fi

	chown -R mysql:mysql "$DATADIR"
fi
}

if [ -z ${CLUSTER+x} ]; then
    echo >&2 "########### CLUSTER variable must be defined as STANDALONE, BOOTSTRAP or a comma-separated list of container names."
    exit 1
elif [ ${CLUSTER} = "STANDALONE" ]; then
    initialize_db $@
    echo "########### Starting MariaDB in STANDALONE mode..."
    exec $@
elif [ ${CLUSTER} = "BOOTSTRAP" ]; then
    preflight
    initialize_db $@
    echo "########### Bootstrapping MariaDB cluster ${CLUSTER_NAME} with primary node ${HOSTNAME}..."
    echo "########### Starting MariaDB cluster..."
    # Workaround odd bug(?) causing corrupted binlog index after initialization
    mv /var/lib/mysql/mysql-bin.index /tmp
    exec $@ --wsrep_node_address="${HOSTNAME}" \
    --wsrep_cluster_name="${CLUSTER_NAME}" \
    --wsrep_new_cluster --wsrep_cluster_address="gcomm://" \
    --wsrep_node_name="${HOSTNAME}" \
    --wsrep_provider_options="${WSREP_OPTS}" ${EXTRA_ARGS} 
else
    echo "########### Joining MariaDB cluster ${CLUSTER_NAME} on nodes ${CLUSTER}..."
    preflight
    initialize_db $@
    exec $@ --wsrep_node_address="${HOSTNAME}" \
    --wsrep_cluster_name="${CLUSTER_NAME}" \
    --wsrep_cluster_address="gcomm://${CLUSTER}" \
    --wsrep_node_name="${HOSTNAME}" \
    --wsrep_provider_options="${WSREP_OPTS}" ${EXTRA_ARGS} 
fi

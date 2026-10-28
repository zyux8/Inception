#!/bin/bash
set -eu

MYSQL_PASSWORD="$(< /run/secrets/db_password)"
MYSQL_ROOT_PASSWORD="$(< /run/secrets/db_root_password)"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d /var/lib/mysql/mysql ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then

    mariadbd --user=mysql &
    pid=$!

    until mariadb-admin ping --silent; do
        sleep 1
    done

    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    mariadb-admin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait $pid
fi

exec mariadbd --user=mysql

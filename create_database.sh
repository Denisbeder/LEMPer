#!/bin/bash

# if ! [ $(id -u) = 0 ]; then
#    echo "The script need to be run as root." >&2
#    exit 1 
# fi

# if [ $SUDO_USER ]; then
#     real_user=$SUDO_USER
# else
#     real_user=$(whoami)
# fi

### Include variables ###
source <(grep -v '^#' vars.sh | grep -v '^\[' | sed -E '/^[[:space:]]*$/d' | sed -E 's/\r/ /g')

echo -n "Enter the name a database: "
read DB_NAME

echo -n "Enter the BIND ip when necessary (leave blank to use default): "
read DB_BIND

echo -n "Create user (yes/no): "
read CREATE_USER

SQL_QUERY="CREATE DATABASE IF NOT EXISTS ${DB_NAME};"

if [[ "$CREATE_USER" == "yes" ]]; then
	echo -n "Digit Username: "
    read USER_NAME

    echo -n "Digit Password: "
    read USER_PASS

    if [[ "$DB_BIND" != "" ]]; then
        SQL_QUERY="${SQL_QUERY} 
        CREATE USER IF NOT EXISTS '${USER_NAME}'@'${MYSQL_BIND_ADDRESS}' IDENTIFIED BY '${USER_PASS}';
        GRANT ALL PRIVILEGES ON *.* TO '${USER_NAME}'@'${MYSQL_BIND_ADDRESS}';"
    fi

    SQL_QUERY="${SQL_QUERY}
        CREATE USER IF NOT EXISTS '${USER_NAME}'@'localhost' IDENTIFIED BY '${USER_PASS}';
        GRANT ALL PRIVILEGES ON *.* TO '${USER_NAME}'@'localhost';
        USE mysql;
        UPDATE user SET plugin='unix_socket' WHERE User='${USER_NAME}';
        FLUSH PRIVILEGES;"
fi

# Root password is blank for newly installed MariaDB (MySQL).
if mysql --user=root --password="${MYSQL_ROOT_PASS}" -e "${SQL_QUERY}"; then
    echo -e "Database name '${DB_NAME}' created to user '${USER_NAME:-$MYSQL_DATABASE_NAME}' and password '${USER_PASS:-$MYSQL_PASS}'"
else
    echo -e "The database could not be created."
fi


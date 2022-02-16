#!/usr/bin/env bash

### MariaDB installation ###
echo -e "${CYAN}[MariaDB (MySQL drop-in replacement) Installation]${NC}"

apt install -yqq libmariadb3 mariadb-common mariadb-server

# Configure MySQL installation.
echo -e "${CYAN}Configure MySQL installation${NC}"

if [ ! -f /etc/mysql/my.cnf ]; then
    cp -f etc/mysql/my.cnf /etc/mysql/
fi
if [ ! -f /etc/mysql/mariadb.cnf ]; then
    cp -f etc/mysql/mariadb.cnf /etc/mysql/
fi
if [ ! -f /etc/mysql/debian.cnf ]; then
    cp -f etc/mysql/debian.cnf /etc/mysql/
fi
if [ ! -f /etc/mysql/debian-start ]; then
    cp -f etc/mysql/debian-start /etc/mysql/
    chmod +x /etc/mysql/debian-start
fi

# init script.
if [ ! -f /etc/init.d/mysql ]; then
    cp etc/init.d/mysql /etc/init.d/
    chmod ugo+x /etc/init.d/mysql
fi

# systemd script.
if [ ! -f /lib/systemd/system/mariadb.service ]; then
    cp etc/systemd/mariadb.service /lib/systemd/system/
fi
if [[ ! -f /etc/systemd/system/multi-user.target.wants/mariadb.service && -f /lib/systemd/system/mariadb.service ]]; then
    ln -s /lib/systemd/system/mariadb.service \
        /etc/systemd/system/multi-user.target.wants/mariadb.service
fi
if [[ ! -f /etc/systemd/system/mysqld.service && -f /lib/systemd/system/mariadb.service ]]; then
    ln -s /lib/systemd/system/mariadb.service \
        /etc/systemd/system/mysqld.service
fi
if [[ ! -f /etc/systemd/system/mysql.service && -f /lib/systemd/system/mariadb.service ]]; then
    ln -s /lib/systemd/system/mariadb.service \
        /etc/systemd/system/mysql.service
fi

# Trying to reload daemon.
systemctl daemon-reload

# Unmask systemd service (?)
systemctl unmask mariadb.service

# Enable MariaDB on startup.
systemctl enable mariadb.service

# Restart MariaDB service daemon.
#systemctl start mariadb
service mysql start



##
# MariaDB (MySQL) secure installation
# Ref: https://mariadb.com/kb/en/library/security-of-mariadb-root-account/
#
echo -e "${CYAN}Securing MariaDB (MySQL) Installation...${NC}"

# Ref: https://bertvv.github.io/notes-to-self/2015/11/16/automating-mysql_secure_installation/
MYSQL_ROOT_PASS=${MYSQL_ROOT_PASS:-$(openssl rand -base64 64 | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)}
SQL_QUERY=""

# Setting the database root password.
SQL_QUERY="ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';"

# Delete anonymous users.
SQL_QUERY="${SQL_QUERY}
        DELETE FROM mysql.user WHERE User='';"

# Ensure the root user can not log in remotely.
SQL_QUERY="${SQL_QUERY}
        DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"

# Remove the test database.
SQL_QUERY="${SQL_QUERY}
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%';"


##### ADD DATABASE WITH BIND_ADDRESS #####
#CREATE DATABASE site;
#CREATE USER 'site'@'10.116.80.2' IDENTIFIED BY 'BLSLtXzPWW@M';
#GRANT ALL PRIVILEGES ON site.* TO 'site'@'10.116.80.2';

# Remove the test database.
SQL_QUERY="${SQL_QUERY}
        CREATE DATABASE ${MYSQL_DATABASE_NAME};
        CREATE USER '${MYSQL_USERNAME}'@'${MYSQL_BIND_ADDRESS}' IDENTIFIED BY '${MYSQL_PASS}';
        GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USERNAME}'@'${MYSQL_BIND_ADDRESS}';"

# Flush the privileges tables.
SQL_QUERY="${SQL_QUERY}
        FLUSH PRIVILEGES;"

# Fix error: ERROR 1045 (28000): Access denied for user 'root'@'localhost' (using password: NO).
SQL_QUERY="${SQL_QUERY}
        USE mysql;
        UPDATE user SET plugin='unix_socket' WHERE User='root';"

# mysql_upgrade saves the MySQL version number in a file named mysql_upgrade_info in the data directory. 
# This is used to quickly check whether all tables have been checked for this release so that table-checking can be skipped
mysql_upgrade -u root -p${MYSQL_ROOT_PASS} --force

# Root password is blank for newly installed MariaDB (MySQL).
if mysql --user=root --password="" -e "${SQL_QUERY}"; then
    echo -e "${GREEN}Securing MariaDB (MySQL) installation has been done.${NC}"
else
    echo -e "${RED}Unable to secure MariaDB (MySQL) installation.${NC}"
fi

if [[ $(pgrep -c mysql) -gt 0 || -n $(command -v mysql) ]]; then
    echo -e "${GREEN}MariaDB (MySQL) installed successfully.${NC}"

    # Restart MariaDB (MySQL)
    systemctl restart mariadb

    if [[ $(pgrep -c mysql) -gt 0 ]]; then
        echo -e "${GREEN}MariaDB (MySQL) configured successfully.${NC}"
    elif [[ -n $(command -v mysql) ]]; then
        # Server died? try to start it.
        systemctl start mariadb

        if [[ $(pgrep -c mysql) -gt 0 ]]; then
            echo -e "${GREEN}MariaDB (MySQL) configured successfully${NC}."
        else
            echo -e "${RED}Something went wrong with MariaDB (MySQL) installation.${NC}."
        fi
    fi
else
    echo -e "${RED}Something went wrong with MariaDB (MySQL) installation.${NC}."
fi


# [L]inux [E]ngine-X [M]ariaDB [P]HP Install[ER]

LEMPer stands for Linux, Engine-X (Nginx), MariaDB and PHP installer written in Bash script. This is just a small tool set (a bunch collection of scripts) that usually I use to deploy and manage LEMP stack on Debian/Ubuntu. 

## Features

* Nginx pre-configured optimization for low-end VPS/cloud server.
* Nginx virtual host (vhost) configuration optimized for WordPress, and several PHP Frameworks.
* Support HTTP/2 natively for your secure website.
* Free SSL certificates from [Let's Encrypt](https://letsencrypt.org/).
* Get an A+ grade on several SSL Security Test ([Qualys SSL Labs](https://www.ssllabs.com/ssltest/analyze.html?d=masedi.net), [ImmuniWeb](https://www.immuniweb.com/ssl/?id=bVrykFnK), and Wormly).
* PHP Zend OPcache.
* SQL database with MariaDB 10, MySQL drop-in replacement.
* In-memory database with Redis.
* Memory cache with Memcached.

## Setting Up

* Ensure that you have git installed.
* Clone LEMPer Git repositroy, ```git clone https://github.com/denisbeder/LEMPer.git```.
* Enter LEMPer directory ```cd LEMPer```.
* Edit if you prefer as settings ```vi vars.sh```.
* Execute lemper.sh file, ```sudo ./install.sh```.

### Install LEMPer SERVER stack

```bash
sudo apt install git && git clone -q https://github.com/denisbeder/LEMPer.git && cd LEMPer && sudo chmod +x ./install_server.sh && sudo ./install_server.sh
```

### Install LEMPer MYSQL stack

```bash
sudo apt install git && git clone -q https://github.com/denisbeder/LEMPer.git && cd LEMPer && sudo chmod +x ./install_mysql.sh && sudo ./install_mysql.sh
```

### Install LEMPer MINIO stack

```bash
sudo apt install git && git clone -q https://github.com/denisbeder/LEMPer.git && cd LEMPer && sudo chmod +x ./install_minio.sh && sudo ./install_minio.sh
```

## TODO

* ~~Custom build latest [Nginx](https://nginx.org/en/) from source~~
* ~~Add [Let's Encrypt SSL](https://letsencrypt.org/)~~
* ~~Add network security (iptable rules, firewall configurator, else?)~~
* Add enhanced security (AppArmor, cgroups, jailkit (chrooted/jail users), fail2ban, else?)
* Add file backup tool (Borg, Duplicati, Rclone, Restic, Rsnapshot, else?)
* ~~Add database backup tool (Mariabackup, Percona Xtrabackup, else?)~~
* Add server monitoring (Amplify, Monit, Nagios, else?)
* Add user account & hosting package management.

## Copyright
This is forked from [https://github.com/joglomedia/LEMPer](https://github.com/joglomedia/LEMPer). All rights reserved to [joglomedia](https://github.com/joglomedia/LEMPer).
(c) 2014-2020 | [MasEDI.Net](https://masedi.net/)

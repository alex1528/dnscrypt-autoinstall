#!/bin/bash

### 
# Installation and autoconfigure script for debian and dnscrypt.eu
#
# Author: Simon Clausen <kontakt@simonclausen.dk>
#
# This script needs a lot of work done - this is just a first draft I quickly cooked up.
#
# Todo: proper init script, choice of dnscrypt service (OpenDNS, DNSCrypt.eu, "other", etc),
#       reconfigure after installed, uninstall feature, download newest version, check for existing DNS service, etc.
###

if [ $USER != 'root' ]; then
	echo "Error: You need to be root to run this."
	exit
fi

if [ -e /usr/local/sbin/dnscrypt-proxy ]; then
	echo "It looks like DNSCrypt is already installed. Quitting."
	exit
else
	apt-get install automake libtool build-essential
	cd
	mkdir dnscrypt-autoinstall
	cd dnscrypt-autoinstall
	wget --no-check-certificate https://download.libsodium.org/libsodium/releases/libsodium-0.4.3.tar.gz
	wget http://download.dnscrypt.org/dnscrypt-proxy/dnscrypt-proxy-1.3.3.tar.gz
	tar -zxf libsodium-0.4.3.tar.gz
	cd libsodium-0.4.3
	./configure
	make
	make check
	make install
	ldconfig
	cd ..
	tar -zxf dnscrypt-proxy-1.3.3.tar.gz
	cd dnscrypt-proxy-1.3.3
	./configure
	make
	make install
	cd ..
	mkdir -p /var/run/dnscrypt
	useradd -d /var/run/dnscrypt -s /dev/nologin dnscrypt
	chown dnscrypt:dnscrypt /var/run/dnscrypt
	wget --no-check-certificate https://raw.github.com/simonclausen/dnscrypt-autoinstall/master/initscript.sh
	mv initscript.sh /etc/init.d/dnscrypt-proxy
	chmod +x /etc/init.d/dnscrypt-proxy
	update-rc.d dnscrypt-proxy defaults
	/etc/init.d/dnscrypt-proxy start
	echo "nameserver 127.0.0.1" > /etc/resolv.conf
	cd
	rm -rf dnscrypt-autoinstall
fi
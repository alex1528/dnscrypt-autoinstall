#! /bin/sh
### BEGIN INIT INFO
# Provides:          dnscrypt-proxy
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: dnscrypt-proxy
# Description:       dnscrypt-proxy secure DNS client
### END INIT INFO

PATH=/usr/sbin:/usr/bin:/sbin:/bin
DAEMON=/usr/local/sbin/dnscrypt-proxy
NAME=dnscrypt-proxy
RESOLVER=dnscrypt.eu-nl

case "$1" in
    start)
	echo "Starting $NAME"
	$DAEMON --daemonize --ephemeral-keys --user=dnscrypt \
		--local-address=127.0.0.1 --resolver-name=$RESOLVER
	# $DAEMON --daemonize --ephemeral-keys --user=dnscrypt \
	# 	--local-address=127.0.0.2 --resolver-name=$RESOLVER2
	;;
    stop)
	echo "Stopping $NAME"
	pkill -f $DAEMON
	;;
    restart)
	$0 stop
	$0 start
	;;
    *)
	echo "Usage: /etc/init.d/dnscrypt-proxy {start|stop|restart}"
	exit 1
	;;
esac

exit 0

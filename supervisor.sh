#!/bin/bash

stop() {
        source /data/sentry/bin/activate
	supervisorctl -c /data/sentry/etc/supervisord.conf stop all
}

start() {
        source /data/sentry/bin/activate
	supervisorctl -c /data/sentry/etc/supervisord.conf start all
}

istart() {
        source /data/sentry/bin/activate
	supervisord -c /data/sentry/etc/supervisord.conf
}

case "$1" in
  start)
	    start
	;;
  stop)
	    stop
	;;
  istart)
      istart
      ;;
  *)
	echo $"Usage: $0 {start|stop|istart}"
	exit 1
esac

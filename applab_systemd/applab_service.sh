#!/bin/sh
#
# applab_service.sh
# Description: Systemd type script to start / stop / restart AppLab service
#	       - Requires python3 to be installed and in the path
# Arguments:
#   start
#   stop
#   status
#   restart
#
# Files:
#   /var/www/html/app.py		Startup script
#   /var/www/html/applab_service.pid	PID of running applab application
#   /var/log/applab_service.log		Log file of all messages from applab
#
# CHANGES
# ------------------------------------------------------------------------
# DATE		OWNER		DESCRIPTION
# ------------------------------------------------------------------------
# 24/09/2020	EResnick	Creation
# ------------------------------------------------------------------------

LC_ALL=en_US.utf-8  
LANG=en_US.utf-8  
APPLAB_JWT_SECRET="\xec\xccHA\x14\xdb\xc6]\xd5F\x9a\xda\xc0\x0c\t\xdc\x9f\xf3S\x07\xc3Yg\x8a"  
RUNTIME_ENV=production  
NSS_STRICT_NOFORK=DISABLED  
FLASK_APP=cli.py

echo $PATH > /tmp/applab_params

usage ()
{
	echo "Usage: applab_service.sh (start | stop | restart | help)"
	echo -e "\tstart\tStart the applab service"
	echo -e "\tstop\tStop the applab service"
	echo -e "\trestart\tRestart the applab service"
	echo -e "\thelp\tDisplay this message"
}

case $1 in
    start)
#	Check for start up file app.py
	if [ ! -f /var/www/html/app.py ]; then
	   echo "applab_service: File /var/www/html/app.py not found"
	   exit 1
	fi
#	Check if python3 is available
	if [ ! `which python3 2>&1 > /dev/null` ]; then
	   python3 /var/www/html/app.py 2>&1 >> /var/log/applab_service.log &
	else
	   echo "applab_service: python3 not found"
	   exit 2
	fi
    ;;
    stop)
#	Managed by systemd
    ;;
    status)
#	Managed by systemd
    ;;
    restart)
#	Managed by systemd
    ;;
    h | help)
	usage
    ;;
    *)
	usage
	exit 1
    ;;
esac

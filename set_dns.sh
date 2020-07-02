#!/bin/sh
# -----------------------------------------------------------------------
# Name: set_dns.sh
#
# Description:
#	Thus script will add or delete an entry in the DNS server
#
# Prerequisite:
#	- nsupdate installed (RHEL 7 bind-utils package)
#
# Arguments:
#	-a	IP address of host
#	-h	Hostname of server to add / delete
#	-m	Mode: add / del
#	-n	FQDN name
#	-s	DNS server (name or IP address)
#
# Exit Codes:
#	1	Parameter error
#	2	Prerequisite not found
#
# -----------------------------------------------------------------------
# DATE		NAME		DESCRIPTION
# -----------------------------------------------------------------------
# 02/07/2020	E Resnick	Creation
# -----------------------------------------------------------------------

usage ()
{
# Requires 2 parameters:
#    1st paramater: message
#    2nd parameter: exit value
	if [ "$1" != "" ]
	then
		echo -e "$1\n"
	fi
	echo "Usage: set_dns.sh [OPTION]...
	-a      IP address of host - REQUIRED
	-m      Mode: add / del - REQUIRED
	-n	FQDN name - REQUIRED
	-s      DNS server (name or IP address) - REQUIRED
	-h      Usage message"
	if [ "$2" != "" ]
	then
		exit $2
	fi
}

NSUPDATE=`which nsupdate`

if [ $NSUPDATE == "" ] || [ ! -x $NSUPDATE ]
then
	usage "nsupdate not installed (RHEL 7 bind-utils package)" 2
fi

while getopts 'a:hm:n:s:' arg
do
	case $arg in
	a)
	   ADDRESS=$OPTARG
	   ;;
	m)
	   MODE=$OPTARG
	   if [ "$MODE" != "add" ] && [ "$MODE" != "del" ]
	   then
		usage "Invalid mode: $MODE" 1
	   fi
	   ;;
	n)
	   HOSTN=$OPTARG
	   ;;
	s)
	   DNS_SERVER=$OPTARG
	   ;;
	h)
	   usage "" 0
	   ;;
	?)
	   usage "" 1
	   ;;
	esac
done

if [ "$ADDRESS" == "" ] || [ "$MODE" == "" ] || [ "$HOSTN" == "" ] || [ "$DNS_SERVER" == "" ]
then
	usage "Missing required parameter" 1
fi

echo "ADDRESS=$ADDRESS | MODE=$MODE | DNS_SERVER=$DNS_SERVER"

# Check valid IP addresses - needs more work
# - only checks the structure and not the range from 1-254
VALIDA=$(echo $ADDRESS | egrep '^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}$');
VALIDS=$(echo $DNS_SERVER | egrep '^[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}$');

if [ ! -n "$VALIDA" ] || [ ! -n "$VALIDS" ]
then
	usage "Invalid IP address $ADDRESS or $DNS_SERVER" 1
fi

echo -e "server $DNS_SERVER\nupdate $MODE $HOSTN 86400 A $ADDRESS\nsend\n" | nsupdate -v

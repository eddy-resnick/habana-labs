#!/bin/sh
# generate_gaudi_addresses.sh
#
# Description: Generate the PCI addresses from a server attached to HLS
# 
# Inputs: 	1 argument - pattern to match for Gaudi cards
# Outputs:	List of addresses to be used for attahcing Gauid cards
# Exit Codes:	0 - Success
#		1 - No pattern provided
#		2 - No Gaudi cards found
#
# Changes:
# -----------------------------------------------------------------------
# DATE		NAME		DESCRIPTION
# -----------------------------------------------------------------------
# 11/08/2020	E Resnick	Creation
# -----------------------------------------------------------------------

HL_PATTERN=$1
if [ "$HL_PATTERN" == "" ]
then
#	No pattern provided
	exit 1
fi

PCI_LIST=""
PCI_ACC=`lspci | grep $HL_PATTERN | cut -f1 -d' '| cut -f1 -d':'`

if [ "$PCI_ACC" == "" ]
then
#	No PCI cards that match
	exit 2
fi

PCI_LIST=`echo $PCI_ACC| tr -s ' ' '|'`
virsh -c qemu:///system?authfile=/etc/ovirt-hosted-engine/virsh_auth.conf nodedev-list --cap pci | egrep "$PCI_LIST"

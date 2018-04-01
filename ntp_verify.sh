#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

PS=$(ps aux | grep ntpd | grep -v grep)

if [[ !(-n "$PS") ]];then
	echo "NOTICE: ntp is not running"
	systemctl restart ntp
fi

DIFF=$(diff -U 0  /etc/ntp.conf.bak /etc/ntp.conf)

if [[ -n "$DIFF" ]];then
	echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
        echo "$DIFF"
	patch -u /etc/ntp.conf <(diff -U 0 /etc/ntp.conf /etc/ntp.conf.bak) >> /dev/null
	systemctl restart ntp
fi


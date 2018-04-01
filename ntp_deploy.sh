#!/bin/bash

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:

DIR=$(echo $0 | sed -r 's/ntp_deploy.sh//g')
if [[ ${DIR:0:2} == *./* ]];then
	DIR=$( echo "$DIR" | sed -r 's/\.\///g')
	PATH_TO="$PWD/$DIR"
else
	cd $(dirname $0)
	PATH_TO=$(echo "$PWD/")
	cd - >> /dev/null
fi
apt -y purge ntp
apt -y install ntp
FILE=$(whereis ntp.conf | awk '{print$2}')
sed -i '/pool/{/#/!d}' "$FILE"
sed -i '/# more information/a\pool ua.pool.ntp.org iburst' "$FILE"
cp /etc/ntp.conf /etc/ntp.conf.bak
systemctl restart ntp
sed -i '/#ntp verify/d' "/etc/crontab"
sed -i '/ntp_verify.sh/d' "/etc/crontab"
echo "#ntp verify" >> /etc/crontab
echo "*/1 * * * * root bash "$PATH_TO"ntp_verify.sh" >> /etc/crontab

#!/bin/bash

rs9116_wifi=`/usr/bin/lsusb | grep 1618:9116 | wc -l`
[ "$rs9116_wifi" == "0" ] && exit 0

TARGET_DIR=`cd "$(dirname "$0")"; pwd`
cd ${TARGET_DIR}/

cmd=`lsmod | grep onebox`
if [ "$cmd" ]; then
	echo "onebox modules are already inserted";
else
	sh onebox_insert.sh
fi

WLAN_BT=3
./onebox_util rpine0 enable_protocol $WLAN_BT

echo "Start wlan interface..."

./onebox_util rpine0 create_vap wifi0 sta hw_bmiss

echo "[Done]"

exit 0

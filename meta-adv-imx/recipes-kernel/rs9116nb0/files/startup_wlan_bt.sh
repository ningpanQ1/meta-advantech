#!/bin/bash

TARGET_DIR=`cd "$(dirname "$0")"; pwd`
cd ${TARGET_DIR}/

cmd=`lsmod | grep rsi`
if [ "$cmd" ]; then
	echo "rs9116n modules are already inserted";
else
	sh onebox_insert.sh
fi

echo "[Done]"

exit 0

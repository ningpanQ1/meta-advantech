#!/bin/sh

# COEX MODE:                  
#							1    WLAN STATION /WIFI-Direct/WLAN PER
#							1    WLAN ACCESS POINT(including muliple APs on different vaps)

#							4    BT CLASSIC MODE/BT CLASSIC PER MODE
#							5    WLAN STATION + BT CLASSIC MODE
#							6    WLAN ACCESS POINT + BT CLASSIC MODE
#							8    BT LE MODE /BT LE PER MODE
#							9    WLAN STATION + BT LE MODE
#                                                       10   WLAN_AP + BT LE MODE
#							12   BT CLASSIC + BT LE MODE 							
#							13   WLAN STATION + BT CLASSIC MODE + BT LE MODE
#							14   WLAN ACCESS POINT + BT CLASSIC MODE+ BT LE MODE
COEX_MODE=5

#to enable debug prints in dmesg. Default value
# of value is 1
DEBUG_IN_DMESG=1
clk_val=50

## hardware interface.
HW_INTERFACE="usb"

PARAMS=" dev_oper_mode=${COEX_MODE} rsi_zone_enabled=$DEBUG_IN_DMESG"

modprobe mac80211
modprobe cfg80211
modprobe bluetooth

cat /dev/null > /var/log/messages
cmd=`lsmod | grep rsi_91x`
if [ "$cmd" ]; then
echo "Removing the open source kernel binaries";
rmmod rsi_usb.ko
rmmod rsi_sdio.ko
rmmod rsi_91x.ko
fi

if [ -f rsi_91x.ko ];then
   insmod rsi_91x.ko $PARAMS 
fi

case $HW_INTERFACE in
usb)
	if [ -f rsi_usb.ko ];then
   		insmod rsi_usb.ko
	fi
	;;
sdio)
	if [ -f rsi_sdio.ko ];then
   		insmod rsi_sdio.ko sdio_clock=${clk_val}
	fi
	;;
esac

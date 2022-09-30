#!/bin/sh

if [ $# -lt 1 ]; then
    exit 0;
fi

case "$1" in
"preinst")
	;;
"postinst")
	fsck.vfat -f -y /dev/mmcblk2p1 2>&1
	## resize2fs mmcblk2p3
	fsck.ext4 -f -y /dev/mmcblk2p3 2>&1
	resize2fs -F /dev/mmcblk2p3  2>&1
	;;
esac

exit 0;

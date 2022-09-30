#!/bin/bash

node=$1
CUR_PATH=${PWD}
IMAGES_PATH=${CUR_PATH}/../images
ABS_DIR_BOOT="/tmp/"$RANDOM$RANDOM$RANDOM
ABS_DIR_RECOVERY="/tmp/"$RANDOM$RANDOM$RANDOM
ABS_DIR_SYSTEM="/tmp/"$RANDOM$RANDOM$RANDOM

#check arg number
if [ $# != 1 ];then
	echo "Usage: ./mkinand-linux.sh /dev/mmcblk2"
	exit
fi

# check the if root?
userid=`id -u`
if [ $userid -ne "0" ]; then
echo "you're not root?"
exit
fi

## check root!
ROOTDRIVE=`mount | grep 'on / ' | awk {'print $1'}`
if [ "$ROOTDRIVE" = "/dev/root" ]; then
    ROOTDRIVE=`readlink /dev/root | cut -c1-12`
else
    ROOTDRIVE=`echo $ROOTDRIVE | cut -c1-12`
fi

if [ "$ROOTDRIVE" = "${node}" ]; then
	ROOTDRIVE=${ROOTDRIVE##*/}
	echo -e "\nWrite image to rootfs partition is forbidden!"
	echo -e "Available Drives to write images to: \n"
    echo "#  major   minor    size   name "
    cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''
    exit 1
fi

#check image file exist or not?
files=`ls ${IMAGES_PATH}`
if [ -z "$files" ]; then
echo "There are no file in image folder."
exit
fi

#check if /dev/sdx exist?
if [ ! -e ${node} ]; then
echo "There is no "${node}" in you system"
exit
fi

#do not ask
#echo "All data on "${node}" now will be destroyed! Continue? [y/n]"
#read ans
#if [ $ans != 'y' ]; then exit 1; fi

# umount device
umount ${node}* 1>/dev/null 2>/dev/null

# destroy the partition table
dd if=/dev/zero of=${node} bs=1M count=10 > /dev/null

#partition
echo "partition start......"
sfdisk ${node} -q --no-reread --force <<EOF
10M,580M,L,*
600M,400M,L
1024M,8190M,L
9216M,,L
write
EOF

sync;sync
sync
echo "partition done"

if [ -x /sbin/partprobe ]; then
	/sbin/partprobe ${node} > /dev/null
else
	sleep 1
fi

## we sleep 5s to wait kernel ready.
sleep 5

umount ${node}p1 1>/dev/null 2>&1
umount ${node}p2 1>/dev/null 2>&1
umount ${node}p3 1>/dev/null 2>&1
umount ${node}p4 1>/dev/null 2>&1

# format filesystem
mkfs.vfat -F 32 -n "boot" ${node}p1 1>/dev/null 2>/dev/null
mkfs.vfat -F 32 -n "recovery" ${node}p2 1>/dev/null 2>/dev/null
mkfs.ext4 -O ^has_journal -F -q -L "rootfs" ${node}p3  1>/dev/null 2>/dev/null
mkfs.ext4 -O ^has_journal -F -q -L "userdata" ${node}p4  1>/dev/null 2>/dev/null
sync;sync
sync

## we sleep 1s to wait kernel ready.
sleep 1

# copy files
echo "dd [u-boot] ..."
#This is diffrent from mksd_*.sh
dd if=${IMAGES_PATH}/flash.bin  of=${node} bs=1k seek=33 1>/dev/null 2>/dev/null
sync

rm -fr $ABS_DIR_BOOT $ABS_DIR_RECOVERY $ABS_DIR_SYSTEM
mkdir -p $ABS_DIR_BOOT
mkdir -p $ABS_DIR_RECOVERY
mkdir -p $ABS_DIR_SYSTEM

##copy to kernel part
echo "copy [Image & dtb] ..."
umount ${node}p1 1>/dev/null 2>&1
mount ${node}p1  $ABS_DIR_BOOT
rm -fr $ABS_DIR_BOOT/*
cp -a ${IMAGES_PATH}/Image $ABS_DIR_BOOT/
cp -a ${IMAGES_PATH}/*.dtb $ABS_DIR_BOOT/

## caculate the md5 sum value
MD5=$(cd ${IMAGES_PATH} && md5sum Image)
echo "$MD5" >> $ABS_DIR_BOOT/md5sums
MD5=$(cd ${IMAGES_PATH} && md5sum *.dtb)
echo "$MD5" >> $ABS_DIR_BOOT/md5sums
cat $ABS_DIR_BOOT/md5sums
sync;sync
sync
umount -f $ABS_DIR_BOOT 1>/dev/null 2>&1

## copy to recovery part
echo "copy [initrd.img] ..."
mount ${node}p2  $ABS_DIR_RECOVERY
rm -rf $ABS_DIR_RECOVERY/*
cp ${IMAGES_PATH}/initrd.img  $ABS_DIR_RECOVERY/
MD5=$(cd ${IMAGES_PATH} && md5sum initrd.img)
echo "$MD5" >> $ABS_DIR_RECOVERY/md5sums
cat $ABS_DIR_RECOVERY/md5sums
sync;sync
sync
umount -f $ABS_DIR_RECOVERY 1>/dev/null 2>&1

##copy to rootfs part
umount -f ${node}p3 1>/dev/null 2>&1
fuser -m -k ${ABS_DIR_SYSTEM}
sync
mount ${node}p3 $ABS_DIR_SYSTEM
sync
rm -fr $ABS_DIR_SYSTEM/*
echo "copy [rootfs] ..."
cp -a ${IMAGES_PATH}/rootfs/* $ABS_DIR_SYSTEM/ 
sync;sync
sync
umount -f $ABS_DIR_SYSTEM 1>/dev/null 2>&1

echo "Sync ..."
sync;sync
sync

rm -rf "$ABS_DIR_BOOT" "$ABS_DIR_RECOVERY" "$ABS_DIR_SYSTEM"

echo "[Done!]"

#!/bin/bash

CONTAINER_VER="1.0"
PRODUCT_NAME="swupdate-image"
DTB_IMAGE="imx8mm-adv-eamb9918-a1.dtb"
KERNEL_IMAGE=Image
ROOTFS_EXT4_IMAGE=$1
FIXUP_SCRIPT=fixupdate.sh

[ ! -e "sw-description" ] && echo "sw-description is missing" && exit 1
FILES="sw-description"

echo "sw-description is as below:"
cat sw-description

if [ -e "$DTB_IMAGE" ] && [ -e "$KERNEL_IMAGE" ];then
	echo "generate the boot.img."
	## 128M
	rm -rf boot.img
	dd if=/dev/zero of=boot.img count=154112 bs=1024 1>/dev/null 2>&1
	mkfs.vfat -F 32 -n "boot" boot.img 1>/dev/null 2>&1
	fsck.vfat -af boot.img 2>&1 1>/dev/null
	mkdir -p ./.BOOTIMG
	mount -t vfat boot.img ./.BOOTIMG
	cp $DTB_IMAGE $KERNEL_IMAGE ./.BOOTIMG/
	sync
	umount ./.BOOTIMG
	rm -rf ./.BOOTIMG
	FILES="${FILES} boot.img"
fi

if [ -e "$ROOTFS_EXT4_IMAGE" ];then
	echo "generate the rootfs compressed image by zstd type."
	result=`cat sw-description | grep "rootfs.zstd"`
	[ "x$result" = "x" ] && echo "sw-description is not config rootfs item" && exit 1
	result=`cat sw-description | grep compressed | grep zstd`
	[ "x$result" = "x" ] && echo "sw-description has invalid compressed type for rootfs" && exit 1
	rm -rf rootfs.zstd
	result=`e2label $ROOTFS_EXT4_IMAGE | grep ext`
	[ "x$result" = "x" ] && e2label $ROOTFS_EXT4_IMAGE rootfs
	zstd $ROOTFS_EXT4_IMAGE -f -o rootfs.zstd
	FILES="${FILES} rootfs.zstd"
fi

if [ -e "$FIXUP_SCRIPT" ];then
	FILES="${FILES} ${FIXUP_SCRIPT}"
fi

echo "update file list: [$FILES]"

for i in $FILES;
do
     echo $i;
done | ./cpio -ov -H crc >  ${PRODUCT_NAME}_${CONTAINER_VER}.swu


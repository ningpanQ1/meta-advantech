#!/bin/bash
 
ROOT=$(pwd)
ABS_IMAGESDIR=${ROOT}/../images
 
[[ "${IMAGE_VERSION}" == "" ]] && IMAGE_VERSION=1.0.0
 
ABS_BL_IMAGE=${ABS_IMAGESDIR}/flash.bin
ABS_KERNEL_IMAGE=${ABS_IMAGESDIR}/Image
ABS_DTB_IMAGE=${ABS_IMAGESDIR}/*.dtb
ABS_INITRD_IMAGE=${ABS_IMAGESDIR}/initrd.img
ABS_ROOTFS=${ABS_IMAGESDIR}/rootfs
ABS_ADDON=${ABS_IMAGESDIR}/addon

ABS_OUT_DIR=${ROOT}/out
ABS_SD_IMAGE=${ABS_OUT_DIR}"/""eamb9918-sdcard_${IMAGE_VERSION}.img"
ABS_SD_DIR_BOOT="/tmp/"$RANDOM$RANDOM$RANDOM
ABS_SD_DIR_RECOVERY="/tmp/"$RANDOM$RANDOM$RANDOM
ABS_SD_DIR_SYSTEM="/tmp/"$RANDOM$RANDOM$RANDOM
 
function do_sdcard_image {
    if [[ ! -d "$ABS_IMAGESDIR" ||
          ! -d "$ABS_ROOTFS" ||
         ! -a "$ABS_BL_IMAGE" ||
		 ! -a "$ABS_INITRD_IMAGE" ||
         ! -a "$ABS_KERNEL_IMAGE" ]]; then
        echo "missing file or files, abort!"
	echo "$ABS_IMAGESDIR"
	echo "$ABS_ROOTFS"
	echo "$ABS_BL_IMAGE"

        exit -1
    fi
 
    if [ -a "$ABS_SD_IMAGE" ]; then
        echo "sdcard image (""$ABS_SD_IMAGE"") already existant, abort!!"
        exit -1
    fi

    echo "generate fullsize sdcard-Image"
    mkdir -p "$ABS_OUT_DIR"
    # 10 GB
    dd if=/dev/zero of="$ABS_SD_IMAGE" bs=65536 count=163840     
 
    echo "partitioning sdcard-Image"
    LOOPDEVICE=$(losetup -f)
    losetup "$LOOPDEVICE" "$ABS_SD_IMAGE"
 
    # set sizes of partitions:
    B_START_SIZE=10  #in MiB
    B_BOOTP_SIZE=200 #in MiB
     
    A=$B_START_SIZE
	B=600	#in MiB
	C=1024	#in MiB
	D=9216	#in MiB
     
    echo A: $A
    echo B: $B
     
    parted -a optimal --script "$LOOPDEVICE" \
        mklabel msdos \
        unit B \
        mkpart primary ext4 "$A"MiB "$B"MiB \
        set 1 boot on \
		mkpart primary ext4 "$B"MiB "$C"MiB \
		mkpart primary ext4 "$C"MiB "$D"MiB \
		mkpart primary ext4 "$D"MiB '100%' \
        print
 
    partprobe "$LOOPDEVICE"
    # set labels accordingly:  BOOT, SYSTEM
    mkfs.vfat -F 32 -n "boot" "$LOOPDEVICE"p1  
	mkfs.vfat -F 32 -n "recovery" "$LOOPDEVICE"p2
    mkfs.ext4 -O ^has_journal -E stride=2,stripe-width=1024 -b 4096 -L "rootfs" "$LOOPDEVICE"p3
	mkfs.ext4 -O ^has_journal -E stride=2,stripe-width=1024 -b 4096 -L "userdata" "$LOOPDEVICE"p4
 
    mkdir -p "$ABS_SD_DIR_BOOT"
    mkdir -p "$ABS_SD_DIR_SYSTEM"
	mkdir -p "$ABS_SD_DIR_RECOVERY"
 
    mount "$LOOPDEVICE"p1 "$ABS_SD_DIR_BOOT"
	mount "$LOOPDEVICE"p2 "$ABS_SD_DIR_RECOVERY"
    mount "$LOOPDEVICE"p3 "$ABS_SD_DIR_SYSTEM"
 
    echo "copy kernel Image + device tree to boot-partition"
    TMP_CMD="cp ""$ABS_KERNEL_IMAGE"" ""$ABS_SD_DIR_BOOT" && eval $TMP_CMD
    TMP_CMD="cp ""$ABS_DTB_IMAGE"" ""$ABS_SD_DIR_BOOT" && eval $TMP_CMD
 
    ## caculate the md5 sum value
    TMPFILE="/tmp/"$RANDOM$RANDOM$RANDOM
    MD5=$(cd $(dirname "$ABS_KERNEL_IMAGE") && md5sum $(basename "$ABS_KERNEL_IMAGE"))
    echo "$MD5" >> "$TMPFILE"
    MD5=$(cd $(dirname "$ABS_DTB_IMAGE") && md5sum $(basename "$ABS_DTB_IMAGE"))
    echo "$MD5" >> "$TMPFILE"
    MD5SFILE_BOOT=${ABS_SD_DIR_BOOT}"/md5sums"
    cp "$TMPFILE" "$MD5SFILE_BOOT"
    cat "$MD5SFILE_BOOT"
 
	echo "copy initrd to recovery-partition"
	TMP_CMD="cp ""$ABS_INITRD_IMAGE"" ""$ABS_SD_DIR_RECOVERY" && eval $TMP_CMD
	MD5=$(cd $(dirname "$ABS_INITRD_IMAGE") && md5sum $(basename "$ABS_INITRD_IMAGE"))
	echo "$MD5" >> 	"$ABS_SD_DIR_RECOVERY""/md5sums"
	cat "$ABS_SD_DIR_RECOVERY""/md5sums"

    echo "copy bootloader"
    dd if="$ABS_BL_IMAGE" of="$LOOPDEVICE" bs=1k seek=33
 
    echo "copy rootfs to system-partition"
    TMP_CMD="cp -a ""$ABS_IMAGESDIR""/rootfs/* ""$ABS_SD_DIR_SYSTEM" && eval $TMP_CMD
 
	echo "[Copying iNAND upgrate tools...]"
	TMP_CMD="mkdir -p $ABS_SD_DIR_SYSTEM/mk_inand" && eval $TMP_CMD
    TMP_CMD="mkdir -p $ABS_SD_DIR_SYSTEM/mk_inand/images" && eval $TMP_CMD
	TMP_CMD="mkdir -p $ABS_SD_DIR_SYSTEM/mk_inand/scripts" && eval $TMP_CMD
	
	TMP_CMD="cp -a  $ABS_KERNEL_IMAGE $ABS_SD_DIR_SYSTEM/mk_inand/images/" && eval $TMP_CMD
	TMP_CMD="cp -a  $ABS_DTB_IMAGE  $ABS_SD_DIR_SYSTEM/mk_inand/images/" && eval $TMP_CMD
	TMP_CMD="cp -a  $ABS_BL_IMAGE  $ABS_SD_DIR_SYSTEM/mk_inand/images/" && eval $TMP_CMD
	TMP_CMD="cp -a  $ABS_INITRD_IMAGE  $ABS_SD_DIR_SYSTEM/mk_inand/images/" && eval $TMP_CMD
	TMP_CMD="cp -a  $ABS_IMAGESDIR/rootfs  $ABS_SD_DIR_SYSTEM/mk_inand/images/" && eval $TMP_CMD
	TMP_CMD="cp -a  ${ROOT}/mkinand-linux.sh ${ROOT}/mkspi-advboot.sh  $ABS_SD_DIR_SYSTEM/mk_inand/scripts/" && eval $TMP_CMD
	
    echo "umount loopdevices"
    umount "$LOOPDEVICE"p3
	umount "$LOOPDEVICE"p2
    umount "$LOOPDEVICE"p1
    sync;sync
	sync
    losetup -d "$LOOPDEVICE"
 
    echo "delete tmp files"
    rmdir "$ABS_SD_DIR_BOOT"
    rmdir "$ABS_SD_DIR_SYSTEM"
	rmdir "$ABS_SD_DIR_RECOVERY"
 
    echo; echo
    echo -e "\t dd if=""$ABS_SD_IMAGE"" of=/dev/sdXXX bs=4096 -> to a 8GB SD/eMMC-Card"
    echo; echo
}
 
 
do_sdcard_image
 
echo "**** END OF $0 ***"

# Generates a advantech swupdate recovery Initramfs image

IMAGE_FSTYPES = "cpio.gz.u-boot tar.bz2"
IMAGE_ROOTFS_SIZE ?= "8192"

IMAGE_LINGUAS = "en-us"

inherit core-image

CORE_IMAGE_BASE_INSTALL = " \
	${CORE_IMAGE_EXTRA_INSTALL} \
"

CORE_IMAGE_EXTRA_INSTALL =  " \
	bash \
	tiny-init \
	base-files \
	base-passwd \
	busybox \
	mtd-utils \
	mtd-utils-ubifs \
	dosfstools \
	exfat-utils \
	e2fsprogs \
	e2fsprogs-e2fsck \
	e2fsprogs-resize2fs \
	libconfig \
	libubootenv \
	swupdate \
	swupdate-engine \
	swupdate-www \
	util-linux-sfdisk \
"

RRECOMMENDS:${PN} = "\
    ${MACHINE_EXTRA_RRECOMMENDS} \
    module-init-tools \
"

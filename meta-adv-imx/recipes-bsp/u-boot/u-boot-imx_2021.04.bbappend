FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

UBOOT_SRC = "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "lf_v2021.04"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "8027e4b5161e21f38ad5ba1ddd047bbeadbb0554"

LOCALVERSION = "-${SRCBRANCH}"

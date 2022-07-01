FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

UBOOT_SRC = "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "lf_v2021.04"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "75a5d09c66383b083cf0857be739b03f63d7985c"

LOCALVERSION = "-${SRCBRANCH}"

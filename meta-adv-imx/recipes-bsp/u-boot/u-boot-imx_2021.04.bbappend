FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

UBOOT_SRC = "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "lf_v2021.04"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "0f179da8b8dd971a17992785de6c9b0c14cc537d"

LOCALVERSION = "-${SRCBRANCH}"

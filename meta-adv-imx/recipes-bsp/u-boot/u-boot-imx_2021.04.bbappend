FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

UBOOT_SRC = "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "lf_v2021.04"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "22aad24a5177bde4f48da4c6d503a3b03d6128a4"

LOCALVERSION = "-${SRCBRANCH}"

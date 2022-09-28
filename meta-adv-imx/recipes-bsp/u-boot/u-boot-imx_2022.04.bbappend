FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

UBOOT_SRC = "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "lf_v2022.04"
SRC_URI = "${UBOOT_SRC};branch=${SRCBRANCH}"
SRCREV = "642b7925a0bcfc145e5ef51214b008afe472cc6d"
LOCALVERSION = "-${SRCBRANCH}"

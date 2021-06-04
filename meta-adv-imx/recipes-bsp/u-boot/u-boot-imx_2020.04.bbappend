FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

UBOOT_SRC ?= "git://github.com/Advantech-IIoT/uboot-imx.git;protocol=https"
SRCBRANCH = "imx_v2020.04_5.4.70_2.3.0"
SRCREV = "026171d80b964aec0c5103e0d9cd561530c1b4da"
LOCALVERSION ?= "-5.4.70-2.3.0"

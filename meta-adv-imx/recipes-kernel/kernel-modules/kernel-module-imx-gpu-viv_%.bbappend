SRCBRANCH = "lf-5.15.y"
LOCALVERSION = "-lts-5.15.y"
KERNEL_SRC = "git://github.com/Advantech-IIoT/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
SRC_URI = " \
    ${KERNEL_SRC};subpath=drivers/mxc/gpu-viv;destsuffix=git/src \
    file://Add-makefile.patch \
"
SRCREV = "065aa1f91e58e1108720dc701a074760be878962"

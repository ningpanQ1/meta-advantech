SRCBRANCH = "lf-5.15.y"
LOCALVERSION = "-lts-5.15.y"
KERNEL_SRC = "git://github.com/Advantech-IIoT/linux-imx.git;protocol=https;branch=${SRCBRANCH}"
SRC_URI = "${KERNEL_SRC}"
SRCREV = "065aa1f91e58e1108720dc701a074760be878962"


addtask copy_defconfig_v2 after do_copy_defconfig before do_merge_delta_config
do_copy_defconfig_v2 () {
    install -d ${B}
    if [ ${DO_CONFIG_V7_COPY} = "yes" ]; then
        # copy latest imx_v7_defconfig to use for mx6, mx6ul and mx7
        mkdir -p ${B}
        cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/.config
    else
        # copy latest imx_v8_adv_defconfig to use for mx8
        mkdir -p ${B}
        cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
    fi
}

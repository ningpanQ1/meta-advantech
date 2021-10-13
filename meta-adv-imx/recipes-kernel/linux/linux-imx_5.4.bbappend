FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "imx_5.4.70_2.3.0"
LOCALVERSION = "-2.3.0"
KERNEL_SRC = "git://github.com/Advantech-IIoT/linux-imx.git;protocol=https"
SRCREV = "f98eadd66eae354fa20c6472b266b1f46dfdeda0"


addtask copy_defconfig_v2 after do_copy_defconfig before do_merge_delta_config
do_copy_defconfig_v2 () {
    install -d ${B}
    if [ ${DO_CONFIG_V7_COPY} = "yes" ]; then
        # copy latest imx_v7_defconfig to use for mx6, mx6ul and mx7
        mkdir -p ${B}
        cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/.config
        cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/../defconfig
    else
        # copy latest imx_v8_defconfig to use for mx8
        mkdir -p ${B}
        cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
        cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
    fi
}

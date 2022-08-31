FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "lf-5.10.y"
LOCALVERSION = "-lts-5.10.y"
KERNEL_SRC = "git://github.com/Advantech-IIoT/linux-imx.git;protocol=https"
SRCREV = "66a33391604a0f9048104405c9b70b3e324933a1"
SRC_URI_append += "\
       file://logo_adv_custom_1024_600_clut224.ppm \
       file://logo_adv_custom_1280_800_clut224.ppm \
       file://logo_adv_custom_1366_768_clut224.ppm \
       file://logo_adv_custom_1920_1080_clut224.ppm \
"

addtask do_after_unpack after do_unpack before do_copy_defconfig
do_after_unpack() {
	cp "${WORKDIR}/logo_adv_custom_1024_600_clut224.ppm" "${WORKDIR}/git/drivers/video/logo/"
        cp "${WORKDIR}/logo_adv_custom_1280_800_clut224.ppm" "${WORKDIR}/git/drivers/video/logo/"
        cp "${WORKDIR}/logo_adv_custom_1366_768_clut224.ppm" "${WORKDIR}/git/drivers/video/logo/"
        cp "${WORKDIR}/logo_adv_custom_1920_1080_clut224.ppm" "${WORKDIR}/git/drivers/video/logo/"
}

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



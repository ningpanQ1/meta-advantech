FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
SRCBRANCH = "imx_5.4.70_2.3.0"
LOCALVERSION = "-2.3.0"
KERNEL_SRC = "git://github.com/Advantech-IIoT/linux-imx.git;protocol=https"
SRCREV = "5f2929ac71822fe2f8e5cb01dd530a97ff724036"
LIC_FILES_CHKSUM = "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

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
        cp ${S}/arch/arm/configs/imx_v7_defconfig ${B}/../defconfig
    else
        # copy latest imx_v8_defconfig to use for mx8
        mkdir -p ${B}
        cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/.config
        cp ${S}/arch/arm64/configs/imx_v8_adv_defconfig ${B}/../defconfig
    fi
}


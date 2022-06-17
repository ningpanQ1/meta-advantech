# Copyright 2021 Advantech

DESCRIPTION = "RS9116-NB0 wifi and BT Support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit module
inherit pkgconfig systemd

SRC_URI = "git://github.com/SiliconLabs/RS911X-nLink-OSD.git;protocol=https \
		file://startup_wlan_bt.sh \
		file://onebox_insert.sh \
		file://wifibt.service \
		file://001_fixup_makefile_build.patch \
"
SRCREV = "591aae04861c6c7ab374e03135be5d58ffb8c62f"
PV = "2022.06_git"

RDEPENDS_${PN} = "bash"

S = "${WORKDIR}/git"
B = "${S}/rsi"

do_configure() {
	oe_runmake KERNELDIR=${STAGING_KERNEL_DIR} clean
}

do_compile() {
	oe_runmake KERNELDIR=${STAGING_KERNEL_DIR}   \
		   CC="${CC}" LD="${LD}" LDFLAGS="${LDFLAGS}"
}

do_install() {
	install -d ${D}/usr/local/wifibt
	install -m 755 ${WORKDIR}/startup_wlan_bt.sh ${D}/usr/local/wifibt/
	install -m 755 ${WORKDIR}/onebox_insert.sh ${D}/usr/local/wifibt/

	# Systemd
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
       	install -d ${D}${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/wifibt.service  ${D}${systemd_unitdir}/system
	fi

	## install the release
	install -m 755 ${B}/release/rsi_91x.ko    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/rsi_sdio.ko     ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/rsi_usb.ko    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*.txt    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/bt_ble_gain_table_update    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/bt_util    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/onebox_util    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/receive    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/transmit*    ${D}/usr/local/wifibt/
}

SYSTEMD_SERVICE:${PN} = "wifibt.service"

# List the files for Package
FILES:${PN} += "${exec_prefix} ${systemd_system_unitdir}"

## Since no pass LDFLAGS for these program, so we
## we must skip the qa check
INSANE_SKIP:${PN} += "ldflags"
INHIBIT_PACKAGE_STRIP = "1" 

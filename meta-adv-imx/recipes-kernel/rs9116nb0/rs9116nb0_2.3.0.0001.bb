# Copyright 2021 Advantech

DESCRIPTION = "RS9116-NB0 wifi and BT Support"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit module
inherit pkgconfig systemd

SRC_URI = "file://rs9116nb0.2.3.0.0001.tar.bz2 \
		file://defconfig \
		file://startup_wlan_bt.sh \
		file://wifibt.service \
		file://0001_change_COEX_MODE.patch \
" 

RDEPENDS_${PN} = "bash"

S = "${WORKDIR}/rs9116nb0.2.3.0.0001"
B = "${S}/source/host"

do_configure() {
	cp ${WORKDIR}/defconfig   ${B}/.config
}

do_compile() {
	oe_runmake KERNELDIR=${STAGING_KERNEL_DIR}   \
		   CC="${CC}" LD="${LD}" LDFLAGS="${LDFLAGS}"
}

do_install() {
	install -d ${D}/usr/local/wifibt
	install -m 755 ${WORKDIR}/startup_wlan_bt.sh ${D}/usr/local/wifibt/

	# Systemd
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
       	install -d ${D}${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/wifibt.service  ${D}${systemd_unitdir}/system
	fi

	## install the release

	install -m 755 ${B}/release/*_util     ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*_transmit     ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/ant_encryption     ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*receive    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*.txt    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/afe_spi    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/wpa_supplicant*    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*_app    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/zb_util    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*.sh    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*.ko    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/*.conf    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/bt_bbp_utils    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/wlan_iqs    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/doth_over_ride    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/PER_TEST_GUI.py   ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/start_atm    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/transmit   ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/p2pcommands.pl    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/soc_pll_reg    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/scr.py    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/gpio_reg    ${D}/usr/local/wifibt/ 
	install -m 755 ${B}/release/transmit_packet    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/atm_data    ${D}/usr/local/wifibt/
	install -m 755 ${B}/release/START_RS9116_NBZ_D0N   ${D}/usr/local/wifibt/ 

	install -d ${D}/usr/local/wifibt/SmartEvk
	install -m 755 ${B}/release/SmartEvk/*    ${D}/usr/local/wifibt/SmartEvk/
	install -d ${D}/usr/local/wifibt/certs
	install -m 755 ${B}/release/certs/*    ${D}/usr/local/wifibt/certs/
	install -d ${D}/usr/local/wifibt/firmware
	install -m 755 ${B}/release/firmware/*    ${D}/usr/local/wifibt/firmware/
	install -d ${D}/usr/local/wifibt/flash
	install -d ${D}/usr/local/wifibt/flash/WC
	install -m 755 ${B}/release/flash/WC/*    ${D}/usr/local/wifibt/flash/WC/
	install -m 755 ${B}/release/flash/*.c    ${D}/usr/local/wifibt/flash/
	install -m 755 ${B}/release/flash/*.sh    ${D}/usr/local/wifibt/flash/
	install -m 755 ${B}/release/flash/*.h    ${D}/usr/local/wifibt/flash/
	install -m 755 ${B}/release/flash/*.txt    ${D}/usr/local/wifibt/flash/
	install -m 755 ${B}/release/flash/FIPS_KEY    ${D}/usr/local/wifibt/flash/
}

SYSTEMD_SERVICE:${PN} = "wifibt.service"

# List the files for Package
FILES:${PN} += "${exec_prefix} ${systemd_system_unitdir}"

## Since no pass LDFLAGS for these program, so we
## we must skip the qa check
INSANE_SKIP:${PN} += "ldflags"
INHIBIT_PACKAGE_STRIP = "1" 

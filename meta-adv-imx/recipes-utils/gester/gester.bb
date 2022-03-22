SUMMARY = "gester"
SECTION = "base"
LICENSE = "LGPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=3000208d539ec061b899bce1d9ce9404"

SRC_URI = "git://github.com/Advantech-IIoT/gester.git;protocol=git;branch=master \
           file://gester.service \
           file://0001_fix_make_err.patch \
"
SRC_URI[md5sum] = "176047737c1a23fb1b6ed2dd1d7b79b4"
SRC_URI[sha256sum] = "53a46ed5ea20fdc40611a4f444370b4337b5f491068c33e842633e0f81596f81"

SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit pkgconfig systemd 

INSANE_SKIP_${PN} = "ldflags"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

do_compile() {
        oe_runmake LD="${CXX}" CC="${CC}" CXX="${CXX}" AR="${AR}"
}

do_install() {	
	install -d ${D}/usr/bin/
        install -m 755 ${S}/bin/gester ${D}/usr/bin/

	# Systemd
	if ${@bb.utils.contains('DISTRO_FEATURES','systemd','true','false',d)}; then
       	install -d ${D}${systemd_unitdir}/system
		install -m 0644 ${WORKDIR}/gester.service  ${D}${systemd_unitdir}/system
	fi
}
SYSTEMD_SERVICE_${PN} = "gester.service"
EXTRA_OEMAKE = "all ${S}"

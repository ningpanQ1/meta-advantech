FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://001_changed_mmcblkp4_on_userdata.patch"

do_install:append() {
	install -d  ${D}/userdata
}

FILES:${PN} += "/userdata"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://001_changed_mmcblkp4_on_userdata.patch"

do_install_append() {
	install -d  ${D}/userdata
}

FILES_${PN} += "/userdata"

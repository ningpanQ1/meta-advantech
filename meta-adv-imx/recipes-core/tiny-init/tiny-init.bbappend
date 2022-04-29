FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://init.tiny \
	   file://rc.local.sample \
	  "

do_install() {
	install -d ${D}${sysconfdir}
	install -Dm 0755 ${WORKDIR}/init.tiny ${D}${sysconfdir}/init
	install -Dm 0755 ${WORKDIR}/rc.local.sample ${D}${sysconfdir}/init.d/rcS.local
}

FILES:${PN} = "${sysconfdir} ${sysconfdir}/init.d/"

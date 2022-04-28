FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI:append = " file://fw_env.config"
SRCREV = "ba7564f5006d09bec51058cf4f5ac90d4dc18b3c"

do_install:append() {
	install -d ${D}${sysconfdir}
	install -m 644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}
}

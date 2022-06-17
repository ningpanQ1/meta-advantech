DESCRIPTION = "swupdate tools for generate OTA images"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"
SECTION = "BSP"

SWUPDATE_TOOLS = "swupdate-tools"

inherit deploy

SRC_URI = "file://mkupdateimg.sh \
		file://fixupdate.sh \
		file://sw-description"


DEPENDS += "cpio-native"

S = "${WORKDIR}"

# This package aggregates output deployed by other packages,
# so set the appropriate dependencies
do_compile[depends] += " cpio-native:do_populate_sysroot"
do_compile() {
	bbnote "${STAGING_DIR_NATIVE}${base_bindir}/cpio is generated!"
}

do_deploy() {
	install -d ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755  ${STAGING_DIR_NATIVE}${base_bindir}/cpio  ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/mkupdateimg.sh        ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/fixupdate.sh        ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/sw-description        ${DEPLOYDIR}/${SWUPDATE_TOOLS}

	if [ -e ${DEPLOY_DIR_IMAGE}/Image ] ; then
		install -m 0755 ${DEPLOY_DIR_IMAGE}/Image		${DEPLOYDIR}/${SWUPDATE_TOOLS}/Image
		for dtb in ${KERNEL_DEVICETREE}; do
			DTB_BASE_NAME=`basename ${dtb}`
			install -m 0755 ${DEPLOY_DIR_IMAGE}/${DTB_BASE_NAME}   ${DEPLOYDIR}/${SWUPDATE_TOOLS}
		done
	fi
}
addtask deploy after do_compile

do_install[noexec] = "1"
do_package[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_qa[noexec] = "1"
do_package_write_deb[noexec] = "1"

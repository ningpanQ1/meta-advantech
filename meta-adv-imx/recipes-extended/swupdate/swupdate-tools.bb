DESCRIPTION = "swupdate tools for generate OTA images"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"
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
	install -d ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	cp ${STAGING_DIR_NATIVE}${base_bindir}/cpio        ${DEPLOYDIR}/${SWUPDATE_TOOLS}
}

do_deploy() {
	install -d ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/mkupdateimg.sh        ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/fixupdate.sh        ${DEPLOYDIR}/${SWUPDATE_TOOLS}
	install -m 0755 ${S}/sw-description        ${DEPLOYDIR}/${SWUPDATE_TOOLS}

	if [ -e ${DEPLOY_DIR_IMAGE}/Image ] ; then
		cp ${DEPLOY_DIR_IMAGE}/Image		${DEPLOYDIR}/${SWUPDATE_TOOLS}/Image
		for dtb in ${KERNEL_DEVICETREE}; do
			DTB_BASE_NAME=`basename ${dtb}`
			cp ${DEPLOY_DIR_IMAGE}/${DTB_BASE_NAME}   ${DEPLOYDIR}/${SWUPDATE_TOOLS}		
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

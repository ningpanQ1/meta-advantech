FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"
#SRC_URI_append = " file://Fix-build-breaks-on-non-gbm-machines.patch \
#"

CHROMIUM_EXTRA_ARGS_append = " --disable-features=VizDisplayCompositor --in-process-gpu"

mime_xdg_postinst(){
	#override the mime_xdg_postinst
}

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append += " \
    file://0001-change-to-debug-version.patch \
    file://0002-set-restart-always.patch \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-change-to-debug-version.patch \
    file://0002-set-restart-always.patch \
"

SUMMARY = "Falkon Webbrowser"
HOMEPAGE = "http://www.falkon.org"
SECTION = "x11"

LICENSE = "GPLv3 & LGPLv3 & MIT"
LIC_FILES_CHKSUM = "file://COPYING;md5=8f0e2cd40e05189ec81232da84bd6e1a"

DEPENDS  = "libxcb ki18n openssl qtbase qttools-native qtwebengine qtx11extras"

inherit cmake_qt5_extra gettext kde-base

SRC_URI = "https://download.kde.org/stable/falkon/3.1/falkon-3.1.0.tar.xz \
           file://0001-fix-QPainterPath-QFile-missing-include.patch \
           "
SRC_URI[md5sum] = "9255fb335d3ba361dea44b7b297ddf7d"
SRC_URI[sha256sum] = "ce743cd80c0e2d525a784e29c9b487f73480119b0567f9ce8ef1f44cca527587"

PATH_prepend = "${STAGING_DIR_NATIVE}${OE_QMAKE_PATH_QT_BINS}:"

export USE_LIBPATH = "${libdir}"
export QUPZILLA_PREFIX = "${prefix}"
export SHARE_FOLDER = "${datadir}"
export QMAKE_LRELEASE = "${RECIPE_SYSROOT_NATIVE}/usr/bin/qt5"

FILES_${PN} += " \
    ${OE_QMAKE_PATH_DATA}/icons \
    ${OE_QMAKE_PATH_DATA}/metainfo \
    ${OE_QMAKE_PATH_DATA}/bash-completion/completions \
    ${OE_QMAKE_PATH_PLUGINS}/falkon \
"

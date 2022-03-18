# Copyright 2021-2022 Advantech
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packagegroup to provide necessary tools for advantech image"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

SWUPDATE_PKS = " \
    libubootenv \
    swupdate-engine \
"

## packages
RDEPENDS_${PN} = " \
    stress-ng \
    mdio-tool \
    parted \
    ${SWUPDATE_PKS} \
    gester \
"

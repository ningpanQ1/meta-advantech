# Copyright 2021-2022 Advantech
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Packagegroup to provide necessary tools for advantech image"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

## tools
RDEPENDS_${PN} = " \
    stress-ng \
    mdio-tool \
    parted \
"

#!/bin/sh
#
# i.MX Yocto Project Build Environment Setup Script
#
# Copyright (C) 2011-2016 Freescale Semiconductor
# Copyright 2017 NXP
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

. sources/meta-imx/tools/setup-utils.sh

CWD=`pwd`
PROGNAME="setup-environment"
exit_message ()
{
   echo "To return to this build environment later please run:"
   echo "    source setup-environment <build_dir>"

}

usage()
{
    echo -e "\nUsage: source imx-setup-release.sh
    Optional parameters: [-b build-dir] [-h]"
echo "
    * [-b build-dir]: Build directory, if unspecified script uses 'build' as output directory
    * [-h]: help

Supported machines: `echo; ls sources/meta-advantech/*/conf/machine/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Supported Freescale's distros: `echo; ls sources/meta-freescale-distro/conf/distro/fslc-*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Available Poky's distros: `echo; ls sources/poky/meta-poky/conf/distro/*.conf \
| sed s/\.conf//g | sed -r 's/^.+\///' | xargs -I% echo -e "\t%"`

Examples:

- To create a new Yocto build directory:
  $ MACHINE=imx8mmeamb9918a1 DISTRO=fsl-imx-xwayland source imx-setup-release.sh -b imx8mmeamb9918a1

- To use an existing Yocto build directory:
  $ source $PROGNAME build
"
}


clean_up()
{
    unset CWD BUILD_DIR FSLDISTRO
    unset fsl_setup_help fsl_setup_error fsl_setup_flag
    unset usage clean_up
    unset ARM_DIR META_ADV_BSP_RELEASE
    exit_message clean_up
}

# get command line options
OLD_OPTIND=$OPTIND
unset FSLDISTRO

while getopts "k:r:t:b:e:gh" fsl_setup_flag
do
    case $fsl_setup_flag in
        b) BUILD_DIR="$OPTARG";
           echo -e "\n Build directory is " $BUILD_DIR
           ;;
        h) fsl_setup_help='true';
           ;;
        \?) fsl_setup_error='true';
           ;;
    esac
done
shift $((OPTIND-1))
if [ $# -ne 0 ]; then
    fsl_setup_error=true
    echo -e "Invalid command line ending: '$@'"
fi
OPTIND=$OLD_OPTIND
if test $fsl_setup_help; then
    usage && clean_up && return 1
elif test $fsl_setup_error; then
    clean_up && return 1
fi


if [ -z "$DISTRO" ]; then
    if [ -z "$FSLDISTRO" ]; then
        FSLDISTRO='fsl-imx-xwayland'
    fi
else
    FSLDISTRO="$DISTRO"
fi

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR='build'
fi

if [ -z "$MACHINE" ]; then
    echo setting to default machine
    MACHINE='imx8mmeamb9918a1'
fi

case $MACHINE in
imx8*)
    case $DISTRO in
    *wayland)
        : ok
        ;;
    *)
        echo -e "\n ERROR - Only Wayland distros are supported for i.MX 8 or i.MX 8M"
        echo -e "\n"
        return 1
        ;;
    esac
    ;;
*)
    : ok
    ;;
esac

# get bsp current git log timestamp
cd $CWD/.repo/manifests
SOURCE_DATE_EPOCH=$(git log -1 --pretty=%ct)
REPRODUCIBLE_TIMESTAMP_ROOTFS=$(git log -1 --pretty=%ct)
cd -

# Cleanup previous meta-freescale/EULA overrides
cd $CWD/sources/meta-freescale
if [ -h EULA ]; then
    echo Cleanup meta-freescale/EULA...
    git checkout -- EULA
fi
if [ ! -f classes/fsl-eula-unpack.bbclass ]; then
    echo Cleanup meta-freescale/classes/fsl-eula-unpack.bbclass...
    git checkout -- classes/fsl-eula-unpack.bbclass
fi
cd -

# Override the click-through in meta-freescale/EULA
FSL_EULA_FILE=$CWD/sources/meta-imx/EULA.txt

# Set up the basic yocto environment
if [ -z "$DISTRO" ]; then
   DISTRO=$FSLDISTRO MACHINE=$MACHINE . ./$PROGNAME $BUILD_DIR
else
   MACHINE=$MACHINE . ./$PROGNAME $BUILD_DIR
fi

# Point to the current directory since the last command changed the directory to $BUILD_DIR
BUILD_DIR=.

if [ ! -e $BUILD_DIR/conf/local.conf ]; then
    echo -e "\n ERROR - No build directory is set yet. Run the 'setup-environment' script before running this script to create " $BUILD_DIR
    echo -e "\n"
    return 1
fi

# On the first script run, backup the local.conf file
# Consecutive runs, it restores the backup and changes are appended on this one.
if [ ! -e $BUILD_DIR/conf/local.conf.org ]; then
    cp $BUILD_DIR/conf/local.conf $BUILD_DIR/conf/local.conf.org
else
    cp $BUILD_DIR/conf/local.conf.org $BUILD_DIR/conf/local.conf
fi

echo >> conf/local.conf
echo "# Switch to Debian packaging and include package-management in the image" >> conf/local.conf
echo "PACKAGE_CLASSES = \"package_deb\"" >> conf/local.conf
echo "EXTRA_IMAGE_FEATURES += \"package-management\"" >> conf/local.conf

echo >> conf/local.conf
echo "# force change password as root when first login " >> conf/local.conf
echo "INHERIT += \"extrausers\"" >> conf/local.conf
echo "EXTRA_USERS_PARAMS = \"passwd-expire root\"" >> conf/local.conf

echo >> conf/local.conf
echo "# Setup default environment for reproducible builds " >> conf/local.conf
echo "SOURCE_DATE_EPOCH = \"${SOURCE_DATE_EPOCH}\"" >> conf/local.conf
echo "REPRODUCIBLE_TIMESTAMP_ROOTFS = \"${REPRODUCIBLE_TIMESTAMP_ROOTFS}\"" >> conf/local.conf

if [ ! -e $BUILD_DIR/conf/bblayers.conf.org ]; then
    cp $BUILD_DIR/conf/bblayers.conf $BUILD_DIR/conf/bblayers.conf.org
else
    cp $BUILD_DIR/conf/bblayers.conf.org $BUILD_DIR/conf/bblayers.conf
fi


META_ADV_BSP_RELEASE="${CWD}/sources/meta-advantech/meta-adv-imx"

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "# Advantech Yocto Project Release layers" >> $BUILD_DIR/conf/bblayers.conf
hook_in_layer meta-advantech/meta-adv-imx
hook_in_layer meta-imx/meta-bsp
hook_in_layer meta-imx/meta-sdk
hook_in_layer meta-imx/meta-ml
hook_in_layer meta-imx/meta-v2x
hook_in_layer meta-nxp-demo-experience

echo "" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-browser/meta-chromium\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-clang\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-gnome\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-networking\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-openembedded/meta-filesystems\"" >> $BUILD_DIR/conf/bblayers.conf

echo "BBLAYERS += \"\${BSPDIR}/sources/meta-qt5\"" >> $BUILD_DIR/conf/bblayers.conf
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-python2\"" >> $BUILD_DIR/conf/bblayers.conf

# Enable docker for mx8 machines
echo "BBLAYERS += \"\${BSPDIR}/sources/meta-virtualization\"" >> conf/bblayers.conf

if [ -d ../sources/meta-ivi ]; then
    echo -e "\n## Genivi layers" >> $BUILD_DIR/conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-gplv2\"" >> $BUILD_DIR/conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi\"" >> $BUILD_DIR/conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi-bsp\"" >> $BUILD_DIR/conf/bblayers.conf
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-ivi/meta-ivi-test\"" >> $BUILD_DIR/conf/bblayers.conf
fi

# Enable meta-qt5-extra for falkon browser
if [ -d ../sources/meta-qt5-extra ]; then
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-qt5-extra\"" >> $BUILD_DIR/conf/bblayers.conf
fi

if [ -d ../sources/meta-readonly-rootfs-overlay ]; then
    echo "BBLAYERS += \"\${BSPDIR}/sources/meta-readonly-rootfs-overlay\"" >> $BUILD_DIR/conf/bblayers.conf
fi

echo BSPDIR=$BSPDIR
echo BUILD_DIR=$BUILD_DIR

# Support integrating community meta-freescale instead of meta-fsl-arm
if [ -d ../sources/meta-freescale ]; then
    echo meta-freescale directory found
    # Change settings according to environment
    sed -e "s,meta-fsl-arm\s,meta-freescale ,g" -i conf/bblayers.conf
    sed -e "s,\$.BSPDIR./sources/meta-fsl-arm-extra\s,,g" -i conf/bblayers.conf
fi

cd  $BUILD_DIR
clean_up
unset FSLDISTRO

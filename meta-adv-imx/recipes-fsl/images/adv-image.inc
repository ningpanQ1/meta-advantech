## Image types extra command.
EXTRA_IMAGECMD_ext3 ?= "-i 4096 -L rootfs"
EXTRA_IMAGECMD_ext4 ?= "-i 4096 -L rootfs"

IMAGE_LINGUAS = "de-de fr-fr en-gb en-us zh-cn zh-tw ja-jp ko-kr"
IMAGE_INSTALL += " source-han-sans-cn-fonts \
    source-han-sans-jp-fonts \
    source-han-sans-kr-fonts \
    source-han-sans-tw-fonts \
    source-code-pro-fonts \
    ttf-wqy-zenhei \
    ttf-dejavu-sans \
    ttf-dejavu-sans-condensed \
    ttf-dejavu-sans-mono \
    ttf-dejavu-serif \
    ttf-dejavu-serif-condensed \
    ttf-dejavu-mathtexgyre \
    ttf-dejavu-common \
"

## remove dropbear and add openssh
IMAGE_FEATURES:remove = "ssh-server-dropbear"

## packages
IMAGE_INSTALL:append = " packagegroup-adv-tools "
IMAGE_INSTALL:append = " giflib exfat-utils "
IMAGE_INSTALL:append = " cronie inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL:append = " glibc-gconv-utf-16 "
IMAGE_INSTALL:append = " qtbase qtbase-plugins qtvirtualkeyboard packagegroup-qt6-webengine "

## support opcua server
IMAGE_INSTALL:append = " python3-netifaces"

## uboot env tools 
IMAGE_INSTALL:append = " u-boot-fw-utils" 

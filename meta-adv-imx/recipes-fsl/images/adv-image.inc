## Image types extra command.
EXTRA_IMAGECMD_ext3 ?= "-i 4096 -L rootfs"
EXTRA_IMAGECMD_ext4 ?= "-i 4096 -L rootfs"

IMAGE_INSTALL += " packagegroup-adv-tools "

## remove dropbear and add openssh
IMAGE_FEATURES:remove += "ssh-server-dropbear "
IMAGE_FEATURES:append = "ssh-server-openssh"

## packages.
IMAGE_INSTALL += " giflib exfat-utils "
IMAGE_INSTALL += " cronie inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL_append += " glibc-gconv-utf-16 "




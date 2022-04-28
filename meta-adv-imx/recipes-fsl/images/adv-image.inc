IMAGE_INSTALL += " packagegroup-adv-tools "

## remove dropbear and add openssh
IMAGE_FEATURES:remove += "ssh-server-dropbear "
IMAGE_FEATURES:append = "ssh-server-openssh"

## packages.
IMAGE_INSTALL += " giflib exfat-utils "
IMAGE_INSTALL += " cronie inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL_append += " glibc-gconv-utf-16 "




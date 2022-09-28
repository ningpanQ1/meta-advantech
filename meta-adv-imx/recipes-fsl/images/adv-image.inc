## remove dropbear and add openssh
IMAGE_FEATURES:remove = "ssh-server-dropbear"

## packages
IMAGE_INSTALL:append = " packagegroup-adv-tools "
IMAGE_INSTALL:append = " giflib exfat-utils "
IMAGE_INSTALL:append = " cronie inetutils inetutils-telnet inetutils-telnetd "
IMAGE_INSTALL:append = " glibc-gconv-utf-16 "

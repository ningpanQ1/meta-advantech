## Package
IMAGE_INSTALL += " packagegroup-adv-tools "
IMAGE_INSTALL += " giflib exfat-utils "
IMAGE_INSTALL += " e2fsprogs cronie e2fsprogs-e2fsck e2fsprogs-resize2fs inetutils inetutils-telnet inetutils-telnetd "
IMAGE_FEATURES_remove += "ssh-server-dropbear " 
IMAGE_INSTALL_remove += " packagegroup-fsl-tools-testapps "
IMAGE_INSTALL_append += " packagegroup-core-ssh-openssh openssh-sftp-server "
IMAGE_INSTALL_append += " qtbase qtbase-plugins qtvirtualkeyboard "
IMAGE_INSTALL_append += " packagegroup-qt5-webengine "

## Package
IMAGE_INSTALL += " packagegroup-adv-tools "
IMAGE_INSTALL += " giflib exfat-utils "
IMAGE_INSTALL += " e2fsprogs cronie e2fsprogs-e2fsck e2fsprogs-resize2fs inetutils inetutils-telnet inetutils-telnetd "
IMAGE_FEATURES_remove += "ssh-server-dropbear " 
IMAGE_INSTALL_append += " packagegroup-core-ssh-openssh openssh-sftp-server "
IMAGE_INSTALL_append += " qtbase qtbase-plugins qtvirtualkeyboard "
IMAGE_INSTALL_append += " packagegroup-qt5-webengine "
IMAGE_INSTALL_append += " glibc-gconv-utf-16 "
IMAGE_LINGUAS = "de-de fr-fr en-gb en-us zh-cn zh-tw ja-jp ko-kr"
IMAGE_INSTALL += " source-han-sans-cn-fonts \
    source-han-sans-jp-fonts \
    source-han-sans-kr-fonts \
    source-han-sans-tw-fonts \    
    ttf-wqy-zenhei \
    ttf-dejavu-sans \
    ttf-dejavu-sans-condensed \
    ttf-dejavu-sans-mono \
    ttf-dejavu-serif \
    ttf-dejavu-serif-condensed \
    ttf-dejavu-mathtexgyre \
    ttf-dejavu-common \
"

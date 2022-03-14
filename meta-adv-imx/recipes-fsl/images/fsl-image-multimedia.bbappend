### include advantech based images features. 
require recipes-fsl/images/adv-image.inc

IMAGE_FEATURES += " ssh-server-openssh "
IMAGE_INSTALL_remove += " ssh-server-dropbear "


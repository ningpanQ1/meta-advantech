### include advantech based images features.
require recipes-fsl/images/adv-image.inc

## Add chromium
CORE_IMAGE_EXTRA_INSTALL += " \
    chromium-ozone-wayland \   
"

ROOTFS_POSTPROCESS_COMMAND:append:mx8 = "install_browser; \                                         
                                         install_virtual_keyboard; "

install_browser() {
    if ! grep -q "icon=/usr/share/icons/hicolor/24x24/apps/chromium.png" ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
    then
       if [ -e ${IMAGE_ROOTFS}/usr/lib/chromium/chromium-wrapper ]; then
           printf "\n\n[launcher]\nicon=/usr/share/icons/hicolor/24x24/apps/chromium.png\npath=/usr/bin/chromium --no-sandbox --test-type --enable-wayland-ime\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
       fi
    fi
}

install_virtual_keyboard() {
    if ! grep -q "path=/usr/libexec/weston-keyboard" ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
    then
       if  [ -e ${IMAGE_ROOTFS}/usr/libexec/weston-keyboard ]; then
           printf "\n\n[input-method]\npath=/usr/libexec/weston-keyboard\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
           printf "\n\n[keyboard]\nkeymap_rules=evdev\nkeymap_model=pc105\nkeymap_layout=us,de,gb\nrepeat-rate=30\nrepeat-delay=300\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini

       fi
    fi
}


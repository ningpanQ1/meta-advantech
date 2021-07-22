CORE_IMAGE_EXTRA_INSTALL += " \
    chromium-ozone-wayland \
"

# Add launcher for chromium.
ROOTFS_POSTPROCESS_COMMAND_append_mx8 = "install_browser; "
ROOTFS_POSTPROCESS_COMMAND_append_mx7ulp = "install_browser; "

install_browser() {
    if ! grep -q "icon=/usr/share/icons/hicolor/24x24/apps/chromium.png" ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
    then
       if [ -e ${IMAGE_ROOTFS}/usr/lib/chromium/chromium-wrapper ]; then
           printf "\n\n[launcher]\nicon=/usr/share/icons/hicolor/24x24/apps/chromium.png\npath=/usr/bin/chromium --no-sandbox --test-type\n" >> ${IMAGE_ROOTFS}${sysconfdir}/xdg/weston/weston.ini
       fi
    fi
}

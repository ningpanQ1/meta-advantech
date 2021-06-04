## Advantech sdk features.

TOOLCHAIN_TARGET_TASK += " \
   zlib curl curl-dev \
   giflib jpeg libpng \
   libusb libxml2 ncurses \
   boost \
"

TOOLCHAIN_TARGET_TASK_append = " openssl"

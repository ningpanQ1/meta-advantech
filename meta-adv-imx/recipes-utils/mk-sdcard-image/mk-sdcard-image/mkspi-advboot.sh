#!/bin/bash

if [ ! -e ../image/SPL ];then
     echo "There is no ../image/SPL file ."
     exit
fi


echo "[Copy SPL]"
mtd_debug read /dev/mtd0 0xD0000 0x1000 mac
flash_erase /dev/mtd0 0 0
dd if=../image/SPL of=/dev/mtd0 bs=512 seek=2 1>/dev/null 2>/dev/null;sync
mtd_debug erase /dev/mtd0 0xD0000 0x1000
mtd_debug write /dev/mtd0 0xD0000 0x1000 mac
rm -rf mac
sync

echo "[Done]"

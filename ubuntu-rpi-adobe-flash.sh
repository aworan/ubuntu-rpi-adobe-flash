#!/bin/bash
mkdir /tmp/abode-flash-rpi
cd /tmp/abode-flash-rpi
# Check if the site can be reached
wget --spider --user-agent="Mozilla/5.0 Gecko/20100101" --timeout=30 -q "https://archive.raspberrypi.org/debian/pool/ui/r/rpi-chromium-mods" -O /dev/null
    if [[ "$?" -ne "0" ]]; then
        echo -e "Can't connect to https://archive.raspberrypi.org server site\nMake sure the internet connection is up and active"
        exit 1
    fi
# Fetch the latest version file name
FLASH_CURRENT="$(wget -O- -q https://archive.raspberrypi.org/debian/pool/ui/r/rpi-chromium-mods/ 2>/dev/null \
                 | awk '{gsub(/ *<[^>]*> */," "); if($1~"tar.xz"){print $1}}' \
		 | sort \
		 | tail -1)"
# Download
wget "https://archive.raspberrypi.org/debian/pool/ui/r/rpi-chromium-mods/$FLASH_CURRENT"
    if [[ "$?" -ne "0" ]]; then
        echo -e "Could not download $FLASH_CURRENT"
        exit 1
    fi
tar Jxvf "$FLASH_CURRENT"
if [ ! -d /usr/lib/PepperFlash ]; then
	mkdir /usr/lib/PepperFlash
fi
flashVersion=`strings rpi-chromium-mods/armhf/libpepflashplayer.so 2> /dev/null | grep LNX | cut -d ' ' -f 2 | sed -e "s/,/./g"`
cp rpi-chromium-mods/armhf/libpepflashplayer.so /usr/lib/PepperFlash
if [ -f /etc/chromium-browser/default ]; then
 	mv /etc/chromium-browser/default /etc/chromium-browser/default.old
	echo "CHROMIUM_FLAGS=\"--ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=$flashVersion\"" >> /etc/chromium-browser/default
fi
rm -fr /tmp/abode-flash-rpi
echo "Adobe Flash $flashVersion installed successfully !"

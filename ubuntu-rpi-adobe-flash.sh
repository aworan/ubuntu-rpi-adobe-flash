#!/bin/bash
mkdir /tmp/abode-flash-rpi
cd /tmp/abode-flash-rpi
wget http://archive.raspberrypi.org/debian/pool/ui/r/rpi-chromium-mods/rpi-chromium-mods_20170213_armhf.deb
ar vx rpi-chromium-mods_20170213_armhf.deb
tar -xf data.tar.xz
if [ ! -d /usr/lib/PepperFlash ]; then
	mkdir /usr/lib/PepperFlash
fi
flashVersion=`strings usr/lib/chromium-browser/libpepflashplayer.so 2> /dev/null | grep LNX | cut -d ' ' -f 2 | sed -e "s/,/./g"`
cp usr/lib/chromium-browser/libpepflashplayer.so /usr/lib/PepperFlash
if [ -f /etc/chromium-browser/default ]; then
 	mv /etc/chromium-browser/default /etc/chromium-browser/default.old
	echo "CHROMIUM_FLAGS=\"--ppapi-flash-path=/usr/lib/PepperFlash/libpepflashplayer.so --ppapi-flash-version=$flashVersion\"" >> /etc/chromium-browser/default
fi
rm -fr /tmp/abode-flash-rpi
echo "Adobe Flash $flashVersion installed successfully !"


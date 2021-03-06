#!/bin/bash
echo "*-*-* Overclocking in progress *-*-*"

BIOS=$1

AMDDEVICE=$(sudo lshw -C display | grep AMD | wc -l)
NVIDIADEVICE=$(sudo lshw -C display | grep NVIDIA | wc -l)
FORCE="no"

NVIDIA="$(nvidia-smi -L)"

if [ ! -z "$NVIDIA" ]; then
	if echo "$NVIDIA" | grep -iq "^GPU 0:" ;then
		DONVIDIA="YES"
	fi
fi

if [ "$AMDDEVICE" -gt "0" ]; then
	DOAMD="YES"
fi

echo "FOUND AMD: $AMDDEVICE || FOUND NVIDIA: $NVIDIADEVICE"
echo ""
echo ""
echo "--------------------------"

TOKEN="$(cat /home/minerstat/minerstat-os/config.js | grep 'global.accesskey' | sed 's/global.accesskey =//g' | sed 's/;//g')"
WORKER="$(cat /home/minerstat/minerstat-os/config.js | grep 'global.worker' | sed 's/global.worker =//g' | sed 's/;//g')"

echo "TOKEN: $TOKEN"
echo "WORKER: $WORKER"

echo "--------------------------"

sudo rm doclock.sh
sleep 1

if [ "$BIOS" != "" ]
then
echo "Overwritting BIOS, Notice this requires a reboot (mreboot)"
FORCE="yes"
fi

if [ ! -z "$DONVIDIA" ]; then	
	sudo nvidia-smi -pm 1
	wget -qO doclock.sh "https://api.minerstat.com/v2/getclock.php?type=nvidia&token=$TOKEN&worker=$WORKER&nums=$NVIDIADEVICE&bios=$FORCE"
	sleep 3
	# FAN PROTECTION
	sudo nvidia-settings -c :0 -a 'GPUFanControlState=1' -a 'GPUTargetFanSpeed='70'' | grep 'Attribute'
	sudo sh doclock.sh
	sleep 2
	sudo chvt 1
fi

if [ ! -z "$DOAMD" ]; then
	wget -qO doclock.sh "https://api.minerstat.com/v2/getclock.php?type=amd&token=$TOKEN&worker=$WORKER&nums=$AMDDEVICE&bios=$FORCE"
	sleep 3
	sudo sh doclock.sh
	sudo chvt 1
fi

#!/bin/bash       

if [ ! $1 ]; then
echo ""
echo "--- EXAMPLE ---"
echo "./overclock_amd a b c d e"
echo "a = GPUID"
echo "b = Memory Clock"
echo "c = Core Clock"
echo "d = Fan Speed"
echo "e = VDDC"
echo ""
echo "-- Full Example --"
echo "./overclock_amd 0 1750 1100 80 1.11"
echo ""
fi

if [ $1 ]; then
GPUID=$1
MEMCLOCK=$2
CORECLOCK=$3
FANSPEED=$4
VDDC=$5                                                                                                                                                                                                 
                                                                                                           
for gpuid in $GPUID; do                                                                                                                                                                                       
echo "Setting up CoreStates and MemClocks GPU$gpuid"                                                                                                                                                               
for corestate in 4 5 6 7; do                                                                                                                                                                                       
sudo ./ohgodatool -i $gpuid --core-state $corestate --core-clock $CORECLOCK --mem-state 2 --mem-clock $MEMCLOCK                                                                                                              
done                                                                                                                                                                                                               
echo manual > /sys/class/drm/card$gpuid/device/power_dpm_force_performance_level                                                                                                                                   
echo 4 > /sys/class/drm/card$gpuid/device/pp_dpm_sclk                                                                                                                                                              
done                                                                                                                                                                                                               
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
# set all voltage states from 1 upwards to xxx mV:                                                                                                                                                                 
for gpuid in $GPUID; do                                                                                                                                                                                       
echo "Setting up VDDC Voltage GPU$gpuid"                                                                                                                                                                           
for voltstate in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do                                                                                                                                                           
sudo ./ohgodatool -i $gpuid --volt-state $voltstate --vddc-table-set $VDDC                                                                                                                                         
done                                                                                                                                                                                                               
done                                                                                                                                                                                                               

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
# VDDCI Voltages          
# VDDC Voltage + 50
VDDCI=$(expr "$VDDC" + 50)                                                                                                                                                  
for gpuid in $GPUID; do                                                                                                                                                                                       
echo "Setting up VDDC Voltage GPU$gpuid"                                                                                                                                                                           
for memstate in 1 2; do                                                                                                                                                                                            
sudo ./ohgodatool -i $gpuid --mem-state $memstate --vddci $VDDCI                                                                                                                                                     
done                                                                                                                                                                                                               
done 


# Tables Edited: OK!
# Now set the clocks as default

if [ "$CORECLOCK" != "skip" ]
then
	if [ "$MEMCLOCK" != "skip" ]
	then
	# Core Clock
	sudo ./amdcovc coreclk:$GPUID=$CORECLOCK | grep "Setting core clock"
	sleep 0.5
	sudo ./amdcovc ccoreclk:$GPUID=$CORECLOCK | grep "Setting current core"
	# Memory Clock
	sudo ./amdcovc memclk:$GPUID=$MEMCLOCK | grep "Setting memory clock"
	sleep 0.5
	sudo ./amdcovc cmemclk:$GPUID=$MEMCLOCK | grep "Setting current memory"
	fi
fi


if [ "$FANSPEED" != "skip" ]
then
	sudo ./ohgodatool -i $GPUID --set-fanspeed $FANSPEED
	sudo ./amdcovc fanspeed:$GPUID=$FANSPEED | grep "Setting"
fi

fi

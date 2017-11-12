#!/bin/bash
# 
# Morse codes the Raspberry Pi Zero's wlan0 IP address
# using the single system LED (ACT)
#

# Disable default ACT LED behavior
echo none > /sys/class/leds/led0/trigger

#
#helper functions
#
off()
{
	# Turn off the LED
	echo 1 > /sys/class/leds/led0/brightness
	#echo "off"
}
on()
{
	# Turn on the LED
	echo 0 > /sys/class/leds/led0/brightness
	#echo "on"
}
dot()
{
	on
	sleep .25
	off
}
dash()
{
	on
	sleep 1
	off
}
flashIntegerDigit()
{
	#convert input integer to morse code as ARRAY_TO_FLASH
	case "$1" in
		0)
			ARRAY_TO_FLASH=(1 1 1 1 1)
			;;
		1)
			ARRAY_TO_FLASH=(0 1 1 1 1)	
			;;
		2)
			ARRAY_TO_FLASH=(0 0 1 1 1)
			;;
		3)
			ARRAY_TO_FLASH=(0 0 0 1 1)
			;;
		4)
			ARRAY_TO_FLASH=(0 0 0 0 1)
			;;
		5)
			ARRAY_TO_FLASH=(0 0 0 0 0)
			;;
		6)
			ARRAY_TO_FLASH=(1 0 0 0 0)
			;;
		7)
			ARRAY_TO_FLASH=(1 1 0 0 0)
			;;
		8)
			ARRAY_TO_FLASH=(1 1 1 0 0)
			;;
		9)
			ARRAY_TO_FLASH=(1 1 1 1 0)
			;;
		".")
			ARRAY_TO_FLASH=(0 1 0 1 0 1) # this is 6 'bits'
			;;
		" ")
			ARRAY_TO_FLASH=(0 1 0 1 0 1) # this is also 6 'bits'
			;;
	esac

	#count the morse code 'bits' to send
	NUMBER_OF_CODED_BITS=${#ARRAY_TO_FLASH[@]}

	#iterate through array of morse code bits and flash them
	for BIT in "${ARRAY_TO_FLASH[@]}"
	do
		sleep .5
		#echo "z is $BIT"
		if [ "$BIT" = "1" ]
		then
			dash
		else
			dot
		fi
	done
}

#
# script body (main)
#

#give the OS plenty of time to connect to wifi and do initial configuration
sleep 30

#get the IP address
# ON macOS / rpi:
IP=$(ifconfig wlan0 | grep 'inet' | cut -d: -f2 | awk '{print $2}')
# on ubuntu:
#IP=$(ifconfig | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')

IP_LENGTH=${#IP}

#for debug:
#ifconfig >> /ipinfo.txt

#send test pattern by blinking quickly a few times
#when you see this, you'll know to look for the IP coming up
for (( Q=0; Q < 5; Q++))
do
	off
	sleep .5
	on
	sleep .5
done
off
sleep 5

#send the actual ip
for (( I=1 ; I <= $IP_LENGTH ; I++ ))
do
	DIGIT=$(echo $IP | cut -c$I)
	#delay before starting a new digit
	sleep 2
	flashIntegerDigit $DIGIT
done

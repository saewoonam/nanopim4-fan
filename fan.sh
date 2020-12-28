#!/bin/bash

if [ ! -d /sys/class/pwm/pwmchip1/pwm0 ]; then
    echo 0 > /sys/class/pwm/pwmchip1/export
fi
sleep 1
while [ ! -d /sys/class/pwm/pwmchip1/pwm0 ];
do
    sleep 1
done
ISENABLE=`cat /sys/class/pwm/pwmchip1/pwm0/enable`
if [ $ISENABLE -eq 1 ]; then
    echo 0 > /sys/class/pwm/pwmchip1/pwm0/enable
fi
echo 50000 > /sys/class/pwm/pwmchip1/pwm0/period
echo 1 > /sys/class/pwm/pwmchip1/pwm0/enable

# max speed run 5s
echo 0 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle
sleep 5
echo 49994 > /sys/class/pwm/pwmchip1/pwm0/duty_cycle

declare -a CpuTemps=(75000 63000 58000 52000 48000 0)
declare -a PwmDutyCycles=(25000 37000 48300 49250 49300 49994)

while true
do
	temp=$(cat /sys/class/thermal/thermal_zone0/temp)
	for i in 0 1 2 3 4 5; do
		if [ $temp -gt ${CpuTemps[$i]} ]; then
			DUTY=${PwmDutyCycles[$i]}
			echo $DUTY > "/sys/class/pwm/pwmchip1/pwm0/duty_cycle";
			#echo "temp: $temp, target: ${CpuTemps[$i]}, duty: $DUTY"
			break		
		fi
	done
	sleep 2s;
done

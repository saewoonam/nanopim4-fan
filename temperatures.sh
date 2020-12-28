#! /bin/bash
# NAS temperatures monitoring
temp0=$(cat /sys/class/thermal/thermal_zone0/temp)
temp1=$(cat /sys/class/thermal/thermal_zone1/temp)

duty0=$(cat /sys/class/pwm/pwmchip1/pwm0/duty_cycle)
echo "cpu: $temp0, gpu: $temp1; duty: $duty0 "

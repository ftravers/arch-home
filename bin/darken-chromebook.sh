#!/bin/bash

lvl="/sys/class/backlight/pwm-backlight.0/brightness"
num=`cat $lvl`
num=`expr $num - 200`
if [[ num -gt 200 ]]; then
    echo $num > $lvl
fi

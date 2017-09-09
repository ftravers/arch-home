#!/usr/bin/zsh

based='/sys/class/backlight/intel_backlight'
pushd $based
max=`cat $based/max_brightness`
let "inc = $max * 0.15"
# inc=`expr $max * 0.15`
curr_lvl="$based/brightness"
num=`cat $curr_lvl`

zmodload zsh/mathfunc
let "newnum = int($num + $inc)"
echo $newnum
echo $newnum > ./brightness


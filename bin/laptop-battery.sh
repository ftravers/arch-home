#!/usr/bin/zsh

zparseopts -a my_opts -state -time -msg

bat_dir="/sys/class/power_supply/sbs-4-000b"
bat_status=`cat ${bat_dir}/status`

convertsecs() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 printf "%02d:%02d" $h $m
}
seconds_until=0
msg=""

# logic for if power adapter is plugged in or not
if [[ $bat_status == "Discharging" ]]; then
    seconds_until=`cat ${bat_dir}/time_to_empty_avg`
    msg="until empty"
else 
    seconds_until=`cat ${bat_dir}/time_to_full_avg`
    msg="until full"
fi

if [[ $my_opts[1] == "--state" ]]; then
    echo ${bat_status}
fi
if [[ $my_opts[1] == "--time" ]]; then
    echo $(convertsecs $seconds_until)
fi
if [[ $my_opts[1] == "--msg" ]]; then
    echo $msg
fi




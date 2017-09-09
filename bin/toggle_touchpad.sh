#!/usr/bin/zsh

tp_state=`synclient -l | awk '/TouchpadOff/{print $(NF)}'`

if [[ ${tp_state} -eq 0 ]]; then
    /usr/bin/synclient TouchpadOff=1
    return 0
elif [[ ${tp_state} -eq 1 ]]; then
    /usr/bin/synclient TouchpadOff=0
    return 0
else
    echo "Can't determine state of Touchpad"
    return 1
fi

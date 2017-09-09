#!/bin/sh
exec >/home/fenton/udev.out 2>&1

hdmi_plugged_in="$(cat /sys/class/drm/card0-HDMI-A-1/status)"

export XAUTHORITY=/home/fenton/.Xauthority
export DISPLAY=:0

if [ "${hdmi_plugged_in}" = "connected" ]; then
    xrandr --output HDMI1 --mode 1920x1080 --pos 1600x0 --rotate normal --output DP1 --off --output eDP1 --mode 1600x900 --pos 0x180 --rotate normal --output VGA1 --off
    # xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output eDP1 --off --output VGA1 --off
else
    xrandr --output HDMI1 --off --output DP1 --off --output eDP1 --mode 1600x900 --pos 0x0 --rotate normal --output VGA1 --off
    #xrandr --output HDMI1 --mode 1920x1080 --pos 1600x0 --rotate normal --output DP1 --off --output eDP1 --mode 1600x900 --pos 0x180 --rotate normal --output VGA1 --off
fi


#!/usr/bin/zsh -xv

snd_funcs="$HOME/bin/sound_functions.sh"

if [ -f $snd_funcs ]; then
    source $snd_funcs
else
    print "404: $snd_funcs not found."
fi

if [[ $(sound_mute_status) == "on" ]]; then
    mute_sound
else
    unmute_sound
fi


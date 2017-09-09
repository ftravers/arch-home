# if [[ $(sound_mute_status) == "on" ]]; then
function sound_mute_status() {
    # echos either 'on' or 'off'
    echo `amixer get Speaker | sed -n 's/.*Left.*Playback \[\(.*\)\].*/\1/p'`
}

# if [[ ${vol} -lt 33 ]]; then
function sound_vol_perc() {
    # echos a percentage the volume is turned on
    echo `amixer get Speaker | sed -n 's/.*Left.*\[\(.*\)%\].*/\1/p'`
}

# $(set_sound_level 15)     # out of 39 max
function set_sound_level() {
    amixer -q set Speaker $1 unmute
}

function mute_sound() {
    amixer -q set Speaker mute    
}

function unmute_sound() {
    if [[ $(sound_vol_perc) -gt 33 ]]; then
        set_sound_level 5
    fi
    amixer -q set Speaker unmute
    amixer -q set 'Left Speaker Mixer Left DAC1' unmute
    amixer -q set 'Left Speaker Mixer Mono DAC2' unmute
    amixer -q set 'Left Speaker Mixer Mono DAC3' unmute
    amixer -q set 'Left Speaker Mixer Right DAC1' unmute
    amixer -q set 'Right Speaker Mixer Left DAC1' unmute
    amixer -q set 'Right Speaker Mixer Mono DAC2' unmute
    amixer -q set 'Right Speaker Mixer Mono DAC3' unmute
    amixer -q set 'Right Speaker Mixer Right DAC1' unmute
}

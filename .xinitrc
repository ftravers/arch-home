# Setup Console Fonts
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources


# Sync clipboard and primary
autocutsel -selection CLIPBOARD -fork & # Clip->Primary
autocutsel -selection PRIMARY -fork & # Primary->Clip


# Extend Monitors if attached
~/bin/pick_monitors.sh &


# Launch WM
exec awesome


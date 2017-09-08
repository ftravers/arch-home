# Setup Console Fonts
[[ -f ~/.Xresources ]] && xrdb ~/.Xresources


# xset +fp /usr/share/fonts/local
# xset fp rehash


# keep CLIPBOARD in sync with PRIMARY
autocutsel -selection CLIPBOARD -fork &

# keep PRIMARY in sync with CLIPBOARD
autocutsel -selection PRIMARY -fork &


# Launch WM
exec awesome


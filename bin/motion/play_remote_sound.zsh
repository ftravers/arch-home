#!/usr/bin/env zsh

if [[ -f last_played ]]; then
    last=`cat last_played`
else
    last=0
fi

now=$(date +%s)
diff=$(( $now - $last ))

if [[ $diff -gt 15 ]]; then
    ssh s9f './bin/motion/motion_detected.zsh'  
    echo $(date +%s) > last_played
fi

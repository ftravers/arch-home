#!/usr/bin/zsh -x

# NOT finished...

git remote rm origin
cur_dir=${PWD##*/}
git remote add origin bkfi:~/git_repos/${cur_dir}

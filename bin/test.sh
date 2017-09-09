#!/usr/bin/zsh

mypkgs=mypkgs
my_pkg_file_cache=/home/${mypkgs}
my_pkg_db_folder=/var/lib/pacman/sync
my_pkg_db=${my_pkg_db_folder}/${mypkgs}
my_pkg_db_file=${my_pkg_db}.db
my_pkg_db_file_zip=${my_pkg_db_file}.tar.gz
pacman_conf=/etc/pacman.conf

# restore
sed -i "$ a\[${mypkgs}]" ${pacman_conf}
sed -i "$ a\Server = file://${my_pkg_db_folder}" ${pacman_conf}

repo-add ${my_pkg_db_file_zip} ${my_pkg_file_cache}/*.tar.xz

pacman -Syy

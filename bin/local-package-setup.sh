#!/usr/bin/zsh -x


mypkgs=mypkgs
my_pkg_file_cache=/home/${mypkgs}
my_pkg_db_folder=/var/lib/pacman/sync
my_pkg_db=${my_pkg_db_folder}/${mypkgs}
my_pkg_db_file=${my_pkg_db}.db
my_pkg_db_file_zip=${my_pkg_db_file}.tar.gz
pacman_conf=/etc/pacman.conf

# clean out
pacman --noconfirm -R slimlock

sed -i "/\[${mypkgs}]/d" ${pacman_conf}
sed -i "\@Server = file://${my_pkg_db_folder}@d" ${pacman_conf}

rm -f ${my_pkg_db_file_zip}
rm -f ${my_pkg_db_file}

pacman -Syy

# validate gone

pacman -Ql | grep slimlock

# restore
sed -i "$ a\[${mypkgs}]" ${pacman_conf}
sed -i "$ a\Server = file://${my_pkg_db_folder}" ${pacman_conf}



echo "repo-add ${my_pkg_db_file_zip} ${my_pkg_file_cache}/*.tar.xz"

my_pkg_file_cache2=/var/cache/pacman/mypkgs
repo-add ${my_pkg_db_file_zip} ${my_pkg_file_cache2}/*.tar.xz


pacman -Syy

pacman -S slimlock

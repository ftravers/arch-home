#!/usr/bin/zsh -x

root="/dev/sdb2"

copy_root_fs() {
    root_device=$1
    su root <<EOF
set -x
mkdir -p root
mount ${root_device} root
tar -xf ArchLinuxARM-am33x-latest.tar.gz -C root
EOF
}
copy_root_fs ${root}

add_downloads() {
    cp BeagleBone-bootloader.tar.gz root
    cp ArchLinuxARM-am33x-latest.tar.gz root
}
add_downloads

unmount_root () {
    root_device=$1
    umount ${root_device}
}

unmount_root ${root}

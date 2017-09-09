#!/usr/bin/zsh
zparseopts d:=device 
notify(){
    echo ">>> $1"
    echo "-------------------------------------------"
}
check_args(){
    if [[ $#device -lt 1 ]]; then 
        print "Please specify a device.  Eg: -d sdb"
        print "Your available devices: "
        lsblk
        exit 1
    fi
}
set_variables() {
    just_device="$device[2]"
    device="/dev/${just_device}"
    boot="${device}1"
    root="${device}2"
}

check_args
notify "starting partitioning"
set_variables

fdisk_device() {
    fdisk ${device} <<EOF
n
p
1

+64M
t
e
a
n
p
2


w
EOF
}

fdisk_device ${device}

make_filesystems() {
    dev=$1
    mkfs.vfat -F 16 ${boot}
    mkfs.ext4 ${root}
}

make_filesystems ${device}

copy_boot_fs() {
    boot_device=$1
    mkdir -p boot
    mount ${boot_device} boot
    tar xvf BeagleBone-bootloader.tar.gz -C boot
    umount boot
}
copy_boot_fs ${boot}

copy_root_fs() {
    root_device=$1
    su root <<EOF
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


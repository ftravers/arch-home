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
}

check_args
set_variables

fdisk_device() {
    dev=$1
    notify "starting partitioning device: ${dev}"
    fdisk ${dev} <<EOF
d
2
d
w
EOF
}
set -x
fdisk_device ${device}

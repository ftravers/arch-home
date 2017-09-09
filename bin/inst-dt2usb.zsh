#!/usr/bin/zsh -x

scriptname=`basename $0`

usage() {
    print "\nUsage:\n"
    print "\t$scriptname -d <device>\n"
    print "Where <device> would be something like: 'sdb', for example:\n"
    print "\t$scriptname -d sdb\n"
}

zparseopts d:=device 

if [[ $#device -lt 1 ]]; then 
    usage
    print "\nYour block devices to choose from:\n"
    lsblk
    exit 1
fi

set_variables() {
    device="/dev/$device[2]"
    archroot="/mnt/na"
    pacman_cache="/home/pkg"
    my_pacman_cache="/home/mypkgs"
    root_partition=2
    full_root_partition="${device}${root_partition}" #/dev/sda2
    volume_group=VolGroup00
    logical_volume=LogVol00
    lv_path="/dev/${volume_group}/${logical_volume}"
    lvm_dev_root="/dev/mapper/${volume_group}-${logical_volume}" #/dev/mapper/LogVol00-VolGroup00
    user=fenton
}

set_variables
remove_lvm
check_valid_device
partition_disk
make_lvm
make_filesystem
make_directories
make_mount_directories
pacman_bootstrap
make_fstab
copy_next_scripts
call_next_scripts
cleanup_next_scripts

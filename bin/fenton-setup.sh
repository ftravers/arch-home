#!/usr/bin/zsh -x

scriptname=`basename $0`

usage() {
    print "\nUsage:\n"
    print "\t$scriptname -p <root-path>\n"
    print "Where <device> would be something like: '/mnt/na', for example:\n"
    print "\t$scriptname -p /mnt/na\n"
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
check_valid_device() {
    mounted=`findmnt | grep ${device}`
    if [[ "$mounted" != "" ]]; then
        print "Device: ${device} has mounted partitions, cannot proceed."
        exit 1
    fi
}
partition_disk() {
    dd if=/dev/zero of=${device} bs=1M conv=notrunc count=3 # zero out the disk
    sgdisk -Z ${device}                    
    default_start_pos=0
    default_size=0
    bios_boot_type=ef02
    bios_boot_part=1
    bios_boot_part_size=+2m
    sgdisk -n ${bios_boot_part}:${default_start_pos}:${bios_boot_part_size} --typecode=${bios_boot_part}:${bios_boot_type} ${device}
    sgdisk -n ${root_partition}:${default_start_pos}:${default_size} ${device}              # root partition
}
make_lvm() {
# sudo pvcreate -ff -y /dev/sdb2; sudo pvdisplay; sudo pvremove /dev/sdb2; sudo pvdisplay
    pvcreate -ff -y ${full_root_partition}

# sudo vgcreate vg /dev/sdb2; sudo vgdisplay; sudo vgremove vg; sudo vgdisplay
    vgcreate ${volume_group} ${full_root_partition}

#  sudo lvcreate -n lv -l 100%FREE vg; sudo lvdisplay
    lvcreate -n ${logical_volume} -l 100%FREE ${volume_group}
}
show_lvm() {
    pvdisplay
    vgdisplay
    lvdisplay
}
remove_lvm() {
    # sudo lvremove -f vg
    lvremove -f ${volume_group}
    vgremove -f ${volume_group}
    pvremove -y -ff ${full_root_partition}
}
make_filesystem(){
    mkfs.ext4 ${lvm_dev_root}
}
make_mount_directories() {
    mkdir -p ${archroot}
    mount ${lvm_dev_root} ${archroot}
    mkdir -p ${archroot}/var/cache/pacman/pkg          
    mount --bind ${pacman_cache} ${archroot}/var/cache/pacman/pkg  
    mkdir -p ${archroot}/var/cache/pacman/mypkgs
    mount --bind ${my_pacman_cache} ${archroot}/var/cache/pacman/mypkgs
}
pacman_bootstrap() {
    pacstrap ${archroot} base base-devel
}
make_fstab () {
    swapoff -a
    echo "genfstab -U -p ${archroot} > ${archroot}/etc/fstab" | sudo zsh
    swapon 
}
copy_fenton_data() {
    mkdir -p ${archroot}/home/${user}/.ssh
    mkdir -p ${archroot}/home/${user}/projects/docs-DIR/documentation
    cp ~${user}/.ssh/id_rsa* ${archroot}/home/${user}/.ssh
    cp ~${user}/.ssh/known_hosts ${archroot}/home/${user}/.ssh
    cp ~${user}/bin/arch-setup-root.sh ${archroot}/
    cp /home/${user}/bin/packages.txt ${archroot}
    cp ~${user}/bin/arch-setup-user.sh ${archroot}/home/${user}/
    cp ~${user}/bin/arch-setup-user-expect.sh ${archroot}/home/${user}
    cp ~${user}/bin/setup-emacs.sh ${archroot}/home/${user}
    cp ~${user}/bin/setup-sbcl.sh ${archroot}/home/${user}
    rsync -aqP /home/${user}/projects/docs-DIR/documentation ${archroot}/home/${user}/projects/docs-DIR/
    rsync -aqP /home/${user}/projects/docs-DIR/documentation/.git* ${archroot}/home/${user}/projects/docs-DIR/documentation/ 
    rsync -aqP /home/${user}/projects/docs-DIR/pers-docs ${archroot}/home/${user}/projects/docs-DIR/
    rsync -aqP /home/${user}/projects/docs-DIR/pers-docs/.git* ${archroot}/home/${user}/projects/docs-DIR/pers-docs/ 
}

set_variables
remove_lvm
check_valid_device
partition_disk
make_lvm
make_filesystem
make_mount_directories
pacman_bootstrap
make_fstab
copy_fenton_data

# CHROOT
# archroot="/mnt/na"; sudo arch-chroot ${archroot}
arch-chroot ${archroot} ./arch-setup-root.sh -d ${lvm_dev_root}

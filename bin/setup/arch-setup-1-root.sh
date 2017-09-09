#!/usr/bin/zsh
zparseopts d:=device u:=user -mbr=mbr
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
    if [[ $#user -lt 1 ]]; then
        print "please specify the new user with: -u <user-name>"
        exit 1
    fi
}
set_variables() {
    just_device="$device[2]"
    device="/dev/${just_device}"
    disk_size=`lsblk -bdn -o SIZE $device`
    big_disk_size=50000000000
    small_disk_size=7000000000
    big_disk=false
    med_disk=false
    sml_disk=false
    root_partition=2
    if [[ $disk_size -gt $big_disk_size ]]; then
        big_disk=true
        swap_partition=2
        root_partition=3
    elif [[ $disk_size -lt $small_disk_size ]]; then
        sml_disk=true
    else
        med_disk=true
    fi
    if [[ "$mbr[1]" == "--mbr" ]]; then
        use_mbr="true"
    fi
    archroot="/mnt/na"
    pm_cache_root="/var/cache/pacman"
    pacman_cache="${pm_cache_root}/pkg"
    my_pacman_cache="/home/mypkgs"
    full_root_partition="${device}${root_partition}" # /dev/sda2
    user=$user[2]
    chroot_script="arch-setup-2-root-chroot.sh"
    new_home="${archroot}/home/${user}"               # /mnt/na/home/fenton
    rel_docs_dir="projects/docs-DIR"                   
    documentation_dir="${rel_docs_dir}/documentation"  # projects/docs-DIR
    src_user="fenton"                                  
    src_dir="/home/${src_user}"                        # /home/fenton
    src_docs_dir="${src_dir}/${documentation_dir}"     # /home/fenton/projects/docs-DIR/documentation
}
unmount_directories() {
    umount ${archroot}/var/cache/pacman/mypkgs
    umount ${archroot}/var/cache/pacman/pkg
    umount ${archroot}
    notify "Drives unmounted"
}
check_valid_device() {
    mounted=`findmnt | grep ${device}`
    if [[ "$mounted" != "" ]]; then
        print "Device: ${device} has mounted partitions, cannot proceed."
        exit 1
    fi
}
clean_disk() {
    notify "Starting disk cleaning."
    dd if=/dev/zero of=${device} bs=1M conv=notrunc count=3 # zero out the disk
    sgdisk -Z ${device} || sgdisk -Z ${device} 
    if [[ $? -ne 0 ]]; then
        exit 1
    fi
    notify "Disk cleaned."
}

partition_disk() {
    notify "begin partition disks"
    default_start_pos=0
    default_size=0
    bios_boot_type=ef02
    bios_boot_part=1
    bios_boot_part_size=+2m
    if [[ "${use_mbr}" == "true" ]]; then
        echo "create mbr steps"
        make_mbr ${device}
    else
        sgdisk -n ${bios_boot_part}:${default_start_pos}:${bios_boot_part_size} --typecode=${bios_boot_part}:${bios_boot_type} ${device}
        if [[ "$big_disk" == "true" ]]; then
            swap_partition_size=+16g
            sgdisk -n ${swap_partition}:${default_start_pos}:${swap_partition_size} ${device}   # swap partition
        fi
        sgdisk -n ${root_partition}:${default_start_pos}:${default_size} ${device}              # root partition
    fi
    notify "finished partitioning disks"

}
make_mbr() {
    dev=$1
    fdisk ${dev} <<EOF
n
p
1


w
EOF
}
make_filesystem(){
    notify "making file system"
    mkfs.ext4 ${full_root_partition}
}
make_and_mount_directories() {
    notify "making and mounting directories"
    mkdir -p ${archroot}
    mount ${full_root_partition} ${archroot}
    mkdir -p ${archroot}/var/cache/pacman/{pkg,mypkgs}
    if [[ "$sml_disk" == "true" ]]; then
        # if not writing to a big disk, don't connect these folders
        # together as USB will run out of space, by the package download
        mount --bind ${pacman_cache} ${archroot}/var/cache/pacman/pkg  
    fi
    mount --bind ${my_pacman_cache} ${archroot}/var/cache/pacman/mypkgs
    notify "finished: make/mount directories"
}

pacman_bootstrap() {
    pacstrap ${archroot} base base-devel zsh > /dev/null
}
make_fstab () {
    swapoff -a
    echo "genfstab -U -p ${archroot} > ${archroot}/etc/fstab" | sudo zsh
    swapon 
}

user_files(){
    mkdir -p ${new_home}/${documentation_dir}/ 
    mkdir -p ${new_home}/.emacs.d
    mkdir -p ${new_home}/.config/awesome
    mkdir -p ${archroot}/mnt/na

    rsync -aqP ${src_docs_dir} ${new_home}/${rel_docs_dir}/
    rsync -aqP ${src_docs_dir}/.git* ${new_home}/${documentation_dir}/ 
    cp ${src_dir}/.xinitrc-generic ${new_home}
    cp ${src_dir}/.xinitrc-common ${new_home}
    cp ${src_dir}/.zshrc ${new_home}
    cp ${src_dir}/.zshrc-functions.sh ${new_home}
    cp ${src_dir}/.aliases ${new_home}
    cp ${src_dir}/.emacs.d/workgroups.copy ${new_home}/.emacs.d/workgroups
    cp ${src_dir}/bin/packages.txt ${src_dir}/bin/setup/${chroot_script} ${archroot}

    cp ${src_dir}/.config/awesome/rc.lua ${new_home}/.config/awesome/
    if [[ ${user} != "fenton" ]]; then
        mkdir -p ${new_home}/.ssh
        ssh-keygen -N '' -f ${new_home}/.ssh/id_rsa
        chmod 700 ${new_home}/.ssh
        chmod -R 600 ${new_home}/.ssh/*
    else
        cd /tmp
        rm -fr ${src_user}
        git clone ${src_dir}
        tar cf f.tar ${src_user}
        mv f.tar ${new_home}/..
        cd ${new_home}/..
        tar xf f.tar
        rm -f f.tar
        rsync -aqP ${src_dir}/${rel_docs_dir}/pers-docs ${new_home}/${rel_docs_dir}/
        rsync -aqP ${src_dir}/${rel_docs_dir}/pers-docs/.git* ${new_home}/${rel_docs_dir}/pers-docs/ 
    fi
    pushd ${new_home}
    rm -f .xinitrc
    ln -s .xinitrc-common .xinitrc 
    popd
    cp ${src_dir}/.ssh/config ${new_home}/.ssh
}
chroot_steps() {
    # To get here by hand do:
    # src_user=fenton; archroot=/mnt/na; sudo arch-chroot ${archroot} 
    # Cannot pass args to script being called by arch-chroot
    sed -i "s/user=DUMMY/user=${user}/" ${archroot}/${chroot_script}
    sed -i "s/target_device=DUMMY/target_device=\/dev\/${just_device}/" ${archroot}/${chroot_script}
    arch-chroot ${archroot} ./${chroot_script}
}
cleanup_next_scripts() {
    rm -f ${archroot}/${chroot_script}
    rm -f ${archroot}/packages.txt
}
copy_packages() {
    free_space=`df --output=avail -B 1G ${full_root_partition} | tail -1 | tr -d ' '`
    pkg_dir_size=`du -sD -BG /var/cache/pacman/pkg | awk '{print $1}'`
    pkg_dir_size="${pkg_dir_size%?}"
    if [[ "$free_space" -gt "$pkg_dir_size" ]]; then
        rsync -avP --stats ${pacman_cache} ${archroot}${pacman_cache}
    fi
}
check_args
set_variables
#---------------- CLEANUP ANY PREVIOUS INSTALL ---------------
unmount_directories
check_valid_device
clean_disk
#---------------- PREPARE DISK/PARTITIONS ---------------
partition_disk
make_filesystem
make_and_mount_directories
#---------------- INSTALL PACKAGES ---------------
notify "starting pacstrap"
pacman_bootstrap
notify "make fstab"
make_fstab
notify "copy over user files"
user_files
notify "do chroot"
chroot_steps
copy_packages
#---------------- CLEANUP ---------------
notify "cleanup"
cleanup_next_scripts
unmount_directories

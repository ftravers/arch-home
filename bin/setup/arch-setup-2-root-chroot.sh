#!/usr/bin/zsh
# To get here by hand do:
# archroot=/mnt/na; sudo arch-chroot ${archroot}
notify(){
    echo ">>> $1"
    echo "-------------------------------------------"
}
set_variables() {
    user=DUMMY
    src_user=fenton
    target_device=DUMMY
    timezone="Asia/Bangkok"
    hostname="thumb"
    my_pkg_file_cache=/var/cache/pacman/mypkgs
}
set_locale_timezone_hostname() {
    sed -i 's/^#  en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" > /etc/locale.conf
    echo "FONT=Lat2-Terminus16" > /etc/vconsole.conf
    ln -s /usr/share/zoneinfo/${timezone} /etc/localtime
    hwclock --systohc --utc
    echo ${hostname} > /etc/hostname
}
make_initramfs() {
    sed -ri "s/^HOOKS=(.*) block (.*)filesystems (.*)/HOOKS=\1 block \2lvm2 filesystems \3/" /etc/mkinitcpio.conf
    mkinitcpio -p linux
}
install_packages() {
    pushd ${my_pkg_file_cache}
    pacman --noconfirm -U * 
    popd
    pacman --needed --noconfirm -S $( < packages.txt ) # > /dev/null
}
setup_grub() {
    sed -i "s/GRUB_TIMEOUT=5/GRUB_TIMEOUT=1/" /etc/default/grub
    set -x
    grub-install --recheck ${target_device}
    grub-mkconfig -o /boot/grub/grub.cfg
    set -x
}
setup_user_sudo_slim() {
    useradd -m -g users -s /usr/bin/zsh ${user}
    echo "${user}:welcome1" | chpasswd
    echo "root:welcome1" | chpasswd
    printf "\n${user} ALL=(ALL) NOPASSWD: ALL\n" >> /etc/sudoers
    touch /home/${user}/.zshrc
    systemctl enable slim.service
    sed -i "s/.*default_user.*/default_user ${user}/" /etc/slim.conf
}
create_ssh_keys() {
    sshdir="/home/${user}/.ssh"
    mkdir -p ${sshdir}
    ssh-keygen -f ${sshdir}/id_rsa -P ""
}
set_ownership() {
    chown -R ${user}:users /home/${user}
}
enable_dhcp() {
    systemctl enable dhcpcd.service
}
notify "setting variables"
set_variables

notify "setting timezone"
set_locale_timezone_hostname

notify "making init ram fs"
make_initramfs

notify "install packages"
install_packages

notify "setup grub"
setup_grub

notify "user sudo slim"
setup_user_sudo_slim

notify "ssh keys"
create_ssh_keys

notify "set user as owner/group permissions"
set_ownership

notify "enable dhcp"
enable_dhcp

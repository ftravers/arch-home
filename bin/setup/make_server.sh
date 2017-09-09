#!/usr/bin/zsh

# meant to be run as root/sudo

lock_down_ssh() {
    sed -i "s/#PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config
    sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/" /etc/ssh/sshd_config
    systemctl restart sshd.service
}

set_autologin() {
    sed -i "s/#auto_login.*/auto_login yes/" /etc/slim.conf
}
lock_down_ssh

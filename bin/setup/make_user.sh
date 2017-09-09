#!/usr/bin/zsh

zparseopts u:=user

check_args(){
    if [[ $#user -lt 1 ]]; then
        print "please specify the new user with: -u <user-name>"
        exit 1
    else
        user="$user[2]"
    fi
}
src_dir="/home/fenton"
new_home="/home/${user}"
useradd -m -g users -s /usr/bin/zsh ${user}
echo "${user}:welcome1" | chpasswd
sshdir="/home/${user}/.ssh"
mkdir -p ${sshdir}
ssh-keygen -f ${sshdir}/id_rsa -P ""
cp ${src_dir}/.xinitrc-common ${new_home}
cp ${src_dir}/.zshrc ${new_home}
cp ${src_dir}/.zshrc-functions.sh ${new_home}
cp ${src_dir}/.aliases_desktop ${new_home}
cp ${src_dir}/.aliases_common ${new_home}
cp -a ${src_dir}/.zsh ${new_home}
pushd ${new_home}
ln -s .xinitrc-common .xinitrc
ln -s .aliases_desktop .aliases
chown -R ${user}:users /home/${user}

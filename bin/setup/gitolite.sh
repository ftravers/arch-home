#!/usr/bin/zsh

# setup
config_settings() {
    git_admin_user="fenton"
}
parse_options() {
    zparseopts u=user
    if [[ $#user -gt 0 ]]; then
        git_admin_user=$user[2]
    fi
}

# fix git
root_steps() {
    sed -i "s#git daemon user:/.*#git daemon user:/home/git:/bin/zsh#" /etc/passwd
    su - ${git_admin_user} -c "cp ~${git_admin_user}/.ssh/id_rsa.pub /tmp/${git_admin_user}.pub"
    mv /tmp/${git_admin_user}.pub ~git/
    git clone https://github.com/sitaramc/gitolite.git ~git/gitolite
    chown -R git:users ~git

}

git_user_steps() {
    su git <<EOF
set -x
cd
mkdir -p ~/bin
rm -f ~/.ssh/authorized_keys
gitolite/install -to /home/git/bin
bin/gitolite setup -pk ${git_admin_user}.pub
EOF
}

# gitolite setup -pk ${git_admin_user}.pub


config_settings
parse_options
# root_steps
set -x
git_user_steps

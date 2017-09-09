#!/usr/bin/env zsh

export JAIL=/srv/http
mkdir $JAIL/dev
mknod -m 0666 $JAIL/dev/null c 1 3
mknod -m 0666 $JAIL/dev/random c 1 8
mknod -m 0444 $JAIL/dev/urandom c 1 9
mkdir -p $JAIL/etc/nginx/logs
mkdir -p $JAIL/usr/{lib,bin}
mkdir -p $JAIL/usr/share/nginx
mkdir -p $JAIL/var/{log,lib}/nginx
mkdir -p $JAIL/www/cgi-bin
mkdir -p $JAIL/{run,tmp}
cd $JAIL; ln -s usr/lib lib 
cd $JAIL; ln -s usr/lib lib64 ; ln -s usr/lib usr/lib64
mount -t tmpfs none $JAIL/run -o 'noexec,size=1M'
mount -t tmpfs none $JAIL/tmp -o 'noexec,size=100M'
cp -r /usr/share/nginx/* $JAIL/usr/share/nginx
cp -r /usr/share/nginx/html/* $JAIL/www
cp /usr/bin/nginx $JAIL/usr/bin/
cp -r /var/lib/nginx $JAIL/var/lib/nginx
cp $(ldd /usr/bin/nginx | grep /usr/lib |  awk '{print $(3)}') $JAIL/usr/lib
cp /usr/lib/libnss_* $JAIL/usr/lib
cp -rfvL /etc/{services,localtime,nsswitch.conf,nscd.conf,protocols,hosts,ld.so.cache,ld.so.conf,resolv.conf,host.conf,nginx} $JAIL/etc

cat <<EOF >> $JAIL/etc/group
http:x:33:
nobody:x:99:
EOF

cat <<EOF >> $JAIL/etc/passwd
http:x:33:33:http:/:/bin/false
nobody:x:99:99:nobody:/:/bin/false
EOF

cat <<EOF >> $JAIL/etc/shadow
http:x:14871::::::
nobody:x:14871::::::
EOF

cat <<EOF >> $JAIL/etc/gshadow
http:::
nobody:::
EOF

touch $JAIL/etc/shells
touch $JAIL/run/nginx.pid

chown -R root:root $JAIL/

chown -R http:http $JAIL/www
chown -R http:http $JAIL/etc/nginx
chown -R http:http $JAIL/var/{log,lib}/nginx
chown http:http $JAIL/run/nginx.pid

find $JAIL/ -gid 0 -uid 0 -type d -print | xargs chmod -rw
find $JAIL/ -gid 0 -uid 0 -type d -print | xargs chmod +x
find $JAIL/etc -gid 0 -uid 0 -type f -print | xargs chmod -x
find $JAIL/usr/bin -type f -print | xargs chmod ug+rx
find $JAIL/ -group http -user http -print | xargs chmod o-rwx
chmod +rw $JAIL/tmp
chmod +rw $JAIL/run

setcap 'cap_net_bind_service=+ep' $JAIL/usr/bin/nginx

cp /usr/lib/systemd/system/nginx.service /etc/systemd/system/nginx.service

cat <<EOF > /etc/systemd/system/nginx.service
[Unit]
Description=A high performance web server and a reverse proxy server
After=syslog.target network.target

[Service]
Type=forking
PIDFile=/srv/http/run/nginx.pid
ExecStartPre=/usr/bin/chroot --userspec=http:http /srv/http /usr/bin/nginx -t -q -g 'pid /run/nginx.pid; daemon on; master_process on;'
ExecStart=/usr/bin/chroot --userspec=http:http /srv/http /usr/bin/nginx -g 'pid /run/nginx.pid; daemon on; master_process on;'
ExecReload=/usr/bin/chroot --userspec=http:http /srv/http /usr/bin/nginx -g 'pid /run/nginx.pid; daemon on; master_process on;' -s reload
ExecStop=/usr/bin/chroot --userspec=http:http /srv/http /usr/bin/nginx -g 'pid /run/nginx.pid;' -s quit

[Install]
WantedBy=multi-user.target
EOF

pacman -Rsc --noconfirm nginx

ps -C nginx | awk '{print $1}' | sed 1d | while read -r PID; do ls -l /proc/$PID/root; done

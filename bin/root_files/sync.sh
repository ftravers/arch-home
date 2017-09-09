#!/usr/bin/zsh

mkdir -p /home/postgres-data
chown postgres:postgres /home/postgres-data

rsync -avP --stats * /

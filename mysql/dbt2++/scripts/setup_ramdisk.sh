#1/usr/bin/env bash

sudo umount $PGDATA

sudo mount -t tmpfs -o size=40G,nr_inodes=10k,mode=0777 tmpfs $PGDATA

sudo chown pgssi $PGDATA
sudo chgrp pgssi $PGDATA

chmod -R 0700 $PGDATA

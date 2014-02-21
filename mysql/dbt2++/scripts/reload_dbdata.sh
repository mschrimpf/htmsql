#!/usr/bin/env bash

BACKUP_PGDATA='/mnt/data1/pgssi/pgdata.bak'
PGDATA='/home/pgssi/install/pgsql/data'
# stop db / kill fast

echo "Kill server for reload..."
pg_ctl -m fast stop

# delete data directory contents

echo "Delete existing PGDATA ($PGDATA)..."
if [ -n "$PGDATA" ]; then #it's defined above - but just in case!
    rm -r $PGDATA/*
fi

# copy data.bak to data

echo "Copy fresh PGDATA from backup ($BACKUP_PGDATA)..."
cp -r $BACKUP_PGDATA/* $PGDATA


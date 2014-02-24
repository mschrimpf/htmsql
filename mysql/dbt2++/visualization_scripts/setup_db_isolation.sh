#!/usr/bin/env bash

#set -v

# remove last line (relies on last line being the default_transaction_isolation
sed -i '$ d' /home/pgssi/install/pgsql/data/postgresql.conf

# append new default_transaction_isolation

isolation="repeatable read"
if [ "$1" == "ssi" ] 
    then 
    isolation="serializable"
fi

echo "default_transaction_isolation = '${isolation}'" >> /home/pgssi/install/pgsql/data/postgresql.conf


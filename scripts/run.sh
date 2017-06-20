#!/bin/bash

# Initialize first run
if [[ -e /.firstrun ]]; then
    /scripts/first_run.sh
fi

# Initial run
/scripts/init_run.sh

USER=`cat /.mongo_user`
DB=`cat /.mongo_db`
PASS=`cat /.mongo_pass`
ROLE=`cat /.mongo_role`

echo "========================================================================"
echo "RUN MongoDB User: \"$USER\""
echo "RUN MongoDB Password: \"$PASS\""
echo "RUN MongoDB Database: \"$DB\""
echo "RUN MongoDB Role: \"$ROLE\""
echo "RUN MongoDB Params: \"$@\""
echo "========================================================================"

# Start MongoDB
echo "RUN Starting MongoDB..."
/usr/bin/mongod --dbpath /data --auth $@

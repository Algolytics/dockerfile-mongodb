#!/bin/bash

USER=`cat /.mongo_user`
DB=`cat /.mongo_db`
PASS=`cat /.mongo_pass`
ROLE=`cat /.mongo_role`

echo "========================================================================"
echo "INITRUN MongoDB User: \"$USER\""
echo "INITRUN MongoDB Password: \"$PASS\""
echo "INITRUN MongoDB Database: \"$DB\""
echo "INITRUN MongoDB Role: \"$ROLE\""
echo "========================================================================"

# Start MongoDB service
echo "INITRUN Starting MongoDB..."
/usr/bin/mongod --dbpath /data --auth $@ &
while ! nc -vz localhost 27017; do echo "INITRUN sleep 1"; sleep 1; done

echo "INITRUN Running initialization scripts..."
mongo $DB /scripts/init.js

# Stop MongoDB service
echo "INITRUN Stoping MongoDB..."
/usr/bin/mongod --dbpath /data --shutdown

#!/bin/bash

# Start MongoDB service
echo "INITRUN Starting MongoDB..."
/usr/bin/mongod --dbpath /data &

while ! nc -vz localhost 27017; do echo "INITRUN waiting for MongoDB"; sleep 1; done

echo "INITRUN Running initialization scripts..."
if [[ -e /scripts/init_script.js ]]; then
  mongo $DB /scripts/init_script.js
  rm -f /scripts/init_script.js
fi

# Stop MongoDB service
echo "INITRUN Stoping MongoDB..."
/usr/bin/mongod --dbpath /data --shutdown

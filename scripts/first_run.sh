#!/bin/bash
USER=${MONGODB_USERNAME:-mongo}
echo $USER > /.mongo_user
PASS=${MONGODB_PASSWORD:-$(pwgen -s -1 16)}
echo $PASS > /.mongo_pass
DB=${MONGODB_DBNAME:-admin}
echo $DB > /.mongo_db
if [ ! -z "$MONGODB_DBNAME" ]
then
    ROLE=${MONGODB_ROLE:-dbOwner}
else
    ROLE=${MONGODB_ROLE:-dbAdminAnyDatabase}
fi
echo $ROLE > /.mongo_role

echo "========================================================================"
echo "FIRSTRUN MongoDB User: \"$USER\""
echo "FIRSTRUN MongoDB Password: \"$PASS\""
echo "FIRSTRUN MongoDB Database: \"$DB\""
echo "FIRSTRUN MongoDB Role: \"$ROLE\""
echo "========================================================================"

# Start MongoDB service
echo "FIRSTRUN Starting MongoDB..."
/usr/bin/mongod --dbpath /data --nojournal &
while ! nc -vz localhost 27017; do echo "FIRSTRUN sleep 1"; sleep 1; done

# Create User
echo "Creating user: \"$USER\"..."
mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });"

# Stop MongoDB service
echo "FIRSTRUN Stoping MongoDB..."
/usr/bin/mongod --dbpath /data --shutdown

echo "FIRSTRUN Removing firstrun file..."
rm -f /.firstrun

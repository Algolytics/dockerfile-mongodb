#!/bin/bash
USER=${MONGODB_USERNAME:-mongo}
echo $USER > /.mongo_user
PASS=${MONGODB_PASSWORD:-$(pwgen -s -1 16)}
echo $PASS > /.mongo_pass
ADMIN_USER='userAdmin'
echo $ADMIN_USER > /.mongo_admin_user
ADMIN_PASS=`pwgen -s -1 16`
echo $ADMIN_PASS > /.mongo_admin_pass
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
echo "FIRSTRUN MongoDB Admin User: \"$ADMIN_USER\""
echo "FIRSTRUN MongoDB Admin Password: \"$ADMIN_PASS\""
echo "========================================================================"

# Start MongoDB service
echo "FIRSTRUN Starting MongoDB..."
if [ -f /data/mongod.lock ]; then
/usr/bin/mongod --dbpath /data &
else
/usr/bin/mongod --dbpath /data --nojournal &
fi

while ! nc -vz localhost 27017; do echo "FIRSTRUN waiting for MongoDB"; sleep 1; done

# Create User
echo "Creating user: \"$USER\"..."
mongo $DB --eval "db.createUser({ user: '$USER', pwd: '$PASS', roles: [ { role: '$ROLE', db: '$DB' } ] });"

# Create Admin
echo "Creating admin..."
mongo $DB --eval "db.createUser({ user: '$ADMIN_USER', pwd: '$ADMIN_PASS', roles: [ { role: 'userAdminAnyDatabase', db: 'admin' } ] });"

# Stop MongoDB service
echo "FIRSTRUN Stoping MongoDB..."
/usr/bin/mongod --dbpath /data --shutdown

echo "FIRSTRUN Removing firstrun file..."
rm -f /.firstrun

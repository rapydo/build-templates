#!/bin/bash

# mongo -- "${MONGO_INITDB_DATABASE}" <<EOF
#     var user = '${MONGO_INITDB_ROOT_USERNAME}';
#     var passwd = '${MONGO_INITDB_ROOT_PASSWORD}';
#     var admin = db.getSiblingDB('admin');
#     admin.auth(user, passwd);
#     use admin;
#     db.updateUser(
#         user,
#         {
#             roles: ["dbAdminAnyDatabase"]
#         }
#     );
# EOF

# userAdminAnyDatabase needed to allow dropDatabase
# roles: ["readWrite"] is not enough

mongo -- "${MONGO_INITDB_DATABASE}" <<EOF
    var user = '${MONGO_INITDB_ROOT_USERNAME}';
    var passwd = '${MONGO_INITDB_ROOT_PASSWORD}';
    var admin = db.getSiblingDB('admin');
    admin.auth(user, passwd);
    db.createUser(
        {
            user: user,
            pwd: passwd,
            roles: ["readWrite", "dbAdmin"]
        }
    );
EOF

mongo -- "celery" <<EOF
    var user = '${MONGO_INITDB_ROOT_USERNAME}';
    var passwd = '${MONGO_INITDB_ROOT_PASSWORD}';
    var admin = db.getSiblingDB('admin');
    admin.auth(user, passwd);
    db.createUser(
        {
            user: user,
            pwd: passwd,
            roles: ["readWrite"]
        }
    );
EOF

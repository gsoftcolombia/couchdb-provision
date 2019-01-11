#!/bin/bash -       
#title				:couchdb_2.3.0-bitnami-ubuntu_18.04.sh
#description		:This script will provision a couchdb service
#author				:dvillarraga
#date				:2019-01-10
#==============================================================================

install() {
# params
couchdb_pswd=$1
# Installing required packages so as to configure 'locales' 
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt-get install -y language-pack-en-base
sudo apt-get -y update

# Mounting Swap Volumes, This's only required in EC2 Instances for performance improvements.
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

# Downloading and installing Couchdb 2.3.0 from Bitnami
wget https://bitnami.com/redirect/to/376294/bitnami-couchdb-2.3.0-0-linux-x64-installer.run
chmod +x bitnami-couchdb-2.3.0-0-linux-x64-installer.run
sudo ./bitnami-couchdb-2.3.0-0-linux-x64-installer.run --mode unattended --couchdb_password $couchdb_pswd

# Configuring Couchdb for receive request from anywhere
sudo bash -c  "cat > /opt/couchdb-2.3.0-0/couchdb/etc/local.d/couchdb_config.ini" << EOF
[chttpd]
bind_address = 0.0.0.0
require_valid_user = true

[cors]
credentials = true
origins = *
headers = accept, authorization, content-type, origin, referer, x-csfr-token
methods = GET, PUT, POST, HEAD, DELETE
EOF

sudo /opt/couchdb-2.3.0-0/ctlscript.sh restart

# Just to be sure that the server is configured as a single node!
curl -X PUT http://admin:$couchdb_pswd@127.0.0.1:5984/_users
curl -X PUT http://admin:$couchdb_pswd@127.0.0.1:5984/_replicator
curl -X PUT http://admin:$couchdb_pswd@127.0.0.1:5984/_global_changes
}

"$@"

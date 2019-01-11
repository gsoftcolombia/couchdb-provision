CouchDB Provision for EC2 Single Node
=========

This provision will let you start an EC2 instance and configure it with CouchDB.

Before Start
------------

Check the correct script for the OS and version you want to launch.

Instructions
------------

**On AWS**
1. I recommend to create two security groups:
  1.1. internal-couchdb-server: Inbound rules for ports 22 (If is necessary) and 5984 with access only for your IP Address.
  1.2. public-couchdb-server: With Inbound rules for port 6984 for everybody.
2. Launch an EC2 Instance which is going to be configured with:

  2.1 user-data: Check if the script fits to your OS and replace your COUCHDB_ADMIN_PASSWORD

```console
#!/bin/bash

sudo apt-get -y update
wget https://raw.githubusercontent.com/gsoftcolombia/couchdb-provision/master/aws-ec2-single-node/couchdb_2.3.0-bitnami-ubuntu_18.04.sh
sudo chmod +x couchdb_2.3.0-bitnami-ubuntu_18.04.sh
sudo ./couchdb_2.3.0-bitnami-ubuntu_18.04.sh install COUCHDB_ADMIN_PASSWORD
sudo rm -f couchdb_2.3.0-bitnami-ubuntu_18.04.sh

```
  2.2 security-group: use the previously created "internal-couchdb-server".

3. If you require, you can create a domain name, something like db.yourapp.com
4. Request a public certificate with AWS Certificate Manager for your domain e.g. db.yourapp.com
5. 
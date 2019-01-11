CouchDB Provision for EC2 Single Node
=========

This provision will let you start an EC2 instance and configure it with CouchDB and SSL over Amazon Web Services.

Before Start
------------

Check the correct script for the OS and version you want to launch.

Instructions
------------

**On AWS**
1. We recommend to create a security group with Inbound rules:

* All traffic for the Internal Network.
* Ports 22 (If is necessary) and 5984 with access for your IP Address.
* Port 6984 for everybody.

2. Launch an EC2 Instance which is going to be configured with:

* user-data: Check if the script fits to your OS and replace your COUCHDB_ADMIN_PASSWORD

```console
#!/bin/bash

sudo apt-get -y update
wget https://raw.githubusercontent.com/gsoftcolombia/couchdb-provision/master/aws-ec2-single-node/couchdb_2.3.0-bitnami-ubuntu_18.04.sh
sudo chmod +x couchdb_2.3.0-bitnami-ubuntu_18.04.sh
sudo ./couchdb_2.3.0-bitnami-ubuntu_18.04.sh install COUCHDB_ADMIN_PASSWORD
sudo rm -f couchdb_2.3.0-bitnami-ubuntu_18.04.sh

```
* security-group: use the previously created.

3. If you require, you can create a domain name, something like db.yourapp.com
4. Request a public certificate with AWS Certificate Manager for your domain e.g. db.yourapp.com
5. Create an application-load-balancer with just one listener for HTTPS and Port 6984 which is going to use the previous certificate requested and the security group previously created.

* Create a target-group with a protocol HTTP Port 5984; in "Advanced health check settings" change the success code to 401 (Because your couchdb will require authorization to access).
* Register the EC2 Instance launched before.

6. Point your domain db.yourapp.com to the application-load-balancer.

**Important**

* Remember, your couchdb password will still available in the instance user-data, you're able to clean it up.





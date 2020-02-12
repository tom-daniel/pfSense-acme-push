#!/bin/sh

#This script takes the specidfied certifiacte and private keys, combines them and transfers to the destination
#The pfsense root account public key should be installed on the destiantion server before use. This can be done using the following command from pfsense root
#    ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
#Communication on TCP port 22 bewtween pfsense and the destintion  is required for the script to work

#Set the variables

#CERT_NAME is the the name of the certificate as set in pfSense
CERT_NAME=server.domain-lets-encrypt-cert

#DESTINATION_SERVER is the FQDN or ipaddress of the server the certificates should be pushed to
DESTINATION_SERVER=server.domain.co.uk

#USER is the username of a user with access on the remote server (you may wish to set up a pfsenseacme user on both pfsense and the destination server specificaly for this task)
USER=pfsenseacme

#DESTINATION_PATH is the directory in which you wish the final certificate to be placed (the example below if for Cockpit on Ubuntu)
DESTINATION_PATH=/etc/cockpit/ws-certs.d/

#DESTINATION_CER_NAME is what you wish for the certificate to be named, you can use the $CERT_NAME variable here to name it the same   
DESTINATION_CER_NAME=$CERT_NAME.cert

#merge the files
cat /cf/conf/acme/$CERT_NAME.crt >> /cf/conf/acme/$CERT_NAME.cert
cat /cf/conf/acme/$CERT_NAME.key >> /cf/conf/acme/$CERT_NAME.cert

#Change ownership of the file to ensure it is able to be updated on the next renewal
chown $USER /cf/conf/acme/$CERT_NAME.cert
chmod 660 /cf/conf/acme/$CERT_NAME.cert

#transfer the file
scp /cf/conf/acme/$CERT_NAME.cert $USER@$DESTINATION_SERVER:$DESTINATION_PATH$DESTINATION_CER_NAME

#clean up pfsense
rm /cf/conf/acme/$CERT_NAME.cert
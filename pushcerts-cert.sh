#!/bin/sh

#This script takes the specidfied certifiacte and private keys and transfers to the destination
#The pfsense root account public key should be installed on the destiantion server before use. This can be done using the following command from pfsense root
#    ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
#Communication on TCP port 22 bewtween pfsense and the destintion  is required for the script to work

#Set the variables
CERT_NAME=wildcard.the-daniels.co.uk
DESTINATION_SERVER=mysql1.the-daniels.co.uk
DESTINATION_USER=tomdaniel
DESTINATION_PATH=/etc/cockpit/ws-certs.d/
DESTINATION_CER_NAME=$CERT_NAME.cert

cat /cf/conf/acme/$CERT_NAME.crt >> /cf/conf/acme/$CERT_NAME.cert
cat /cf/conf/acme/$CERT_NAME.key >> /cf/conf/acme/$CERT_NAME.cert

scp /cf/conf/acme/$CERT_NAME.cert $DESTINATION_USER@$DESTINATION_SERVER:$DESTINATION_PATH$DESTINATION_CER_NAME

rm /cf/conf/acme/$CERT_NAME.cert
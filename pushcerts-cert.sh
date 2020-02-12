#!/bin/sh

#This script takes the specidfied certifiacte and private keys, combines them and transfers to the destination
#The pfsense root account public key should be installed on the destiantion server before use. This can be done using the following command from pfsense root
#    ssh-copy-id -i ~/.ssh/id_rsa.pub user@server
#Communication on TCP port 22 bewtween pfsense and the destintion  is required for the script to work

#Set the variables

#CERT_NAME is the the name of the certificate as set in pfSense
CERT_NAME=host.domain.co.uk-lets-encrypt-cert

#DOMAIN_NAME is the the domain name of the certificate 
DOMAIN_NAME=host.domain.co.uk

#DESTINATION_SERVER is the FQDN or ipaddress of the server the certificates should be pushed to
DESTINATION_SERVER=$DOMAIN_NAME

#USER is the username of a user with access on the remote server (you may wish to set up a pfsenseacme user on both pfsense and the destination server specificaly for this task)
USER=root

#DESTINATION_PATH is the directory in which you wish the final certificate to be placed (the example below if for Cockpit on Ubuntu)
DESTINATION_PATH=/etc/cockpit/ws-certs.d/

#DESTINATION_CER_NAME is what you wish for the certificate to be named, you can use the $CERT_NAME variable here to name it the same   
DESTINATION_CER_NAME=$DOMAIN_NAME.cert

#merge the files
cat /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.cer >> /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.cert
cat /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.key >> /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.cert

#transfer the file
scp /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.cert $USER@$DESTINATION_SERVER:$DESTINATION_PATH$DESTINATION_CER_NAME

#clean up pfsense
rm /tmp/acme/$CERT_NAME/$DOMAIN_NAME/$DOMAIN_NAME.cert
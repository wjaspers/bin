#!/bin/bash

source utils/inputs.sh

BITS=''
while [[ $BITS = '' ]]
do
    readnumber "How many bits to use? [>=2048] " BITS
    if [[ $BITS -lt 2048 ]]; then
    	echo "A certificate less than 2048 bits in strength is "
	    echo "considered cryptographically insecure."
        if ! secureconfirm; then
            BITS=''
        fi
    fi
done

DAYS=''
while [[ $DAYS = '' ]]
do
    readnumber "How long should the certificate be valid (in days)? " DAYS
    if [ $DAYS -lt 1 ]; then
        echo "WARNING! Certificates generated from this CA "
        echo "will immediately expire!"
        if ! secureconfirm; then
            DAYS=''
        fi
    fi
    if [ $DAYS -gt 1095 ]; then
        echo "It is NOT recommended to create a certificate"
        echo "which is valid for more than 3 years."
        if ! secureconfirm; then
            DAYS=''
        fi
    fi
done

readwriteablefilename "Where should the private key be saved? " PATH_PRIVATEKEY
readwriteablefilename "Where should the public certificate be stored? " PATH_PUBLIC_CERTIFICATE

#
# Step 1.
# Create a keypair.
# TODO: This isn't a very flexible command, but its quick.
#
openssl genrsa -des3 -out $PATH_PRIVATEKEY $BITS
if [ $? -ne 0 ]; then
	echo "Error generating private key."
	exit 1
fi

#
# Step 2.
# Create a root certificate and sign it.
#
openssl req \ 
    -new \ 
    -x509 \ 
    -key $PATH_PRIVATEKEY \ 
    -out $PATH_PUBLIC_CERTIFICATE \ 
    -days $DAYS
if [ $? -ne 0 ]; then
	echo "Error generating signed certifcate."
	exit 1
fi

exit 0

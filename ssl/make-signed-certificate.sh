#!/bin/bash
REPO_HOME=$(git rev-parse --show-toplevel)
source "$REPO_HOME/utils/inputs.sh"

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
        echo "WARNING! Your certificate will immediately expire!"
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

readwriteablefilename "Where should the private key be saved? " PATH_PRIVATE_KEY

readwriteablefilename "Where should the signing request be saved? " PATH_SIGNING_REQUEST

readfilename "Where is the certificate authority (public key)? " PATH_CA_CERTIFICATE

readfilename "Where is the certificate authority (private key)? " PATH_CA_KEY

readwriteablefilename "Where should the public certificate be stored? " PATH_PUBLIC_CERTIFICATE

#
# Step 1.
# Create a new private key.
#
openssl genrsa -des3 -out $PATH_PRIVATE_KEY $BITS
if [ $? -ne 0 ]; then
	echo "Error generating private key."
	exit 1
fi

#
# Step 2.
# Create a signing request.
#
openssl req -new \
	-key $PATH_PRIVATE_KEY \
	-out $PATH_SIGNING_REQUEST
if [ $? -ne 0 ]; then
	echo "Error generating signing request."
	exit 1
fi

#
# Step 3.
# Generate a certificate using the certificate authority.
#
openssl x509 -req -in $PATH_SIGNING_REQUEST \
	-CA $PATH_CA_CERTIFICATE \
	-CAkey $PATH_CA_KEY \
	-CAcreateserial \
	-out $PATH_PUBLIC_CERTIFICATE \
	-days $DAYS

if [ $? -ne 0 ]; then
	echo "Error generating the public certificate!"
	exit 1
fi

#
# Finished successfully
# 
exit 0

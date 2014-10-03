#!/bin/bash

if [ -z $1 ]; then
	echo "Please specify a search string".
	echo
	exit 1
fi

if [ -z $2 ]; then
	echo "Please specify a directory to search."
	echo
	exit 1
fi

RESULT=$(grep -rH "$1" "$2" | cut -d ":" -f 1)

if [ $? -gt 0 ]; then
	echo "Your search did not produce a useable result."
	echo "$RESULT"
	echo
	exit 1
fi

vi $RESULT

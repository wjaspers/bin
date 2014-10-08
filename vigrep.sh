#!/bin/bash

if [[ -z $1 ]]; then
	echo "Please specify a search string".
	echo
	exit 1
fi

if [[ -z $2 ]]; then
        echo "Please specify a directory to search."
        echo
        exit 1
fi

RESULT=$(grep -rl "$1" "$2")

if [ $? -gt 0 ]; then
	echo "Your search did not produce a useable result."
	echo
	exit 1
fi


TEST_RESULT=$(echo "$RESULT" | cut -s -d ":" -f 1)
if [ $TEST_RESULT ] && [[ $TEST_RESULT=~'too long' ]]; then
	echo "Your search produced too many results for vi to handle."
	echo
	exit 1
fi

vi $RESULT

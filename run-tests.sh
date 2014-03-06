#!/bin/bash

WATCH=${WATCH:false}
TARGET_FOLDER=$(dirname "$0")
if [ ! -z $1 ] && [ -d $1 ]; then
    TARGET_FOLDER=$1
fi
MOST_RECENT=''

TARGET_EXEC="./vendor/bin/phpunit"
if [ ! -f $TARGET_EXEC ]; then
    TARGET_EXEC=`command -v phpunit`
    if [ $? -ne 0 ]; then
        echo "Can't find PHPUnit"
        exit 1
    fi
fi

#
# Look for any local filesystem changes, omitting
# dotfiles and logs. Ideally this should ignore a lot
# more, but for simplicity's sake, it does what we need it to.
#
noFilesHaveChanged()
{
    mostRecent=$(find $TARGET_FOLDER -type f \( ! -iname ".*" ! -iname "*.log" \) -printf '%T@ %p\n' | sort -n | tail -1)
    if [[ $mostRecent == $MOST_RECENT ]]; then
        return 0
    fi
    MOST_RECENT=$mostRecent
    return 1
}


#
# Loop unless WATCH is false
#
while : ; do
    if ! noFilesHaveChanged; then
        ./${TARGET_EXEC} -c .
    fi
    if [ ! $WATCH ]; then   
       break
    fi
    sleep 1
done

#!/bin/bash

#
# Ask for confirmation
#
confirm() {
    local result
    while [[ $result = '' ]]
    do
        read -r -p "${1:-Are you sure?} [y/N]  " result
        case $result in
            [yY][eE][sS]|[yY]) 
                return 0
                ;;
            [nN][oO]|[nN])
                return 1
                ;;
        esac
    done
}


#
# Ask for a directory name
#
readdirname() {
    local result
    while [[ $result = '' ]]
    do
        read -er -p "$1" result
        if [ ! -d $result ]; then
            echo "Directory does not exist."
            result=''
        fi
    done
    export ${2}=$result
}

#
# Ask for a filename
#
readfilename() {
    local result
    while [[ $result = '' ]]
    do
        read -er -p "$1" result
        if [ ! -f $result ]; then
            echo "File does not exist."
            result=''
        fi
    done
    export ${2}=$result
}

#
# Ask for a filename we can write to.
#
readwriteablefilename() {
    local result
    local tmp_dirname
    while [[ $result = '' ]]
    do
        read -er -p "$1" result
        tmp_dirname=$(dirname "$result")
        if [ ! -w $tmp_dirname ]; then
            echo "Path: ${tmp_dirname} is not writable!"
            result=''
        fi
        if [ -f $result ]; then
            echo "Oops! That file already exists."
            if ! confirm "Overwrite it? "; then
                result=''
            fi
        fi
    done
    export ${2}=$result
}

#
# Ask for an integer.
#
readnumber() {
    local result
    while [[ $result = '' ]]
    do
        read -p "$1" result
        if [[ $result = *[!0-9]* ]]; then
            result=''
        fi
    done
    export ${2}=$result
}


secureconfirm() {
    return $(confirm "${1:-Accept this risk?}")
}

#!/bin/bash

if ! command -v sshpass $> /dev/null
then
    # requires sshpass
    sudo apt-get install sshpass -y >> /dev/null
fi

if [[ "$#" -lt 2 ]] ; then
   echo "Invalid number of arguments. Provide at least 2 arguments"
else

    HOSTNAME=$(hostname)
    TARGET=""
    TARGET_DIR="${@: -1}"
    ARG_COUNT="$#"


    if [[ "$HOSTNAME" = server1 ]] ; then
        TARGET="192.168.100.11"
    else
        TARGET="192.168.100.10"
    fi

    DEST="$TARGET:$TARGET_DIR"

    ITERATION=1
    for arg in "$@" ; do
        if [[ "$ITERATION" = "$ARG_COUNT" ]] ; then
            break
        else
            sshpass -p 'vagrant' scp -q -o StrictHostKeyChecking=no "$arg" vagrant@"$DEST"
            FILE_SIZE=$(wc -c < "$arg")
            BYTES=$(($BYTES + $FILE_SIZE))
            ITERATION=$(($ITERATION + 1))
        fi
    done

    echo "$BYTES"
fi

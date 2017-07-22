#!/bin/bash
# Imports proprietary blobs depending on which are currently in the proprietary
# folder

importtype=

if [ -z "$1" ]; then
  echo "Specify dir to import or use the --adb parameter to pull from phone"
elif [ "$1" == "--adb" ]; then
  importtype=adb
else
  importtype=fs
fi

if [ ! -z "$importtype" ]; then
    while read blob; do
        blobonly="${blob/proprietary\//}"
        if [ "$importtype" == "adb" ]; then
            if [[ "$(adb devices)" == *"device "* ]]; then
                echo "/system/$blobonly -> $blob"
                adb pull "/system/$blobonly" "$blob"
                [ $? -ne 0 ] && echo "Cannot pull /system/$blobonly"
            else
                echo "No devices found!"
                break
            fi
        else
            echo "$1/system/$blobonly -> $blob"
            cp "$1/system/$blobonly" "$blob"
        fi
    done < <(find proprietary -type f)
fi
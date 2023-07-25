#!/bin/bash

# Check if PKGBUILD exists in the current directory
if [ -f PKGBUILD ]; then

    # Add "-binderfs" prefix to pkgbase variable
    sed -i 's/pkgbase=.*/pkgbase=linux-g14-binderfs/' PKGBUILD
    # Search for the prepare() function and add the lines before the closing }
    if grep -q 'prepare()' PKGBUILD; then
        awk -i inplace '/prepare\(\)/ {
            print
            is_prepare=1
            next
        }
        is_prepare && /^}/ {
            print "  scripts/config --enable CONFIG_ANDROID"
            print "  scripts/config --enable CONFIG_ANDROID_BINDER_IPC"
            print "  scripts/config --enable CONFIG_ANDROID_BINDERFS"
            print "  scripts/config --set-str CONFIG_ANDROID_BINDER_DEVICES \"\""
            is_prepare=0
        }
        1' PKGBUILD
        echo "PKGBUILD updated successfully."
    else
        echo "The PKGBUILD does not contain a prepare() function."
    fi
else
    echo "PKGBUILD file not found in the current directory."
fi

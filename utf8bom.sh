#!/bin/bash

for file in "$@"
do
    if test -s "${file}"
    then
        if [[ $(cut -z -b1-3 "${file}" | hexdump -v -e '/1 "%02X"') == 'EFBBBF00' ]]
        then
            echo "Unchanged ${file}"
        else
            sed -i '1s/^/\xef\xbb\xbf/' "${file}" || exit $?
            echo "Added UTF-8 BOM to ${file}"
        fi
    elif test -w $file
    then
        echo -en "\xef\xbb\xbf" > "${file}" || exit $?
        echo "Added UTF-8 BOM to ${file}"
    else
        file "${file}" || exit $?
        exit 1
    fi
done


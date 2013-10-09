#!/bin/bash

ext=${1:-orig}
out_file=${2:-./config.diff}

> $out_file
for item in $(find /etc -name "*.${ext}" -print) ; do
    path=${item%.$ext}
    echo "#================================================================================" >> $out_file
    diff -u $path.$ext $path >> $out_file
done
echo "#================================================================================" >> $out_file

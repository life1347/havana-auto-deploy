#!/bin/bash

file1=$1
file2=$2

#-------------------------------------------------------------------------------

trim() {
    echo "$1"
}


# Determinate is the given option present in the INI file
# ini_has_option config-file section option
function ini_has_option() {
    local file=$1
    local section=$2
    local option=$3
    local line
    line=$(sed -ne "/^\[$section\]/,/^\[.*\]/ { /^$option[ \t]*=/ p; }" "$file")
    [ -n "$line" ]
}


# Set an option in an INI file
# iniset config-file section option value
function iniset() {
    local file=$1
    local section=$2
    local option=$3
    local value=$4
    if ! grep -q "^\[$section\]" "$file"; then
        # Add section at the end
        echo -e "\n[$section]" >>"$file"
    fi
    if ! ini_has_option "$file" "$section" "$option"; then
        # Add it
        sed -i -e "/^\[$section\]/ a\\
$option = $value
" "$file"
    else
        # Replace it
        sed -i -e "/^\[$section\]/,/^\[.*\]/ s|^\($option[ \t]*=[ \t]*\).*$|\1$value|" "$file"
    fi
}

#-------------------------------------------------------------------------------

if [ ! -f "$file1.orig" ] ; then
    cp "$file1" "$file1.orig"
fi


section=''
while IFS='=' read -r option value
do
    [ -z "$option" ] && continue

    [[ "$option" =~ ^# ]] && continue

    if [[ "$option" =~ \[.*\] ]] ; then
        section=${option#*[}
        section=${section%]*}
        continue
    fi

    option=$(trim $option)
    value=$(trim $value)

    iniset "$file1" "$section" "$option" "$value"
done < $file2

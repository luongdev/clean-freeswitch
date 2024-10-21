#!/bin/bash

PASS_FILE="/usr/local/freeswitch/.pass"
FILE_NAME="/usr/local/freeswitch/conf/autoload_configs/acl.conf.xml"
PROVIDERS_RN=$(sed -n '/<list name="providers" default=".*">/=' /usr/local/freeswitch/conf/autoload_configs/acl.conf.xml | head -n 1)

reload_acl() {
    PWD="$(cat $PASS_FILE)"
    PWD=${PWD:-Default#Switch@6699}

    fs_cli -p $PWD -x "reloadacl"
}

add_provider() {
    local cidr="$1"
    if [[ ! "$cidr" =~ / ]]; then
        cidr="$cidr/32"
    fi
    sed -i "${PROVIDERS_RN}a <node type=\"allow\" cidr=\"$cidr\"/>" /usr/local/freeswitch/conf/autoload_configs/acl.conf.xml
    echo "Added provider with CIDR $cidr"
}

del_provider() {
    local cidr="$1"
    local has_subnet="0"
    if [[ "$cidr" =~ / ]]; then
        has_subnet="1"
    fi
    local formatted_cidr=$(echo "$cidr" | sed 's/\./\\./g; s/\//\\\//g')
    if [[ "$has_subnet" = "0" ]]; then
        sed -i "/<list name=\"providers\" default=\".*\">/,/<\/list>/ s/<node type=\".*\" cidr=\"$formatted_cidr\/.*\"\/>//" "$FILE_NAME"
    else
        sed -i "/<list name=\"providers\" default=\".*\">/,/<\/list>/ s/<node type=\".*\" cidr=\"$formatted_cidr\"\/>//" "$FILE_NAME"
    fi
    
    echo "Deleted provider with CIDR $cidr"
}

if [[ "$1" == "add" && ! -z "$2" ]]; then
    add_provider "$2"
elif [[ "$1" == "del" && ! -z "$2" ]]; then
    del_provider "$2"
else
    echo "Usage: $0 provider add|del [CIDR]"
    exit 1
fi

reload_acl
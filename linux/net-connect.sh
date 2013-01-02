#!/usr/bin/env bash

## About
#   Effectively this script acts as a toggle between a dhcp network and a static 
#   configured router.
#   This script connects a linux network_interface to a FIRST configured access point 
#   either via wireless or ethernet from dhcp or from a static IP to dhcp
#   depending on the current status of the computer's connection
#
#   For example, if I'm connected to a static FIRST network at 10.29.45.5
#   over ethernet and I run this script(assuming my $default_network_interface or options 
#   select the ethernet network interface, I will be switched to dhcp. If I run this script 
#   again with the same options, I will be switched from dhcp to the pre-set static ip.
# Options:
# --wireless 
#           Use the wireless network interface specified as $wireless_network_interface in the script
# --wired 
#           Use the wired network interface specified as $wireless_network interface in the script
#
# Requirements: 
#   - bash
#   - network-tools 
#   - wicd 

##  User set variables -- Using text files
# Unique identifier for the computer you're running the script on
ip_identifier="4" # 4
netmask="255.255.255.0" # 255.255.255.0
team_number="2945" # 2945
wired_network_interface="eth0" # eth0
wireless_network_interface="wlan0" #wlan0
access_point="2945" # only needed for wireless. Assumes network has no 
#                       encryption
# wireless or wired default
default_network_interface="$wired_network_interface"

## Functions

# Figure out what the connection ip will look like based on the team number
# and the unique identifier
function return_final_ip {
    # IP format:
    #   29 = 10.0.29.$(ip_identifier)
    #   294 = 10.2.94.$(ip_identifier)
    #   2945 = 10.29.45.$(ip_identifier)
    #   107 = 10.1.7.$(ip_identifier)
    #   170 = 10.1.70.$(ip_identifier)
    #   1700 = 10.17.0.$(ip_identifier)
    team_number="$1"
    ip_identifier="$2"

    team_number_length=${#team_number}
    sub_ip="" # The team configured ip substring

    if [[ $team_number_length == 1 || $team_number_length == 2 ]]; then
        sub_ip="0.${team_number}"
    elif [[ $team_number_length == 3 ]]; then
        if [[ ${team_number:1:1} == "0" ]]; then # ex: 107
            sub_ip="${team_number:0:1}.${team_number:2:1}" # ex 107 -> 1.7
        else
            sub_ip="${team_number:0:1}.${team_number:1:2}" # ex 294 -> 2.94
        fi

    elif [[ $team_number_length == 4 ]]; then
        sub_ip="10.29.${team_number}.${ip_identifier}"
        if [[ ${team_number:2:1} == 1 ]]; then # ex 1700 -> 17.0 or 1707 -> 17.7
            sub_ip="${team_number:0:2}.${team_number:3:1}"
        else
            sub_ip="${team_number:0:2}.${team_number:2:2}" # ex 2945 -> 29.45
        fi
    else
        echo "Incorrect team name"
        exit 1
    fi
    final_ip="10.${sub_ip}.${ip_identifier}"
    echo "$final_ip"
}


# accept arguments
# function wireless_to_static { # I cannot get wicd to set IP, so this doesn't work
#     final_ip="$1"
#     access_point="$2"
# 
#     wicd_cli=`wicd-cli -l --wireless`
#     # returns the access point name
#     available_essid=$(echo "$wicd_cli" | grep -i "$access_point"  | awk '{ print $4 }')
# 
#     if [[ "$access_point" == "$available_essid" ]]; then
#         # Find number and connect or disconnect
#         number=$( echo "$wicd_cli" | grep "$access_point"  | awk '{ print $1 }')
#         wicd-cli 
#     else
#         echo "Cannot find access point to connect to" >&2
#         exit 1
#     fi
# }

function wireless_to_dhcp {
    # Let wicd automatically connect to your dhcp network
    # wicd-cli -x --wireless
    # wicd-cli -c --wireless
    echo "foo"
}

function wired_to_static {
    sudo ifconfig $selected_network_interface $final_ip netmask $netmask
}

function wired_to_dhcp {
    # wicd-cli -x --wired
    # wicd is a piece of shit
    echo "foo"
}

final_ip=`return_final_ip $team_number $ip_identifier`
echo "Connecting as $final_ip on $selected_network_interface"

# options
connect_wireless=false
connect_wired=false

if [[ "$1" == "--wireless" ]]; then
    selected_network_interface="$wireless_network_interface"
    connect_wireless=true
elif [[ "$1" == "--wired" ]]; then
    selected_network_interface="$wired_network_interface"
    connect_wired=true
else
    # Grep returns 1 if the desired search is not matched
    # I exploit this to determine wether the output of iwconfig shows the 
    # selected network interface to be wireless or wired

    selected_network_interface="$default_network_interface"
    network_interface_type=`iwconfig | grep "$default_network_interface"`
    network_interface_is_wired=$?
    if (( $network_interface_is_wired )); then
        connect_wired=true
    else
        connect_wireless=true
    fi
fi

ifconfig | grep -A2 "$selected_network_interface" | grep "$final_ip"
is_current_network_dhcp="$?" # Doesn't totally determine if the current network
# is using dhcp, but it's good enough for my purposes

if $connect_wired; then
    if (( $is_current_network_dhcp )); then
        wired_to_static 
    else
        wired_to_dhcp 
    fi
elif $connect_wireless; then
    if (( $is_current_network_dhcp )); then
        # wireless_to_static $final_ip $netmask $access_point 
        echo "nothing to do here"
    else
        wiress_to_dhcp
    fi
else
    echo "Something went wrong with determining with what nick to connect"
    exit 1
fi
# main

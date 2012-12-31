#!/usr/bin/env python2
import subprocess
import os

static_ip = "10.29.45.4"
interface_type="wired" # 'wired' or 'wireless'

# Note: the interface names may be different for you. Check them in
# 'Network Connections'
if interface_type == "wireless":
    interface = "Wireless Network Connection"
elif interface_type == "wired":
    interface = "Local Area Connection"
else: 
    raise

# You don't need to set these unless you are using a static wireless connection
# I don't set the gateway, because it messes with how Windows 7 looks for 
# internet access

netsh_output_cmd = 'netsh interface ipv4 show address name="' + interface + '"'
netsh_output_handle = subprocess.Popen(netsh_output_cmd.split(), stdout=subprocess.PIPE)

out, err = netsh_output_handle.communicate()

print out
try :
    # Search for intended static ip in command output
    if out.index(static_ip):
        switch_to="dhcp"
except ValueError:
    switch_to="static"

print switch_to


if switch_to == "dhcp":
    dhcp_cmd = 'netsh interface ipv4 set address name="' + interface \
            + '" dhcp'

    subprocess.call(dhcp_cmd.split())
elif switch_to == "static":
    static_cmd='netsh interface ipv4 set address name="' + interface + \
            '" static ' + static_ip + ' 255.255.255.0'
    subprocess.call(static_cmd.split())
    
else:
    raise

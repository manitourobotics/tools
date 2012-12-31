#!/usr/bin/env python2
import subprocess
import ConfigParser

config = ConfigParser.ConfigParser()
try:
    config.read("config.txt.example")
except: 
    print "Error reading config.txt"
    raise SystemExit

try:
    main_section = "user_set_variables"
    static_ip = config.get( main_section, 'static_ip' )
    interface_type = config.get( main_section, 'interface_type' )
except ConfigParser.NoSectionError: 
    print "Be sure to copy config.txt.example to config.txt"
    print "Error parsing options"
    raise SystemExit

print static_ip
print interface_type

def retrieve_ip_information(interface):
    netsh_output_cmd = 'netsh interface ipv4 show address name="' + \
            interface + '"'
    netsh_output_handle = subprocess.Popen(netsh_output_cmd.split(), \
            stdout=subprocess.PIPE)
    out, err = netsh_output_handle.communicate()
    return out

# Note: the interface names may be different for you. Check them in
# 'Network Connections'
if interface_type == "wireless":
    interface = "Wireless Network Connection"
elif interface_type == "wired":
    interface = "Local Area Connection"
else: 
    print "Error determening interface"
    raise SystemExit


pre_ipconfig = retrieve_ip_information(interface)
print "pre-ipconfig: " + pre_ipconfig
try :
    # Search for intended static ip in command pre_ipconfigput
    if pre_ipconfig.index(static_ip):
        switch_to="dhcp"
except ValueError:
    switch_to="static"

print "Switching to " + switch_to


if switch_to == "dhcp":
    dhcp_cmd = 'netsh interface ipv4 set address name="' + interface \
            + '" dhcp'

    subprocess.call(dhcp_cmd.split())
elif switch_to == "static":
    static_cmd='netsh interface ipv4 set address name="' + interface + \
            '" static ' + static_ip + ' 255.255.255.0'
    subprocess.call(static_cmd.split())
else:
    print "Error determining what to set the network interface to"
    raise SystemExit

# Wait for netsh to show ip address if switching to static 
times_retrieved_information=0
while True:
    post_ipconfig = retrieve_ip_information(interface)
    times_retrieved_information+=1
    try:
        if switch_to == "dhcp":
            print "post-ipconfig: " + post_ipconfig
            break
        elif post_ipconfig.index(static_ip):
            print "post-ipconfig: " + post_ipconfig
            break
        else:
            print "Error retrieving IP information"
            raise SystemExit
    except ValueError:
        pass
    if times_retrieved_information >= 10:
        print "Failed to verify static ip connection"
        raise SystemExit


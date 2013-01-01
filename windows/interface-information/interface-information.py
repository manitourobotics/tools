import os
import sys
import ConfigParser
import subprocess

config = ConfigParser.ConfigParser()
try:
    config_filename="config.txt"
    config.read(config_filename)
except:
    print "Error reading " + config_filename
    sys.exit(-1)

try:
    main_section = "user_set_variables"
    interfaces=config.get(main_section, 'survey_interfaces').split(',')
    for interface in interfaces:
        netsh_output_cmd = 'netsh interface ipv4 show address name="%s"' \
                % interface.strip()
        # remove trailing and leading whitespace from user config

        netsh_output_handle = subprocess.Popen(netsh_output_cmd.split(), \
                stdout=subprocess.PIPE)
        netsh_out, err = netsh_output_handle.communicate() 
        print "%s" % netsh_out 
except ConfigParser.NoSectionError: 
    print "Error reading variables"
    print "Be sure to copy config.example.txt to config.txt and configure"
    sys.exit(-1)

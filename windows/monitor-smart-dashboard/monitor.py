#!/usr/bin/env python2

# This script monitors the SmartDashboard process and 
# restarts it if it's not running. This service is nessesary because of a bug 
# in the SmartDashboard, where if you use the camera plugin, then, after a 
# plugin, so hence the script

import win32ui
import sleep

TEAM_NAME = "2945"
if __name__ == "__main__":
    while True:
        windowName = "SmartDashboard - %s" % TEAM_NAME
        if FindWindow(windowName, "SmartDashboard" ):
            print "found smd"
        time.sleep(1)

#!/usr/bin/env python2
import subprocess
import os


subprocess.call('netsh interface ipv4 set address name="Local Area Connection" static 10.29.45.4 255.255.255.0'.split())
os.system("pause")
subprocess.call('netsh interface ipv4 set address name="Local Area Connection" dhcp'.split())

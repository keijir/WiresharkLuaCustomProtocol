#!/bin/sh
/Applications/Wireshark.app/Contents/Resources/bin/tshark -i 2 -b filesize:1024 -w capture.pcap

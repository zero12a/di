#!/bin/sh



echo "\n\nStarting rsyslogd...\n\n"
/usr/sbin/rsyslogd

echo "\n\nStarting crontab...\n\n"
crond -f 

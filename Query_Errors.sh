#!/bin/bash

#linkedin : https://www.linkedin.com/in/can-sayın-b332a157/
#cansayin.com

#If your ClickHouse Server has 1000 query error, (type=4 'Exception While Processing') script returns an alert email.
 
cd /home/clickhouse
clickhouse-client -q "SELECT count(*) FROM system.query_log where type=4 and event_time > now()-3600*24" >> clickhouseQueryAlert.txt
 
cd /home/clickhouse
host = hostname
usep= cat clickhouseQueryAlert.txt
if [ "${usep}" -gt 1000 ]; then
echo "There are huge amount of query is getting error on $host" > /tmp/clickhouseQueryAlert.out

 
tomail='can.sayn@chistadata.com'
frommail='can.sayn@mail.com'
smtpmail=smtp.mail.com
echo "There are huge amount of query is getting error on $host"  | /bin/mailx -s "$host Clickhouse Query Error" -r  "$frommail" -S smtp="$smtpmail" $tomail < /tmp/clickhouseQueryAlert.out
 
fi
 
cd /home/clickhouse
rm -rf clickhouseQueryAlert.txt

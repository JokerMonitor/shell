#!/bin/bash
logfile="diskusage.log"

if [ ! -n $1 ] ;
then
 logfile=$1
fi

user=$USER

if [ -e $logfile ];
then
printf "%-8s %-14s %-9s %-8s %-6s %-6s %-6s\n" "DATE" "IP ADDR" "DEVICE" "CAPACITY" "USED" "FREE" "PERCENT" > $logfile
fi

while read server;
   do
    ssh -n root@$server 'df -H' | grep ^/dev/ > /tmp/$$.df
       
    while read line;
    do
    cur_date=$(date +%D)
    echo "ip is $server" 
    #printf "%-8s %-14s " $cur_date $server
    echo $line | awk '{ printf("%-8s %-14s %-9s %-8s %-6s %-6s %-8s\n", v1,v2,$1,$2,$3,$4,$5); }' v1=$cur_date v2=$server >> $logfile
    
    done < /tmp/$$.df
    rm /tmp/$$.df
done < servers.list

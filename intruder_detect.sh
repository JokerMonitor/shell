#!/bin/bash
AUTHLOG=/var/log/auth.log

if [[ -n $1 ]] ;
then
AUTHLOG=$1
echo "using log file : ${AUTHLOG}" 
fi

FAILEDLOG=/tmp/failed.$$.log
grep "Failed pass" $AUTHLOG > $FAILEDLOG

users=$(cat $FAILEDLOG | awk '{ print $(NF-5) }' | sort | uniq )

ips=$(egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' $FAILEDLOG | sort | uniq )
printf "%-10s|%-10s|%-16s|%-10s|%s\n" "Users" "Attempts" "IP Address" "Host" "Time Range"

for ip in $ips;
do
 for user in $users;
 do
  attempts=`grep $ip $FAILEDLOG | grep " $user " | wc -l `
  if [ $attempts -ne 0 ];
   then
    first_time=`grep $ip $FAILEDLOG | grep " $user " | head -1 | cut -c-16 | tr -d '\n' `
    time="$first_time"
    if [ $attempts -gt 1 ];
    then
    last_time=`grep $ip $FAILEDLOG | grep " $user " | tail -1 | cut -c-16 | tr -d '\n' `
    time="${first_time} -> ${last_time}"
    fi
    HOST=$(host $ip 8.8.8.8 | tail -1 | awk '{print -NF}')
    printf "%-10s|%-10s|%-16s|%-10s|%s\n" $user $attempts $ip $HOST "$time"
   #$user $attempts $ip $HOST $time;
   fi
 done
done
rm $FAILEDLOG





#!/bin/bash
username=$(whoami);
plugin=iperf
if [ $# -eq 0 -o $# -gt 1 ]; 
then
 echo "must type 1 argument ."
 exit;
fi
action=$1
if [ $action == "install" ];
then
  while read ip;
  do
   ( 
   ssh $username@$ip "apt-get install $plugin";
   if [ $? -eq 0 ] ;
   then
    echo "installed iperf on server $ip"
   fi
   )&
done < servers.list
wait;
elif [ $action == "launch" ] ;
  then
  while read ip;
  do
  (
   ssh $username@$ip "iperf -s"
   if [ $? -eq 0 ];
   then
   echo "iperf has been launched at $ip"
   fi
  )&
  done < servers.list
  wait;
elif [ $action == "shutdown" ];
  then
  while read ip;
  do
  (
  ssh $username@$ip "pkill -KILL iperf"
  if [ $? -eq 0 ];
  then
   echo "iperf has been shutdown at $ip"
  fi
  )&
  done < servers.list
  wait;
fi
exit;

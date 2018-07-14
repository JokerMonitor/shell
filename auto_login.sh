#!/bin/bash
read -p "please input your username:" username
read -s -p "please input your password:" password

sync_key() {
while read ip;
do 
 (
  sshpass -p $password  ssh -o StrictHostKeyChecking=no $username@$ip "cat >> /$username/.ssh/authorized_keys" < /$username/.ssh/id_rsa.pub ;
#echo -e "${password}\n" | ssh-copy-id -f $username@$ip ;
if [ $? -eq 0 ];
 then 
  echo "the server $ip set successful ."
 else
  echo "the server $ip set failed ."
 fi
 )&
done < servers.list
wait;
}

if [ -e /$username/.ssh/id_rsa.pub -a -e /$username/.ssh/id_rsa ];
then
echo "the key is already"
sync_key
else
echo "the key is not exsits . "
exit
fi

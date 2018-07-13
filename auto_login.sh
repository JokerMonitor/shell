#!/bin/bash
read -p "please input your username:" username
read -s -p "please input your password:" password
if [ -e /$username/.ssh/id_rsa.pub -a -e /$username/.ssh/id_rsa ] ;
then 
echo "the keys all be already ."
else
echo "the keys need to be generate. "
echo "Now, generating ..."
ssh-keygen -t rsa
fi

while read ip;
do 
 (
 ssh $username@$ip "cat >> /$username/.ssh/authorized_keys" < /$username/.ssh/id_rsa.pub ;
 if [ $? -eq 0 ];
 then 
  echo "the server $ip set successful ."
 else
  echo "the server $ip set failed ."
 fi
 )&
done < servers.list
wait

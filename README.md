# shell
run the script curry.sh :

1.clone this repository

2.run ./curry.sh [port | optional]

3.run curl http://localhost:port/server_info
  Now, you can get the server info (disk, network, cpu)
  servers.list define the server IPs in your cluster.

run the script auto_login.sh

1.run ./auto_login.sh and input yout username and password
and it will copy the public_key to the servers which been defined in servers.list 
and you will login the servers without input username and password

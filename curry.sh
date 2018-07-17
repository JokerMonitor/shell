#!/bin/bash
response="/tmp/response-$RANDOM.pipe"
template=template.txt
touch $template
mkfifo $response > /dev/null 2>&1
trap "rm -rf $response $template" EXIT INT TERM
start_server() {
local port=${1:-8080}
while true; do
cat $response | nc -l $port > >(handler_request) || break;
done
}

servers_active() {
while read ip;
do 
     ( 
        ping $ip -c 3 &> /dev/null ;
        if [ $? -eq 0 ] ;
         then 
          echo $ip is alive
         else
          echo $ip is down
        fi
           
     )&
     done < servers.list
     wait
}

handler_request() {
read request
echo "$request"
local service_name=$(echo "$request" | cut -d ' ' -f2)
echo "$service_name"
local port_info="portinfo-$RANDOM.txt"
local addr_info="addrinfo-$RANDOM.txt"

if [ "$service_name" == "/server_info" ]; then
    echo "------- disk usage --------- " >> $template
     df >> $template
    echo "----------- the system run time ------------ " >> $template
     uptime | sed 's/.*up \(.*\),.*users.*/\1/' >> $template
    echo "------------ cpu usage info -------------" >> $template
    ps -eocomm,pcpu | egrep -v '(0.0)|(0,0)|(%CPU)' | sort -nrk 2 >> $template
    echo "------------ network info ---------------" >> $template
     #ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n' >> $port_info
     ip addr | egrep "^[0-9]*:" | cut -d ':' -f2 >> $port_info
     ip addr | grep "inet " >> $addr_info
     paste $port_info $addr_info -d " " | tr -s " " >> $template
     rm $port_info $addr_info
    echo "---------- servers active info ------------" >> $template
    servers_active >> $template 	
    cat $template >> $response
    echo "" > $template
    return
else
  echo "service not found " > $response
fi
}

start_server $1

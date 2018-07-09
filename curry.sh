#!/bin/bash
response="/tmp/response-$RANDOM.pipe"
template=template.txt
touch $template
mkfifo $response > /dev/null 2>&1
trap "rm -rf $response" EXIT INT TERM
start_server() {
local port=${1:-8080}
while true; do
cat $response | nc -l $port > >(handler_request) || break;
done
}

handler_request() {
read request
echo "$request"
local service_name=$(echo "$request" | cut -d ' ' -f2)
echo "$service_name"
if [ "$service_name" == "/server_info" ]; then
   echo "------- disk usage --------- " >> $template
     df >> $template
     echo "----------- the system run time ------------ " >> $template
    uptime | sed 's/.*up \(.*\),.*users.*/\1/' >> $template
    echo "------------ cpu usage info -------------" >> $template
    ps -eocomm,pcpu | egrep -v '(0.0)|(0,0)|(%CPU)' | sort -nrk 2 >> $template
   	
    cat $template >> $response
    echo "" > $template
    return
else
  echo "service not found " > $response
fi
}

start_server $1

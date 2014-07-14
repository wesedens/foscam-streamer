#!/bin/bash

function handle {
    FILENAME="img_$(date +%Y-%m-%d-%R:%S).mpeg"
    cvlc 'http://192.168.1.111/videostream.cgi?user=wedens&pwd=risku123&rate=10' --sout file/ts:${FILENAME}
    #cvlc 'http://192.168.1.111/videostream.asf?user=wedens&pwd=risku123' --sout file/ts:streamtest.mpg
}

# stop the server on ctrl-c
trap exit SIGINT SIGTERM

# wait for a connection and kick off the streaming on accept
while true;
do {
    echo -e 'HTTP/1.1 200 OK\r\n';
} | nc -l 9090;

echo -e 'start saving the stream...\r\n';

# start the streaming and save to a file in the background
handle &
CPID=$!

# wait a couple of minutes, then shut it down
sleep 4m

echo -e 'stopping streaming...\r\n';
pkill -TERM -P ${CPID}

done

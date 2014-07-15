#!/bin/bash

LOGFILE=cam.log
ERRCOUNT=4
SLEEPCOUNT=4
PORT=9090


function handle {
    FILENAME="img_$(date +%Y-%m-%d-%R:%S).mpeg"
    echo "motion detect: $(date +%Y-%m-%d-%R:%S)" >> ${LOGFILE}
    cvlc 'http://192.168.1.111/videostream.cgi?user=wedens&pwd=risku123&rate=10' --sout file/ts:${FILENAME} >> ${LOGFILE} 2>&1
}

# stop the server on ctrl-c
trap exit SIGINT SIGTERM

# wait for a connection and kick off the streaming on accept
while true;
do {
    echo -e 'HTTP/1.1 200 OK\n';
} | nc -l ${PORT};

RV=$?

# only stream if the nc call was successful
if [[ "${RV}" -eq 0 ]]; then
    echo -e "start saving the stream $(date +%Y-%m-%d-%R:%S)...";

    # start the streaming and save to a file in the background
    handle &
    CPID=$!

    # wait a couple of minutes, then shut it down
    sleep 4m

    echo -e 'stopping streaming...';
    pkill -TERM -P ${CPID}
else
    # if we error out too many times, just take the hint and give up
    if [[ "${ERRCOUNT}" -eq 0 ]]; then
        exit 1
    fi
    echo "sleeping [${SLEEPCOUNT}]"
    sleep ${SLEEPCOUNT}
    ERRCOUNT=$((ERRCOUNT-1))
    SLEEPCOUNT=$((SLEEPCOUNT*2))
fi
done

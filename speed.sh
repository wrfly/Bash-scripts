#!/bin/bash
# a script to monitor interface lo's speed.
#set -x
while true
do
    before=$(ifconfig | head -n 19| tail -n 1 | cut -d ":" -f 2|cut -d " " -f 1)
    sleep 1
    after=$(ifconfig | head -n 19| tail -n 1 | cut -d ":" -f 2|cut -d " " -f 1)
    speed=$(echo $after - $before| bc)
    speed=$((speed / 1024 ))
    if [[ $speed -gt 1024 ]]; then
        unit="M"
        speed=`echo "scale=1;$speed / 1024" | bc`
    else
        unit="K"
    fi
    clear
    echo -e "\v\v\v\v\v\v\v\v"
    echo "The net speed now is:"
    echo -e "        $speed" | toilet -f future.tlf --gay
    echo -e "\t\t\t\t${unit}B/s"
done

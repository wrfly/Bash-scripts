#!/bin/bash
# a script to monitor interface lo's speed.
while true
do
    before=$(ifconfig | head -n 19| tail -n 1 | cut -d "(" -f 2|cut -d " " -f 1)
    sleep 1
    after=$(ifconfig | head -n 19| tail -n 1 | cut -d "(" -f 2|cut -d " " -f 1)
    speed=$(echo $after $before| awk '{printf "%.1f", $1 - $2}')
    clear
    echo -e "\v\v\v\v\v\v\v\v"
    echo "The net speed now is:"
    echo -e "        $speed" | toilet -f future.tlf --gay
    echo -e "\t\t\t\tM/s"
done

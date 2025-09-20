#!/bin/bash

data="/home/ubuntu/syslogs/sysscrlog/service.log"

for i in {1..3}; do

        ram=$(free -m | grep Mem | awk '{print $7}')
        cpu=$(mpstat 1 1 | grep Average | awk '{print 100 - int($12)}')
        threshould=75

        warning=98
        if [ "$cpu" -gt  "$threshould" ] || [ "$ram" -lt 200]; then
                batch=$(top -b -n 1 -o %CPU)

                echo " Batch start at $(date) " >> "${data}"
                echo " ${batch}" >> "${data}"
        fi
        echo " ${i} times $(date) "
        sleep 15
done

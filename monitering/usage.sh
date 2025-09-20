#!/bin/bash

data="/home/ubuntu/syslogs/sysscrlog/usage.log"

cpu=$(mpstat 1 1 | grep Average | awk '{print $3, $5, $12}')
mem=$(free -m | grep Mem | awk '{print $2, $3, $7}')
disk=$(df -h --total | grep total | awk '{$1=""; print $0}')
network=$(cat /proc/net/dev | grep en | awk '{print $2, $3, $10, $11}')
networkif=$(ifstat 1 1 | awk ' NR==3 ')

echo "usage: CPU: ${cpu} | Mem: ${mem} | Disk: ${disk} | Network info by /proc/net/dev : ${network} | network info by ifstat: ${networkif} | Datetime: $(date) " >> "${data}"

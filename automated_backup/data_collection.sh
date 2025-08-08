#!/bin/bash

cpu=$(mpstat 1 1 | grep Average | awk '{print $3 , $4 , $12}')

mem=$(free -m | grep Mem | awk '{print $2, $3, $7}')
swap=$(free -m | grep Swap | awk '{print $3}')
disk=$(df -h --total | grep total | awk '{print $2 , $3 , $4 , $5}')
network=$(cat /proc/net/dev | grep en | awk '{print $2, $3 , $10 , $11}')

date=$(date)

echo "Usage cpu: ${cpu} | mem: ${mem} | swap: ${swap} | disk: ${disk} | network: ${network}| date: ${date}" >> /home/ubuntu/prot1data.txt
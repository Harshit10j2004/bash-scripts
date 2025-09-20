#!/bin/bash


log="/home/ubuntu/syslogs/sysscrlog/compression.log"
loc="/home/ubuntu/temp/loctemp"
folloc="/home/ubuntu/syslogs/sysscrlog/data"

date=$(date "+%d-%m")
filename="syslogs-${date}"

servicelog="/home/ubuntu/syslogs/sysscrlog/service.log"
usagelog="/home/ubuntu/syslogs/sysscrlog/usage.log"

logs=("${servicelog}" "${usagelog}")

for i in "${logs[@]}"; do

        echo " the file $i is going to be compressed and cleaning at $(date) " >> "${log}"
        gzip -k "$i"
        mv "$i.gz" "${folloc}"
        > "$i"

done

echo " now packing the folder at $(date)" >> "${log}"

cd "/home/ubuntu/syslogs/sysscrlog" || exit
tar -cvf "${filename}".tar "data/"

echo " now moving the folder to temp at $(date) " >> "${log}"

mv "${filename}".tar "${loc}"

cd "/home/ubuntu/syslogs/sysscrlog/data" || exit

rm -f *.gz

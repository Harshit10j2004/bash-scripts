#!/bin/bash

path="/home/ubuntu/data/cpu_data.txt"
log="/home/ubuntu/logs/res_log.txt"
key="/home/ubuntu/keys/key2.pem"
rsync="/usr/bin/rsync"

ip=""
instance=""

date=$(date '+%Y-%m-%d')

loc="/home/ubuntu/scripts/automated_datasender"
file="${loc}/data_${date}.enc"

aws ec2 start-instances\
        --instance-ids "${instance}"

echo "starting the server $(date)" >> "${log}"

aws ec2 wait instance-status-ok --instance-ids "${instance}"

stat=$(aws ec2 describe-instance-status \
    --instance-ids "${instance}" \
    --query 'InstanceStatuses[*].[SystemStatus.Status,InstanceStatus.Status]' \
    --output text | tr -s '\t' ' ')


if [[ $stat == "ok ok" ]]; then



        echo "server is running $(date)" >> "${log}"

fi
openssl enc -aes-256-cbc -salt -pbkdf2 -iter 100000 -in "${path}" -out "${file}" -base64 -pass pass:Harshit@1234



count=1
max_try=12

echo "starting to testing the ssh connection $(date)" >> "${log}"

while true; do


        if ssh -i "${key}" -o StrictHostKeyChecking=accept-new ubuntu@"${ip}" 'echo ssh ready' 2>/dev/null; then



                echo "ssh is ready in ${count} time $(date)" >> "${log}"

                break

        fi

        ((count++))



        if [ $count -gt $max_try ]; then

                echo "ssh is having problem to connect $(date)" >> "${log}"
                exit 1



        fi

        sleep 10

done

echo "connection checked and its active $(date)" >> "${log}"

rsync_count=1
max_retry=5

while true; do


        "${rsync}" -avz --progress -e "ssh -i ${key} -o StrictHostKeyChecking=accept-new" "${file}" ubuntu@"${ip}":/home/ubuntu/backups

        status=$?


        if [ "$status" -eq 0 ]; then


                echo "data is transfered over server ${ip} at ${rsync_count} times $(date)" >> "${log}"
                break

        elif [ "$rsync_count" -gt "$max_retry" ]; then

                echo " Rsync cant be done after 5 retries $(date) " >> "${log}"

                break
        else
                echo "data is not transfered its try no ${rsync_count} $(date)" >> "${log}"



        ((rsync_count++))
        fi

        sleep 5
done

> "${path}"
rm -f "${file}"


echo "data is cleared as well $(date)" >> "${log}"

aws ec2 stop-instances\
        --instance-ids "${instance}"

echo "server stopped $(date)" >> "${log}"                                                                 

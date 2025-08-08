#!/bin/bash

ip="<server-private-ip>"
instanceid="<instance-id>"
logfile="<logfilelocation>"

date=$(date '+%Y%m%d_%H%M%S')

aws ec2 start-instances --instance-ids "${instanceid}"

aws ec2 wait instance-status-ok --instance-ids "${instanceid}"

data="backup_${date}.gz"

gzip -c /home/ubuntu/prot1data.txt > /home/ubuntu/"${data}"

rsync -avz -e "ssh -i /home/ubuntu/key/key1.pem -o StrictHostKeyChecking=accept-new" /home/ubuntu/"${data}" ubuntu@"${ip}":/home/ubuntu/backups

status=$?

        if [ $status -eq 0 ]; then

                echo "data sended to server" >> /home/ubuntu/logs/"${logfile}"

        else

                echo " data cant be send $(date)" >> /home/ubuntu/logs/"${logfile}"

        fi



echo "server or port is unreachable at $(date)" >>/home/ubuntu/logs/"${logfile}"

sleep 5


> /home/ubuntu/prot1data.txt

rm /home/ubuntu/"${data}"


aws ec2 stop-instances --instance-ids "${instanceid}"

echo "server stopped" >> /home/ubuntu/logs/"${logfile}"
                                                                                  
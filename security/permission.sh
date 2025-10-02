#!/bin/bash
set -x
file="/home/ubuntu/data/details.txt"


sendmessage() {

        local message="$1"

        curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
                -d chat_id="$chatid" \
                -d text="$message"
}

getupdate(){

        curl -s "https://api.telegram.org/bot$token/getUpdates"

}

response=$(getupdate)
message_text=$(echo "$response" | jq -r '.result[-1].message.text')
chatid=$(echo "$response" | jq -r '.result[-1].message.chat.id')
updateid=$(echo "$response" | jq -r '.result[-1].update_id')



echo "Received message: $message_text"


if [ "$message_text" != "null" ] && [ "$chatid" != "null" ]; then





    if [ "$message_text" == "login" ]; then


        message="Login command received. Send username ..."
        sendmessage "$message"
        echo "Login data sent"

        while true; do


            sleep 5

            newresponse=$(getupdate)
            newupdateid=$(echo "$newresponse" | jq -r '.result[-1].update_id')




            username_text=$(echo "$newresponse" | jq -r '.result[-1].message.text')

            user=$(grep -w "${username_text}" "${file}" | awk '{print $1}')



            if [ "$username_text" == "$user" ]; then



                if [ $newupdateid != $updateid ]; then


                    updateid=$newupdateid

                    sendmessage "Got username send ssh key"
                    echo " checkpoint 1"

                    while true; do

                            sleep 5

                            newres=$(getupdate)
                            newupid=$(echo "$newres" | jq -r '.result[-1].message.text')

                            sendmessage " key is $newupid "
                            echo "hitpoint x"

                            sleep 5
                    done



                fi



            else

                    sendmessage "Wrong username or user is not in system send again"
                    echo " checkpoint 1:1"



            fi


            sleep 10



        done
    elif [ "$message_text" == "logout" ]; then
        message="logout command received. removing ssh"
        sendmessage "$message"
        echo "logout"
    fi
    echo " data send "
fi



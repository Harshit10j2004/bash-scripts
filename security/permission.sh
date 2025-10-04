#!/bin/bash
set -x
file="/home/ubuntu/data/details.txt"
filepath="/home/ubuntu/data"
token=""
TMP="/home/ubuntu/temp"

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

                            file_id=$(echo "$newres" | jq -r '.result[-1].message.document.file_id // empty')
                            file_name=$(echo "$newres" | jq -r '.result[-1].message.document.file_name // empty' | tr -d "'")

                            file_info=$(curl -s "https://api.telegram.org/bot${token}/getFile?file_id=${file_id}")
                            file_path=$(echo "$file_info" | jq -r '.result.file_path // empty')

                            download_url="https://api.telegram.org/file/bot${token}/${file_path}"

                            out_tmp="${TMP}/${file_name}"

                            curl -s -o "$out_tmp" "$download_url"

                            cd "${TMP}"

                            new_file="${username_text}.pem"

                            mv "${file_name}" "${new_file}"

                            mv "${new_file}" "${filepath}"

                            cd "${filepath}"

                            sudo chmod u+x "${new_file}"

                            sleep 5

                            sendmessage " Under 15 sec you can enter to server "
                            exit 0
                    done



                fi



            else

                    sendmessage "Wrong username or user is not in system send again"
                    echo " checkpoint 1:1"



            fi


            sleep 10



        done
    elif [ "$message_text" == "logout" ]; then
        message="logout command received, enter your username"
        sendmessage "$message"
        echo "logout"

         while true; do


            sleep 5

            newresponse=$(getupdate)
            newupdateid=$(echo "$newresponse" | jq -r '.result[-1].update_id')


            username_text=$(echo "$newresponse" | jq -r '.result[-1].message.text')

            user=$(grep -w "${username_text}" "${file}" | awk '{print $1}')



            if [ "$username_text" == "$user" ]; then



                if [ $newupdateid != $updateid ]; then

                    updateid=$newupdateid

                    sshfile="${username_text}.pem"

                    cd "${filepath}"

                    if [ -f "${sshfile}" ]; then

                            rm "${sshfile}"


                            sendmessage "Ok ${username_text} after 20 sec your connection to server will end"
                            exit 0

                    else
                            sendmessage "Recheck your username and do again the protocol"

                            exit 0


                    fi

                fi
            fi
         done



    fi
    echo " data send "
fi

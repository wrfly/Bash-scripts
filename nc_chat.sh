#!/bin/bash
# A little chat progream via ncat
# Author:wrfly Date:2015.7
# Usage: 
# Server: ncat -e chat.sh -lk &
# Client: ncat server_ip

#config
db_users=user_lists
db_rooms=db_rooms
room_dir=chat_rooms

trap clean_up SIGQUIT EXIT

function clean_up
{
	if [[ -z $chat_room ]]; then
	cat bye
	exit
	else
	echo -e "\033[1;34m$msg_date\033[0m\033[1;31m $username \033[0m\
\033[1;34mleaved room\033[0m \033[1;36m \"$user_room\" \033[0m" >> $chat_room
	cat bye
	exit
fi

}

function check_lenth {
	count=$(echo $1 | wc -m)
	if [[ $count -gt $2 ]]; then
		echo "Argument too long, 40 limit."
		exit 2
	fi
}

# Welcome
cat welcome

# Login

echo -e "\033[1;36m Now, chose a username first (visitor by default): \033[0m"

	read -e username
	visitor=visitor.$RANDOM
	username=${username:-$visitor}

check_lenth "$username" 20

if [[ $username =~ ^visitor\. ]]; then
	:
	else
		echo $username >> $db_users
fi

echo -e "\033[1;36m Hi, $username! Which room do you prefer?\033[0m"
echo -e "\033[1;36m Enter a chat room(public by default): \033[0m"


# Enter_room
read -e chat_room
chat_room=${chat_room:-public}

check_lenth "$chat_room" 20

if [[ ! -z $(echo $chat_room | grep "\.\./") ]] ;then
	echo "NO way"
	chat_room=${room_dir}/"bad"
	exit 2
fi

if [[ -z $(grep ^"$chat_room"$ $db_rooms) ]]; then 
	echo -e "\033[1;36m Sorry, There is no room named \033[1;31m\"$chat_room\"\033[0m.
\033[1;36mIf you want to create a chat_room named \"$chat_room\", enter it again: \033[0m"
	try_times=0
	while true;do
	read -e chat_room_again
	check_lenth "$chat_room_again" 20
	if [[ $chat_room_again == $chat_room ]]; then
		touch ${rooms_dir}/$chat_room &> /dev/null
		echo $chat_room >> $db_rooms
		break
		else
			echo -e "\033[1;36m Not match. Try again:\033[0m"
	fi
	try_times=$((try_times+1))
	if [[ $try_times -gt 5 ]]; then
		echo -e "\033[1;31mToo many tries.\033[0m"
		exit 1
	fi
	done
fi

# Chating......
user_room=$chat_room
chat_room=${room_dir}/${chat_room}
touch $chat_room

tail -f --pid=$$ $chat_room &

msg_date=$(date +"%R:%S")
echo -e "\033[1;34m$msg_date\033[0m\033[1;31m User \"$username\" \033[0m\
\033[1;34m has came into \033[0m\033[1;36m\"$user_room\"\033[0m" >> $chat_room

while read -e msg; do
	check_lenth "$msg" 200
	if [[ $msg =~ ^: ]]; then
		case $msg in
			":help")
				echo "Help messages."
				;;
			":lists")
				echo "User lists."
				;;
			":q")
				exit
				;;
				*)
				echo "Default"
				;;
		esac
	elif [[ -z $msg ]]; then
			:
		else
			msg_date=$(date +"%R:%S")
			echo -e "\033[1;34m$msg_date\033[0m\033[1;31m $username \033[0m\
\033[1;34msaid:\033[0m \033[1;36m $msg \033[0m" >> $chat_room
	fi
	msg= #clear msg for tailf
done
#!/bin/sh

addresses=("192.168.0.100" "192.168.1.154")

if [ -z $1 ]
then
	printf "Usage: 'remote.sh SERVER_ADDRESS'.\nCurrent remotes status:\n"
	
	for str in ${addresses[@]}; do
		isActive="$(query user /SERVER:$str | grep Active)"
		if [ -z "$isActive" ]
		then
			printf "$str available\n"
		else
			printf "$str used:\n$isActive\n"
		fi
	done

else
	while [ ! -z "$(query user /SERVER:$1 | grep Active)" ]
	do
		printf "Remote in use, connected devices:\n$(query user /SERVER:$1)\n\n"
		sleep 1
	done

	printf "Remote available, connecting\n"
	mstsc -console -v:$1 &
	disown
fi


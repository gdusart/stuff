#!/bin/bash
set -e
set -u
#set -o xtrace

DEST_HOSTS=("seedhost"  "autumnleaf")

DATE=`date +%Y%m%d%H%M%S`
BACKUP_FOLDER="/data/backup"
BACKUP_FILE=$BACKUP_FOLDER"/home_greg-"$DATE".tar.gz"

tar -zcf "$BACKUP_FILE" /home/greg
echo "File saved under $BACKUP_FILE"

#SEND FILES USING SSH
BACKUP_FOLDER="~/backup/"$HOSTNAME

#Allow errors
set +e

for host in "${DEST_HOSTS[@]}"
do
	printf "Sending data to %s... " $host

 	ssh $host "mkdir -p $BACKUP_FOLDER" && \
	scp -r "$BACKUP_FILE" "$host:$BACKUP_FOLDER/" 1>/dev/null 

	if [ $? -eq 0 ]; then
	  echo "OK"
	else
	  echo "NOK"
	fi

done

set -e

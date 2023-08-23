#! /bin/bash
set -e

NAME="$1"
OPTIONS='replica 3'
TRANSPORT='tcp'
PATH='/mnt/raid1/gluster'
declare -a SERVERS=("zima1.elementohq" "zima2.elementohq" "zima3.elementohq")

SERVERS_STRING=""
for i in "${SERVERS[@]}"
do
   if [ $i == $(hostname) ]
   then
      echo "$i is localhost"
      sudo mkdir -p "$PATH"
   else
      if [ "`/usr/bin/ping -c 1 $i`" ]
      then
        echo "$i is available"
      else
        echo "$i is unreachable. Aborting."
        exit 1
      fi
      /usr/bin/ssh $USER@$i -t "sudo mkdir -p $PATH"
   fi
   SERVERS_STRING="$SERVERS_STRING $i$PATH"
done

GLUSTER_CMD="sudo gluster volume create $NAME $OPTIONS transport $TRANSPORT $SERVERS_STRING"

"$GLUSTER_CMD"

exit 0

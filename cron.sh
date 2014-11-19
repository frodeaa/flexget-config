#!/bin/bash

FILE="${HOME}/.flexget/.config-lock"
LOG="${HOME}/.flexget/cron.log"

F=$(pidof -s -x flexget)

if [ $F ]; then
  kill $F
  echo "flexget was still running... so killed it..." >> $LOG
fi

if [ -f $FILE ]; then
  echo "lock file was there. so deleting lock file..." >> $LOG
  rm -f $FILE
fi

D=$(date)
echo "$D - running flexget cron now..." >> $LOG
echo " "
/usr/local/bin/flexget execute --tasks tv-*

echo "cleanup finished downloads $(transmission-remote --list | grep 100% | grep Done | awk '{print $1}'|wc --lines)"
transmission-remote --list | grep 100% | grep Done | awk '{print $1}' | xargs --max-args 1 --replace=% transmission-remote --torrent '%' --remove

exit 0


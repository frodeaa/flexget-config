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
/usr/local/bin/flexget --cron

exit 0


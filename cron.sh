#!/usr/bin/env bash

FILE="${HOME}/.flexget/.config-lock"
LOG_PATH="${HOME}/.flexget/logs"
LOG="${LOG_PATH}/cron.log"
FLEX_LOG="${LOG_PATH}/flexget.log"

mkdir -p $LOG_PATH

F=$(pidof -s -x flexget)

if [ $F ]; then
  kill $F
  echo "$(date) - flexget was still running... so killed it..." >> $LOG
fi

if [ -f $FILE ]; then
  echo "$(date) - lock file was there. so deleting lock file..." >> $LOG
  rm -f $FILE
fi

echo "$(date) - running flexget cron now..." >> $LOG
echo " "

/usr/local/bin/flexget --logfile $FLEX_LOG execute --tasks tv-* > /dev/null 2>&1

C=$(transmission-remote --list | grep 100% | grep Done | awk '{print $1}'|wc --lines)
echo "$(date) - cleanup finished downloads, found $C" >> $LOG
transmission-remote --list | grep 100% | grep Done | awk '{print $1}' | xargs --max-args 1 --replace=% transmission-remote --torrent '%' --remove

# PATH where downloads are saved
DOWNLOADS=$(grep -Eo "path:..(.*)" ${HOME}/.flexget/secrets.yml | cut -d: -f2 | tr -d ' ')

echo "$(date) Check old downloads in ${DOWNLOADS}" >> $LOG ;
echo "$(date) - remove old download files, found $(find $DOWNLOADS -maxdepth 1 -type f -mtime +7 -print|wc --lines)" >> $LOG ;
find "$DOWNLOADS" -maxdepth 1 -type f -mtime +7 -exec rm {} \;

echo "$(date) - remove old downloads directories, found $(find $DOWNLOADS -maxdepth 1 -type d -mtime +7 -print|wc --lines)" >> $LOG ;
find "$DOWNLOADS" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;

exit 0


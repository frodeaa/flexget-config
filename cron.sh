
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

D=$(date)
C=$(transmission-remote --list | grep 100% | grep Done | awk '{print $1}'|wc --lines)
echo "$D - cleanup finished downloads, found $C" >> $LOG
transmission-remote --list | grep 100% | grep Done | awk '{print $1}' | xargs --max-args 1 --replace=% transmission-remote --torrent '%' --remove

# PATH where downloads are saved
DOWNLOADS=$(grep -Eo "path:..(.*)" config.yml |cut -d: -f2 | tr -d ' ')

D=$(date)
C=$(find $DOWNLOADS -maxdepth 1 -type f -mtime +7 -print|wc --lines)
echo "$D - remove old download files, found $C" >> $LOG ;
find "$DOWNLOADS" -maxdepth 1 -type f -mtime +7 -print -exec rm {} \;

D=$(date)
C=$(find $DOWNLOADS -maxdepth 1 -type d -mtime +7 -print|wc --lines)
echo "$D - remove old downloads directories, found $C" >> $LOG ;
find "$DOWNLOADS" -maxdepth 1 -type d -mtime +7 -print -exec rm -rf {} \;

exit 0


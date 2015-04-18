#!/usr/bin/env bash

ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
FILE="${ROOT}/.config-lock"
LOG_PATH="${ROOT}/logs"
FLEX_LOG="${LOG_PATH}/flexget.log"

mkdir -p $LOG_PATH

function log_msg() {
    echo "$(date) - $@" >> "${LOG_PATH}/cron.log"
}

F=$(pidof flexget | head -n 1)

if [ $F ]; then
  kill $F
  log_msg "flexget was still running... so killed it..."
fi

if [ -f $FILE ]; then
  log_msg "lock file was there. so deleting lock file..."
  rm -f $FILE
fi

log_msg "running flexget cron now..."

/usr/local/bin/flexget --logfile $FLEX_LOG execute --tasks tv-* > /dev/null 2>&1

C=$(transmission-remote --list | grep 100% | grep Done | awk '{print $1}'|wc -l)
log_msg "cleanup finished downloads, found $C"

transmission-remote --list | grep 100% | grep Done | awk '{print $1}'\
    | xargs --max-args 1 --replace=% transmission-remote --torrent '%' --remove

# PATH where downloads are saved
DOWNLOADS=$(grep -Eo "path:..(.*)" ${ROOT}/secrets.yml | cut -d: -f2 | tr -d ' ')

function count_old() {
    local ft="$1"
    find $DOWNLOADS -maxdepth 1 -type $ft -mtime +7 -print|wc -l)
}

log_msg "Check old downloads in ${DOWNLOADS}"

log_msg "remove old download files, found $(count_old f)"
find "$DOWNLOADS" -maxdepth 1 -type f -mtime +7 -exec rm {} \;

log_msg"remove old downloads directories, found $(count_old d)"
find "$DOWNLOADS" -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \;

exit 0


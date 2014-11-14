flexget-config
==============

configuration for FlexGet

## install

    pip install flexget
    pip install transmissionrpc
    git clone git@github.com:frodeaa/flexget-config.git ~/.flexget
    git remote set-url --push origin no_push #avoid sharing secrets

## configure

See http://flexget.com/wiki for more information

## schedule

add cron.sh to crontab

    crontab -e
    0/30 * * * * /home/pi/.flexget/cron.sh





flexget-config
==============

configuration for FlexGet

## install

    pip install flexget
    pip install transmissionrpc
    git clone git@github.com:frodeaa/flexget-config.git ~/.flexget

## configure

    cp secretfile_template.yml secretfile.yml # edit the secrets

See http://flexget.com/wiki for more information

## schedule

add cron.sh to crontab

    crontab -e
    0/30 * * * * /home/pi/.flexget/cron.sh





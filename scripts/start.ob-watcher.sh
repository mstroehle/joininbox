#!/bin/bash

#install dependency
. /home/joinmarket/joinmarket-clientserver/jmvenv/bin/activate

echo "installing matplotlib"
pip install matplotlib

SCRIPT="ob-watcher"

sudo systemctl stop $SCRIPT
sudo systemctl disable $SCRIPT 2>/dev/null
sleep 5

echo "
[Unit]
Description=$SCRIPT

[Service]
WorkingDirectory=/home/joinmarket/joinmarket-clientserver/scripts/obwatch
ExecStart=/bin/sh -c \
'. /home/joinmarket/joinmarket-clientserver/jmvenv/bin/activate && \
python ob-watcher.py'
User=joinmarket
Group=joinmarket
Type=simple
KillMode=process
TimeoutSec=600
Restart=no

[Install]
WantedBy=multi-user.target
" | sudo tee /etc/systemd/system/$SCRIPT.service 1>/dev/null
sudo systemctl enable $SCRIPT 2>/dev/null
sudo systemctl start $SCRIPT

#create Hidden Service
/home/joinmarket/install.hiddenservice.sh ob-watcher 80 62601
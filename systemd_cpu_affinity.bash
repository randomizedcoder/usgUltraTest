#!/usr/bin/bash

echo "CPUAffinity=4-7" >> /etc/systemd/system.conf
echo "CPUAffinity=4-7" >> /etc/systemd/user.conf

systemctl daemon-reload

reboot
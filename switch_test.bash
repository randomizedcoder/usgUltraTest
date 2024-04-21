#!/usr/bin/bash

# git@github.com:randomizedcoder/usgUltraTest.git

# used pip
# add-apt-repository ppa:tohojo/flent
# apt update

apt install python3-pip
pip install flent

apt install --yes iperf fping netperf ethtool cpufrequtils
# don't install ping, or it stuffs up flent
apt remove --yes iputils-ping

systemctl disable multipathd.service
systemctl stop multipathd.service

systemctl disable ModemManager.service
systemctl stop ModemManager.service

systemctl disable wpa_supplicant.service
systemctl stop wpa_supplicant.service

systemctl disable netperf.service
systemctl stop netperf.service

echo GOVERNOR="performance" > /etc/default/cpufrequtils

sysctl -w net.ipv4.ip_local_port_range="1025 65534"

ip netns add blue
ip netns add red

ip link set dev enp1s0f0 netns blue
ip link set dev enp1s0f1 netns red

ip netns exec blue ip addr add 10.0.0.0/31 dev enp1s0f0
ip netns exec blue ip link set dev enp1s0f0 up
#ip link set dev enp1s0f0 mtu 9000
#ip netns exec network"${namespace}" ip route add 0.0.0.0/0 via

ip netns exec blue ethtool --set-ring enp1s0f0 rx 8192 tx 8192
ip netns exec blue ethtool -g enp1s0f0
ip netns exec red ethtool --set-ring enp1s0f1 rx 8192 tx 8192
ip netns exec red ethtool -g enp1s0f1

ip netns exec red ip addr add 10.0.0.1/31 dev enp1s0f1
ip netns exec red ip link set dev enp1s0f1 up

#---- sysctls start
ip netns exec blue sysctl -w net.ipv4.ip_local_port_range="1025 65534"
ip netns exec red sysctl -w net.ipv4.ip_local_port_range="1025 65534"

ip netns exec blue sysctl -w net.ipv4.tcp_rmem="4096    1000000    16000000"
ip netns exec red sysctl -w net.ipv4.tcp_rmem="4096    1000000    16000000"

ip netns exec blue sysctl -w net.ipv4.tcp_timestamps=1
ip netns exec red sysctl -w net.ipv4.tcp_timestamps=1

ip netns exec blue sysctl -w net.ipv4.tcp_fin_timeout=10
ip netns exec red sysctl -w net.ipv4.tcp_fin_timeout=10
#---- sysctls end

ip netns exec blue ip link
ip netns exec blue ip route

ip netns exec red ip link
ip netns exec red ip route

ip netns exec blue /usr/bin/netserver -4 -f

# https://flent.org/intro.html#quick-start
ip netns exec red /usr/local/bin/flent rrul \
    --host=10.0.0.0 \
    --length=600 \
    --socket-stats \
    --output=flent_test_output \
    --data-dir=./tests_outputs/

# set interfaces ge-0/0/8 mtu 9216
# set interfaces ge-0/0/8 unit 0 family ethernet-switching port-mode access
# set interfaces ge-0/0/8 unit 0 family ethernet-switching vlan members flent

# set interfaces ge-0/0/10 mtu 9216
# set interfaces ge-0/0/10 unit 0 family ethernet-switching port-mode access
# set interfaces ge-0/0/10 unit 0 family ethernet-switching vlan members flent

# https://github.com/tohojo/flent
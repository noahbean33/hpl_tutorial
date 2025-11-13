#!/usr/bin/env bash
set -e

sudo echo 'net.core.default_qdisc=fq' >> sudo /etc/sysctl.conf
sudo echo 'net.ipv4.tcp_congestion_control=bbr' >> sudo /etc/sysctl.conf
sudo sysctl -p

sudo sysctl net.core.rmem_max >> default_network.txt
sudo sysctl -w net.core.rmem_max=536870912

sudo sysctl net.core.wmem_max >> default_network.txt
sudo sysctl -w net.core.wmem_max=536870912 

sudo sysctl net.ipv4.tcp_rmem >> default_network.txt
sudo sysctl -w net.ipv4.tcp_rmem='4096 87380 268435456'

sudo sysctl net.ipv4.tcp_wmem >> default_network.txt
sudo sysctl -w net.ipv4.tcp_wmem='4096 87380 268435456'

sudo sysctl net.ipv4.tcp_mem >> default_network.txt
sudo sysctl -w net.ipv4.tcp_mem='268435456 268435456 268435456'

sudo sysctl net.ipv4.tcp_max_tw_buckets >> default_network.txt
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=450000

sudo sysctl net.ipv4.tcp_low_latency >> default_network.txt
sudo sysctl -w net.ipv4.tcp_low_latency=1

sudo sysctl net.ipv4.tcp_fin_timeout >> default_network.txt
sudo sysctl -w net.ipv4.tcp_fin_timeout=10

sudo sysctl net.core.netdev_max_backlog >> default_network.txt
sudo sysctl -w net.core.netdev_max_backlog=30000

sudo sysctl net.core.netdev_budget >> default_network.txt
sudo sysctl -w net.core.netdev_budget=600

sudo sysctl net.core.netdev_budget_usecs >> default_network.txt
sudo sysctl -w net.core.netdev_budget_usecs=4000

sudo sysctl net.ipv4.tcp_no_metrics_save >> default_network.txt
sudo sysctl -w net.ipv4.tcp_no_metrics_save=1

sudo sysctl net.ipv4.tcp_mtu_probing >> default_network.txt
sudo sysctl -w net.ipv4.tcp_mtu_probing=1

sudo /sbin/tc qdisc edit dev eth0 root fq maxrate 10gbit 

sudo sysctl -w net.core.rmem_max=212992
sudo sysctl -w net.core.wmem_max=212992
sudo sysctl -w net.ipv4.tcp_rmem='4096        131072  6291456'
sudo sysctl -w net.ipv4.tcp_wmem='4096        16384   4194304'
sudo sysctl -w net.ipv4.tcp_mem='1497753      1997005 2995506'
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=262144
sudo sysctl -w net.ipv4.tcp_low_latency=0
sudo sysctl -w net.ipv4.tcp_fin_timeout=60
sudo sysctl -w net.core.netdev_max_backlog=1000
sudo sysctl -w net.core.netdev_budget=300
sudo sysctl -w net.core.netdev_max_backlog=30000
sudo sysctl -w net.ipv4.tcp_no_metrics_save=0
sudo sysctl -w net.ipv4.tcp_mtu_probing=0
sudo sysctl -w net.core.rmem_max=212992
sudo sysctl -w net.core.wmem_max=212992
sudo sysctl -w net.ipv4.tcp_rmem='4096        131072  6291456'
sudo sysctl -w net.ipv4.tcp_wmem='4096        16384   4194304'
sudo sysctl -w net.ipv4.tcp_mem='1497753      1997005 2995506'
sudo sysctl -w net.ipv4.tcp_max_tw_buckets=262144
sudo sysctl -w net.ipv4.tcp_low_latency=0
sudo sysctl -w net.ipv4.tcp_fin_timeout=60
sudo sysctl -w net.core.netdev_max_backlog=1000
sudo sysctl -w net.core.netdev_budget=300
sudo sysctl -w net.core.netdev_budget_usecs=2000
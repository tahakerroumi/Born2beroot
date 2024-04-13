#!/bin/sh

# architecture
arch=$(uname -a)

# CPU physical
CPU=$(lscpu | grep "Socket(s)" | awk '{print $2}')

# virtual CPU
vCPU=$(lscpu | grep "CPU(s)" | awk '{print $2; exit}')

#RAM
total=$(free -m | awk '$1 == "Mem:" {print $2}')
usage=$(free -m | awk '$1 == "Mem:" {print $3}')
cal=$(free -m | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

#disk
total_disk=$(df -h --total | awk '$1 == "total" {sub("G","",$2)}; END {print $2}')
usage_disk=$(df -m --total |awk '$1 == "total" {print $3}')
percent_disk=$(df -h --total | awk '$1 == "total" {print $5}')

#cpu load
cpul=$(mpstat | awk '$3 == "all" {print 100 - $NF}')

#LAST BOOT
lb=$(who -b | awk '$1 == "system" {print $3 " " $4}')

#LVM
lvm=$(if lsblk | grep -q "lvm"; then 
		echo "Yes"
	else
		echo "No";fi)

#tcp connections
TCP=$(ss -ta | grep "ESTAB" | wc -l)

#USER LOG
ulog=$(users | wc -w)

#NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{print $2}')

#SUDO
cmnd=$(cat /var/log/sudo/sudo_config | grep "COMM" |wc -l)

wall "	Architecture: $arch
	CPU physical: $CPU
	vCPU: $vCPU
	Memory Usage: $usage/$total"MB" ($cal"%")
	Disk Usage: $usage_disk/${total_disk}"Gb" ($percent_disk)
	CPU load: $cpul"%"
	Last boot: $lb
	LVM use: $lvm
	Connections TCP: $TCP
	User log: $ulog
	Network: IP $ip ($mac)
	Sudo:$cmnd cmd"

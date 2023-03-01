#!/bin/bash

echo "HOSTNAME = $(hostname)"

sudo timedatectl set-timezone Asia/Novosibirsk
echo "TIMEZONE = $(timedatectl | awk '/Time zone/{print $3}') $(date | awk '{print "UTC " $7}')"
echo "USER = $USER"
echo "OS = $(awk '{print $1}' /etc/issue) $(awk '{print $2}' /etc/issue) $(awk '{print $3}' /etc/issue)"
echo "DATE = $(date | awk '{print $2,$3,$4,$5}')"

echo "UPTIME = $(uptime -p | awk '{print $2,$3,$4,$5}')"
echo "UPTIME_SEC = $(awk '{print $1}' /proc/uptime)"

echo "IP = $(ifconfig | awk '/inet/{print $2}' | head -n 1)"
echo "MASK = $(ifconfig | awk '/inet/{print $4}' | head -n 1 | awk -F. '{printf "%03d.%03d.%03d.%03d", $1,$2,$3,$4}')"
echo "GATEWAY = $(ip r | awk '/default via/{print $3}')"

echo "RAM_TOTAL = $(free -h | awk '/Mem/{printf "%.3f GB", $2/1024}')"
echo "RAM_USED = $(free -h | awk '/Mem/{printf "%.3f GB", $3/1024}')"
echo "RAM_FREE = $(free -h | awk '/Mem/{printf "%.3f GB", $4/1024}')"

echo "SPACE_ROOT = $(df /root | awk '/\//{printf "%.2f MB", $2/1024}')"
echo "SPACE_ROOT_USED = $(df /root | awk '/\//{printf "%.2f MB", $3/1024}')"
echo "SPACE_ROOT_FREE = $(df /root | awk '/\//{printf "%.2f MB", $4/1024}')"
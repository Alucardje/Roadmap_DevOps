#!/bin/bash
# -- ENCODING: UTF-8 --
# Script to analyse basic server performance stats

echo "Server Performance Stats"

# Total CPU usage
echo "Total CPU Usage:"
top -bn1 | grep "Cpu(s)" | \
sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
awk '{print 100 - $1"%"}'

# Total memory usage
echo "Total Memory Usage:"
free -m | awk 'NR==2{printf "Used: %sMB (%.2f%%)\tFree: %sMB (%.2f%%)\n", $3, $3*100/$2, $4, $4*100/$2}'

# Total disk usage
echo "Total Disk Usage:"
df -h | awk '$NF=="/"{printf "Used: %dGB (%.2f%%)\tFree: %dGB (%.2f%%)\n", $3, $3*100/($3+$4), $4, $4*100/($3+$4)}'

# Top 5 processes by CPU usage
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6

# Top 5 processes by memory usage
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

# Optional stats
echo "OS Version:"
lsb_release -a

echo "Uptime:"
uptime -p

echo "Load Average:"
uptime | awk -F 'load average:' '{ print $2 }'

echo "Logged in Users:"
who

echo "Failed Login Attempts:"
grep "Failed password" /var/log/auth.log | wc -l

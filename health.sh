#!/bin/bash
# A basic health check script

echo "===================="
echo "SERVER HEALTH REPORT"
echo "Generated: $(date)"
echo "===================="

# Uptime
echo -e "\n--- Uptime ---"
uptime

# CPU usage
echo -e "\n--- CPU Load ---"
top -bn1 | grep "load average" | awk '{print $(NF-2), $(NF-1), $NF}'

# Memory usage
echo -e "\n--- Memory Usage ---"
free -h

# Disk usage
echo -e "\n--- Disk Usage ---"
df -h --total | grep total

# Top 5 processes by memory usage
echo -e "\n--- Top 5 Memory-Consuming Processes ---"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6

# Network info
echo -e "\n--- Network Interfaces ---"
ip -brief addr show

echo -e "\nReport complete."

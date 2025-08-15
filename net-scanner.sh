#!/bin/bash
# check which IP addresses are active in a given IP range 

if [ -z "$1" ]; then
    echo "Usage: $0 <base-ip> <start-range> <end-range> [--preserve]"
    echo "Example: $0 192.168.1 1 254 --preserve"
    exit 1
fi

base_ip=$1
start=${2:-1}
end=${3:-254}
save_progress=false
progress_file=".scan_progress"


# Check if user wants to perseve position if scan is canceled
if [[ "$4" == "--preserve" ]]; then
    save_progress=true
fi

# Resume only if preserving is enabled and file exists
if $save_progress && [ -f "$progress_file" ]; then
    start=$(cat "$progress_file")
    echo "Resuming scan from $base_ip.$start..."
fi

for i in $(seq $start $end); do
    current=$i
    ip="$base_ip.$i"
    ping -c 1 -W 1 "$ip"  &> /dev/null && echo "$ip is up"

    # Trap for Ctrl+C only if preserving is enabled
    if $save_progress; then
        trap "echo $current > $progress_file; echo -e '\nScan stopped. Progress saved.'; exit 0" SIGINT
    else
        trap "echo -e '\nScan stopped.'; exit 0" SIGINT
    fi

done

# Cleanup progress file if preserving is enabled
if $save_progress; then
    rm -f "$progress_file"
    echo "Scan completed. Progress file removed."
else
    echo "Scan completed."
fi

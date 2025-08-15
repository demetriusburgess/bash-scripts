#!/bin/bash
# Basic DNS record check script

# Check if a domain was provided
if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

DOMAIN=$1

echo "Checking DNS records for $DOMAIN"
echo "--------------------------------"

types=("A" "AAAA" "CNAME" "MX" "TXT" "NS")

for type in "${types[@]}"; do
    echo ""
    echo "$type Records:"
    dig +short $type $DOMAIN | sed 's/^/  /' || echo "  (none found)"
done

#!/bin/bash
# WP Dowload, Config, & Deploy script 

# CONFIG
TMP_DIR="/tmp/wp_download"
WP_ZIP="latest.zip"

# FUNCTIONS
prompt() {
    read -rp "$1: " "$2"
}

# GET USER INPUT
prompt "Enter remote SSH user" REMOTE_USER
prompt "Enter remote host" REMOTE_HOST
prompt "Enter remote destination path" REMOTE_PATH

# CREATE TEMP DIR
mkdir -p "$TMP_DIR"
cd "$TMP_DIR" || exit 1

# DOWNLOAD LATEST WORDPRESS
echo "Downloading latest WordPress..."
curl -O https://wordpress.org/latest.zip
if [ ! -f "$WP_ZIP" ]; then
    echo "Failed to download WordPress."
    exit 1
fi

# UNZIP
unzip -q "$WP_ZIP" -d "$TMP_DIR"

# WordPress files will be in $TMP_DIR/wordpress
WP_DIR="$TMP_DIR/wordpress"

# PROMPT FOR WP-CONFIG SETTINGS
echo "Now let's configure wp-config.php"
prompt "Enter DB Name" DB_NAME
prompt "Enter DB User" DB_USER
prompt "Enter DB Password" DB_PASS
prompt "Enter DB Host (default: localhost)" DB_HOST
DB_HOST=${DB_HOST:-localhost}

# Copy sample config
cp "$WP_DIR/wp-config-sample.php" "$WP_DIR/wp-config.php"

# Replace values
sed -i "s/database_name_here/$DB_NAME/" "$WP_DIR/wp-config.php"
sed -i "s/username_here/$DB_USER/" "$WP_DIR/wp-config.php"
sed -i "s/password_here/$DB_PASS/" "$WP_DIR/wp-config.php"
sed -i "s/localhost/$DB_HOST/" "$WP_DIR/wp-config.php"

# UPLOAD TO REMOTE
echo "Uploading WordPress files to remote server..."
scp -r "$WP_DIR"/* "${REMOTE_USER}@${REMOTE_HOST}:$REMOTE_PATH"

if [ $? -eq 0 ]; then
    echo "WordPress uploaded successfully!"
else
    echo "Upload failed."
    exit 1
fi

# CLEANUP
rm -rf "$TMP_DIR"
echo "Temporary files cleaned up."

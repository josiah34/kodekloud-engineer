#!/bin/bash

BACKUP_DIR="/var/www/html/official"
ARCHIVE_NAME="/backup/xfusioncorp_official.zip"
REMOTE_HOST="stbkp01"
REMOTE_USER="clint"
REMOTE_DIR="/backup/"

echo "Creating backup of $BACKUP_DIR to $BACKUP_PATH"


zip -r  "$ARCHIVE_NAME" "$BACKUP_DIR"

echo "Uploading backup to $REMOTE_HOST"

scp "$ARCHIVE_NAME" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

if [ $? -eq 0 ]; then
    echo "Backup successful"
    exit 0
else
    echo "Backup failed"
    exit 1
fi
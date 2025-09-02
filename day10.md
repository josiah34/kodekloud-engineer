### Task Description
The production support team of xFusionCorp Industries is working on developing some bash scripts to automate different day to day tasks. One is to create a bash script for taking websites backup. They have a static website running on App Server 1 in Stratos Datacenter, and they need to create a bash script named official_backup.sh which should accomplish the following tasks. (Also remember to place the script under /scripts directory on App Server 1).



a. Create a zip archive named xfusioncorp_official.zip of /var/www/html/official directory.


b. Save the archive in /backup/ on App Server 1. This is a temporary storage, as backups from this location will be clean on weekly basis. Therefore, we also need to save this backup archive on Nautilus Backup Server.


c. Copy the created archive to Nautilus Backup Server server in /backup/ location.


d. Please make sure script won't ask for password while copying the archive file. Additionally, the respective server user (for example, tony in case of App Server 1) must be able to run it.


e. Do not use sudo inside the script.

Note:
The zip package must be installed on given App Server before executing the script. This package is essential for creating the zip archive of the website files. Install it manually outside the script.

### Solution 

<u><b>Commands to run before executing the script:</b></u>

```
# SSH into stapp01 server as tony user
ssh tony@stapp01

# Install zip package
sudo yum install zip -y

# Generate an ssh key 
 ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_ed25519

 # Copy the public key to stbkp01 server
 ssh-copy-id clint@stbkp01


```

<details>
<summary>Bash Script</summary>

```
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


```
</details>
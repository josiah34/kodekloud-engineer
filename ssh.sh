#!/bin/bash

HOSTS=(stapp01 stapp02 stapp03)
USERNAMES=(tony steve banner)

# Add SSH key to all hosts
for i in "${!HOSTS[@]}"; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub "${USERNAMES[$i]}@${HOSTS[$i]}"
done
#!/bin/bash

# Simple script to setup ansible and configure it to simplify tasks with KodeKloud Engineer multihost tasks

inventory="
[nautilus_app_servers]
stapp01 ansible_user=tony   ansible_password=Ir0nM@n   ansible_become_password=Ir0nM@n
stapp02 ansible_user=steve  ansible_password=Am3ric@   ansible_become_password=Am3ric@
stapp03 ansible_user=banner ansible_password=BigGr33n  ansible_become_password=BigGr33n

[nautilus_db_servers]
stdb01 ansible_user=peter   ansible_password=Sp!dy  ansible_become_password=Sp!dy
"

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi


echo "Installing ansible"

sudo yum install ansible -y

if [ $? -eq 0 ]; then
    echo "Ansible installed successfully"
else
    echo "Failed to install ansible"
fi


# Get ssh keys from other servers

ssh-keyscan -H stapp01 stapp02 stapp03 stdb01 | tee -a /home/thor/.ssh/known_hosts /root/.ssh/known_hosts > /dev/null



# Create inventory file

echo "$inventory" > /etc/ansible/hosts


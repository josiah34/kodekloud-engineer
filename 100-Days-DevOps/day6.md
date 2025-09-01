### Task Description

The Nautilus system admins team has prepared scripts to automate several day-to-day tasks. They want them to be deployed on all app servers in Stratos DC on a set schedule. Before that they need to test similar functionality with a sample cron job. Therefore, perform the steps below:



a. Install cronie package on all Nautilus app servers and start crond service.


b. Add a cron */5 * * * * echo hello > /tmp/cron_text for root user.


### Solution


- I had a few issues with this one. The sandbox was limited and the parallel execution of the tasks was causing the script to fail. I had to use -f1 of ansible-playbook to run the playbook sequentially.

```

---
- name: Setup cron job on Nautilus app servers
  hosts: all
  become: true   

  tasks:
    - name: Ensure cronie package is installed
      yum:
        name: cronie
        state: present
        update_cache: no

    - name: Ensure crond service is enabled and running
      service:
        name: crond
        state: started
        enabled: yes

    - name: Add cron job for root user
      cron:
        name: "Echo hello every 5 minutes"
        minute: "*/5"
        job: "echo hello > /tmp/cron_text"
        user: root



### Ansible playbook command 

ansible-playbook cron.yml -f 1

```
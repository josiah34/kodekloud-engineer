### Task Decription

Following security audits, the xFusionCorp Industries security team has rolled out new protocols, including the restriction of direct root SSH login.



Your task is to disable direct SSH root login on all app servers within the Stratos Datacenter.



### Solution

- Ansible Playbook to disable root login on all App Servers in Stratos Datacenter
```
---
 - name: Disable Root Login
   hosts: all
   become: true
   gather_facts: yes


   tasks:
   - name: Disable Root Login
     lineinfile:
           dest: /etc/ssh/sshd_config
           regexp: '^PermitRootLogin'
           line: "PermitRootLogin no"
           state: present
     notify:
       - restart sshd

   handlers:
   - name: restart sshd
     service:
       name: sshd
       state: restarted


```

- Check that root login is disabled on all App Servers in Stratos Datacenter

```
ansible all -b -m shell -a "cat /etc/ssh/sshd_config | grep PermitRootLogin"

```
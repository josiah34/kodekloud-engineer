### Task Description

We have one of our websites up and running on our Nautilus infrastructure in Stratos DC. Our security team has raised a concern that right now Apache’s port i.e 8086 is open for all since there is no firewall installed on these hosts. So we have decided to add some security layer for these hosts and after discussions and recommendations we have come up with the following requirements:



1. Install iptables and all its dependencies on each app host.


2. Block incoming port 8086 on all apps for everyone except for LBR host.


3. Make sure the rules remain, even after system reboot.

<hr>

### Task Solution

- From jump host I will install and setup ansible using my ansible-setup.sh script

- Afterwards I will run the below ansible playbook to install iptables and set the required rules

<details> <summary>Ansible Playbook</summary>

```

---
- name: Configure iptables firewall on Nautilus app servers
  hosts: nautilus_app_servers
  become: yes
  gather_facts: no
  vars:
    # IP of the Load Balancer
    lbr_ip: 172.16.238.14

  tasks:
    - name: Ensure iptables and dependencies are installed
      yum:
        name:
          - iptables
          - iptables-services
        state: present

    - name: Flush existing iptables rules
      command: iptables -F

    - name: Allow loopback interface
      command: iptables -A INPUT -i lo -j ACCEPT

    - name: Allow established and related connections
      command: iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    - name: Allow SSH access on port 22
      command: iptables -A INPUT -p tcp --dport 22 -j ACCEPT

    - name: Allow Apache port 8086 from LBR host only
      command: iptables -A INPUT -p tcp -s {{ lbr_ip }} --dport 8086 -j ACCEPT

    - name: Drop all other traffic to port 8086
      command: iptables -A INPUT -p tcp --dport 8086 -j DROP

    - name: Drop everything else (for strict security)
      command: iptables -A INPUT -j DROP

    - name: Save iptables rules persistently
      command: service iptables save

    - name: Enable and start iptables service
      service:
        name: iptables
        enabled: yes
        state: started





```

</details>


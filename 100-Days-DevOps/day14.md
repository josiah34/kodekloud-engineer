### Task Description
The production support team of xFusionCorp Industries has deployed some of the latest monitoring tools to keep an eye on every service, application, etc. running on the systems. One of the monitoring systems reported about Apache service unavailability on one of the app servers in Stratos DC.



Identify the faulty app host and fix the issue. Make sure Apache service is up and running on all app hosts. They might not have hosted any code yet on these servers, so you don’t need to worry if Apache isn’t serving any pages. Just make sure the service is up and running. Also, make sure Apache is running on port 8082 on all app servers.

<hr>

### Task Solution

- To start I will install and setup ansible using my ansible-setup.sh script

- Afterwards I ran an ansible playbook which checks if apache is running on port 8082 on all app servers. If not it will try to start the service. 

- It is running on all app servers except stapp01 and when I attempted to start it in the playbook it failed. 

```
TASK [Start service if not running] *******************************************************************************************************************************************
fatal: [stapp01]: FAILED! => {"changed": false, "msg": "Unable to start service httpd: Job for httpd.service failed because the control process exited with error code. See \"systemctl status httpd.service\" and \"journalctl -xe\" for details.\n"}
```

- I ssh into stapp01 and checked the status of the service. As shown below something is running on port 8082.

```
 httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Mon 2025-10-13 20:25:54 UTC; 1min 5s ago
     Docs: man:httpd(8)
           man:apachectl(8)
  Process: 1706 ExecStop=/bin/kill -WINCH ${MAINPID} (code=exited, status=1/FAILURE)
  Process: 1705 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 1705 (code=exited, status=1/FAILURE)

Oct 13 20:25:54 stapp01.stratos.xfusioncorp.com httpd[1705]: AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using stapp01.stratos.xfusioncorp.com. Set...this message
Oct 13 20:25:54 stapp01.stratos.xfusioncorp.com httpd[1705]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:8082

```
- Using ss command I checked which process is running on port 8082. It's sendmail service. As it is not needed in this task I will stop it and then disable it. 

``sudo systemctl stop sendmail`` and ``sudo systemctl disable sendmail``

```
[tony@stapp01 ~]$ sudo ss -tulnp | grep :8082
tcp    LISTEN     0      10     127.0.0.1:8082                  *:*                   users:(("sendmail",pid=791,fd=4))
```

- Afterward I rerun my ansible playbook which succesfully starts apache service on all app servers including stapp01.


<details> <summary>Ansible Playbook</summary>

```
---
- name: Ensure service is running and listening on specific port
  hosts: nautilus_app_servers
  become: yes
  vars:
    service_name: httpd
    service_port: 8086

  tasks:
    - name: Check if {{ service_name }} service is running
      ansible.builtin.systemd:
        name: "{{ service_name }}"
      register: service_status

    - name: Start service if not running
      ansible.builtin.service:
        name: "{{ service_name }}"
        state: started
      when: not service_status.status.ActiveState == "active"

    - name: Verify service is listening on port {{ service_port }}
      ansible.builtin.shell: |
        ss -tuln | grep ":{{ service_port }} "
      register: port_check
      changed_when: false
      failed_when: port_check.rc != 0

    - name: Display confirmation
      ansible.builtin.debug:
        msg: "✅ {{ service_name }} is running and listening on port {{ service_port }}"

```

</details>
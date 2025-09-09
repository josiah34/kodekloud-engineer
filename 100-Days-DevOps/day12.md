### Task Description

Our monitoring tool has reported an issue in Stratos Datacenter. One of our app servers has an issue, as its Apache service is not reachable on port 3001 (which is the Apache port). The service itself could be down, the firewall could be at fault, or something else could be causing the issue.



Use tools like telnet, netstat, etc. to find and fix the issue. Also make sure Apache is reachable from the jump host without compromising any security settings.

Once fixed, you can test the same using command curl http://stapp01:3001 command from jump host.

Note: Please do not try to alter the existing index.html code, as it will lead to task failure.


### Solution

- From Jump Host test connectivity to stapp01 on port 3001

``telnet stapp01 3001``

``ping stapp01``

- Ping command was succesful so jump host can reach stapp01 on port 3001 which points towards a firewall issue or apache is not running on port 3001

- Check if apache is running on the app server

`` sudo systemctl status httpd``

<details> <summary>Output</summary>

```
[tony@stapp01 ~]$ sudo systemctl status httpd

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for tony: 
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Tue 2025-09-09 14:46:38 UTC; 11min ago
     Docs: man:httpd.service(8)
  Process: 511 ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND (code=exited, status=1/FAILURE)
 Main PID: 511 (code=exited, status=1/FAILURE)
   Status: "Reading configuration..."

Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com httpd[511]: (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:3001
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com httpd[511]: no listening sockets available, shutting down
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com httpd[511]: AH00015: Unable to open logs
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Child 511 belongs to httpd.service.
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Main process exited, code=exited, status=1/FAILURE
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Failed with result 'exit-code'.
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Changed start -> failed
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Job httpd.service/start finished, result=failed
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: Failed to start The Apache HTTP Server.
Sep 09 14:46:38 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Unit entered failed state.
[tony@stapp01 ~]$ 



```

</details>

We see that apache service is not running and it appears its because of another service running on port 3001. Next I'll find out which service is running on port 3001. 

``sudo lsof -i:3001``

I found that the sendmail service is running on port 3001.

```
[tony@stapp01 ~]$ sudo netstat -tulnp | grep :3001
tcp        0      0 127.0.0.1:3001          0.0.0.0:*               LISTEN      449/sendmail: accep 
```

Since it's not needed in this task I will stop it and then disable it.

``sudo systemctl stop sendmail`` and ``sudo systemctl disable sendmail``

Now that sendmail service is disable I will start httpd again. 
<details> <summary>Output</summary>

```

[tony@stapp01 ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
   Loaded: loaded (/usr/lib/systemd/system/httpd.service; disabled; vendor preset: disabled)
   Active: active (running) since Tue 2025-09-09 15:05:32 UTC; 44s ago
     Docs: man:httpd.service(8)
 Main PID: 1315 (httpd)
   Status: "Running, listening on: port 3001"
    Tasks: 213 (limit: 411434)
   Memory: 22.2M
   CGroup: /docker/a683782ebe993c2e4b62a87bc8d0c0f1953ef986af89192fb01297accdebd0f8/system.slice/httpd.service
           ├─1315 /usr/sbin/httpd -DFOREGROUND
           ├─1340 /usr/sbin/httpd -DFOREGROUND
           ├─1341 /usr/sbin/httpd -DFOREGROUND
           ├─1342 /usr/sbin/httpd -DFOREGROUND
           └─1343 /usr/sbin/httpd -DFOREGROUND

Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Installed new job httpd.service/nop as 320
Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Job httpd.service/nop finished, result=done
Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com httpd[1315]: Server configured, listening on: port 3001
Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Configuration loaded
.)
Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Changed reload -> running
Sep 09 15:05:32 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Started, listening o
n: port 3001, MAINPID=1315)
Sep 09 15:05:41 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Running, listening o
n: port 3001)
Sep 09 15:05:51 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Running, listening o
n: port 3001)
Sep 09 15:06:01 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Running, listening o
n: port 3001)
Sep 09 15:06:11 stapp01.stratos.xfusioncorp.com systemd[1]: httpd.service: Got notification message from PID 1315 (READY=1, STATUS=Running, listening o
n: port 3001)
[tony@stapp01 ~]$ 

```

</details>

It is now working fine. I tested curl on port 3001 from jump host and it still does not work. Pointing towards a firewall issue on app server. After investigating iptables I found that a final rule will drop all traffic unless explicitly allowed earlier in the chain. 

``sudo iptables -I INPUT 1 -p tcp --dport 3001 -j ACCEPT`` Will fix it. 

### Task Description 
Following a security audit, the xFusionCorp Industries security team has opted to enhance application and server security with SELinux. To initiate testing, the following requirements have been established for App server 2 in the Stratos Datacenter:



Install the required SELinux packages.

Permanently disable SELinux for the time being; it will be re-enabled after necessary configuration changes.

No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.

Disregard the current status of SELinux via the command line; the final status after the reboot should be disabled.


### Solution 

```
# SSH into stapp02 server as steve user
ssh steve@stapp02

# Install the SELINUX packages
 sudo yum install selinux-policy selinux-policy-targeted policycoreutils

# Disable SELinux

sudo vi /etc/selinux/config



# Check the SELinux status
[steve@stapp02 ~]$ sestatus
SELinux status:                 disabled


```
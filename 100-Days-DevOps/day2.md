### Task Desciption 
As part of the temporary assignment to the Nautilus project, a developer named yousuf requires access for a limited duration. To ensure smooth access management, a temporary user account with an expiry date is needed. Here's what you need to do:



Create a user named yousuf on App Server 2 in Stratos Datacenter. Set the expiry date to 2024-04-15, ensuring the user is created in lowercase as per standard protocol.

### Solution



```
thor@jumphost ~$ ssh steve@stapp02

[steve@stapp02 ~]$ sudo useradd -e 2024-04-15 yousuf

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for steve: 

# Check that yousuf exists with specified expiry date 

[steve@stapp02 ~]$ id yousuf
uid=1002(yousuf) gid=1002(yousuf) groups=1002(yousuf)

[steve@stapp02 ~]$ sudo chage -l yousuf
Last password change                                    : Aug 31, 2025
Password expires                                        : never
Password inactive                                       : never
Account expires                                         : Apr 15, 2024
Minimum number of days between password change          : 0
Maximum number of days between password change          : 99999
Number of days of warning before password expires       : 7

```
### Task Decription

To accommodate the backup agent tool's specifications, the system admin team at xFusionCorp Industries requires the creation of a user with a non-interactive shell. Here's your task:



Create a user named mariyam with a non-interactive shell on App Server 1.



### Solution



```
# SSH into stapp01 server as tony user
ssh tony@stapp01

#  Create user with non interactive shell on app server 1 
sudo useradd -r -s /usr/sbin/nologin -M mariyam

# -r Creates a system account
# -M does not create a home directory
# -s sets the login shell /usr/sbin/nologin prevents interactive logins 

# Check that the user mariyam exists

id mariyam 

```
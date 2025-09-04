### Task Description 
The Nautilus application development team recently finished the beta version of one of their Java-based applications, which they are planning to deploy on one of the app servers in Stratos DC. After an internal team meeting, they have decided to use the tomcat application server. Based on the requirements mentioned below complete the task:



a. Install tomcat server on App Server 1.

b. Configure it to run on port 3004.

c. There is a ROOT.war file on Jump host at location /tmp.

d.Deploy it on this tomcat server and make sure the webpage works directly on base URL i.e curl http://stapp01:3004


### Solution

- Install tomcat on stpp01 server
``sudo yum install tomcat -y``

- Configure it to run on port 3003
``sudo vi /etc/tomcat/server.xml``

<img width="1300" height="717" alt="Screenshot 2025-09-04 194855" src="https://github.com/user-attachments/assets/bb47e9ce-749e-4fb5-be73-bb99aef16c8a" />


- Deploy ROOT.war on tomcat server
```
thor@jumphost ~$ scp /tmp/ROOT.war tony@stapp01:/usr/share/tomcat/webapps/
tony@stapp01's password: 
dest open("/usr/share/tomcat/webapps/ROOT.war"): Permission denied
failed to upload file /tmp/ROOT.war to /usr/share/tomcat/webapps/ROOT.war
thor@jumphost ~$ sudo scp /tmp/ROOT.war tony@stapp01:/usr/share/tomcat/webapps/
```
This command fails as the tony user does not have permission to write to /usr/share/tomcat/webapps directory. As workaround I copied it to a location where I have write permissions.

``scp /tmp/ROOT.war tony@stapp01:/home/tony/``

With it now in my home directory I can copy it to /usr/share/tomcat/webapps

``sudo cp /home/tony/ROOT.war /usr/share/tomcat/webapps/``

- Start the tomcat server
``sudo systemctl start tomcat``

- Check the status of the tomcat server
``sudo systemctl status tomcat``

- Make sure the webpage works directly on base URL i.e curl
``curl http://stapp01:3004``






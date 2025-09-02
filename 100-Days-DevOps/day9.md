### Task Description
There is a critical issue going on with the Nautilus application in Stratos DC. The production support team identified that the application is unable to connect to the database. After digging into the issue, the team found that mariadb service is down on the database server.



Look into the issue and fix the same.



### Solution

```
# Login to mariadb server 

ssh peter@stdb01

# Check status of mariadb service

sudo systemctl status mariadb


# Check the status
# I see the mariadb service is down

# Start mariadb service

sudo systemctl start mariadb


# Check the status
# I see the mariadb service is still not running

# Check the logs

sudo tail -20 /var/log/mariadb/mariadb.log

# From the logs we see that the mariadb service account is not able to create the pid file

# Check permissions 
[peter@stdb01 ~]$ ls -ld /run/mariadb
drwxr-xr-x 2 root mysql 40 Sep  2 17:50 /run/mariadb


# We see the the mysql user does not have ownership to write to the /run/mariadb directory as shown above. As it is not owner it falls under other which only has read access

# Change the ownership to mysql user

sudo chown -R mysql:mysql /run/mariadb

# Give full permissions to mysql user

sudo chmod -R 755 /run/mariadb

# Restart the mariadb service

sudo systemctl restart mariadb

# After this I checked and found that the mariadb service was running properly 


```

<details>

<summary>MariaDB logs</summary>

```
[peter@stdb01 ~]$  sudo tail -20 /var/log/mariadb/mariadb.log
2025-09-02 17:53:19 0 [Note] InnoDB: Compressed tables use zlib 1.2.11
2025-09-02 17:53:19 0 [Note] InnoDB: Number of pools: 1
2025-09-02 17:53:19 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
2025-09-02 17:53:19 0 [Note] mariadbd: O_TMPFILE is not supported on /var/tmp (disabling future attempts)
2025-09-02 17:53:19 0 [Note] InnoDB: Using Linux native AIO
2025-09-02 17:53:19 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
2025-09-02 17:53:19 0 [Note] InnoDB: Completed initialization of buffer pool
2025-09-02 17:53:19 0 [Note] InnoDB: Starting crash recovery from checkpoint LSN=45091,45091
2025-09-02 17:53:19 0 [Note] InnoDB: 128 rollback segments are active.
2025-09-02 17:53:19 0 [Note] InnoDB: Removed temporary tablespace data file: "ibtmp1"
2025-09-02 17:53:19 0 [Note] InnoDB: Creating shared tablespace for temporary tables
2025-09-02 17:53:19 0 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
2025-09-02 17:53:19 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
2025-09-02 17:53:19 0 [Note] InnoDB: 10.5.27 started; log sequence number 45103; transaction id 20
2025-09-02 17:53:19 0 [Note] Plugin 'FEEDBACK' is disabled.
2025-09-02 17:53:19 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
2025-09-02 17:53:19 0 [Note] InnoDB: Buffer pool(s) load completed at 250902 17:53:19
2025-09-02 17:53:19 0 [Note] Server socket created on IP: '::'.
2025-09-02 17:53:19 0 [ERROR] mariadbd: Can't create/write to file '/run/mariadb/mariadb.pid' (Errcode: 13 "Permission denied")
2025-09-02 17:53:19 0 [ERROR] Can't start server: can't create PID file: Permission denied
[peter@stdb01 ~]$  sudo tail -40 /var/log/mariadb/mariadb.log
2025-09-02 17:52:54 0 [Note] InnoDB: Compressed tables use zlib 1.2.11
2025-09-02 17:52:54 0 [Note] InnoDB: Number of pools: 1
2025-09-02 17:52:54 0 [Note] InnoDB: Using crc32 + pclmulqdq instructions
2025-09-02 17:52:54 0 [Note] mariadbd: O_TMPFILE is not supported on /var/tmp (disabling future attempts)
2025-09-02 17:52:54 0 [Note] InnoDB: Using Linux native AIO
2025-09-02 17:52:54 0 [Note] InnoDB: Initializing buffer pool, total size = 134217728, chunk size = 134217728
2025-09-02 17:52:55 0 [Note] InnoDB: Completed initialization of buffer pool
2025-09-02 17:52:55 0 [Note] InnoDB: 128 rollback segments are active.
2025-09-02 17:52:55 0 [Note] InnoDB: Creating shared tablespace for temporary tables
2025-09-02 17:52:55 0 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
2025-09-02 17:52:55 0 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
2025-09-02 17:52:55 0 [Note] InnoDB: 10.5.27 started; log sequence number 45091; transaction id 20
2025-09-02 17:52:55 0 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
2025-09-02 17:52:55 0 [Note] Plugin 'FEEDBACK' is disabled.
2025-09-02 17:52:55 0 [Note] InnoDB: Buffer pool(s) load completed at 250902 17:52:55
2025-09-02 17:52:55 0 [Note] Server socket created on IP: '::'.
2025-09-02 17:52:55 0 [ERROR] mariadbd: Can't create/write to file '/run/mariadb/mariadb.pid' (Errcode: 13 "Permission denied")
```

</details>
## Initial Setup (docker)
- docker compose up

## login
- splunk GUI
  - Access (admin gui)[http://localhost:8000/]
  - login with user=admin and password=password which you put above
- splunk Container CLI
  ``` 
  docker exec -it splunk /bin/bash 
  ```
- postgres container CLI
  ```
  docker exec -it splunk /bin/bash
  psql -h localhost - p 5432 - U postgresql (default password is `postgres`)
  ```
- postgres container login
  ```
  docker exec -it postgresql /bin/sh 
  ```

## setup splunk
- setup splunk db connect at splunk GUI

[root@6a19045afc45 bin]# chmod -R 777 /opt/splunk/etc/apps/splunk_app_db_connect/
[root@6a19045afc45 bin]# /opt/splunk/bin/splunk restart
[root@6a19045afc45 bin]# /opt/splunk/bin/splunk status

## suppress splunk warn for dbxquery
- docs
  - https://docs.splunk.com/Documentation/Splunk/8.2.2/Security/SPLsafeguards?ref=hk
- procedures
  ```
  docker exec -it splunk /bin/bash
  sudo -s
  chmod 644 /opt/splunk/etc/system/default/web.conf
  vi /opt/splunk/etc/system/default/web.conf
    # Locate "enable_risky_command_check" and change the setting value from true to false
    # save the web.conf
  chmod 444 /opt/splunk/etc/system/default/web.conf
  /opt/splunk/bin/splunk restart
  ```

## PaloAlto Knowledge page
  - 
  https://live.paloaltonetworks.com/t5/%E3%83%8A%E3%83%AC%E3%83%83%E3%82%B8%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88/pan-db-category-list-japanese/ta-p/61944
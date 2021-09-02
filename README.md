## Initial Setup (docker)
- docker compose up

## login
- splunk GUI
  - Access (admin gui)[http://localhost:8000/]
  - login with user=admin and password=password which you put above
- splunk Container CLI
  - docker exec -it splunk /bin/bash
- postgres container CLI
  - docker exec -it splunk /bin/bash
  - psql -h localhost - p 5432 - U postgresql (default password is `postgres`)
- postgres container login
  - docker exec -it postgresql /bin/sh 

## setup postgresql
- create table with no thougts
  - psql -h localhost -p 5432 -d postgres -U postgres --command "create table app_report(date varchar(150), srcip varchar(150), app varchar(150), appcate varchar(150), act varchar(150), bytes int);" 

## setup splunk
- setup splunk db connect at splunk GUI

## suppress splunk warn for dbxquery
- docs
  - https://docs.splunk.com/Documentation/Splunk/8.2.2/Security/SPLsafeguards?ref=hk
- procedures
  - docker exec -it splunk /bin/bash
  - chmod 644 /opt/splunk/etc/system/default/web.conf
  - vi /opt/splunk/etc/system/default/web.conf
    - Locate "enable_risky_command_check" and change the setting value from true to false
    - save the web.conf
  - chmod 444 /opt/splunk/etc/system/default/web.conf
  - /opt/splunk/bin/splunk restart


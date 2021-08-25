## Setup
- JAVA_HOME=openjdk:8JAVA_VERSION=openjdk:8 SPLUNK_PASSWORD={password} docker compose up
  - https://github.com/splunk/docker-splunk/issues/208

## login
- splunk
  - Access (admin gui)[http://localhost:8000/]
  - login with user=admin and password which you put above

- postgresql
  - psql -h localhost -p 5432 -U postgres
  - after above command enter your passwrod


  ## create table with no thougts
  - create table app_report(date varchar(150), srcip varchar(150), app varchar(150), appcate varchar(150), act varchar(150), bytes int);


  ## postgres container login
  - docker exec -it postgresql /bin/sh 
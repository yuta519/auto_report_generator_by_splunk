#! /bin/bash

# Please replace a database information to insert log data 
# TODO: replace environmental values below
db_user="postgres"
db_name="postgres"
db_host="localhost"
db_tbl="app_report"

# Please replace a log file to parse
target_log_file='trafficlogs.csv'


BASE_SQL_QUERY="INSERT INTO ${db_tbl}(date, srcip, app, appcate, act, bytes) VALUES "
apps=$(cut -d , -f 15 ${target_log_file} | sed -e '1d' | sort -u)

for app in ${apps};do
	users=$(awk -F',' 'BEGIN {app="'"$app"'"} (NR!=1 && match($15, "^" app)) {print $8}' ${target_log_file})
	for user in ${users};do
		arr=$(grep ${app} ${target_log_file} | grep ${user} | cut -d , -f 7,31,38 | sort -u)
		date=$(echo ${arr} | cut -d " " -f 1)
		act=$(echo ${arr} | cut -d , -f 2)
		appcate=$(echo ${arr} | cut -d , -f 3 | cut -d " " -f 1)
		bytes=$(awk -F',' 'BEGIN {user="'"$user"'"}{app="'"$app"'"} (NR!=1 && match($8, "^" user) && match($15, "^" app)) {sum+=$32} END {print sum}' ${target_log_file})
		BASE_SQL_QUERY="${BASE_SQL_QUERY} ('${date}', '${user}', '${app}', '${appcate}', '${act}', '${bytes}'), "
	done
done

SQL_QUERY=$(echo ${BASE_SQL_QUERY} | sed -e "s/,$/;/")
echo ${SQL_QUERY} | psql -U ${db_user} -d ${db_name} 

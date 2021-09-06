#! /bin/bash

# Please replace a database information to insert log data 
# TODO: replace environmental values below
db_user="postgres"
db_name="agrex"
db_host="localhost"
db_tbl="app_report"

# Please replace a log file to parse
target_log_file='trafficlogs.csv'

echo $(sed -i '1d' ${target_log_file})
echo $(mkdir ./tmp && split -l 1000 ${target_log_file} ./tmp/trafficlogs_)

function insert_parsed_log() {
	BASE_SQL_QUERY="INSERT INTO ${db_tbl}(date, srcip, app, appcate, act, bytes) VALUES "
	apps=$(cut -d , -f 15 $1 | sed -e '1d' | sort -u)

	for app in ${apps};do
		users=$(awk -F',' 'BEGIN {app="'"$app"'"} (match($15, "^" app)) {print $8}' ${1} | sort -u)
		for user in ${users};do
			arr=$(grep ${app} ${1} | grep ${user} | cut -d , -f 7,31,38 | sort -u)
			date=$(echo ${arr} | cut -d " " -f 1)
			act=$(echo ${arr} | cut -d , -f 2)
			appcate=$(echo ${arr} | cut -d , -f 3 | cut -d " " -f 1)
			bytes=$(awk -F',' 'BEGIN {user="'"$user"'"}{app="'"$app"'"} (match($8, "^" user) && match($15, "^" app)) {sum+=$32} END {print sum}' ${1})
			BASE_SQL_QUERY="${BASE_SQL_QUERY} ('${date}', '${user}', '${app}', '${appcate}', '${act}', '${bytes}'), "
		done
	done

	SQL_QUERY=$(echo ${BASE_SQL_QUERY} | sed -e "s/,$/;/")
	echo ${SQL_QUERY} | psql -U ${db_user} -d ${db_name} 
}

for file in `ls ./tmp/trafficlogs_*`; do
	echo $(mv ${file} ${file}.csv)
	echo "start: ${file}.csv"
	insert_parsed_log ${file}.csv 
	echo "finished: ${file}.csv"
done

echo "Parsed Script is done"
echo $(rm -rf ./tmp)

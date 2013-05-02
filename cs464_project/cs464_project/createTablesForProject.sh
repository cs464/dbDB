#!/usr/bin/bash

echo "Type bash createTablesForProject.sh to run this properly."
echo "Make sure you change the -u to your username."

mysql -u root -h 127.0.0.1 -P 3306 -p dating_db < ./createTable.sql 
#mysql -u jaysong -h bender.cs.unm.edu -p \T output.txt group_2 < ./createTable.sql

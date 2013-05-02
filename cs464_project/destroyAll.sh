#!/usr/bin/bash

echo "Type bash destroyAll.sh to run this properly."
echo "Make sure you change the -u to your username."

mysql -u root -h 127.0.0.1 -p dating_db < ./destroyAllTables.sql
#mysql -u jaysong -h bender.cs.unm.edu -p group_2 < ./destroyAllTables.sql
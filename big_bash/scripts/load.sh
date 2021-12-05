#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'cricket';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb cricket;"
   eval $cmd
fi

psql cricket -f schema/create_schema.sql

cat csv/big_bash*.csv >> /tmp/games.csv

psql cricket -f loaders/load_games.sql

rm /tmp/games.csv

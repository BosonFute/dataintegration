#!/bin/bash
#title          :create_sql_tables.sh
#description    :This script will generate sql queries for tables creations for csv files
#note           :This is just a handy tool but not fully reliable; be sure to check the result; command csqsql is not fully trustable (analyses only a subset of the file); make sure you check the sql logs when running the command (longer char than expected, NULL values, etc.)
#author         :hnonne
#date           :2015-07-25
#version        :0.1
#usage          :bash mkscript.sh
#bash_version   :4.3.11(1)-release
#dependencies   :csvkit (csvsql)
#==================================================================

outfile=create_sql_tables.sql
if [ -f $outfile ]
    then
        echo "File $outfile already exists"
        exit
fi


files=($1*.csv)

for i in "${files[@]}"
do
    csvsql $i >> $outfile
done

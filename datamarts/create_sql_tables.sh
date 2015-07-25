#!/bin/bash
#title          :create_sql_tables.sh
#description    :This script will generate sql queries for tables creations for csv files
#note           :This is just a handy tool but not fully reliable; be sure to check the result; command csqsql is not fully trustable (analyses only a subset of the file);
#               :add indexes manually to the query
#               :make sure you check the sql logs when running the command (longer char than expected, NULL values, etc.)
#author         :Heloise Nonne
#date           :2015-07-25
#version        :0.1
#usage          :bash mkscript.sh inputdir separator database output
#bash_version   :4.3.11(1)-release
#dependencies   :csvkit (csvsql)
#==================================================================
inputdir=$1
sep=$2
database=$3
outfile=$4

if [ -f $outfile ]
    then
        echo "File $outfile already exists"
        exit
fi

echo "CREATE DATABASE $database;"
echo "USE $database;" >> $outfile
echo "SET @@Max_error_count=65535;" >> $outfile

files=($inputdir*.csv)

for i in "${files[@]}"
do
    file=$(basename $i)
    name=$(echo $file | cut -d '.' -f1 )
    echo "Analysing file: $(basename $i)"
    csvsql $i >> $outfile
    echo "LOAD DATA LOCAL INFILE '$i'" >> $outfile
    echo "INTO TABLE $name" >> $outfile
    echo "FIELDS TERMINATED BY '$sep';" >> $outfile
    echo "" >> $outfile
done

sed -i 's/"//g' $outfile

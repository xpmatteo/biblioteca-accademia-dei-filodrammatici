#!/bin/bash

# define key information
dump=/Users/matteo/bak/filodrammatici/filo-20120501171642.sql.gz
name=filo

# no customization needed beyond this line
dbname=${name}_development
dbname_test=${name}_test
dbuser=$name
dbpassword=$name

# stop after the first error
set -e

# go to project home directory
cd "$(dirname $0)/.."

# ask mysql root password
read -s -p "mysql root password? (type return for no password) " MYSQL_ROOT_PASSWORD
if [ "$MYSQL_ROOT_PASSWORD" != "" ]; then
    MYSQL_ROOT_PASSWORD=-p$MYSQL_ROOT_PASSWORD
fi

# drop old databases; ignore errors
mysqladmin -uroot $MYSQL_ROOT_PASSWORD --force drop $dbname || true
mysqladmin -uroot $MYSQL_ROOT_PASSWORD --force drop $dbname_test || true

# create databases
mysqladmin -uroot $MYSQL_ROOT_PASSWORD create $dbname
mysqladmin -uroot $MYSQL_ROOT_PASSWORD create $dbname_test

# create user and grant rights
echo "grant all on $dbname.* to '$dbuser'@localhost identified by '$dbpassword';" \
     | mysql -uroot $MYSQL_ROOT_PASSWORD $dbname
echo "grant all on $dbname_test.* to '$dbuser'@localhost identified by '$dbpassword';" \
      | mysql -uroot $MYSQL_ROOT_PASSWORD $dbname_test

# load schema
gunzip < $dump | mysql -u$dbuser -p$dbpassword $dbname 
gunzip < $dump | mysql -u$dbuser -p$dbpassword $dbname_test 


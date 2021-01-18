#!/bin/bash
 
MYSQL_USER=your_user
MYSQL_PASSWD=your_password
BACKUP_DIR=/var/backups/mysql
 
rm /var/tmp/database-temp

case $# in
0)
;;

1)
 MYSQL_PASSWD=$1
;;

2)
 MYSQL_USER=$1
 MYSQL_PASSWD=$2
;;

*)
 echo "Usage: $0 <mysql_user> <mysql_passwd> || <mysql_passwd>"
 exit 0;
;;
esac
 
echo "show databases" | mysql -b -u $MYSQL_USER --password=$MYSQL_PASSWD | grep -v ^Database > /var/tmp/database-temp
 
for i in $(cat /var/tmp/database-temp); do
        if [ ! -d $BACKUP_DIR/$i ]; then
                mkdir -p $BACKUP_DIR/$i
        fi
        mysqldump --opt -Q -u $MYSQL_USER --password=$MYSQL_PASSWD $i | gzip -9 -c > $BACKUP_DIR/$i/$i-db-dump$(date +%Y%m%d%H%M).sql.gz
        echo "$i backup done"
done
 
exit 0;

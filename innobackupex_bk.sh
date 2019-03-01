#!/bin/bash
source /home/mysql/.bash_profile
datadir="/data/bak/innodb_backup"
backup_date=`date  +"%Y%m%d"`
delete_date=`date +%Y%m%d "-d 5 days ago"`

mkdir ${datadir}/${backup_date}
chown mysql.mysql ${datadir}/${backup_date}

echo -e "${backup_date} start backup"
echo `date`

/data/mysql/mysql_3306/bin/percona-xtrabackup/bin/innobackupex   --user=root --password='GGyy@%%%234' --defaults-file=/data/mysql/mysql_3306/etc/my.cnf --slave-info --parallel=4 --no-timestamp /data/bak/innodb_backup/${backup_date}/db_full_${backup_date} 2>&1 
cd /data/bak/innodb_backup/${backup_date}
tar -zcvf db_full_${backup_date}.tar.gz db_full_${backup_date} 
echo " "
echo " "
echo "delete backup files" 
rm -rf /data/bak/innodb_backup/${backup_date}/db_full_${backup_date}


if [ -d /data/bak/innodb_backup/${delete_date}/ ]
then
	echo -e "/data/bak/innodb_backup/${delete_date}/ exist and deleted" 
	rm -rf /data/bak/innodb_backup/${delete_date}/ 
else
	echo -e "/data/bak/innodb_backup/${delete_date}/ not exist"
fi

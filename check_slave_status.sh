#!/bin/bash      
#  
# MySQL Database monitor replication Script 
#   

if [ $# -ne 1 ]  
then             
        exit  
fi 
   
SNAME=$1 
  
case $SNAME in   
    IDC-YZ-7)    
        DBHOST=127.0.0.1
	USERNAME=gol_monitor         
	PASSWORD=ssdg123!@#      
	PORTNUM=3306           
        ;; 
     *)
        exit    
        ;;       
esac             
   
# Email Address
MYSQL=/data/mysql/mysql_3306/bin/mysql
DATE=`date +%Y-%m-%d_%Hh%Mm`                            # Datestamp e.g 2002-09-21     
LOGFILE=/tmp/slave_status_$SNAME.log         # Logfile Name   

echo $SNAME >>"$LOGFILE"

# Database load function       
dbcheck () {
${MYSQL} --user=$USERNAME --password=$PASSWORD  --host=$DBHOST --port=$PORTNUM -e"show slave status\G"  > $1
}

dbcheck "$LOGFILE"

IOstat=`cat "$LOGFILE"|grep Slave_IO_Running|awk '{print $2}'`
SQLstat=`cat "$LOGFILE"|grep Slave_SQL_Running|head -n 1|awk '{print $2}'`
Seconds=`cat "$LOGFILE"|grep Seconds_Behind_Master|awk '{print $2}'`

echo $IOstat
echo $SQLstat
echo $Seconds

if [ $IOstat = 'Yes' ] && [ $SQLstat = 'Yes' ] 
then
        echo `date` "slave is up!"
else
		echo `date` "slave is down"
	cat "$LOGFILE" | /usr/bin/mutt -s "$SNAME MySQL replication down, please check the email info. Urgent!!!" rengaojian@golive-tv.com qishanrong@golive-tv.com cuijingkun@golive-tv.com
fi

if [ $Seconds -le 300 ]
then
        echo "mysql server rep normal"
else 
        echo "mysql server $SNAME replatency $Seconds seconds"
	cat "$LOGFILE" | /usr/bin/mutt -s "mysql server $SNAME replatency $Seconds seconds. Warning!!!" rengaojian@golive-tv.com qishanrong@golive-tv.com cuijingkun@golive-tv.com
fi

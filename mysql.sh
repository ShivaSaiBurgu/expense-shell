#!/bin/bash
USER=$(id -u)
if [ $USER -ne 0 ]
then
echo "please run the script with root access"
exit
else
echo "You are a root user"
fi
echo "please enter db password"
read password
time=$(date +%F-%H-%M-%S)
script=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$time-$script.log
VALIDATE()
{
    if [ $1 -ne 0 ]
    then
    echo "$2...Failure"
    exit
    else
    echo "$2...success"
    fi

}
yum install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing mysql"
systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling MySQL Server"
systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting MySQL Server"
mysql -h db.burgu.space -uroot -p${password} -e 'SHOW DATABASES;' &>>LOGFILE
if [ $? -eq 0 ]
then
echo "DB password already setup"
else
mysql_secure_installation --set-root-pass ${password} &>>$LOGFILE
validate $? "password setup"
fi

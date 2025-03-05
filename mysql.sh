#!/bin/bash
USER=$(id -u)
if [ $USER -ne 0 ]
then
echo "please run the script with root access"
exit
else
echo "You are a root user"
fi
time=$(date +%F-%H-%M-%S)
script=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$time-$script.log
validate()
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
validate $? "Installing mysql"
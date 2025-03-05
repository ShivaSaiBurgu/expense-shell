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
dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs:20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing nodejs"
id expense &>>LOGFILE
if [ $? -eq 0 ]
then
echo "expense user already added"
else
useradd expense &>>LOGFILE
VALIDATE $? "Added expense user"
fi

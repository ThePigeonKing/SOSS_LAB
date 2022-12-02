#!/bin/bash

echo -e "Текущая дата:";
date;
echo "Существующие пользователи:"
awk -F: '{ print $1}' /etc/passwd | tr '\n' " "; 
echo;
echo -n "Uptime: ";
uptime;
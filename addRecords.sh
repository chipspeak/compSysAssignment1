#!/bin/bash

##========================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to allow user to add new records
##========================================================================

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

##variable to be set to true for use in a do while loop
subMenu=true

detail_check() {
if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        subMenu=false
        spacing
        echo "Returning to the previous menu..."
        spacing
        sleep 1
        clear
        exit
fi
}

##loop is set
while $subMenu; do
spacing
##while $detailCheck; do
##user is prompted to enter the record details one at a time or r to return. This is then stored in the appropriate variable.
read -p "Enter the ID of the person you wish to add or enter 'R' to return: " id
detail_check $id
read -p "Enter the name of the person you wish to add or enter 'R' to return: " name
detail_check $name
read -p "Enter the role of the person you wish to add or enter 'R' to return: " role
detail_check $role
read -p "Enter the department of the person you wish to add or enter 'R' to return: " department
detail_check $department
read -p "Enter the salary of the person you wish to add or enter 'R' to return: " salary
detail_check $salary
spacing
##user then has their input echoed back to them before being given a prompt before adding it to the txt file
echo "ID:$id
NAME:$name
ROLE:$role
DEPARTMENT:$department
SALARY:€$salary"
spacing
read -p "Is the above information correct(Y/N)? " answer
        if [ $answer = "Y" ] || [ $answer = "y" ] ; then
        spacing
        echo "Adding details to records..."
        echo "$id $name $role $department €$salary" >> demotxt.txt
        sleep 1
        echo "Details added"
fi
done
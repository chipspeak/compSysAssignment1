#!/bin/bash

##========================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to add to new information to records
##========================================================

##variable to be set to true for use in a do while loop

subMenu=true
question=true
confirmation=false
numRestriction="^[0-9]{9}$"
letterRestriction="^[a-zA-z]+$"

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

exit_menu() {
        spacing
        echo "returning to the previous menu"
        spacing
        sleep 1
        clear
        exit
}

detail_check() {
if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
elif [ "$1" != "" ] && [[ $1 =~ $letterRestriction ]]; then
        question=false
else echo "This field cannot contain numbers or symbols. Please enter only letters"
fi
}

email_check() {
if [ "$1" = "" ] ; then
echo "This field cannot be left blank. "
else question=false
fi
}

number_check() {
if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
elif [ "$1" != "" ] && [[ $1 =~ $numRestriction ]] ; then
        question=false
else echo "Please enter the 9 digits following +353. This field cannot be left blank. "
fi
}

yes_or_no() {
confirmation=false
while ! $confirmation; do
read -p "Is the above information correct(Y/N)? " answer
        if [ $answer = "Y" ] || [ $answer = "y" ] ; then
        spacing
        echo "Adding details to records..."
        echo "$name,$company,$speciality,$city,$county,+353$phone,$email" >> records.txt
        sleep 1
        echo "Details added"
        confirmation=true
        elif [ $answer = "N" ] || [ $answer = "n" ] ; then
        confirmation=true
        else echo "Invalid input. Please answer 'Y' or 'N' "
fi
done
}

##outer loop is set
while $subMenu; do
spacing
##user is prompted to enter the record details one at a time or r to return. This is then stored in the appropriate variable.
question=true
while $question; do
read -p "Enter the name of the rep you wish to add or enter 'R' to return: " name
detail_check $name
done
question=true
while $question; do
read -p "Enter the rep's company or enter 'R' to return: " company
detail_check $company
done
question=true
while $question; do
read -p "Enter the speciality of the company or enter 'R' to return: " speciality
detail_check $speciality
done
question=true
while $question; do
read -p "Enter the city in which the rep is based or enter 'R' to return: " city
detail_check $city
done
question=true
while $question; do
read -p "Enter the county in which the rep is based or enter 'R' to return: " county
detail_check $county
done
question=true
while $question; do
read -p "Enter the rep's phone number or enter 'R' to return: " phone
number_check $phone
done
question=true
while $question; do
read -p "Enter the email address of the rep or enter 'R' to return: " email
email_check $email
done
spacing
##user then has their input echoed back to them before being given a prompt before adding it to the txt file
echo "NAME:$name
COMPANY:$company
SPECIALTY:$speciality
CITY:$city
COUNTY:$county
PHONE:$phone
EMAIL:$email"
spacing
yes_or_no $name $company $speciality $city $county $phone $email
done
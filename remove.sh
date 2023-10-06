#!/bin/bash

##=================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and remove records
##=================================================================

##variable purely for aesthetic adjustments.



confirmation=false
entry=false
headings="NAME,COMPANY,SPECIALITY,CITY,COUNTY,PHONE,EMAIL"

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

yes_or_no() {
confirmation=false
while ! $confirmation; do
read -p "Do you wish to remove the above information from records (Y/N)? " answer
        if [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
        sed -i "/$1/d" records.txt
        echo "Removing records containing $1..."
        sleep 1
        echo "Record removed. "
        sleep 1
        clear
        confirmation=true
        elif [ "$answer" = "N" ] || [ "$answer" = "n" ] ; then
        clear
        confirmation=true
        else echo "Invalid input. Please answer 'Y' or 'N' "
fi
done
}

##variable to be set to true for use in a do while loop
subMenu=true
##loop is set
while $subMenu; do
spacing
sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
spacing
##user is prompted to enter the name of choice or r to return. This is then stored in the name variable.
read -p "Please enter the word or number you wish to search for and remove or enter 'R' to return: " input
while [ "$input" = "" ] ; do
        echo "Invalid entry. This field cannot be left blank "
        read -p "Please enter the word or number you wish to search for and remove or enter 'R' to return: " input
done

if [ "$input" = "r" ] || [ "$input" = "R" ] ; then
        echo "Returning to the previous menu..."
        spacing
        sleep 1
        clear
        exit
fi
## expenses variable uses grep -i -w to check for the name in the txt file case-insensitive
## seeking a whole word before piping into awk to print the expenses column
search=$(grep -i -w -F "$input" records.txt)

##if statement checks if the variable is true i.e the name search returns a true result
if [ "$search" ] ; then
## echos a message to user listing the name and their expenses
        spacing
        echo "$search"
        spacing
        yes_or_no $input
elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
## otherwise returns that the name could not be found and the main script returns to the initial 3 options.
        spacing
        echo "No results."
fi
done
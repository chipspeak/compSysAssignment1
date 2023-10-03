#!/bin/bash

##========================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to allow user to remove records
##========================================================================

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

##variable to be set to true for use in a do while loop
subMenu=true
##loop is set
while $subMenu; do
spacing
cat demotxt.txt
spacing
##user is prompted to enter the name of choice or r to return. This is then stored in the name variable.
read -p "Please enter the word or number you wish to search for and remove or enter 'R' to return: " input
if [ $input = "r" ] || [ $input = "R" ] ; then
        subMenu=false
        echo "Returning to the previous menu..."
        spacing
        sleep 1
        clear
fi
## expenses variable uses grep -i -w to check for the name in the txt file case-insensitive
## seeking a whole word before piping into awk to print the expenses column
search=$(grep -i -w -F "$input" demotxt.txt)

##if statement checks if the variable is true i.e the name search returns a true result
if [ "$search" ] ; then
## echos a message to user listing the name and their expenses
        spacing
        echo "$search"
        spacing
        read -p "Are you sure you want to remove the above records? (Y/N) " answer
        if [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
        sed -i "/$input/d" demotxt.txt
        echo "Removing records containing $input..."
        fi
elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
## otherwise returns that the name could not be found and the main script returns to the initial 3 options.
        spacing
        echo "No results."
fi
done
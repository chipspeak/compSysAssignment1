#!/bin/bash

##========================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to search files via keywords or numbers
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

##user is prompted to enter the name of choice or r to return. This is then stored in the name variable.
read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
if [ $input = "r" ] || [ $input = "R" ] ; then
        subMenu=false
        spacing
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
elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
## otherwise returns that the name could not be found and the main script returns to the initial 3 options.
        spacing
        echo "No results."
fi
done
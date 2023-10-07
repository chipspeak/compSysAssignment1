#!/bin/bash

##========================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and find record by detail
##========================================================================

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

loading() {
    spacing
    echo "Loading..."
    spacing
    sleep 1
    clear
}

exit_menu() {
    spacing
    echo "returning to the previous menu"
    spacing
    sleep 1
    clear
    exit
}

##variable to be set to true for use in a do while loop
subMenu=true
loading
##loop is set
while $subMenu; 
do
    ##user is prompted to enter the name of choice or r to return. This is then stored in the name variable.
    read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
    while [ "$input" = "" ] ; 
    do
        echo "Invalid entry. This field cannot be left blank. "
        read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
    done
    if [ $input = "r" ] || [ $input = "R" ] ; then
        exit_menu
    fi
    ## expenses variable uses grep -i -w to check for the name in the txt file case-insensitive
    ## seeking a whole word before piping into awk to print the expenses column
    search=$(grep -i -w -F "$input" records.txt)

    ##if statement checks if the variable is true i.e the name search returns a true result
    if [ "$search" ] ; then
    ## echos a message to user listing the name and their expenses
        spacing
        grep -i -w -F "$input" records.txt >> searchresult.txt | column -t -s ","
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        rm searchresult.txt
        spacing
    elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
    ## otherwise returns that the name could not be found and the main script returns to the initial 3 options.
        spacing
        echo "No results."
    fi
done
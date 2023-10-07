#!/bin/bash

##=================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and remove records
##=================================================================

##variable used in the yes or no method loop
confirmation=false
##variable used to store the headings that will be presented with the txt file
headings="NAME,COMPANY,SPECIALITY,CITY,COUNTY,PHONE,EMAIL"

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

##function which uses a while loop to check if the user wants to delete the results of the search
yes_or_no() {
confirmation=false
while ! $confirmation; 
do
    read -p "Do you wish to remove the above information from records (Y/N)? " answer
    if [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
            sed -i "/$1/d" records.txt
            echo "Removing the above records..."
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

exit_menu() {
    spacing
    echo "returning to the previous menu"
    spacing
    sleep 1
    clear
    exit
}

##variable to be set to true for use in the outer loop of this script
subMenu=true
loading
##the outer loop in which the bulk of this scripts actions are contained
while $subMenu; 
do
    spacing
    ##sed command is used to add the headings variable to the output of the txt file. This is piped into colum for formatting via comma delimiter
    sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
    spacing
    ##user is prompted to enter the details they wish to search for or r to return. This is then stored in the input variable.
    read -p "Please enter the word or number you wish to search for and remove or enter 'R' to return: " input
    ##while loop set to run while input variable has been left blank to prevent empty fields.
    while [ "$input" = "" ] ; 
    do
        echo "Invalid entry. This field cannot be left blank "
        read -p "Please enter the word or number you wish to search for and remove or enter 'R' to return: " input
    done
    ##if statement to account for entry of our return key. Loop is broken if this is true.
    if [ "$input" = "r" ] || [ "$input" = "R" ] ; then
        exit_menu
    fi

    ## search variable uses grep -i -w to check for the name in the txt file case-insensitive and is a whole word.
    search=$(grep -i -w -F "$input" records.txt)

    ##if statement checks if the variable is true and then uses grep to search for the variable within records.txt before outputting to a new text file.
    if [ "$search" ] ; then
    ## echos a message to user listing the name and their expenses
        spacing
        grep -i -w -F "$search" records.txt >> searchresult.txt | column -t -s ","
        ##once again the headings variable and sed command are used to present the headings appropriately in new file
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        ##as we've used grep to visually output the contents of the new file, it is subsequently deleted
        rm searchresult.txt
        spacing
        ##user is then asked if they wish to delete the found records vis the yes or no function
        yes_or_no $input
    elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
    ## Else if checks for a lack of the variable or r for return and if they're not found, message is echoed to user.
        spacing
        echo "No results."
        sleep 1
        clear
    fi
done
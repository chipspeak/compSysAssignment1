#!/bin/bash

##=================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and remove records
##=================================================================

##variable used in the yes or no method loop
confirmation=false
##variable to be set to true for use in the outer loop of this script
subMenu=true
##variable set to false for use in menu choice
choice=false
##variable used to store the headings that will be presented with the txt file
headings="NAME,COMPANY,SPECIALITY,CITY,COUNTY,PHONE,EMAIL"
##variable used to store the regex that will be used to validate email addresses
emailRestriction='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'

GREEN=$'\e[32m'
RED=$'\e[31m'
YELLOW=$'\e[33m'
NC=$'\e[0m'
INVERTED=$'\e[7m'
UNDERLINED=$'\e[4m'
BOLD=$'\e[1m'

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
    echo " "
    printf "%*s" $(tput cols) | tr " " "=\n"
    echo " "
}

loading() {
    spacing
    echo -e "${BOLD}Loading...${NC}"
    spacing
    sleep 1
    clear
}

email_check() {
    if [[ $1 =~ $emailRestriction ]]; then
        return 0 
    else
        return 1 
    fi
}

exit_option() {
    ##if statement to account for entry of our return key. Loop is broken if this is true.
    if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
    fi
}

##function which uses a while loop to check if the user wants to delete the results of the search
yes_or_no() {
confirmation=false
while ! $confirmation; 
do
    read -p "Do you wish to ${UNDERLINED}remove${NC} the above information from records (${GREEN}Y${NC}/${RED}N${NC})? " answer
    if [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
            sed -i "/$1/d" records.txt
            echo -e "Removing the above record(s)..."
            sleep 1
            echo "${GREEN}Record(s) removed${NC} "
            sleep 2
            clear
            confirmation=true
    elif [ "$answer" = "N" ] || [ "$answer" = "n" ] ; then
            clear
            break
    else echo "${YELLOW}Invalid input. Please answer 'Y' or 'N'${NC} "
    fi
done
}

exit_menu() {
    spacing
    echo -e "Returning to the previous menu..."
    spacing
    sleep 1
    clear
    exit
}

loading
##the outer loop in which the bulk of this scripts actions are contained
while $subMenu; 
do
    spacing
    ##sed command is used to add the headings variable to the output of the txt file. This is piped into column for formatting via comma delimiter.
    sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
    spacing
    ##user is prompted to enter the details they wish to search for or r to return. This is then stored in the input variable.
    read -p "Please enter the ${UNDERLINED}email address${NC} of the rep you wish to remove or enter 'R' to return: " input
    ##this while loop will account for all eventualities where the input does not match an email. Checked by regex in email_check function.
    while ! email_check "$input" 
    do
        exit_option "$input"
        echo "${YELLOW}This email address cannot be found. Please enter an email from the above list. ${NC}"
        read -p "Please enter the ${UNDERLINED}email address${NC} of the rep you wish to remove or enter 'R' to return: " input
    done
    ##if statement checks if the function is returning a true (i.e 0) when using a regex check on the input email and then executes the following commands.
    if  email_check "$input" ; then
        # ## search variable uses grep -i -w to check for the name in the txt file case-insensitive and is a whole word.
        # search=$(grep -i -w "$input" records.txt)  
        spacing
        ##grep is used to place the result in a new txt file for formatting with headings and columns
        grep -i -w -F "$input" records.txt >> searchresult.txt | column -t -s ","
        ##once again the headings variable and sed command are used to present the headings appropriately in new file
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        ##as we've used grep to visually output the contents of the new file, it is subsequently deleted
        rm searchresult.txt
        spacing
        ##user is then asked if they wish to delete the found records vis the yes or no function
        yes_or_no $input
    fi
done
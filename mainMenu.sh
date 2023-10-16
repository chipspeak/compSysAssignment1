#!/bin/bash

##=======================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak/compSysAssignment1
##Description: main menu script for programme
##=======================================================

##colour and text formatting variables
YELLOW=$'\e[33m'
CYAN=$'\e[96m'
INVERTED=$'\e[7m'
BOLD=$'\e[1m'
NC=$'\e[0m'

##variable for use in the menu loop
subMenu=true

##function to display a welcome greeting container author info etc
##this method ends with a user prompt where -n 1 is used to ensure it takes a single character input, 
##-s for silent mode so that the users input is not displayed back to them and -r to prevent backslashes being treated as escape characters.
welcome_greeting() {
    clear
    welcome_spacing
    echo ""
    echo "${INVERTED}${CYAN} W E L C O M E - T O - R E P C H E C K ${NC}"
    echo ""
    echo "${CYAN}This script will allow you to search through records of Irish musical instrument sales reps."
    echo "You will have the option to add new records, remove records or search the existing records."
    echo ""
    echo "${BOLD}AUTHOR:Patrick O'Connor"
    echo "${BOLD}STUDENT NUMBER:2004012"
    echo "${BOLD}GITHUB:https://github.com/chipspeak/compSysAssignment1${NC}"
    welcome_spacing
    echo ""
    read -n 1 -s -r -p "Press any key to begin" answer
}

##slightly different version of the spacing function where tput has been used to swap in @ symbols instead of the = in the below function
welcome_spacing() {
    echo "${CYAN}"
    printf "%*s" $(tput cols) | tr " " "@\n"
    echo "${NC}"
}

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
    echo " "
    printf "%*s" $(tput cols) | tr " " "=\n"
    echo " "
}

##welcome greeting is display upon initial startup
welcome_greeting
echo ""
##main menu loading message is issued before brief downtime and then clear before the main menu loop begins
echo -ne "${BOLD}${CYAN}Loading main menu..."
sleep 1
echo -ne "..."
sleep 1
echo -ne "...${NC}"
sleep 1
clear
##main menu while loop where the user is presented their menu choices. A case is then used to direct to the appropriate subscript as needed based on response.
##as with all cases in this script and its subscripts, wildcard * is used for all answers that are not listed choices and an appropriate error message is displayed.
while [ $subMenu ]
spacing
echo "${INVERTED}${CYAN} M A I N - M E N U ${NC}"
echo ""
do
    echo "${BOLD}Please select one of the following options${NC} "
    echo ""
    echo "1) Add a new record"
    echo "2) Remove a record"
    echo "3) Search Records"
    echo "4) Exit"
    read answer
    case $answer in 
        1) ./addRecords.sh ;;
        2) ./remove.sh ;;
        3) ./search.sh ;;
        4)  spacing
            echo "${BOLD}${CYAN}Exiting programme...${NC}"
            spacing
            sleep 1
            clear
            break
            ;;
        *)  spacing
            echo "${YELLOW}Invalid option. Please enter one of the supplied numbers. ${NC}"
            ;;
    esac
done
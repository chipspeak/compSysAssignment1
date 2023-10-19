#!/bin/bash

##=======================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak/compSysAssignment1
##Description: main menu script for programme
##=======================================================


##==========================================================================================================================================================
##VARIABLES
##==========================================================================================================================================================


##colour and text formatting variables
YELLOW=$'\e[33m'
CYAN=$'\e[96m'
RED=$'\e[31m'
INVERTED=$'\e[7m'
BOLD=$'\e[1m'
NC=$'\e[0m'

##variable for use in the menu loop
subMenu=true


##==========================================================================================================================================================
##FUNCTIONS
##==========================================================================================================================================================


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

##function which uses the same concept as the welcome menu but in the context of displaying an error message
##for use in conjunction with menu options
display_error() {
    clear
    spacing
    echo "${YELLOW}Invalid option. Please enter one of the supplied numbers. ${NC}"
    spacing
    read -n 1 -s -r -p "${BOLD}${CYAN}Press any key to try again ${NC}" ans
    clear
}


##==========================================================================================================================================================
##MAIN PROGRAMME
##==========================================================================================================================================================


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
##main menu while loop where the user is presented their menu choices. A case is then used to direct to the appropriate subscript.
##as with all cases in this script and its subscripts, wildcard * is used for all answers that are not listed choices 
##and an appropriate error message is displayed.
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
        2) if [ -s records.txt ] ; then
           ./remove.sh 
           else clear
                spacing
                echo "${BOLD}${RED}Records file is empty. Please add a record before attempting to remove ${NC}"
           fi
           ;;
        3) if [ -s records.txt ] ; then
           ./search.sh 
           else clear
                spacing
                echo "${BOLD}${RED}Records file is empty. Please add a record before attempting to search ${NC}"
           fi
           ;;
        4)  spacing
            echo "${BOLD}${CYAN}Exiting programme...${NC}"
            spacing
            sleep 3
            clear
            break
            ;;
        *)  display_error
            ;;
    esac
done
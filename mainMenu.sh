#!/bin/bash

##===========================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: main menu script for programme
##===========================================

YELLOW=$'\e[33m'
INVERTED=$'\e[7m'
BOLD=$'\e[1m'
NC=$'\e[0m'
subMenu=true

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

display_center(){
    columns="$(tput cols)"
    while IFS= read -r line; do
        printf "%*s\n" $(( (${#line} + columns) / 2)) "$line"
    done < "$1"
}

##clear terminal prior to menu loop being set
display_center records.txt
sleep 2
clear
while [ $subMenu ]
spacing
echo "${INVERTED}MAIN MENU${NC}"
echo ""
do
    echo "${BOLD}Please select one of the below options${NC} "
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
            echo "Exiting programme..."
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
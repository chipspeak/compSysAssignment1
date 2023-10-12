#!/bin/bash

##===========================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: main menu script for programme
##===========================================

YELLOW=$'\e[33m'
NC=$'\e[0m'
subMenu=true

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

##clear terminal prior to menu loop being set
clear
while [ $subMenu ]
spacing
do
    echo "Please select on of the below options "
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
            spacing
            ;;
    esac
done
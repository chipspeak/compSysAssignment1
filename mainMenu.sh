#!/bin/bash

##===========================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: main menu script for programme
##===========================================

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

##PS3 variable contains numbers to account for clear and to prevent user from needing to scroll up should they forget their options
PS3='Choose whether you wish to 1) Add a record, 2) Remove a record, 3) Search records, 4) Check records or 5) quit: '
options=("Add a new record" "Remove a record" "Search records" "Check records" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Add a new record")
            ./addRecords.sh
            ;;
        "Remove a record")
            ./remove.sh
            ;;
        "Search records")
            ./search.sh
            ;;
        "Check records")
            ./checkRecords.sh
            ;;
        "Quit")
            spacing
            echo "Exiting programme..."
            spacing
            sleep 1
            clear
            break
            ;;
        *)  spacing
            echo "invalid option, please select one of the numeric options"
            spacing
            ;;
    esac
done
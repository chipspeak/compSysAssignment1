#!/bin/bash

##===========================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: main menu script for programme
##===========================================

###variable purely for aesthetic adjustments.
spacing=" \n==============================================================================\n"

##PS3 variable contains numbers to account for clear and to prevent user from needing to scroll up should they forget their options
PS3='Choose whether you wish to 1) Add a record, 2) Remove a record, 3) Search records, 4) Generate a report or 5) quit: '
echo -e $spacing
options=("Add a new record" "Remove a record" "Search records" "Generate a report" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Add a new record")
            ./addRecords.sh
            ;;
        "Remove a record")
            ./findExpenses.sh
            ;;
        "Search records")
            ./search.sh
            ;;
        "Generate a report")
        ##
            ;;
        "Quit")
            echo -e $spacing
            echo "Exiting programme..."
            echo -e $spacing
            sleep 1
            clear
            break
            ;;
        *)  echo -e $spacing
            echo "invalid option, please select one of the numeric options"
            echo -e $spacing
            ;;
    esac
done
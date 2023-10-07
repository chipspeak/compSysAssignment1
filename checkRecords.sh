#!/bin/bash

##========================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and find record by detail
##========================================================================

subMenu=true

provinces=("Munster" "Leinster" "Connacht" "Ulster")
munster=("Clare" "Cork" "Kerry" "Limerick" "Tipperary" "Waterford")
leinster=("Carlow" "Dublin" "Kildare" "Kilkenny" "Laois" "Longford" "Louth" "Meath" "Offaly" "Westmeath" "Wexford" "Wicklow")
Connacht=("Galway" "Leitrim" "Mayo" "Roscommon" "Sligo")
Ulster=("Donegal" "Monaghan" "Cavan")

##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
    echo " "
    printf "%*s" $(tput cols) | tr " " "=\n"
    echo " "
}

##function for use in breaking up user experience via brief load and clear.
loading() {
    spacing
    echo "Loading..."
    spacing
    sleep 1
    clear
}

##function to echo a message to user notifying them of menu change prior to clear and return.
exit_menu() {
    spacing
    echo "returning to the previous menu"
    spacing
    sleep 1
    clear
    exit
}

answer_formatting() {
    spacing
    sleep 1
    clear
    spacing
}

##function that will be called upon choice of a specific province.
display_province_results() {
    ##if the passed variable is x province then a for loop iterates through the appropriate array
    ##this array then uses grep command to search the records file for whole words, case insensensitive matches
    ##The array-matched results are then placed inside a new text file.
    if [ "$1" = "munster" ] ; then
        for i in "${munster[@]}" 
        do
            grep -i -w -F "$i" records.txt >> munster.txt
        done
        ##this if statement checks if the txt file contains data and if so, uses sed to add headings before outputting to user
        ##additionally, sed is used to check for the number of entries for the province in question.
        if [ -s munster.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' munster.txt | column -t -s ","
            repnum=$(sed -n '$=' munster.txt)
            spacing
            echo "There are a total of $repnum sales representatives in Munster "
            rm munster.txt
        ##otherwise (meaning the txt file has no data) user is informed that there are no reps in this area.
        else
            echo "There are currently no Munster-based sales reps in the records "
        fi
        ##the below conditionals follow the same logic.
    elif [ "$1" = "leinster" ] ; then
        for i in "${leinster[@]}" 
        do
            grep -i -w -F "$i" records.txt >> leinster.txt
        done
        if [ -s leinster.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' leinster.txt | column -t -s ","
            repnum=$(sed -n '$=' leinster.txt)
            spacing
            echo "There are a total of $repnum sales representatives in Leinster "
            rm leinster.txt
        else
            echo "There are currently no Leinster-based sales reps in the records "
        fi
    elif [ "$1" = "connacht" ] ; then
        for i in "${connacht[@]}" 
        do
            grep -i -w -F "$i" records.txt >> connacht.txt
        done
        if [ -s connacht.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' connacht.txt | column -t -s ","
            repnum=$(sed -n '$=' connacht.txt)
            spacing
            echo "There are a total of $repnum sales representatives in Connacht "
            rm connacht.txt
        else
            echo "There are currently no Connacht-based sales reps in the records "
        fi
    elif [ "$1" = "ulster" ] ; then
        for i in "${ulster[@]}" 
        do
            grep -i -w -F "$i" records.txt >> ulster.txt
        done
        if [ -s ulster.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' ulster.txt | column -t -s ","
            repnum=$(sed -n '$=' ulster.txt)
            spacing
            echo "There are a total of $repnum sales representatives in Ulster "
            rm ulster.txt
        else
            echo "There are currently no Ulster-based sales reps in the records "
        fi
    fi
}

##This function presents a while loop based case where the user is echoed choices of province or return.
county_options() {
while [ $subMenu ] 
do
    echo "Please select the province you wish to locate sales reps in "
    echo "1) Munster"
    echo "2) Leinster"
    echo "3) Connacht"
    echo "4) Ulster"
    echo "5) Return to the previous menu"
    read answer
    ##once user chooses an option the display_province_results function has the answer passed to it.
    case $answer in
        1) spacing
            echo "Loading representatives based in Munster..."
            answer_formatting
            display_province_results munster
            spacing
            ;;
        2) spacing
            echo "Loading representatives based in Leinster..."
            answer_formatting
            display_province_results leinster
            spacing 
            ;;
        3) spacing
            echo "Loading representatives based in Connacht..."
            answer_formatting
            display_province_results connacht
            spacing 
            ;;
        4) spacing
            echo "Loading representatives based in Ulster..."
            answer_formatting
            display_province_results ulster
            spacing 
            ;;
        5) subMenu=false
            spacing
            echo "Returning to previous menu..."
            spacing
            sleep 1
            clear
            break 
            ;;
        *) echo "Invalid option. Please select one of the supplied numbers. "
    esac
done
}

loading
##outer menu for checking records and other options 
PS3='Choose whether you wish to 1) Check reps by province, 2) Remove a record, 3) Search records, 4) Check records or 5) Return to the previous menu: '
options=("Check reps by province" "Remove a record" "Search records" "Check records" "Return to the previous menu")
select opt in "${options[@]}" 
do
    case $opt in
        "Check reps by province")
            loading
            county_options
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
        "Return to the previous menu")
            spacing
            echo "Returning to previous menu..."
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
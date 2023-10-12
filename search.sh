#!/bin/bash

##=================================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to filter through txt file and find specific details via menu
##=================================================================================

subMenu=true
searchMenu=true
mainMenu=true

provinces=("Munster" "Leinster" "Connacht" "Ulster")
munster=("Clare" "Cork" "Kerry" "Limerick" "Tipperary" "Waterford")
leinster=("Carlow" "Dublin" "Kildare" "Kilkenny" "Laois" "Longford" "Louth" "Meath" "Offaly" "Westmeath" "Wexford" "Wicklow")
connacht=("Galway" "Leitrim" "Mayo" "Roscommon" "Sligo")
ulster=("Antrim" "Armagh" "Tyrone" "Derry" "Down" "Donegal" "Fermanagh" "Monaghan" "Cavan")
instruments=("Piano" "Guitar" "String" "Percussion" "Wind" "Brass")

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

view_all_records() {
    spacing
    ##sed command is used to add the headings variable to the output of the txt file. This is piped into colum for formatting via comma delimiter
    sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
    repnum=$(sed -n '$=' records.txt)
    spacing
    echo "There are a total of $repnum sales reps currently on record."
}

search_by_word() {
##loop is set
while $searchMenu; 
do
    spacing
    ##user is prompted to enter the name of choice or r to return. This is then stored in the name variable.
    read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
    while [ "$input" = "" ] ; 
    do
        echo "${YELLOW}Invalid entry. This field cannot be left blank. ${NC}"
        read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
    done
    if [ $input = "r" ] || [ $input = "R" ] ; then
        spacing
        echo "Returning to previous menu..."
        spacing
        sleep 1
        clear
        break
    fi
    ## expenses variable uses grep -i -w to check for the name in the txt file case-insensitive
    ## seeking a whole word before piping into awk to print the expenses column
    search=$(grep -i -w -F "$input" records.txt)
    ##if statement checks if the variable is true i.e the name search returns a true result
    if [ "$search" ] ; then
    ## echos a message to user displaying the returned result
        echo "Returning result(s) for $input..."
        spacing
        sleep 1
        grep -i -w -F "$input" records.txt >> searchresult.txt | column -t -s ","
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        rm searchresult.txt
    elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
    ## otherwise returns that the name could not be found and the main script returns to the initial 3 options.
        spacing
        echo "No results found for your search."
    fi
done
}

##function that will be called upon choice of a specific province.
display_province_results() {
    ##The array of counties in the province is passed into the function before being iterated through via for loop
    ##this array then uses grep command to search the records file for whole words, case insensensitive matches
    ##The array-matched results are then placed inside a new text file.
        for i in "$@"
        do
            grep -i -w -F "$i" records.txt >> province.txt
        done
        ##this if statement checks if the txt file contains data and if so, uses sed to add headings before outputting to user
        ##additionally, sed is used to check for the number of entries for the province in question.
        if [ -s province.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' province.txt | column -t -s ","
            repnum=$(sed -n '$=' province.txt)
            spacing
            echo "There are a total of $repnum sales representatives in this province "
            rm province.txt
        ##otherwise (meaning the txt file has no data) user is informed that there are no reps in this area.
        else
            echo "There are currently no sales reps operating in this province on record "
        fi
}

##function that will be called upon choice of a specific province.
display_specialist_results() {
    ##if the passed variable is x province then a for loop iterates through the appropriate array
    ##this array then uses grep command to search the records file for whole words, case insensensitive matches
    ##The array-matched results are then placed inside a new text file.

        grep -i -w -F "$1" records.txt >> instruments.txt
        ##this if statement checks if the txt file contains data and if so, uses sed to add headings before outputting to user
        ##additionally, sed is used to check for the number of entries for the province in question.
        if [ -s instruments.txt ] ; then
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' instruments.txt | column -t -s ","
            repnum=$(sed -n '$=' instruments.txt)
            spacing
            echo "There are a total of $repnum sales representatives specialising in $1 "
            rm instruments.txt
        ##otherwise (meaning the txt file has no data) user is informed that there are no reps in this area.
        else
            echo "There are currently no $1 specialists on record "
        fi
}

##This function presents a while loop based case where the user is echoed choices of province or return.
county_options() {
while [ $subMenu ] 
do
    spacing
    echo "${BOLD}Please select the province you wish to locate sales reps in ${NC}"
    echo ""
    echo "1) Munster"
    echo "2) Leinster"
    echo "3) Connacht"
    echo "4) Ulster"
    echo "5) Return to the previous menu"
    read answer
    ##once user chooses an option the display_province_results function has the answer passed to it in the form of an array of the counties conta.
    case $answer in
        1) spacing
            echo "Loading representatives based in Munster..."
            answer_formatting
            display_province_results "${munster[@]}"
            
            ;;
        2) spacing
            echo "Loading representatives based in Leinster..."
            answer_formatting
            display_province_results "${leinster[@]}"
             
            ;;
        3) spacing
            echo "Loading representatives based in Connacht..."
            answer_formatting
            display_province_results "${connacht[@]}"
             
            ;;
        4) spacing
            echo "Loading representatives based in Ulster..."
            answer_formatting
            display_province_results "${ulster[@]}"
             
            ;;
        5) subMenu=false
            spacing
            echo "Returning to previous menu..."
            spacing
            sleep 1
            clear
            break 
            ;;
        *)  spacing
            echo "${YELLOW}Invalid option. Please enter one of the supplied numbers. ${NC}"
    esac
done
}

speciality_options() {
while [ $subMenu ] 
do
    spacing
    echo "${BOLD}Please select the instrumental specialty you wish to search for ${NC}"
    echo ""
    echo "1) Piano"
    echo "2) Guitar"
    echo "3) String"
    echo "4) Wind"
    echo "5) Percussion"
    echo "6) Brass"
    echo "7) Return to the previous menu"
    read answer
    ##once user chooses an option the display_province_results function has the answer passed to it.
    case $answer in
        1) spacing
            echo "Loading reps specialising in Piano..."
            answer_formatting
            display_specialist_results piano
            ;;
        2) spacing
            echo "Loading reps specialising in Guitar..."
            answer_formatting
            display_specialist_results guitar 
            ;;
        3) spacing
            echo "Loading reps specialising in Strings..."
            answer_formatting
            display_specialist_results string
            ;;
        4) spacing
            echo "Loading reps specialising in Wind..."
            answer_formatting
            display_specialist_results wind
            ;;
        5) spacing
            echo "Loading reps specialising in Percussion..."
            answer_formatting
            display_specialist_results percussion
            ;;
        6) spacing
            echo "Loading reps specialising in Brass..."
            answer_formatting
            display_specialist_results brass
            ;;
        7) subMenu=false
            spacing
            echo "Returning to previous menu..."
            spacing
            sleep 1
            clear
            break 
            ;;
        *)  spacing
            echo "${YELLOW}Invalid option. Please enter one of the supplied numbers. ${NC}"
    esac
done
}

loading
##outer menu for checking records and other options 
##PS3='Choose whether you wish to 1) Search by word or number 2) Search by instrument speciality 3) Search by province 4) View all records 5) Return to the previous menu: '
##options=("Search by word or number" "Search by instrument speciality" "Search by province" "View all records" "Return to the previous menu")
while [ $mainMenu ]
do
    spacing
    echo "${INVERTED}SEARCH MENU${NC}"
    echo ""
    echo "${BOLD}Please select one of the following options${NC}"
    echo ""
    echo "1) Search by word or number"
    echo "2) Search by instrumental speciality"
    echo "3) Search by province"
    echo "4) View all records"
    echo "5) Return to the previous menu"
    read option
    case $option in  
        1)  loading
            search_by_word
            ;;
        2)
            loading
            speciality_options
            ;;
        3)
            loading
            county_options
            ;;
        4)
            loading
            view_all_records
            ;;
        5)
            spacing
            echo "Returning to previous menu..."
            spacing
            sleep 1
            clear
            break
            ;;
        *)  spacing
            echo "${YELLOW}Invalid option. Please select one of supplied numbers. ${NC}"
            ;;
    esac
done
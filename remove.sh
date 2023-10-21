#!/bin/bash

##=================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak/compSysAssignment1
##video walkthrough: https://youtu.be/MECO79392ys   
##Description: script to filter through txt file and remove records
##=================================================================


##==========================================================================================================================================================
##VARIABLES
##==========================================================================================================================================================


##variable used in the yes or no method loop
confirmation=false
##variable to be set to true for use in the outer loop of this script
subMenu=true
##variable for use within inner menu loops
removeMenu=true
##variable for use in speciality choice menu
speciality=""
##variable used to store the regex that will be used to validate email addresses
emailRestriction='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'

##colour and text formatting variables
GREEN=$'\e[32m'
RED=$'\e[31m'
YELLOW=$'\e[33m'
CYAN=$'\e[96m'
NC=$'\e[0m'
INVERTED=$'\e[7m'
UNDERLINED=$'\e[4m'
BOLD=$'\e[1m'


##==========================================================================================================================================================
##FUNCTIONS
##==========================================================================================================================================================


##function using tput command in addition to columns to substitude equals sign into character width of screen
spacing() {
    echo " "
    printf "%*s" $(tput cols) | tr " " "=\n"
    echo " "
}

##function for use in breaking up user experience via brief load and clear.
loading() {
    spacing
    echo "${BOLD}${CYAN}Loading...${NC}"
    spacing
    sleep 1
    clear
}

##function similar to loading but for returning to other menus
returning() {
    spacing
    echo "${BOLD}${CYAN}Returning to the previous menu...${NC}"
    spacing
    sleep 1
    clear
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

##function which uses regex to check if the email passed in matches the appropriate format before returning a success or failure binary
email_check() {
    emailSearch=$(grep -i -w -F "$1" records.txt)
    if [[ $1 =~ $emailRestriction ]] && [ "$emailSearch" ] ; then
        return 0 
    else
        return 1 
    fi
}

##function which allows user to remove multiple records by filtering via county
remove_by_county() {
    clear
    while [ $removeMenu ]
        do
        spacing
        read -p "Please enter the county you wish to remove from the records or press 'R' to return to the previous menu: " county
        if [ "$county" = "r" ] || [ "$county" = "R" ] ; then
            returning
            break
        elif [ "$county" != "r" ] || [ "$county" != "R" ] && [ "$county" != "" ]; then
            remove_multiple_records $county
        elif [ "$county" = "" ] ; then
            echo "${YELLOW}This field cannot be left blank. Please enter again. ${NC}"
        fi
    done
}

##function which allows the user to remove a single record via email
remove_single_record() {
    clear
    while [ $removeMenu ]
        do
        spacing
        ##sed command is used to add the headings to the output of the txt file. This is piped into column for formatting via comma delimiter.
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
        spacing
        ##user is prompted to enter the details they wish to search for or r to return. This is then stored in the input variable.
        read -p "Please enter the ${UNDERLINED}email address${NC} of the rep you wish to remove or enter 'R' to return: " input
        ##if variable is r returning function is called and loop is broken
        if [ "$input" = "r" ] || [ "$input" = "R" ] ; then
            returning
            break
        ##if statement checks if the function is returning a true (i.e 0) when using a regex check on the input email and then executes the following commands.
        elif  email_check "$input" ; then
            spacing
            ##grep is used to place the result in a new txt file for formatting with headings and columns
            grep -i -w -F "$input" records.txt >> searchresult.txt | column -t -s ","
            ##once sed command is used to present the headings appropriately in new file
            sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
            ##variable using wc -l to check line numbers of the new file and used to present user with number of potentially deleted records
            removeNum=$(cat searchresult.txt | wc -l)
            ##as we've used grep to visually output the contents of the new file, it is subsequently deleted
            rm searchresult.txt
            spacing
            ##user is then asked if they wish to delete the found records via the yes or no function
            yes_or_no $input $removeNum
        else clear
            spacing
            echo "${YELLOW}Invalid entry. Please enter one of the displayed email addresses ${NC}"
            spacing
            read -n 1 -s -r -p "${BOLD}${CYAN}Press any key to display the list and try again ${NC}" ans
            clear
        fi
    done
}

##function which takes in a user-supplied variable via a separate function and provides the same temporary visual output seen elsewhere in the script
remove_multiple_records() {
    spacing
    echo "${BOLD}${CYAN} Checking records... ${NC}"
    spacing
    sleep 1
    clear
    search=$(grep -i -w -F "$1" records.txt)
    if [ "$search" ] ; then
        spacing
        ##grep is used to place the result in a new txt file for formatting with headings and columns
        grep -i -w -F "$1" records.txt >> searchresult.txt | column -t -s ","
        ##once sed command is used to present the headings appropriately in new file
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        ##variable using wc -l to check line numbers of the new file and used to present user with number of potentially deleted records
        removeNum=$(cat searchresult.txt | wc -l)
        ##as we've used grep to visually output the contents of the new file, it is subsequently deleted
        rm searchresult.txt
        spacing
        ##user is then asked if they wish to delete the found records via the yes or no function
        yes_or_no $1 $removeNum
    else spacing   
        echo "${INVERTED}${RED} We found no matching results to remove ${NC}"
    fi
}

##function using a while loop and case to provide the user with the list of specialities and the option to remove via these
##once user selects an option it is passed to the remove_multiple_records function
remove_by_speciality() {
    while [ $removeMenu ] 
    do
        ##variable reset at the start of each loop to prevent interference with display_error
        speciality=""
        spacing
        echo "${INVERTED}${CYAN} Please select the instrumental specialty you to remove records by: ${NC}"
        echo ""
        echo "1) Guitar"
        echo "2) Piano"
        echo "3) String"
        echo "4) Wind"
        echo "5) Percussion"
        echo "6) Brass"
        echo "7) Return to the previous menu"
        read answer
        case $answer in
            1) speciality="Guitar";;
            2) speciality="Piano";;
            3) speciality="String";;
            4) speciality="Wind";;
            5) speciality="Percussion";;
            6) speciality="Brass";;
            7) returning
               break;;
            *) display_error
               ;;
        esac
        if [ $speciality != "" ] ; then 
            remove_multiple_records $speciality
        else clear
        fi
    done
}


##function which uses a while loop to check if the user wants to delete the results of the search.
yes_or_no() {
confirmation=false
##while the confirmation variable is false (which it is by default) prompts the user a y or n option.
##this option, if affirmed, uses the passed argument and sed to delete the search result from the txt file.
##a success message is echoed to the user and then the loop is broken when confirmation is declared true
##otherwise, if the user chooses n, the screen is cleared and the loop is broken. 
##error checking is also in place to ensure that all answers that are not y or n return an error message.
while ! $confirmation; 
do
    read -p "You are about to ${UNDERLINED}remove${NC} ${INVERTED}${BOLD} $2 ${NC} record(s). Do you still want to proceed? (${GREEN}${BOLD}Y${NC}/${RED}${BOLD}N${NC})? " answer
    if [ "$answer" = "Y" ] || [ "$answer" = "y" ] ; then
            sed -i "/$1/d" records.txt
            echo -e "Removing the above record(s)..."
            sleep 1
            echo "${GREEN}${BOLD}Record(s) removed${NC} "
            sleep 2
            clear
            confirmation=true
    elif [ "$answer" = "N" ] || [ "$answer" = "n" ] ; then
            loading
            break
    else echo "${YELLOW}Invalid input. Please answer 'Y' or 'N'${NC} "
    fi
done
}


##==========================================================================================================================================================
##MAIN PROGRAMME
##==========================================================================================================================================================


loading
##the outer loop in which the bulk of this scripts actions are contained
while [ $subMenu ]
do
    spacing
    echo "${INVERTED}${CYAN} R E M O V E - A - R E C O R D ${NC}"
    echo ""
    echo "${BOLD}Please select one of the following options:${NC}"
    echo ""
    echo "1) Remove records individually"
    echo "2) Remove multiple records by County"
    echo "3) Remove multiple records by instrumental speciality"
    echo "4) Return to the previous menu"
    read option
    case $option in  
        1)  loading
            remove_single_record
            ;;
        2)  loading
            remove_by_county
            ;;
        3)  loading
            remove_by_speciality
            ;;
        4)  returning
            break
            ;;
        *)  display_error
            ;;
    esac
done
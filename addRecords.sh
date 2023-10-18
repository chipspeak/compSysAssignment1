#!/bin/bash

##========================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak/compSysAssignment1
##Description: script to add to new information to records
##========================================================


##==========================================================================================================================================================
##VARIABLES
##==========================================================================================================================================================


##variables for use in while loops.
subMenu=true
question=true
instrumentCheck=false
confirmation=false
check=false

##variables for later use to check for letters or numbers via regular expressions.
numRestriction="^[0-9]{9}$"
letterRestriction="^[a-zA-z]+$"

##variable used to store the regex that will be used to validate email addresses
emailRestriction='^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$'

##an array of counties for use in error checking when adding a county.
counties=("Clare" "Cork" "Kerry" "Limerick" "Tipperary" "Waterford" "Carlow" "Dublin" "Kildare" "Kilkenny" "Laois" "Longford" "Louth" "Meath" "Offaly" "Westmeath" "Wexford" "Wicklow" "Galway" "Leitrim" "Mayo" "Roscommon" "Sligo" "Antrim" "Armagh" "Tyrone" "Derry" "Down" "Donegal" "Fermanagh" "Monaghan" "Cavan")

##variables for use in colour and text formatting
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


##function using tput command in addition to columns to substitude equals sign into character width of screen.
spacing() {
    echo " "
    printf "%*s" $(tput cols) | tr " " "=\n"
    echo " "
}

##function for use in breaking up user experience via brief load and clear.
loading() {
    spacing
    echo "${CYAN}Loading...${NC}"
    spacing
    sleep 1
    clear
}

##function to echo a message to user notifying them of menu change prior to clear and return.
exit_menu() {
    spacing
    echo "${BOLD}${CYAN}returning to the previous menu${NC}"
    spacing
    sleep 1
    clear
    exit
}

##function which takes in a user input as a variable and checks for return option, regex letter check and blank space check.
detail_check() {
    if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
    elif [ "$1" != "" ] && [[ $1 =~ $letterRestriction ]]; then
        question=false
    else echo "${YELLOW}This field cannot contain numbers, symbols or be left blank. Please enter only letters${NC}"
    fi
}

##function for use with final stage of email input. It checks that the input is appropriate via regex before returning a 0 for success or 1 for failure for use in the final check.
email_check() {
    if [[ $1 =~ $emailRestriction ]]; then
        return 0 
    else
        return 1 
    fi
}

##similar function to detail check but this regex is used to ensure only numbers are entered.
number_check() {
    if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
    elif [ "$1" != "" ] && [[ $1 =~ $numRestriction ]] ; then
        question=false
    else echo "${YELLOW}Please enter the 9 digits following +353. This field cannot be left blank. ${NC}"
    fi
}

##function to check that the user has not entered an inappropriate value or blank space in the speciality field.
speciality_check() {
    if [ "$1" = "" ] ; then
        echo "${YELLOW}Invalid entry. Please enter one of the numeric options provided. ${NC}"
    elif [ "$1" = "R" ] || [ "$1" = "r" ] ; then
    exit_menu
    else instrumentCheck=false
    fi
}

##function to check the user input matches a county within the county array.
##two variables are used as switches here to allow the loop to be exited if the input matches a county in the array
##the second variable is used in the event that the input fails to match anything in the array.
##the check is then set to false. External to the loop, an if statement is used in conjunction with the check variable
##if check is false, an error is echoed to the user explaining that the input is invalid.
county_check() {
    for i in "${counties[@]}"
    do
        if [ "$1" = "$i" ] ; then
            check=true
            question=false
            break
        elif [ "$1" = "r" ] || [ "$1" = "R" ] ; then
            exit_menu
        elif [ "$1" != "$i" ] ; then
            check=false
        fi
    done
    if [ "$check" = false ] ; then
    echo "${YELLOW}Please enter a valid Irish county, being mindful of spelling errors or blank space.${NC}"
    fi
}

##as throughout these scripts, this function creates a new file, adds the users input to it with comma delimiters as appropriate
##and then uses sed to supply headings and then outputs to the user using column for formatting before deleting the new file.
present_entry() {
        echo "$name,$company,$speciality,$city,$county,+353$phone,$email" > searchresult.txt | column -t -s ","
        ##once again the sed command are used to present the headings appropriately in new file
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        ##as we've used grep to visually output the contents of the new file, it is subsequently deleted
        rm searchresult.txt
}


##function for use in confirming entered information. The user has had the details echoed back. A y or n option is then given to them
##this function also has a nested if statement within the yes option which uses grep to search the document for a matching entry.
##if a matching entry is found the user is informed of this and the loop is broken. Otherwise the entry is added to the txt file.
yes_or_no() {
    confirmation=false
    while ! $confirmation; 
    do
        read -p "Is the above information correct(${GREEN}${BOLD}Y${NC}/${RED}${BOLD}N${NC})? " answer
        if [ $answer = "Y" ] || [ $answer = "y" ] ; then
            spacing
            check=$(grep -i -w -F "$name,$company,$speciality,$city,$county,+353$phone,$email" records.txt)
            if [ "$check" ] ; then
                echo "${YELLOW}These details are already present in the records. ${NC}"
                break
            else
                echo "$name,$company,$speciality,$city,$county,+353$phone,$email" >> records.txt
            fi
            echo "Adding details to records..."
            sleep 1
            echo "${GREEN}Details added${NC}"
            sleep 2
            clear
            confirmation=true
        elif [ $answer = "N" ] || [ $answer = "n" ] ; then
            echo "Restarting entry process..."
            sleep 1
            clear
            confirmation=true
        else echo "${YELLOW}Invalid input. Please answer'Y' or 'N' ${NC}"
        fi
    done
}


##==========================================================================================================================================================
##MAIN PROGRAMME
##==========================================================================================================================================================


##outer menu loop is set
loading
while $subMenu; 
do
    spacing
    echo "${INVERTED}${CYAN} A D D - A - N E W - R E C O R D ${NC}"
    echo ""
    ##user is prompted to enter the record details one at a time or r to return. These are then stored in the appropriate variables.
    ##then the check functions have these new variables passed into them for error checking as explained above. 
    ##the loops ensure that correct information must be entered before progressing through the system.
    ##the question variable is set back to true before each loop given the check functions set it to false upon success.
    question=true
    while $question; 
    do
        read -p "Enter the name of the rep you wish to add or enter 'R' to return: " name
        detail_check $name
    done
    question=true
    while $question; 
    do
        read -p "Enter the rep's company or enter 'R' to return: " company
        detail_check $company
    done
    question=true
    instrumentCheck=true
    ##below is a loop used to ensure that the user cannot enter innapropriate specialities via a case.
    ##the presented choices are appropriate and error checking is then easily performed.
    while $instrumentCheck; 
    do
        echo "Please select the instrumental specialty of the rep you wish to add "
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
            7) speciality="R";;
            *) speciality=""
        esac
        speciality_check $speciality
    done
    question=true
    while $question; 
    do
        read -p "Enter the city in which the rep is based or enter 'R' to return: " city
        detail_check $city
    done
    question=true
    while $question; 
    do
        read -p "Enter the county in which the rep is based or enter 'R' to return: " county
        county_check $county
    done
    question=true
    while $question; 
    do
        read -p "Enter the rep's phone number or enter 'R' to return: " phone
        number_check $phone
    done
    question=true
    ##this final check is vital as it is how the remove feature will be implemented
    ##if the email is anything other than the correct format or the letter r to return, an error message is echoed.
    while $question; 
    do
        read -p "Enter the email address of the rep or enter 'R' to return: " email
        ##passes the user input to the email_check for function for regex comparison. If a 0 is returned (success) loop is exited.
        if email_check "$email" ; then
        question=false
        ##letter r input is also accounted for lest the user wish to return to the previous menu.
        elif [ "$email" = "r" ] || [ "$email" = "R" ] ; then
            exit_menu
        ##otherwise an error message is echoed to the user prompting them to use the correct email format
        else echo "${YELLOW}Please enter a valid email in the format of example@example.com${NC}"
        fi
    done
    spacing
    ##user then has their input echoed back to them before being given a prompt before adding it to the txt file
    present_entry $name $company $speciality $city $county $phone $email
    spacing
    ##finally these variables are passed to the yes_or_no function.
    yes_or_no $name $company $speciality $city $county $phone $email
done
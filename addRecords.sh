#!/bin/bash

##========================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak
##Description: script to add to new information to records
##========================================================

##variables to be set to true for use in while loops.
subMenu=true
question=true
confirmation=false
##variables for later use to check for letters or numbers via regular expressions.
numRestriction="^[0-9]{9}$"
letterRestriction="^[a-zA-z]+$"

##function using tput command in addition to columns to substitude equals sign into character width of screen.
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

##function which takes in a read variable and checks for return option, regex letter check and blank space check.
detail_check() {
    if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
    elif [ "$1" != "" ] && [[ $1 =~ $letterRestriction ]]; then
        question=false
    else echo "This field cannot contain numbers or symbols. Please enter only letters"
    fi
}

##function for use with email field to check that it does not contain no value.
email_check() {
    if [ "$1" = "" ] ; then
        echo "This field cannot be left blank. "
    else question=false
    fi
}

##similar function to detail check but this regex is used to ensure only numbers are entered.
number_check() {
    if [ "$1" = "r" ] || [ "$1" = "R" ] ; then
        exit_menu
    elif [ "$1" != "" ] && [[ $1 =~ $numRestriction ]] ; then
        question=false
    else echo "Please enter the 9 digits following +353. This field cannot be left blank. "
    fi
}

##function for use in confirming entered information. The user has had the details echoed back. A y or n option is then given to them
##this function also has a nested if statement within the yes option which uses grep to search the document for a matching entry.
##if a matching entry is found the user is informed of this and the loop is broken. Otherwise the entry is added to the txt file.
yes_or_no() {
    ##below loop is exited via the n option or the pre-existing details break.
    confirmation=false
    while ! $confirmation; 
    do
        read -p "Is the above information correct(Y/N)? " answer
        if [ $answer = "Y" ] || [ $answer = "y" ] ; then
            spacing
            check=$(grep -i -w -F "$name,$company,$speciality,$city,$county,+353$phone,$email" records.txt)
            if [ "$check" ] ; then
                echo "These details are already present in the records. "
                break
            else
                echo "$name,$company,$speciality,$city,$county,+353$phone,$email" >> records.txt
            fi
            echo "Adding details to records..."
            sleep 1
            echo "Details added"
            sleep 2
            clear
            confirmation=true
        elif [ $answer = "N" ] || [ $answer = "n" ] ; then
            confirmation=true
        else echo "Invalid input. Please answer 'Y' or 'N' "
        fi
    done
}

##outer menu loop is set
loading
while $subMenu; 
do
    ##user is prompted to enter the record details one at a time or r to return. These are then stored in the appropriate variable.
    ##the check functions then have these new variables passed into them for error checking as explained above.
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
    while $question; 
    do
        read -p "Enter the speciality of the company or enter 'R' to return: " speciality
        detail_check $speciality
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
        detail_check $county
    done
    question=true
    while $question; 
    do
        read -p "Enter the rep's phone number or enter 'R' to return: " phone
        number_check $phone
    done
    question=true
    while $question; 
    do
        read -p "Enter the email address of the rep or enter 'R' to return: " email
        email_check $email
    done
    spacing
    ##user then has their input echoed back to them before being given a prompt before adding it to the txt file
    echo "NAME:$name
COMPANY:$company
SPECIALTY:$speciality
CITY:$city
COUNTY:$county
PHONE:$phone
EMAIL:$email"
    spacing
    ##finally these variables are passed to the yes_or_no function.
    yes_or_no $name $company $speciality $city $county $phone $email
done
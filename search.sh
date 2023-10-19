#!/bin/bash

##=================================================================================
##Author: Patrick O'Connor
##Student number: 20040412
##github: https://github.com/chipspeak/compSysAssignment1
##Description: script to filter through txt file and find specific details via menu
##=================================================================================


##==========================================================================================================================================================
##VARIABLES
##==========================================================================================================================================================


##variables for use within menu loops
subMenu=true
searchMenu=true
mainMenu=true

##arrays for use in the search menus
munster=("clare" "cork" "Kerry" "limerick" "tipperary" "waterford")
leinster=("carlow" "dublin" "kildare" "kilkenny" "laois" "longford" "louth" "meath" "offaly" "westmeath" "wexford" "wicklow")
connacht=("galway" "leitrim" "mayo" "roscommon" "sligo")
ulster=("antrim" "armagh" "tyrone" "derry" "down" "donegal" "fermanagh" "monaghan" "cavan")

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

##function similar to loading but for returning to previous menus
returning() {
    spacing
    echo "${BOLD}${CYAN}Returning to the previous menu...${NC}"
    spacing
    sleep 1
    clear
}

##function for use in formatting the submenu results.
answer_formatting() {
    spacing
    sleep 1
    clear
    spacing
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

##the simplest of the functions, this yields a full display of the current record to the user via sed.
##user is also supplied with a total number of reps via variable created using -n to suppress sed output
##and $= to check the final line of the file, thus providing the total number.
view_all_records() {
    spacing
    ##sed command is used to add the headings to the output of the txt file. This is piped into colum for formatting via comma delimiter
    sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' records.txt | column -t -s ","
    repnum=$(sed -n '$=' records.txt)
    spacing
    echo "${INVERTED}${GREEN} There are a total of $repnum sales reps currently on record. ${NC}"
}

##broad search where the user can enter any word or number and filter the file via this entry.
search_by_word() {
##loop is set
while $searchMenu; 
do
    spacing
    ##user is prompted to enter their word or number of choice or r to return. This is then stored in the input variable.
    read -p "Please enter the word (i.e name, instrument, location etc) that you wish to search for or enter 'R' to return: " input
    while [ "$input" = "" ] ; 
    do
        echo "${YELLOW}Invalid entry. This field cannot be left blank. ${NC}"
        read -p "Please enter the word or number you wish to search for or enter 'R' to return: " input
    done
    if [ $input = "r" ] || [ $input = "R" ] ; then
        returning
        break
    fi
    ## search variable uses grep -i -w to check for the input variable for appearances in the txt file.
    search=$(grep -i -w -F "$input" records.txt)
    ##if statement checks if the variable is true i.e the search returns a true result
    if [ "$search" ] ; then
    ## echos a loading message to the user.
        echo "${BOLD}${GREEN}Returning result(s) for $input...${NC}"
        spacing
        sleep 1
        ##the result of the search is placed into a new text file and then piped into the column command for formatting
        grep -i -w -F "$input" records.txt >> searchresult.txt | column -t -s ","
        ##sed command is used to add the headings to the output of the txt file. This is piped into colum for formatting via comma delimiter
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' searchresult.txt | column -t -s ","
        ##the newly created file is then deleted.
        rm searchresult.txt
    elif [ ! "$search" ] && [ "$input" != "r" ] && [ "$input" != "R" ] ; then
    ## otherwise returns that the search could not be found and the process restarts.
        spacing
        echo "${BOLD}${RED}No results found for your search.${NC}"
    fi
done
}

##function that will be called upon choice of a specific province.
display_province_results() {
    ##The elements of the province array are passed into the function before being iterated through via a for loop
    ##this array then uses the grep command to search the records file for whole-words, case insensensitive matches
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
        echo "${INVERTED}${GREEN} There are a total of $repnum sales representatives in this province. ${NC}"
        rm province.txt
    ##otherwise (meaning the txt file has no data) user is informed that there are no reps in this area.
    else
        echo "${INVERTED}${RED} There are currently no sales reps operating in this province on record. ${NC}"
        rm province.txt
    fi
}

##function that will be called upon choice of a specific instrument type.
display_specialist_results() {
    ##this function follows a similar logic to display_province_results but rather than an array it takes a single user-supplied variable.
    ##it once again uses the creation of a separate text file to provide user-friendly formatting for the output
    grep -i -w -F "$1" records.txt >> instruments.txt
    ##this if statement checks if the txt file contains data and if so, uses sed to add headings before outputting to user
    ##additionally, sed is used to check for the number of reps in the records that specialise in this particular instrument type
    if [ -s instruments.txt ] ; then
        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' instruments.txt | column -t -s ","
        repnum=$(sed -n '$=' instruments.txt)
        spacing
        echo "${INVERTED}${GREEN} There are a total of $repnum sales representatives specialising in $1 instruments. ${NC}"
        rm instruments.txt
    ##otherwise (meaning the txt file has no data) user is informed that there are no reps who specialise in the instrument type in question.
    else
        echo "${INVERTED}${RED} There are currently no $1 instrument specialists on record. ${NC}"
        rm instruments.txt
    fi
}

##This function presents a while loop case where the user is echoed choices of province or return.
province_options() {
while [ $subMenu ] 
do
    spacing
    echo "${INVERTED}${CYAN} Please select the province you wish to locate sales reps in: ${NC}"
    echo ""
    echo "1) Munster"
    echo "2) Leinster"
    echo "3) Connacht"
    echo "4) Ulster"
    echo "5) Return to the previous menu"
    read answer
    ##once user chooses an option the display_province_results function has the answer passed to it in the form of an array of the counties contained in said province.
    ##a loading message is echoed before the answer_formatting function is called.
    ##the province array is then passed into the display_province_results function.
    case $answer in
        1) spacing
            echo "${BOLD}${GREEN}Loading representatives based in Munster...${NC}"
            answer_formatting
            display_province_results "${munster[@]}"
            ;;
        2) spacing
            echo "${BOLD}${GREEN}Loading representatives based in Leinster...${NC}"
            answer_formatting
            display_province_results "${leinster[@]}"
            ;;
        3) spacing
            echo "${BOLD}${GREEN}Loading representatives based in Connacht...${NC}"
            answer_formatting
            display_province_results "${connacht[@]}"
            ;;
        4) spacing
            echo "${BOLD}${GREEN}Loading representatives based in Ulster...${NC}"
            answer_formatting
            display_province_results "${ulster[@]}"
            ;;
        5) subMenu=false
            returning
            break 
            ;;
        *)  display_error
            ;;
    esac
done
}

##once again this function works similarly to the province version but instead provides a choice of instrumental specialities. 
speciality_options() {
while [ $subMenu ] 
do
    spacing
    echo "${INVERTED}${CYAN} Please select the instrumental specialty you wish to search for: ${NC}"
    echo ""
    echo "1) Piano"
    echo "2) Guitar"
    echo "3) String"
    echo "4) Wind"
    echo "5) Percussion"
    echo "6) Brass"
    echo "7) Return to the previous menu"
    read answer
    ##once user chooses an option the display_specialist_results function has the answer passed to it.
    ##again, the logic is the same as the prior function re formatting and loading message etc
    case $answer in
        1) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Piano...${NC}"
            answer_formatting
            display_specialist_results piano
            ;;
        2) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Guitar...${NC}"
            answer_formatting
            display_specialist_results guitar 
            ;;
        3) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Strings...${NC}"
            answer_formatting
            display_specialist_results string
            ;;
        4) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Wind...${NC}"
            answer_formatting
            display_specialist_results wind
            ;;
        5) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Percussion...${NC}"
            answer_formatting
            display_specialist_results percussion
            ;;
        6) spacing
            echo "${BOLD}${GREEN}Loading reps specialising in Brass...${NC}"
            answer_formatting
            display_specialist_results brass
            ;;
        7) subMenu=false
            returning
            break 
            ;;
        *)  display_error
            ;;
    esac
done
}


##==========================================================================================================================================================
##MAIN PROGRAMME
##==========================================================================================================================================================


loading
##outer menu for selecting a search type.
##in a similar way to the main menu, the users choice is used to lead to a different menu-loop. 
##in contrast to the main menu these choices lead to the  core functions listed above rather than sub-scripts.
while [ $mainMenu ]
do
    spacing
    echo "${INVERTED}${CYAN} S E A R C H - M E N U ${NC}"
    echo ""
    echo "${BOLD}Please select one of the following options:${NC}"
    echo ""
    echo "1) Search by word"
    echo "2) Search by instrumental speciality"
    echo "3) Search by province"
    echo "4) View all records"
    echo "5) Return to the previous menu"
    read option
    case $option in  
        1)  loading
            search_by_word
            ;;
        2)  loading
            speciality_options
            ;;
        3)  loading
            province_options
            ;;
        4)  loading
            view_all_records
            ;;
        5)  returning
            break
            ;;
        *)  display_error
            ;;
    esac
done
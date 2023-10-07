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

spacing() {
        echo " "
        printf "%*s" $(tput cols) | tr " " "=\n"
        echo " "
}

display_province_results() {
        if [ "$1" = "munster" ] ; then
                for i in "${munster[@]}"
                        do
                        grep -i -w -F "$i" records.txt >> munster.txt
                done
                if [ -s munster.txt ] ; then
                        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' munster.txt | column -t -s ","
                        echo " "
                        repnum=$(sed -n '$=' munster.txt)
                        echo "There are a total of $repnum sales representatives in Munster "
                        rm munster.txt
                else
                        echo "There are currently no Munster-based sales reps in the records "
                fi
        elif [ "$1" = "leinster" ] ; then
                for i in "${leinster[@]}"
                        do
                        grep -i -w -F "$i" records.txt >> leinster.txt
                done
                if [  -s leinster.txt ] ; then
                        sed '1 i\NAME,COMPANY,SPECIALTY,CITY,COUNTY,PHONE,EMAIL' leinster.txt | column -t -s ","
                        echo " "
                        repnum=$(sed -n '$=' leinster.txt)
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
                        echo " "
                        repnum=$(sed -n '$=' connacht.txt)
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
                        echo " "
                        repnum=$(sed -n '$=' ulster.txt)
                        echo "There are a total of $repnum sales representatives in Ulster "
                        rm ulster.txt
                else
                        echo "There are currently no Ulster-based sales reps in the records "
                fi
        fi
}

county_options() {

while [ $subMenu ]
do

echo "Please select the province you wish to locate sales reps via "

echo "1) Munster"
echo "2) Leinster"
echo "3) Connacht"
echo "4) Ulster"
echo "5) Return to the previous menu"

read answer

case $answer in
        1) spacing
           echo "Loading representatives based in Munster..."
           spacing
           sleep 1
           clear
           spacing
           display_province_results munster
           spacing ;;
        2) spacing
           echo "Loading representatives based in Leinster..."
           spacing
           sleep 1
           clear
           spacing
           display_province_results leinster
           spacing ;;
        3) spacing
           echo "Loading representatives based in Connacht..."
           spacing
           sleep 1
           clear
           spacing
           display_province_results connacht
           spacing ;;
        4) spacing
           echo "Loading representatives based in Ulster..."
           spacing
           sleep 1
           clear
           spacing
           display_province_results ulster
           spacing ;;
        5) subMenu=false
           spacing
           echo "Returning to previous menu..."
           spacing
           sleep 1
           clear
           break ;;
        *) echo "Invalid option. Please select one of the supplied numbers. "
        esac
done
}

spacing
echo "Loading..."
spacing
sleep 1
clear
PS3='Choose whether you wish to 1) Check reps by province, 2) Remove a record, 3) Search records, 4) Check records or 5) Return to the previous menu: '
options=("Check reps by province" "Remove a record" "Search records" "Check records" "Return to the previous menu")
select opt in "${options[@]}"
do
    case $opt in
        "Check reps by province")
                spacing
                echo "Loading..."
                spacing
                sleep 1
                clear
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
            ##exit
            ;;
        *)  spacing
            echo "invalid option, please select one of the numeric options"
            spacing
            ;;
    esac
done
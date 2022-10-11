#! /usr/bin/bash

# This function takes table name as an argument
# It Prints two string (attributes names and attributes data types)
function showTableMetaData() {
    echo -e "
----------------------------------------------------------------------------------------
$tableName has $numOfColumns columns which are:
----------------------------------------------------------------------------------------"
    echo -e "$(sed -n '1,2p' "$tableName")
----------------------------------------------------------------------------------------
    "
}

function insertIntoTable() {
    numOfColumns=$(awk -F: 'END{print NF}' "$tableName")
    # echo "$numOfColumns"
    newRow=""
    showTableMetaData
    echo -e "---------- You are inserting into $tableName ----------
Notice: the first column is your primary key that must be unique.
    "
    for ((i = 1; i <= "$numOfColumns"; i++)); do

        # Get each attribute name VS its data type
        currentAttName=$(awk -F: -v x="$i" '{if(NR == 1){
            print $x
        }}' "$tableName")

        currentAttDataType=$(awk -F: -v x="$i" '{if(NR == 2){
            print $x
        }}' "$tableName")
        echo -e "$currentAttName is of type $currentAttDataType"

        if [[ $i == 1 ]]; then
            read -rp "Enter ($currentAttName) of Type ($currentAttDataType)
            Notice: it must be unique because it is the primary key!
            " currentUserInput

            # checkInput column "$currentUserInput" ". insertData.sh"

            # check if the entered values matches column type
            checkPassedMetaData "$currentUserInput"
            isMatched=$?
            if [[ $currentAttDataType == "string" ]]; then
                if [[ $isMatched == 110 ]]; then
                    # echo "string is matched!"
                    true
                elif [[ $isMatched == 111 ]]; then
                    echo -e "
                    --------------------------------------------------------------------------
                    you have entered an int value ($currentAttName) only accepts string values
                    --------------------------------------------------------------------------
                    "
                    return 110
                fi
            elif [[ $currentAttDataType == "int" ]]; then

                if [[ $isMatched == 111 ]]; then
                    # echo "int is matched!"
                    true
                elif [[ $isMatched == 110 ]]; then
                    echo -e "
                    --------------------------------------------------------------------------
                    you have entered a string value ($currentAttName) only accepts int values
                    --------------------------------------------------------------------------
                    "
                    return 110
                fi
            fi

            checkredandancy=$(awk -F: -v x="$currentUserInput" 'BEGIN{
                check=0
            }{if($1 == x){
                check=1
            }}END{print check}' "$tableName")

            if [[ $checkredandancy == 0 ]]; then
                if [[ $i == 1 ]]; then
                    newRow+="$currentUserInput"
                else
                    newRow+=":$currentUserInput"
                fi
            else
                echo -e "
----------------------------------------------------------------------------------------               
This value is already exists, Primary keys is unique please choose a unique one
----------------------------------------------------------------------------------------"
                return 110
            fi
        else
            read -rp "Enter ($currentAttName) of Type ($currentAttDataType)
            " currentUserInput
            # checkInput column "$currentUserInput" ". insertData.sh"

            # check if the entered values matches column type
            checkPassedMetaData "$currentUserInput"
            isMatched=$?
            if [[ $currentAttDataType == "string" ]]; then
                if [[ $isMatched == 110 ]]; then
                    # echo "string is matched!"
                    true
                    if [[ $i == 1 ]]; then
                        newRow+="$currentUserInput"
                    else
                        newRow+=":$currentUserInput"
                    fi
                elif [[ $isMatched == 111 ]]; then
                    echo -e "you have entered an int value ($currentAttName) only accepts string values"
                    return 110
                fi
            elif [[ $currentAttDataType == "int" ]]; then

                if [[ $isMatched == 111 ]]; then
                    # echo "int is matched!"
                    true
                    if [[ $i == 1 ]]; then
                        newRow+="$currentUserInput"
                    else
                        newRow+=":$currentUserInput"
                    fi
                elif [[ $isMatched == 110 ]]; then
                    echo -e "you have entered a string value ($currentAttName) only accepts int values"
                    return 110
                fi
            fi

        fi

    done
    echo "$newRow" >>"$tableName"
}

# echo -e "\n\nHello from insert into Table\n"
listTables
read -rp "Enter A valid table name that you want to insert values in it or type 'exit' to quit
Notice: Spaces will be replaced with underScore character
" tableName
tableName=${tableName// /_}

checkInput table "$tableName" ". insertData.sh"

checkExistance file "$tableName"

checkExistanceResult=$?

if [[ $checkExistanceResult == 111 ]]; then
    # echo "exits"
    insertIntoTable
    isInsertionFinish=$?
    # echo " the return number is $isInsertionFinish"

    while [[ $isInsertionFinish == 110 ]]; do
        # echo " the return number from inside is $isInsertionFinish"
        insertIntoTable
        isInsertionFinish=$?
    done
    . DMLMenue.sh
elif [[ $checkExistanceResult == 110 ]]; then
    echo -e "The table you have entered is not exits, Please choose another one\n\n"
    . insertData.sh
fi

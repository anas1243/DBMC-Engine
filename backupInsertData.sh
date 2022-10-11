#! /usr/bin/bash

# This function takes table name as an argument
# It Prints two string (attributes names and attributes data types)
function showTableMetaData() {
    echo -e "$tableName has $numOfColumns columns which are:"
    echo -e "$(sed -n '1,2p' "$tableName")"
}
#this function takes three arguments:
#1- current table name
#2- current(actual) attribute datatype
#3- Passed (that user want to enter in the DB) attribute datatype
function checkPassedMetaData() {
    case $3 in
    \\)
        echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
        return 110
        ;;
    +([0-9]))
        if [[ $2 == "int" ]]; then
            echo -e "Matched"
            return 111
        elif [[ $2 == "string" ]]; then
            echo -e "you have entered an int value ($1) only accepts string values"
            return 110
        fi
        ;;
    *)
        if [[ $2 == "int" ]]; then
            echo -e "you have entered a string value ($1) only accepts int values"
            return 110
        elif [[ $2 == "string" ]]; then
            echo -e "Matched"
            return 111
        fi
        ;;
    esac
}

function insertIntoTable() {
    numOfColumns=$(awk -F: '{print NF; exit}' "$tableName")
    echo "$numOfColumns"
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
            checkPassedMetaData "$currentAttName" "$currentAttDataType" "$currentUserInput"

            isPrimaryMatched=$?
            echo " the return number is $isPrimaryMatched from primary condition is matched ??"

            while [[ $isPrimaryMatched == 110 ]]; do
                echo " the return number from inside is $isPrimaryMatched primary condition"
                insertIntoTable
                isPrimaryMatched=$?
            done

            # isMatched=$?
            # if [[ $currentAttDataType == "string" ]]; then
            #     if [[ $isMatched == 110 ]]; then
            #         echo "string is matched!"
            #     elif [[ $isMatched == 111 ]]; then
            #         echo -e "you have entered an int value ($currentAttName) only accepts string values"
            #         return 110
            #     fi
            # elif [[ $currentAttDataType == "int" ]]; then

            #     if [[ $isMatched == 111 ]]; then
            #         echo "int is matched!"
            #     elif [[ $isMatched == 110 ]]; then
            #         echo -e "you have entered a string value ($currentAttName) only accepts int values"
            #         return 110
            #     fi
            # fi

            redundancycheck=$(awk -F: -v x="$currentUserInput" 'BEGIN{
                check=0
            }{if($1 == x){
                check=1
            }}END{print check}' "$tableName")

            if [[ $redundancycheck == 0 ]]; then
                newRow+="$currentUserInput"
                echo -e "the value of new row in itiration # $i is $newRow"
            else
                echo -e "This value is already exists, Primary keys is unique please choose a unique one"
                return 110
            fi
        else
            read -rp "Enter ($currentAttName) of Type ($currentAttDataType)
            " currentUserInput
            # checkInput column "$currentUserInput" ". insertData.sh"

            # check if the entered values matches column type
            checkPassedMetaData "$currentAttName" "$currentAttDataType" "$currentUserInput"

            isMatched=$?
            echo " the return number is $isMatched from NOT primary key is matched ???"

            while [[ $isMatched == 110 ]]; do
                echo " the return number from inside is $isMatched from Not primary key"
                insertIntoTable
                isMatched=$?
            done

            newRow+=":$currentUserInput"

        fi

    done
    echo "$newRow" >>"$tableName"
}

echo -e "\n\nHello from insert into Table\n"
listTables
read -rp "Enter A valid table name that you want to insert values in it or type 'exit' to quit
Notice: Spaces will be replaced with underScore character
" tableName
tableName=${tableName// /_}

checkInput table "$tableName" ". insertData.sh"

checkExistance file "$tableName"

checkExistanceResult=$?

if [[ $checkExistanceResult == 111 ]]; then
    echo "exits"
    insertIntoTable
    isInsertionFinish=$?
    echo " the return number is $isInsertionFinish from is finish ?!"

    while [[ $isInsertionFinish == 110 ]]; do
        echo " the return number from inside is $isInsertionFinish from is finish"
        insertIntoTable
        isInsertionFinish=$?
    done
elif [[ $checkExistanceResult == 110 ]]; then
    echo -e "The table you have entered is not exits, Please choose another one\n\n"
    . insertData.sh
fi

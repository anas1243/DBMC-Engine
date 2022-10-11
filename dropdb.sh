#! /usr/bin/bash
echo -e "
-------------------- You Are Droping A DataBase --------------------

Write the name of database you want to Delete from the list below or type 'exit' to quit
Notice: Spaces will be replaced with under score character"

#Show all available databases inside 'databases' directory
listDatabases

read -r databaseName

databaseName=${databaseName// /_}
# echo "$databaseName"

checkInput database "$databaseName" ". connectdb.sh"
# pwd
checkExistance directory "$databaseName"

checkExistanceResult=$?

if [[ $checkExistanceResult == 111 ]]; then
    # echo "hey now"
    # pwd
    rm -r "$databaseName"
    cd ..
    . main.sh
elif [[ $checkExistanceResult == 110 ]]; then
    echo -e "The Database you have entered is not exits, Please choose another one\n\n"
    . dropdb.sh
fi

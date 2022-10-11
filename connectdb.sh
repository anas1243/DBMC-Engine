#! /usr/bin/bash
echo -e "
-------------------- You Are Connecting To a Database --------------------

Write the name of database you want to connect to from the list below or type 'exit' to quit
Notice: Spaces will be replaced with under score character
"

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
    checkPermission "$1" "$2"
    checkPermissionResult=$?

    if [[ $checkPermissionResult ]]; then

        cd "$databaseName" || true
        # pwd
        . DMLMenue.sh "$databaseName"

    elif [[ $checkPermissionResult == 110 ]]; then
        echo "Your file doen't take the right permissions, your OS will ask for your password to give the directory the needed permissions"
        sudo chmod 770 "$2"
        cd "$databaseName" || true
        # pwd
        . DMLMenue.sh "$databaseName"
    fi
elif [[ $checkExistanceResult == 110 ]]; then
    echo -e "The Database you have entered is not exits, Please choose another one\n\n"
    cd ..
    . main.sh
fi

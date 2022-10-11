#! /usr/bin/bash

# echo " your avalible table in your database : "

# if [[ ls ./database/$dbname/ | wc -l = 0 ]]
# then
#     echo  "No Table Found"
#     source menu.sh
# else

#     ls ./database/$dbname |find . -type f
# fi
# read -rp "pleace enrer the name of table you want to drob "
# #check the name
# #check if exist or not
# rm $table_name

#! /usr/bin/bash

#Show all available tables inside a Certain database
listTables
echo -e "------------------------ You Are Droping table ------------------------"
read -rp "Write the name of the table you want to Delete to from the list below or type 'exit' to quit
Notice: Spaces will be replaced with under score character" tableName

tableName=${tableName// /_}
# echo "$tableName"

checkInput table "$tableName" ". dropTable.sh"
# pwd
checkExistance file "$tableName"

checkExistanceResult=$?

if [[ $checkExistanceResult == 111 ]]; then
    # echo "hey now"
    # pwd
    rm "$tableName"
    . DMLMenue.sh
elif [[ $checkExistanceResult == 110 ]]; then
    echo -e "The table you have entered is not exits, Please choose another one\n\n"
    . dropTable.sh
fi

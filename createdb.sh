#! /usr/bin/bash

# It takes 3 inputs
# what you want to check (Database, table or column)
# DatabaseName, tableName or ColumnName
# Where to go if the input is wrong

read -rp "
-------------------- You Are Creating A New DataBase --------------------

Enter A valid database name that you want to create or type 'exit' to quit
Notice: Spaces will be replaced with underScore character
" databaseName
databaseName=${databaseName// /_}

checkInput database "$databaseName" ". createdb.sh"

create directory "$databaseName" newdb
# echo "form create db"
# pwd
cd ../..
# pwd
# . dbMainPage.sh
. main.sh

#! /usr/bin/bash

echo -e "-------------------- You Are Creating Table in '$1' Database --------------------
"
read -rp "Enter A valid table name that you want to create or type 'exit' to quit
Notice: Spaces will be replaced with underScore character
" tableName
tableName=${tableName// /_}

checkInput table "$tableName" ". createTable.sh"
create "file" "$tableName" ". createTable.sh"
. createColumn.sh "$tableName"

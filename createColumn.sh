#! /usr/bin/bash
# echo "Hello from create column"
#to insert a new column in a table we must take table name: from create Table
TableName=$1

#It takes no arguments and sets the data type of a certain column
function setColumnDataType() {
    read -rp "choose ($columnName) data type :
            1) Integer
            2) String
            " columnType

    case $columnType in
    \\)
        echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
        setColumnDataType
        ;;
    1) columnType="int" ;;
    2) columnType="string" ;;
    *)
        echo -e "invalid column data type/nEnter it again"
        setColumnDataType
        ;;
    esac

}
function setColumnName() {
    for ((i = 1; i <= "$numberOfColumns"; i++)); do

        read -rp "
        Enter the name of the column number '$i': 
        " columnName

        columnName=${columnName// /_}
        checkInput column "$columnName" ". createColumn.sh"

        #check the existance of the column
        if [[ $names == *"$columnName"* ]]; then
            echo -e "you have entered this column before\nPlease enter a correct columns name again"
            . createColumn.sh "$TableName"
        fi

        #to remove the last ':' in the line
        if [[ $i == "$numberOfColumns" ]]; then
            names+="$columnName"
            setColumnDataType
            types+="$columnType"
        else
            names+="$columnName:"
            setColumnDataType
            types+="$columnType:"
        fi
        echo "column type is $columnType"
        echo "check the value of table name is: $TableName"
    done
}
# Its takes one argument which is number of column that should be inserted in a certain table
# It allows you to insert all meta data in a certain table
createTableMetaData() {
    #variable carries all attributes name to append them in the table in a row
    names=""
    #variable carries all attributes datatype to append them in the table in a row
    types=""
    setColumnName
    echo -e "
    OS may ask you for your password to give table the right permissions
    "
    touch "$TableName"
    sudo chmod 660 "$TableName"
    echo "$names" >>"$TableName"
    echo "$types" >>"$TableName"

}

read -rp 'Please enter number of columns in your table: ' numberOfColumns
numberOfColumns=${numberOfColumns// /}
case $numberOfColumns in
\\)
    echo -e "You Have Entered the escape character, Please Enter a valid input\n"
    . createColumn.sh
    ;;
+([1-9])*([0-9]))
    # echo "Integer "
    echo -e "Enter your attributes names one by one\n\nNotice: the first attribute is the primary key\n"
    createTableMetaData
    . DMLMenue.sh
    ;;
*)
    echo -e "Invalid input\nplease Enter a numeric value of columns in your table again
    "
    . createColumn.sh
    ;;
esac

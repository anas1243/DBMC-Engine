#! /usr/bin/bash

# It takes no arguments
# It prints all available tables(files) in the current location
function listTables() {
    # Using commands substitution, check if it returns an empty result of not
    echo -e "------------------------ Availible Tables ------------------------"

    if [[ $(find . -type f | sed 's/.\///') ]]; then
        find . -type f | sed 's/.\///'
        # echo -e "\n"
    else
        echo -e "You Don't Have Tables in this database yet\n"
    fi
    echo -e "--------------------------------------------------------------------"
}
function checkPassedMetaData() {
    case $1 in
    +([0-9]))
        return 111
        ;;
    *)
        return 110
        ;;
    esac
}

#----------------------------------------function name------------------------------------------------
#listTables   =>list all table
#checkInput database|table|coulnm "$(database|table|coulnm)name" "target" =>check syntax
#checkExistance file|dir "$(database|table)Name"  =>check existance 111
#checkresult =>111

#CheckColunmExistance coulnmname tablename target
#checkNumberOfColunms  =>check the number of colunms (is digit)

#----------------------------------------check Coulnm is exist------------------------------------------------
#$1 => culonm name to evaluate ColumnNumber
#$2 => table name to evaluate numberOfColunms
#$3 => target if Check of Colunm Existance is false

function CheckColunmExistance() {
    numberOfColunmsExists=$(awk -F: 'END{print NF}' "$2")

    currentAttName=$(awk -F: '{if(NR == 1){
            print $0
        }}' "$2")
    if [[ $currentAttName == *"$1"* ]]; then
        echo "Check Colunm Existance done"
    else
        echo "Column name you have entered doesn't exists, please enter a correct column name"
        $3
    fi
}

#------------------------------------------------------------------------------------------------------------
#------------------------------------------checkNumberOfColunms------------------------------------------------

#Function check the number of colunms (is digit)
function checkNumberOfColunms() {
    #$1 =>argument  (numberOfColunms) user will enter
    #$2 =>argument   table name to callculate (numberOfColunms) exact in my table
    #$3 =>argument   Target if Failed
    case $1 in
    \\)
        echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
        $3
        ;;
    +([1-9]))
        numberOfColunmsExact=$(awk -F: 'END{print NF}' "$2")
        if (($1 > $numberOfColunmsExact)); then
            echo "there is no column with that number! please enter a valid number "
            $3
        fi
        ;;
    *)
        echo "you have entered an invalid input"
        . selectFromTable.sh
        ;;
    esac
}

#_____________________________________________________________________________________________________________
#____________________________________where condtion #Coulnms_________________________________________________________________________

#select * from emp where id(condtionColunmName) =(condtionOperator) 1(condtionCoulnmValue)
#condtionColunmName
#read colunmUnderCondtion (where) => check =>exist .
#condtionOperator =>
#condtionCoulnmValue=> check=> exis with (RowYouWantTo)=>id=5

#check condtion culnm and value
function condtionCoulnm() {

    read -rp "enter the number of condtion coulnm you want to Restrict with them " numberOfContionColunms

    #******************check Coulnm number is (A digit)*******************************

    #Function take 3 arg : to combare it with Nf   *table name to calc Nf  *if condtion failed
    checkNumberOfColunms $numberOfContionColunms $tableName selectMenu

    for ((i = 1; i <= $numberOfContionColunms; i++)); do
        read -rp "enter The Name Of Coulnm Number $i You Want To display in $tableName Table :": condtionColunmName

        #******************check Coulnm Name Syntax*******************************
        checkInput table "colunm" "$condtionColunmName" "condtionCoulnm"

        #******************check Coulnm existance*******************************
        CheckColunmExistance $condtionColunmName $tableName condtionCoulnm

        condtionColunmNumber=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++)
                        {if($i=="'$condtionColunmName'") print i}}}' $tableName)
        if [[ $condtionColunmNumber == "" ]]; then
            echo "Column name you have entered doesn't exists"
            condtionCoulnm
        else
            read -rp " Enter required VALUE:" condtionCoulnmValue
            #TODO check the type

            RowYouWantTo=$(awk -v x=$condtionColunmNumber 'BEGIN{FS=":"}
                            {if($x=="'$condtionCoulnmValue'") print $0,"\n"}
                          ' "$tableName")
            if [[ $RowYouWantTo == "" ]]; then
                echo "Data You Want To Display Dosen't Exsit In $tableName table "
                condtionCoulnm
            else

                echo "your condtion you select to restrection your data is true"

            fi
        fi
    done
}

echo -e "
-------------------- Welcome To $1 Database --------------------"
read -rp "
Select one numeric option from below or exit to quit
1) Create Table
2) List Available Tables
3) Drop Table
4) Insert Into Table
5) Select From Table
6) Delete From Table
7) Update Table 
8) exit

" opt

opt=${opt// /_}
case $opt in
\\)
    echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
    . DMLMenue.sh
    ;;
1)
    . createTable.sh $1
    ;;
2)
    listTables
    . DMLMenue.sh
    ;;
3)
    . dropTable.sh
    ;;
4)
    . insertData.sh
    ;;
5)
    . selectFromTable.sh
    ;;
6)
    . removeFromTable.sh
    ;;
7)
    . updatetable.sh
    ;;
8)
    echo -e "Thank you for using our DBMS Engine!\n"
    exit
    ;;
*)
    echo -e "You Have Entered a wrong value, Please choose integer values from 1 to 8 according to your choice\n"
    cd ..
    . DMLMenue.sh
    ;;
esac

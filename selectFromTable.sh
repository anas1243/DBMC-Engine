#! /usr/bin/bash

#------------------------------------------------------------------------------------------------------
#-------------------------------------check condtion Operator------------------------------------------------
#$1 => operator user will enter it
#$2 => target if Check of Colunm Existance is false
function checkOperator() {
  echo "hello from check"
  case "$1" in
  \\)
    echo -e "You Have Entered the escape character, Please Enter a valid operator\n"
    $2
    ;;

  +([0-9])*)
    echo -e "You Have Entered Numirc Value, Please Enter a valid operator\n"
    $2
    ;;
  *+(["'"'@''#''$''%''^''&''*''('')''-''+''/''`''~''.'';'':'',''['']''{''}''"'\\])*)
    echo -e "operator name should Not contain special characters\n"
    $3s
    ;;
  [a-zA-z]*([a-zA-Z_]))
    echo -e "You Have Entered string Value, Please Enter a valid operator\n"
    $3
    ;;
  *)
    if [[ $condtionOperator == "==" ]] || [[ $condtionOperator == "!=" ]] ||
      [[ $condtionOperator == ">" ]] || [[ $condtionOperator == "<" ]] ||
      [[ $condtionOperator == ">=" ]] || [[ $condtionOperator == "<=" ]]; then
      echo -e "You Have Enter true operator"
    else
      echo -e "You Have Entered invalid operator, Please Reenter your Selection Again\n"
      $2
    fi
    ;;
  esac

}
#-------------------------------------select Menu--------------------------------------------------------------------
function selectMenu() {
  read -rp "
    Select one numeric  option from below to display $tableName table data :
    1) Display All Data of a Table           
    2) Display Specific Column from a Table     
    3) Display Data From Table under Restriction       
    4) Back To DML Menu                     
    5) Back To DDL Menu                       
    6) Exit " opt

  opt=${opt// /_}
  case $opt in
  \\)
    echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
    . selectFromTable.sh
    ;;
  1) selectAllData ;;
  2) selectSpecificsColunm ;;
  3) colunmUnderCondtion ;;
  4) . DMLmenue.sh ;;
  5) . main.sh ;;
  6) exit ;;
  *)
    echo " Wrong Choice "
    selectMenu
    ;;
  esac
}

#_____________________________________________________________________________________________________________
#__________________________________________select All Coulnm data_____________________________________________________________

#select * from emp
function selectAllData() {
  echo "---------------------------------$tablename--------------------------------------------------------------------"
  sed '2d' $tableName
  selectMenu
}

#_____________________________________________________________________________________________________________
#__________________________________________select Specific #Colunm_____________________________________________________________

#select id (colunmName) from emp(tablename)
#select id (colunmName) name(colunmName)from emp(tablename)
#numberOfColunms => coulnms you want to display
function selectSpecificsColunm() {
  echo "$tableName Table Contain this colunms :"
  echo "--------------------------------------------------------------------------------------"
  sed -n '1p' $tableName
  echo "--------------------------------------------------------------------------------------"

  read -rp "enter the number of specifc coulnm you want to display " numberOfColunms

  #******************check Coulnm number is (A digit)*******************************

  #Function take 3 arg : to combare it with Nf   *table name to calc Nf  *if condtion failed
  checkNumberOfColunms $numberOfColunms $tableName selectMenu
  echo $numberOfColunms

  # for ((i = 1; i <= $numberOfColunms; i++)); do
  i=1
  while ((i <= $numberOfColunms)); do
    echo "iteration is $i"
    read -rp "Enter The Name Of Coulnm Number $i You Want To display in $tableName Table :" colunmName

    #******************check Coulnm Name Syntax*******************************
    checkInput "column" "$colunmName" ". selectSpecificsColunm.sh"

    ##******************check Coulnm existance*******************************
    CheckColunmExistance $colunmName $tableName selectSpecificsColunm

    colunmNumber=$(awk 'BEGIN{FS=":"}    
                 {if(NR==1)
                 {for(x=1;x<=NF;x++)
                 {if($x=="'$colunmName'" )    print x}}  }' $tableName)
    echo "$colunmName---------------------------------------------------------------------------------------------"

    awk 'BEGIN{FS=":"}{print $'$colunmNumber'}' $tableName | sed '1,2d'
    i=$(($i + 1))
  done
}

#_____________________________________________________________________________________________________________
#__________________________________________colunm Under Condtion____________________________________________________________

#
#ROW contain all coullnms=>select from row (number of coulnm)
function colunmUnderCondtion() {
  #condtionCoulnm function take 1 argument if condtion match the path to complete display
  #$RowYouWantTo =>exist and want to select from it
  condtionCoulnm colunmUnderCondtion

  #******** select coulnms to display this row which (condtionCoulnm) return it ********
  read -rp "
        Select one numeric option from below to select the display way of Specific Row  data :
         ---------------------------Select Menu---------------------------
        1) Display All Data           
        2) Display Specific Column from a Table     
        3) Exit " opt
  opt=${opt// /_}
  case $opt in
  \\)
    echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
    selectMenu
    ;;
  1)
    echo "---------------------------$tableName----------------------------------------------------"

    echo $RowYouWantTo
    selectMenu
    ;;
  2) selectSpecificColunm ;;

  *) echo " Wrong Choice " selectMenu ;;
  esac
  selectSpecificsColunm

}

#---------------------------MAIN OF SELECT FROM TABLE----------------------------------------------------------------------------------
listTables
read -rp "To display Data From Table First Enter Name Of The Table You Want To Dispay Data From It :" tableName
checkInput table "$tableName" ". selectFromTable.sh"
checkExistance file "$tableName"
checkresult=$?
if [[ $checkresult == 111 ]]; then
  echo "hello from $tableName table "
  selectMenu
else
  echo "the table ($tableName)you have entered does not exists"
  . selectFromTable.sh
fi

#!/usr/bin/bash

function condtionCoulnm() {
  #_____________________________________________________________________________________________________
  #____________________________________where condtion #Coulnms_________________________________________________________________________

  #select * from emp where id(condtionColunmName) =(condtionOperator) 1(condtionCoulnmValue)
  #condtionColunmName
  #read colunmUnderCondtion (where) => check =>exist .
  #condtionOperator =>
  #condtionCoulnmValue=> check=> exis with (RowYouWantToSELECT)=>id=5

  #check condtion culnm and value
  read -rp "enter the number of condtion coulnm you want to Restrict Data which you want to delet with them :
  " numberOfContionColunms
  echo "_______________________________________________________________________________________"

  #******************check Coulnm number is (A digit)*******************************

  #Function take 3 arg : to combare it with Nf   *table name to calc Nf  *if condtion failed
  checkNumberOfColunms $numberOfContionColunms $tableName ". removeFromTable.sh"

  for ((i = 1; i <= $numberOfContionColunms; i++)); do
    read -rp "enter The Name Of Coulnm Number $i You Want To restric data with it in $tableName Table :": condtionColunmName

    #******************check Coulnm Name Syntax*******************************
    checkInput table "colunm" "$condtionColunmName" "condtionCoulnm"

    #******************check Coulnm existance*******************************
    CheckColunmExistance $condtionColunmName $tableName condtionCoulnm

    condtionColunmNumber=$(awk 'BEGIN{FS=":"}{if(NR==1){for(i=1;i<=NF;i++)
                        {if($i=="'$condtionColunmName'") print i}}}' $tableName)
    if [[ $condtionColunmNumber == "" ]]; then
      echo "Column name you have entered doesn't exists"
      echo "_______________________________________________________________________________________"

      condtionCoulnm
    else
      read -rp " Enter the Restriction Coulmn $condtionColunmName  VALUE:" condtionCoulnmValue

      RowYouWantToSELECT=$(awk -v x=$condtionColunmNumber 'BEGIN{FS=":"}
                            {if($x=="'$condtionCoulnmValue'") print $0}
                          ' "$tableName")
      if [[ $RowYouWantToSELECT == "" ]]; then
        echo "Data You Want To Remove Dosen't Exsit In $tableName table "
        echo "_______________________________________________________________________________________"

        condtionCoulnm
      else

        echo "_____________________________________________________________________________________"

      fi
    fi
  done
}

#delet from emp(tableName) where id(conditionColumnName ) = 1(condtionCoulmnValue)
#conditionColumnNumber =>number of the condtion coulnm (where)
#deletRow function => delet row with contain specfic value (ex:id=1) the user will enter it
function deletRowFromTable {

  condtionCoulnm
  for field in $RowYouWantToSELECT; do
    sed -i "/$field/d" $tableName
    echo "Row Deleted Successfully"
    echo "_______________________________________________________________________________________"

  done

}
#delet all date of the table but keep the structure (meta data)(2row)

function deletALLRowOfTable() {
  sed -i "3,$ d" $tableName
  echo "Row Deleted Successfully"
}
listTables

read -rp "Enter Table Name which you want to delet from it: " tableName
echo "_______________________________________________________________________________________"

checkInput table "$tableName" ". removeFromTable.sh"
checkExistance file "$tableName"
checkresult=$?
if [[ $checkresult == 111 ]]; then

  read -rp "
Select one numeric option from below
1) Delet Record From Table
2) Delet All Data From Table 
3) Exit
" opt
  opt=${opt// /_}
  case $opt in
  \\)
    echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"

    . removeFromTable.sh
    ;;
  1)
    deletRowFromTable
    . DMLMenue.sh

    ;;
  2)
    deletALLRowOfTable
    . DMLMenue.sh
    ;;
  3)
    echo -e "Thank you for using our DBMS Engine!\n"
    exit
    ;;
  *)
    echo -e "You Have Entered a wrong value, Please choose integer values from 1 to 3 according to your choice\n"
    removeFromTable.sh
    ;;
  esac
else
  echo "the table ($tableName)you have entered does not exists"
  . removeFromTable

fi

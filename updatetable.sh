#!/usr/bin/bash

function condtionCoulnm() {

  read -rp "enter the number of condtion coulnm you want to Restrict Data which you want to update data with them  : " numberOfContionColunms

  #******************check Coulnm number is (A digit)*******************************

  #Function take 3 arg : to combare it with Nf   *table name to calc Nf  *if condtion failed
  checkNumberOfColunms $numberOfContionColunms $tableName . "condtionCoulnm"

  for ((i = 1; i <= $numberOfContionColunms; i++)); do
    read -rp "enter The Name Of Coulnm Number $i You Want To update data with it in $tableName Table :": condtionColunmName

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
      read -rp " Enter the Restriction Coulmn $condtionColunmName VALUE :  " condtionCoulnmValue

      RowYouWantToSELECT=$(awk -v x=$condtionColunmNumber 'BEGIN{FS=":"}
                            {if($x=="'$condtionCoulnmValue'") print $0}
                          ' "$tableName")
      if [[ $RowYouWantToSELECT == "" ]]; then
        echo "Data You Want To Remove Dosen't Exsit In $tableName table "
        condtionCoulnm
      else

        echo "_____________________________________________________________________________________
        "

      fi
    fi
  done
}

#update employe(tablename) set id(setColumnName)=..(new value)
#                          where name(condtionColumnName)=(condtionColumnValue)
#condtioncoulnmnuber=>the number of condtioncoulnm
#condtionrown= the row which contain the value that will be ubdate
#udate  tablename(emp) set
#read table name

listTables
read -rp "Enter Name Of The Table You want to update Data in It :  " tableName
#check table name  syntax
checkInput "table" "tableName" ". updatetable.sh"
#check existance of this table
checkExistance file "$tableName"
checkresult=$?
if [[ $checkresult == 111 ]]; then
  condtionCoulnm
  read -rp "Enter coulnm name that you want to update  data which contain:  " setColumnName
  setColumnNumber=$(awk 'BEGIN{FS=":"}{
        if(NR==1){
        for(i=1;i<=NF;i++){
        if($i=="'$setColumnName'")
        print i}}}' $tableName)

  if [[ $setColumnNumber == "" ]]; then
    echo "Column name you have entered doesn't exists, please enter a correct column name"
    . updatetable.sh
  else
    read -rp "Enter the new value of column $setColumnName where you want to update" newValue
    # TODO check that the new value matches column data type
    # TODO check if we add value to the first column (primary key) --> check redandancy

    # _________________________Check update Data Type __________________________________________#

    currentAttDataType=$(awk -F: -v x="$setColumnNumber" '{if(NR == 2){
            print $x
        }}' "$tableName")
    #return 111 if int
    #return 110 if string
    checkPassedMetaData "$newValue"
    isMatched=$?
    if [[ $currentAttDataType == "string" ]]; then
      if [[ $isMatched == 110 ]]; then
        # echo "string is matched!"
        true
      elif [[ $isMatched == 111 ]]; then
        echo -e "
                    --------------------------------------------------------------------------
                    you have entered an int value ($setColumnName) only accepts string values
                    --------------------------------------------------------------------------
                    "
        . updatetable.sh
      fi
    elif [[ $currentAttDataType == "int" ]]; then

      if [[ $isMatched == 111 ]]; then
        # echo "int is matched!"
        true
      elif [[ $isMatched == 110 ]]; then
        echo -e "
                    --------------------------------------------------------------------------
                    you have entered a string value ($setColumnName) only accepts int values
                    --------------------------------------------------------------------------
                    "
        . updatetable.sh
      fi
    fi
    #____________________________check reduandancy if it is primary key_____________________________________#

    if [[ $setColumnNumber == 1 ]]; then
      # echo $setColumnNumber
      checkredandancy=$(awk -F: -v x="$newValue" 'BEGIN{
              check=0
          }{if($1 == x){
              check=1
          }}END{print check}' "$tableName")
      # echo "${checkredandancy}"

      if [[ $checkredandancy == 1 ]]; then
        echo -e "
----------------------------------------------------------------------------------------               
This value is already exists, Primary keys is unique please choose a unique one
----------------------------------------------------------------------------------------"
        . updatetable.sh
      fi
    fi

    #row >>>>number
    numberofrowYouWant=$(awk 'BEGIN{FS=":"}{
                       if ($'$condtionColunmNumber' == "'$condtionCoulnmValue'")
                       print NR}' $tableName)
    #using set coulnm number to get the old value
    oldValue=$(awk 'BEGIN{FS=":"}{
              if(NR=='$numberofrowYouWant'){for(i=1;i<=NF;i++){
              if(i=='$setColumnNumber') print $i}}}' $tableName)

    sed -i ''$numberofrowYouWant's/'$oldValue'/'$newValue'/g' $tableName
    echo "replacing  column $setColumnName value  => ($oldValue) with ($newValue)"
    echo "Row  Successfully"
    . DMLMenue.sh
  fi

else
  echo "the table ($tableName)you have entered does not exists"
  . updatetable.sh
fi

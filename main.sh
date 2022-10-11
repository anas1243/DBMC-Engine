#! /usr/bin/bash
#Remove case sensitivity from string comparison
#Allow RGEX
shopt -s extglob
export LC_COLLATE=C
function checkInput() {
    # echo "hello from check"
    case "$2" in
    \\)
        echo -e "You Have Entered the escape character, Please Enter a valid database name\n"
        $3
        ;;
    [Ee]xit)
        echo -e "-------------------- Thank you for using our DBMS Engine --------------------\n"
        exit
        ;;
    +([0-9])*)
        echo -e "$1 name should NOT start with number\n"
        $3
        ;;
    *+(["'"'!''@''#''$''%''^''&''*''('')''-''=''+''/''`''~''.'';'':'',''>''<''['']''{''}''"'\\])*)
        echo -e "$1 name should Not contain special characters\n"
        $3
        ;;
    [a-zA-z]*([a-zA-Z0-9_]))
        # echo -e "esm kolo tamm\n"
        ;;
    *)
        echo -e "You Have Enter in invalid $1 Name, please choose another one\n"
        $3
        ;;
    esac

}

#This function don't take any argument. It lists all avaiable Databases in 'databases' directory
function listDatabases() {
    echo -e "-------------------- All Available Databases --------------------
    "
    if [[ $(ls -F | grep / | sed 's/\// /') ]]; then
        ls -F | grep / | sed 's/\// /'
        # echo -e "\n"
    else
        echo -e "You Don't Have Databases yet\n"
    fi
}

# takes two params (file or directory) & (FileName or DirectoryName)
# Returns 111 if the file or the directory is exits and returns 110 if it is not exits
# database container or a new database
checkExistance() {
    # echo "hello existance"
    if [[ "$1" == "directory" ]]; then
        # echo "is directory"
        if [[ -d "$2" ]]; then
            if [[ $3 == "newdb" ]]; then
                echo "DataBase you have entered is already exists!"
            fi
            return 111
        else
            # echo "is not exists"
            return 110
        fi

    elif [[ "$1" == "file" ]]; then
        # echo "it is file"
        if [[ -f "$2" ]]; then
            # echo "exists"
            return 111
        else
            # echo "it is not exists"
            return 110
        fi

    fi
}

#takes two params (file or directory) & (FileName or DirectoryName)
# Returns 1 if the file or the directory has permissions and returns 0 if it is has not permissions
checkPermission() {
    if [[ "$1" == "directory" ]]; then
        # echo "from checkPerm it is directory"
        if [[ -r "$2" && -w "$2" && -x "$2" ]]; then
            # echo "from checkPerm it has perm"
            return 111
        elif ! [[ -r "$2" && -w "$2" && -x "$2" ]]; then
            # echo "from checkPerm it has no perm"
            return 110
        fi

    elif [[ "$1" == "file" ]]; then
        # echo "from checkPerm it is file"
        if [[ -r "$2" && -w "$2" ]]; then
            # echo "from checkPerm it has per"
            return 111
        elif ! [[ -r "$2" && -w "$2" ]]; then
            # echo "from checkPerm it has no per"
            return 110
        fi

    fi
}
# This funciton takes three argument
# 1st: directory or file
# 2nd: directory name or file name
# third: after creation where to go
function create() {
    # echo -e "hello from create"
    checkExistance "$1" "$2" "$3"
    checkExistanceResult=$?

    if [[ $checkExistanceResult == 111 ]]; then
        # echo "hey now"
        checkPermission "$1" "$2"
        checkPermissionResult=$?

        if [[ $checkPermissionResult == 111 && "$1" == "directory" ]]; then
            cd "$2" || true
            # pwd
        elif [[ $checkPermissionResult == 110 && "$1" == "directory" ]]; then
            echo "Your file doen't take the right permissions, your OS will ask for your password to give the directory the needed permissions"
            sudo chmod 770 "$2"
            cd "$2" || true
        elif [[ $checkPermissionResult == 111 && "$1" == "file" ]]; then
            echo -e "The table you have entered is exists"
            $3
        elif [[ $checkPermissionResult == 110 && "$1" == "file" ]]; then
            echo "Your table doen't have the right permissions, your OS will ask for your password to give the table the needed permissions"
            sudo chmod 660 "$2"
            $3
        fi
    elif [[ $checkExistanceResult == 110 && "$1" == "directory" ]]; then
        mkdir -m 770 "$2"
        cd "$2" || return
    elif [[ $checkExistanceResult == 110 && "$1" == "file" ]]; then
        true
    fi
}

create directory databases
# cd databases || true

read -rp "
-------------------- Welcome To Our DBMS Engine --------------------

Select one numeric option from below
1) Create Database
2) List available Databases
3) Drop Datebase
4) Connect To a Database
5) Exit

" opt
opt=${opt// /_}
case $opt in
\\)
    echo -e "You Have Enter the escape character, Please Enter a valid value!!!!\n"
    cd ..
    . main.sh
    ;;
1)
    . createdb.sh
    ;;
2)
    listDatabases
    cd ..
    . main.sh
    ;;
3)
    . dropdb.sh
    ;;
4)
    . connectdb.sh
    ;;
5)
    echo -e "Thank you for using our DBMS Engine!\n"
    exit
    ;;
*)
    echo -e "You Have Entered a wrong value, Please choose integer values from 1 to 5 according to your choice\n"
    cd ..
    . main.sh
    ;;
esac

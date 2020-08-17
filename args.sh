#!/bin/bash

VERSION=1.1
ARGSV=1.0
HELPV=1.0


case $1  in 
    -h|--help)
    echo -e "Workspace creator script\n\n\tAvailable script arguments: \n\t\twkcr: ./wkcr [-hvgzUz]\n./wkcr --[version|help]"
    echo "wkcr/args: Help command in args.sh " >> "wkcr.log"
    exit 0
    ;;

    -v|--version)
    echo "Current version of workspace creator: $VERSION, args version: $ARGSV, help version: $HELPV"
    echo "wkcr/args: Version command in args.sh " >> "wkcr.log"
    exit 0
    ;;

    -g)
    echo -n "Give folder name that you want to init git in: "
    read c
    cd $c
    # git init
    echo "Init git in $c "
    cd ..
    echo "wkcr/args: Git init successfully in $(pwd)" >> "wkcr.log"
    exit 0
    ;;
    
    -d)
    echo "Docs are at: https://github.com/Czesiek2000/workspace-creator"
    echo "wkcr/args: Docs command in args.sh " >> "wkcr.log"
    exit 0
    ;;

    -z)
    echo -n "Give zip name: "
    read zip
    echo -n "Give files or folder to zip: "
    read zf

    zip $zip $zf
    echo "wkcr/args: Folder $zip will be zipped with $zf files" >> "wkcr.log"
    exit 0
    ;;

    -Uz)
    echo -n "Give zip folder name to unzip: "
    read uz
    echo -n "Unzip in current directory or create folder(./folder name): "
    read a

    echo "wkcr/args: Folder $uz will be unzipped" >> "wkcr.log"

    if [ -z $a ]
    then
        unzip $uz
        echo "wkcr/args: Unzip file $uz in current directory" >> "wkcr.log"
    fi

    if [ "$a" == "." ]
    then 
        name=$(echo "$uz" | cut -d "." -f1 )
        mkdir $name
        echo "wkcr/args: Create folder $name" >> "wkcr.log"
        cd "$name"
        echo "wkcr/args: Change directory to $name" >> "wkcr.log"
        unzip "../$uz"
        echo "wkcr/args: Unzip filder $uz in $name" >> "wkcr.log"
        cd ".."
        echo "wkcr/args: Change directory from $name to previous" >> "wkcr.log"

    fi
    
    if [[ "$a" =~ [a-zA-z] ]]
    then
        mkdir $a
        echo "wkcr/args: Folder $a was made successfully" >> "wkcr.log"
        cd $a
        echo "wkcr/args: Change directory to $a currently in $(pwd)" >> "wkcr.log"
        unzip "../$uz"
        echo "wkcr/args: Folder $uz will be unzipped to folder $a" >> "wkcr.log"
        cd ".."
        echo "wkcr/args: Change directory from $a to previus currently in $(pwd)" >> "wkcr.log"
    fi

    exit 0
    ;;

    *)
    echo "This argument doesn't exists, please check docs or type -h / --help"
    echo "wkcr/args: Case default value" >> "wkcr.log"
    ;;
esac
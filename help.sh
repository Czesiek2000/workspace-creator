#!/bin/bash
# Link to github config
REPO=https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/config

# Variables use in script
CFGF=config
VERSION=1.1

# Clear terminal window 
clear 

# Add space to the screen 
echo -e "\n"

# Change prompt text
echo -n "Something went wrong? Check out more info" 
echo -e "\n0. Exit program\n1. Missing files or something wrong with files let me check\n2. Check parameters to give ex.0,1\n3. Clean your workspace\n4. Create folders and subfolders or files\n5. Help option"
echo -n "Your choice: "
read CHOICE 

function download {
    echo "$1 doesn't exists downloading it"
    curl -O "$REPO/$1" 2> /dev/null
    echo "$1 downloaded successfully"
    echo "wkcr: move successfully to $CFGF file $1" >> "wkcr.log"
    mv "$1" "$CFGF"
    echo "wkcr/help: Move file $1 to $CFGF successfully" >> "wkcr.log"
}

# Program menu
if [ $CHOICE -eq 0 ]
then
    echo "Exit help program"
    echo "wkcr/help: Exit help program" >> "wkcr.log"
    exit 0

elif [ $CHOICE -eq 1 ] ;
then
    if [ -d $CFGF ] ;
    then
        echo "wkcr/help:Config folder exists " >> "wkcr.log"
    else 
        echo "wkcr/help: Config directory doesn't exists" >> "wkcr.log"
        mkdir $CFGF
        echo "wkcr/help: Directory $CFGF made successfully" >> "wkcr.log"
    fi

    if [ ! -f $CFGF/example.html ] ;
    then
        # download example.html
        echo "example.html included in script source"
    fi

    if [ ! -f $CFGF/example.css ] ;
    then
        # download example.css
        echo "wkcr/help: Download example.css successfully" >> "wkcr.log"
    fi

    if [ ! -f $CFGF/example.js ] ;
    then
        # download example.js
        echo "wkcr/help: Download example.js successfully" >> "wkcr.log"
    fi

    if [ ! -f $CFGF/example.cpp ] ;
    then
        #download example.cpp
        echo "wkcr/help: Download example.cpp successfully" >> "wkcr.log"
    fi
    
    if [ ! -f $CFGF/example.py ] ;
    then
        download example.py
        echo "wkcr/help: Download example.py successfully" >> "wkcr.log"
    fi
    
    if [ ! -f $CFGF/example.go ] ;
    then
        download example.go
        echo "wkcr/help: Download example.go successfully" >> "wkcr.log"
    fi
    
    if [ ! -f $CFGF/example.ru ] ;
    then
        download example.ru
        echo "wkcr/help: Download example.ru successfully" >> "wkcr.log"
    fi

elif [ $CHOICE -eq 2 ]
then
    echo "Choice 2"
    echo "Available commands"
    echo "wkcr/help: Help menu option 2" >> "wkcr.log"

elif [ $CHOICE -eq 3 ]
then
    for i in `ls .`
    do
        if [ -d $i ]
        then
            echo "wkcr/help: $i is directory " >> "wkcr.log"
            if [ "$i" != "config" ]
            then
                echo -e "$i/ \t"
            fi
        fi
    done

    for j in `ls .`
    do
        if [ -f $j ]
        then
            echo "wkcr/help: $j is file " >> "wkcr.log"
            if [ "$j" != "wkcr.sh" ] && [ "$j" != "args.sh" ] && [ "$j" != "help.sh" ]
            then
                echo "-- $j"
            fi

        fi
    done

    echo -n "Give folders that you want to delete: "
    read a
    
    if [ ! -z $a ]
    then
        echo -n "Are you sure you want to delete given folders?(y/n): "
        read b

        if [ $b == "y" ]
        then 
            echo "wkcr/help: Help choice 3 choice y" >> "wkcr.log"
            for i in $a
            do
                if [ -f $i ]
                then 
                    echo "$i is a file"  
                fi

                if [ -d $i ] 
                then
                    rm -r "$i"
                    echo "$i deleted"
                fi
                echo "wkcr/help: Folder $i deleted from $(pwd)" >> "wkcr.log"
            done
        fi
    else
        echo -n "Give files name to delete: "
        read files

        if [ -z $files ]
        then
            echo -n "Are you sure you want to delete them? (y/n): "
            read answer
            
            if [ "$answer" == "y" ]
            then
                for i in $files
                do
                    if [ -f $i ]
                    then
                        rm $i
                        echo "File $i deleted"
                        echo "wkcr/help: $i deleted from $(pwd)" >> "wkcr.log"
                    else
                        echo "$i doesn't exists"
                    fi
                done
            fi
        else 
            echo "wkcr/help: User enter nothing" >> "wckr.log"
        fi
    fi
elif [ $CHOICE -eq 4 ]
then
    echo -n "You want to create files or folders? (file/folder): "
    read ans

    if [ $ans == "folder" ]
    then
        echo -n "Want to create subfolder? (y/n): "
        read yn

        if [ $yn == "y" ]
        then
            echo -n "Give folder and subfolder name with / (ex. folder/subfolder): "
            read folders

            for i in $folders
            do
                if [ -d $i ]
                then
                    echo "$i exists"
                else
                    echo "wkcr: Folder $i created: " >> "wkcr.log"
                    mkdir -p $i
                fi
            done
        else
            echo -n "Give folder / folders name you want to create: "
            read FOLDERS
            
            for i in $FOLDERS
            do
                echo "wkcr/help: Folder $i created " >> "wkcr.log"
                mkdir $i
                echo "$i created"
            done
        fi

    elif [ $ans == "file" ]
    then
        echo -n "Give folder name where you want to create files: "
        read D
        if [ -d $D ]
        then 
            echo "$D exists delete it with menu option"
            exit 0

        else
            echo "wkcr: Folder $D created" >> "wkcr.log"
            mkdir $D
            echo "$D created"
        fi

        echo -n "Give file extension: "
        read EXT
        if [ -z $EXT ]
        then
            echo "wkcr/help: File create without extension " >> "wkcr.log"
            echo "File create without extension"
        fi
        echo -n "Give name of file or files: "
        read file

        for j in $file
        do
            if [ -f $j ]
            then
                echo "$j exists"
            else
                echo "File $j created in $D" >> "wkcr.log"
                if [[ $EXT =~ "." ]]
                then
                    touch "$D/$j$EXT"
                else
                    touch "$D/$j.$EXT"
                fi
            fi
        done
    fi
elif [ $CHOICE -eq 5 ]
then
    echo "What you want to check: "
    read OPTION
    if [ -z $OPTION ]
    then
        echo -e "Usage 
        $ version 
        0-4 from menu"

    elif [ $OPTION == "version" ] || [ $OPTION == "v" ]
    then
        echo "Current project version is: $VERSION"
    # elif [ $OPTION == "" ] || [ $OPTION == "" ]
    # then
    #     echo ""
    else
        echo "Command not found"
        echo "Available menu options 0-4"
        exit 0
    fi
fi
# fi

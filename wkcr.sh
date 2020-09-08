#!/bin/bash
: '
Workspace creator - https://github.com/Czesiek2000/workspace-creator
Author: Michał Czech, Czesiek2000 https://github.com/Czesiek2000
Licence MIT
'

# Start link to raw files
REPO=https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/config
docs=https://github.com/Czesiek2000/workspace-creator

# Script variables
CFGF=config
CON=config.txt
CONFIG="$CFGF/$CON"
FILECFG=filecfg
LOG=wkcr.log
VERSION=1.1

# Colors for terminal output
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 12`
dark_blue=`tput setaf 19`
magenta=`tput setaf 5`
white=`tput setaf 15`
black=`tput setaf 16`
grey=`tput setaf 248`
reset=`tput sgr0`
bold=`tput bold`
underline=`tput smul`

# Check if log file exists, if true clear file content
if [ -f $LOG ]
then
    # rm wkcr.log
	# Change removing file with clearing 
	echo "" > wkcr.log
fi

# Function to delete existing folder
function check {
	if [ -d $1 ] 
	then
		echo -n "Folder with that name exists on your disk, delete it (y/n): "
		read ans

		if [ $ans == "y" ]
		then
			rm -r $1
			echo -e "\n$magenta$1 deleted\n"
		fi
	fi
}

# Check user machine
if [ $(uname) == "Darwin" ]
then
	echo "wkcr: Using macos" >> $LOG
	machine="mac"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
then 
    echo "wkcr: Using linux" >> $LOG
    machine="Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]
then
    echo "wkcr: Using windows 32 NT" >> $LOG
    machine="Win32"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]
then
    echo "wkcr: Using windows 64 NT" >> $LOG
    machine="Win64"
else
    echo "wkcr: Using undetected machine" >> "wckr.log"
fi

# Function to download file 
function download {
    if [ "$machine" == "mac" ]
    then
        echo "$1 doesn't exists downloading it"
        curl -O "$REPO/$1" 2> /dev/null
        echo "$1 downloaded successfully"
        mv "$1" "$CFGF/$1"
        echo "wkcr: move file $1 to $CFGF successfully" >> $LOG
    elif [ "$machine" == "Linux" ]
    then
        echo "$1 doesn't exists downloading it"
        wget -i "$REPO/$1" 2> /dev/null
        echo "$1 downloaded successfully"
        mv "$1" "$CFGF/$1"
        echo "wkcr: move file $1 to $CFGF successfully" >> $LOG
    else
        echo "Other machine " >> $LOG
    fi
}

# Function to check if user enter good value
function validate {
	# $1 - regex to check 
    # $2 - value to check
    # $3 - read value
    while [[ ! "$2" =~ "$1" ]]; do
        echo -n "$red Incrorrect value $white Please enter correct value. If something is wrong please refer to docs here $docs"
        read $3
    done
}


# Another script to check arguments
if [ -f args.sh ]
then
	# echo "args.sh File exist"
	if [ $# -ne 0 ]
	then
		echo "wkcr: Source ./args.sh with $1 argument" >> $LOG
		source ./args.sh $1
	fi	
else 
	echo "File doesn't exists"
	curl -O "https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/args.sh"
	echo "wkcr: File args.sh downloaded " >> $LOG
fi

# Script to handle errors inside main script
if [ -f help.sh ]
then
	echo "wckr: help.sh file exists" >> $LOG
else 
	echo "help.sh doesn't exists"
	curl -O "https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/help.sh"
	echo "wkcr: File help.sh downloaded " >> $LOG
fi

# Check if config folder exists
if [ -d $CFGF ]
then
	echo "wkcr: Directory $CFGF exists " >> $LOG
else
	echo "wkcr: Direcotry doesn't exists, $CFGF created" >> $LOG
	mkdir "$CFGF"
fi

if [ ! -f $CONFIG ]
then
	echo "Missing $CONFIG"
	download "$CON"
	echo "Run script again config files downloaded"
	exit 0
else 
	echo "wkcr: $CONFIG file exists " >> $LOG
	
	# Clear terminal window
	echo "wkcr: Terminal cleared " >> $LOG
	clear
	
	# Show some space for better view
	echo -e "\n"

	# Read and display menu 
	cat $CONFIG | while read LINE ;
	do
		echo $LINE
	done

	# User choice 
	echo -n -e "$green?$white Your choice: "
	read choice

	# Check if user enter right value 
	while [[ ! $choice =~ ^[0-9]+$ ]] ; do
		echo -e "$red Incorrect value $white.Please enter correct value. Available options 0-6. When problem occures check $docs \n"
        echo -n "$green?$white Your choice: "
		echo "wkcr: Give wrong values of $choice " >> $LOG
		read choice
	done
fi

# Check if config.txt exists
if [ ! -f "$CFGF/$FILECFG" ]
then
	download $FILECFG
	echo "wkcr: $FILECFG downloaded" >> $LOG
	echo "✔️ Run script again config files downloaded"
	exit 0
else
	# Load script variables
	echo "wkcr: $CFGF/$FILECFG loaded to script " >> $LOG
	source "$CFGF/$FILECFG"
fi

function bash {
    echo "wkcr: Bash project creating " >> $LOG
    echo -n "$green?$white Give project folder / directory name: (. or nothing to create in currrent directory): "
    read dir

    echo -e "\n$grey If you want to create more than one file please go to help option from this menu and then enter 4 option\n $white"
    echo -n "$green?$white Give file name that you want to create: "
    read file
    
    while [[ ! $file =~ ^[a-z] ]]
    do
        echo -n "Give correct file name you want to create"
        read file
    done

    if [[ $file =~ .sh$ ]]
    then
        file="$file"
    else
        file="$file.sh"
    fi

    echo "wkcr: Bash file name $file corrected " >> $LOG

    # Check if user enter empty string to prompt
    # If user enter . or space then give prompt to open file
    # If user enter folder name, check if exists if true ask to delete else prompt that exists and exit
    # If user enter directory that not exists, then create it and create file inside it and prompt to cd to folder
    if [ -z $dir ] || [ "$dir" == "." ]
    then
        dir="current directory"
        if [ -e "$file" ]
        then
            echo "wkcr: empty directory, $file exists " >> $LOG
            echo -e "\n\t$green$file$white exists in $blue$dir\n\n\t$white\bTo open type\n\n\t$green./$file\n"
            exit 0

        else
            touch $file
        
            echo "wkcr: Created file in $dir" >> $LOG
        
            chmod a+x $file
        
            echo "wkcr: Add a+x permision to script " >> $LOG

            echo -e "\n\tAdd execute permission to file\n"
            
            echo -e "\n\t$green$file$white created in folder $blue$dir/ \n\n\t$white\bTo open type\n\n\t$green./$file\n"
            
            echo -e '#!/bin/bash \n\n#This is example bash program \n\necho "Hello World"' >> "$file"
            
            echo "wkcr: Enter example script to $file " >> $LOG
        fi

    else 
        check "$dir"
        echo "wkcr: Check if $dir exists" >> $LOG
        if [ -d $dir ]
        then
            echo "wkcr: $dir exists " >> $LOG
            echo "wkcr: $red Folder with that name already exists on your disk"
            exit 1
        else
            echo "wkcr: $dir doesn't exists" >> $LOG
            mkdir $dir
            echo "Directory $dir created" >> $LOG
            echo "wkcr: Directory $dir created"

            touch "$dir/$file"
            echo -e "\nwkcr:$green$file$white created\n$white"
            echo "wkcr: Created $file " >> $LOG

            chmod a+x "$dir/$file"
            
            echo -e "\nAdd execute permission to $green$file"
            echo "wkcr: Add a+x permision to script " >> $LOG
            
            echo -e '#!/bin/bash \n\n#This is example bash program \n\necho "Hello World"' >> "$dir/$file"
            echo "wkcr: Add example script to $file" >> $LOG
            echo -e "\n\t$green$file$white created in folder $blue$dir$white/\n\n\tTo run type\n\n\t$green cd $dir\n\n\t./$file\n"
        fi
    fi


}


case $choice in 
    0)
    echo "Exit program"
    echo "wkcr: Program existed succesfully " >> $LOG
    exit 0
    ;;

    1)
    bash
    ;;

esac

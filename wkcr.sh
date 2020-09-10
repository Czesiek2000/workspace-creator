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

    # Store value user enter
    echo "wkcr: User choice $choice " >> $LOG    
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


    # Store value user enter
    echo "wkcr: Folder name $dir " >> $LOG    
    echo "wkcr: File name $file " >> $LOG    

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

function web {
    cssFile=styles.css
    jsFile=script.js
    defaultWebDir=WebProject
    echo -n "$green?$white Give folder name where you want your project to be created: "
	read webDir

    if [ -z $webDir ]
    then
        webDir=$defaultWebDir
    fi

    if [ -d $webDir ]
    then
        echo "wkcr: $webDir exists on disk " >> $LOG
		echo "wkcr: $webDir Folder with that name already exists on your disk"
		check "$webDir"
        echo "wkcr: Check function on $webDir" >> $LOG
        exit 0
    else
        echo -n -e "$green?$white Select project structure (0,1,2): "
        read str
        while [[ ! $str =~ ^[0-2] ]]
        do
            echo -e "\n$red\bIncorrect value.$white\nPlease enter correct value. More info inside docs $docs or enter help option in this menu\n"
            echo -n "$green?$white\bYour choice: "
            read str
        done

        # Store value user enter
        echo "wkcr: Value of directory $webDir " >> $LOG
        
        echo "wkcr: Value of option $str " >> $LOG
        
        # Check what editor user has on computer
        function editor {
            EDITOR=""                
                if ! command -v code &>>$LOG
                then
                    echo "wkcr: VSCode not found on computer" >> $LOG
                    
                    if ! command -v subl &>>$LOG 
                    then
                        echo "wkcr: sublime not found on computer" >> $LOG
                    else
                        EDITOR="subl"
                        echo "wkcr: Open $webDir in Sublime text " >> $LOG
                    fi
                                        
                else 
                    EDITOR="code"
                    echo "wkcr: Open $webDir in Visual Studio Code" >> $LOG
                fi
                if [ -z $EDITOR ]
                then
                    echo -e "\nTo start working:\n\n\t$blue cd $webDir \n\n\t$white Open your favourite editor and start working\n"
                else 
                    echo -e "\nTo start working:\n\n\t$blue cd $webDir\n\t$green$EDITOR $webDir$white\n"
                fi 
                echo "wkcr: VSCode and Sublime Text 3 doesn't installed on computer show default message" >> $LOG
        }

        if [ ! -f config/example.css ]
        then
            echo "wkcr:$red example.css not exists$white" >> $LOG
        fi

        if [ ! -f config/example.js ]
        then
            echo "wkcr:$red example.js not exists$white" >> $LOG
        fi

        if [ ! -f config/example.scss ]
        then
            echo "wkcr:$red example.scss not exists$white" >> $LOG
        fi

        if [ ! -f config/example_variables.scss ]
        then
            echo "wkcr:$red example_variables.scss not exists$white" >> $LOG
        fi

        # Diffrent project structures
        if [ $str -eq 0 ]
        then
            echo "wkcr: Enter first option in second menu" >> $LOG
            
            # Check if example files exists
			if [ -f "config/example.css" ] && [ -f "config/example.js" ] ;
			then
				echo "wkcr: example.css, example.js exists" >> $LOG
				mkdir -p $webDir "$webDir" "$webDir"
				echo "wkcr: Made directories: $webDir" >> $LOG
				touch "$webDir/index.html" "$webDir/$cssFile" "$webDir/$jsFile"
				echo "wkcr: Made index.html, $cssFile in $webDir, $jsFile in $webDir" >> $LOG

				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
				
				echo "wkcr: Starters copied to project directory " >> $LOG
                
                editor
            
            else
                echo "wkcr: Missing example files for webdevelopment in option 2 in config folder " >> $LOG
				echo -e "$red\bMissing config files $white add it to current location or use help option from this menu (6)"
				
                if [ "$machine" == "mac" ]
                then
                    open .
                elif [ "$machine" == "Linux" ]
                then
                    xdg-open .
                    echo "wkcr: Open current location in explorator" >> $LOG
                else 
                    echo "wkcr:$red Unknow machine"
                    echo "wkcr: else in 0 option in 2 menu option, machine windows or other linux distibution not supported yet" >> $LOG
                fi
				exit 0
            fi
        
        elif [ $str -eq 1 ]
        then
            # Check if example files exists
			if [ -f "config/example.css" ] && [ -f "config/example.js" ] ;
			then
				echo "wkcr: example.css, example.js exists" >> $LOG
				mkdir -p $webDir "$webDir/css" "$webDir/js"
				echo "wkcr: Made directories: $webDir $webDir/css $webDir/js" >> $LOG
				touch "$webDir/index.html" "$webDir/css/$cssFile" "$webDir/js/$jsFile"
				echo "wkcr: Made index.html, $cssFile in $webDir/css, $jsFile in $webDir/js" >> $LOG

				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'css/$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'js/$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/css/$cssFile"
				cp "config/example.js" "$webDir/js/$jsFile"
				
				echo "wkcr: Starters copied to project directory " >> $LOG 
                
                editor

			else 
				echo "wkcr: Missing example files for webdevelopment in option 2 in config folder " >> $LOG
				echo -e "$red\bMissing config files $white add it to current location or use help option from this menu (6)"

				if [ "$machine" == "mac" ]
                then
                    open .
                elif [ "$machine" == "Linux" ]
                then
                    xdg-open .
                    echo "wkcr: Open current location in explorator" >> $LOG
                else 
                    echo "wkcr:$red Unknow machine"
                    echo "wkcr: else in 0 option in 2 menu option, machine windows or other linux distibution not supported yet" >> $LOG
                fi
				exit 0
			fi

        
        else 
            echo "wkcr: Structure with sass" >> $LOG
			# Check if example files exists
			if [ -f "config/example.css" ] && [ -f "config/example.js" ] && [ -f "config/example.scss" ];
			then
				echo "wkcr: example.css, example.js, example.scss exists" >> $LOG
				mkdir -p $webDir "$webDir/css" "$webDir/scss" "$webDir/js"
				echo "wkcr: make $webDir $webDir/css $webDir/scss/ $webDir/js/ directories successfully" >> $LOG
				touch "$webDir/index.html" "$webDir/css/$cssFile" "$webDir/js/$jsFile" "$webDir/scss/variables.scss" "$webDir/scss/styles.scss"
				echo "wkcr: make index.html in root $webDir $cssFile file in $webDir/js/$jsFile $webDir/scss/variables.scss $webDir/scss/styles.scss successfully" >> $LOG

				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'css/$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'js/$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/css/$cssFile"
				cp "config/example.js" "$webDir/js/$jsFile"
				cp "config/example.scss" "$webDir/scss/styles.scss"
				cp "config/example_variables.scss" "$webDir/scss/variables.scss"
				echo "wkcr: Sass project created " >> $LOG
				echo "wkcr: copied starters from config to files specified in option 2 in webdevelopment menu option successfuly to $webDir " >> $LOG
                
                editor

			else 
			    echo "wkcr: Missing example files for webdevelopment in option 2 in config folder " >> $LOG
				echo -e "$red\bMissing config files $white add it to current location or use help option from this menu (6)"

				if [ "$machine" == "mac" ]
                then
                    open .
                elif [ "$machine" == "Linux" ]
                then
                    xdg-open .
                    echo "wkcr: Open current location in explorator" >> $LOG
                else 
                    echo "wkcr:$red Unknow machine"
                    echo "wkcr: else in 0 option in 2 menu option, machine windows or other linux distibution not supported yet" >> $LOG
                fi

				exit 0
			fi

        fi
    fi
}

function cpp {
    echo "MENU OPTION 3 CPP " >> $LOG
    echo "wkcr: Menu option 3 cpp folder creating" >> $LOG
    echo -n "$green?$white Give project folder name that you want to be created: "
    read cppDir
    echo "wkcr: Cpp dir $cppDir " >> $LOG
    echo -n "$green?$white Give name of main cpp file (empty to be main.cpp): "
    read cppFile

    if [ -z $cppFile ]
    then
        cppFile="main.cpp"
        echo "wkcr: Empty cppFile variable assign main.cpp as main file" >> $LOG
    else
        cppFile=$cppFile
    fi
        echo "wkcr: Cpp file $cppFile " >> $LOG

    if [ -d $cppDir ]
    then
        echo "wkcr: Folder $cppDir exists, from menu option 3" >> $LOG
		echo "wkcr: $red$cppDir Folder with that name already exists on your disk"
		exit 0

    else 
        mkdir $cppDir
        touch "$cppDir/$cppFile"
        echo "wkcr: Value of directory $cppDir" >> $LOG
        echo "wkcr: Value of file $cppFile" >> $LOG
        echo "wkcr: Created $cppFile file in $cppDir" >> $LOG
        echo "wkcr: Created $cppFile inside $cppDir " >> $LOG

        # Give starter point to file
		echo -e '#include <iostream>\n\n# example cpp code \n\nint main() {\n\n\tcout << "Hello World" << endl\n\n# your code here\n\n}' > "$cppDir/$cppFile"
		echo "wkcr: Menu option 3 include in $cppFile starter template" >> $LOG
    fi


    echo -n "$green?$white Want to create class file (y/n): "
    read a

    if [[ "$a" == "y" ]]
    then
        echo "wkcr: Create class option" >> $LOG
        
        # TODO: Delete message if multiple class support
        echo -e "\n$grey In current version of workspace-creator you can create only one class file\n $white"
        
        echo "wkcr: Show user notification about class file" >> $LOG

        echo -n "$green?$white Give class name "
        read class

        # TODO: Add support more than one class 
        touch "$cppDir/$class.cpp" "$cppDir/$class.h"
        echo "wkcr: Create class files: $class.cpp and $class.h inside $cppDir" >> $LOG

        # Starter for cpp class file
        echo -e '#include ''"'$class.h'"'' \n# your code here' > "$cppDir/$class.cpp"
		echo "wkcr: Add template to cpp classes" >> $LOG

        # Create uppercase guard to class header file
        echo $class | tr a-z A-Z > tmp
        echo "wkcr: Tmp file created" >> $LOG
        for i in `cat tmp`
        do
            echo -e "#ifndef ${i}_H #include guard \n#define ${i}_H\n\n# your code here\n\n#endif /* ${i}_H */" > "$cppDir/$class.h"
        done
        
        # Remove tmp file 
        rm tmp
        echo "wkcr: Tmp file removed" >> $LOG

        echo -e "Project created \n\n\t$blue cd $cppDir\n\t$green gcc main.cpp -o main $white\n"

        # Check if user is using mac/linux/windows
        if [ "$machine" == "mac" ]
        then
            open .
            echo "wkcr: Open current location in explorator on mac"
        elif [ "$machine" == "Linux" ]
        then
            xdg-open .
            echo "wkcr: Open current location in explorator on linux" >> $LOG
        else 
            echo "wkcr:$red Unknow machine"
            echo "wkcr: else in 0 option in 2 menu option, machine windows or other linux distibution not supported yet" >> $LOG
        fi

    elif [ "$a" == "n" ]
    then
        echo -e "Project created \n\n\t$blue cd $cppDir\n\t$green gcc main.cpp -o main $white\n"

        # Check if user is using mac/linux/windows
        if [ "$machine" == "mac" ]
        then
            open .
            echo "wkcr: Open current location in explorator on mac"
        elif [ "$machine" == "Linux" ]
        then
            xdg-open .
            echo "wkcr: Open current location in explorator on linux" >> $LOG
        else 
            echo "wkcr:$red Unknow machine"
            echo "wkcr: else in 0 option in 2 menu option, machine windows or other linux distibution not supported yet" >> $LOG
        fi

    else
        echo "wkcr: Menu option 3 creating classes error give something else than y/n" >> $LOG
		echo "wkcr:$red Something wrong only avaiable options are y/n"
		exit 0
    fi

}

function java {
    echo "JAVA OPTION" >> $LOG
	echo "wkcr: Enter menu option 4" >> $LOG
	echo -n "$green?$white Give project folder name that you want to create: "
	read javaD

    # Use default value when user enter nothing
	if [ -z $javaD ] ;
	then
		javaD=$javaDir
	else
		javaD=$javaD
	fi

    echo "wkcr: Correct java folder name if nothing passed" >> $LOG

    # Check if passed directory exists
    if [ -d $javaD ]
    then
        check "$javaD"
        echo "wkcr: Java option, folder $javaD exists" >> $LOG
		echo "wkcr: $red$javaD Folder with that name already exists $white \n"
		exit 0

    else 
        mkdir $javaD
        echo "wkcr: Java menu option $javaD folder created " >> $LOG
        echo -n "$green?$white Give file or files names to create (only filenames): "
        read files


        for i in $files
        do
            touch "$javaD/$i.java"
            echo -e 'public class' $i ' {\n\tpublic static void main(String args[]) {\n\t\t// Example code\n\t\tSystem.out.println("Hello world");\n\n\t\t// Your code here\n\t}\n}' > "$javaD/$i.java"
			echo "wkcr: Java option $javaD/$i created and add template to file" >> $LOG
        done

        echo "wkcr: OUTPUT FILES" >> $LOG
        for i in $files
        do
            jfile+="$i.java "
            echo "wkcr: $jfile" >> $LOG
        done

    fi

    # echo -e "\n New project created in javaD \n\n Execute commands to start project \n\n\t$blue cd javaD $white\n\t > $green javac Test.java $white\n\t > $green java Test.java\n"
    echo -e "\n New project created in $javaD \n\n Execute commands to start project \n\n\t$blue cd $javaD\n\t$green javac $jfile\n\t$green java $jfile\n"
}


case $choice in 
    0)
    echo "Exit program"
    echo "wkcr: Program existed succesfully " >> $LOG
    exit 0
    ;;

    1)
    echo "wkcr: Option 1 from main menu" >> $LOG
    bash
    ;;


    2)
    echo "wkcr: Option 2 from main menu" >> $LOG
    web
    ;;

    3)
    echo "wkcr: Option 2 from main menu" >> $LOG
    cpp
    ;;

    4)
    echo "wkcr: Option 2 from main menu" >> $LOG
    java
    ;;

    5)
    echo "Option 5"
    ;;

    6)
    echo "Option 6"
    ;;

esac

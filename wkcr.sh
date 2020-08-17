#!/bin/bash
# Starter link to raw files
REPO=https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/config
docs=https://github.com/Czesiek2000/workspace-creator
CFGF=config
CON=config.txt
CONFIG="$CFGF/$CON"
FILECFG=filecfg

# Colors for terminal output
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
grey=`tput setaf 8`
reset=`tput sgr0`
bold=`tput bold`
underline=`tput smul`

# Check if log file exists
if [ -f wkcr.log ]
then
	rm wkcr.log
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
			echo "$1 deleted"
		fi
	fi
}

# Function to download file 
function download {
    echo "$1 doesn't exists downloading it"
    curl -O "$REPO/$1" 2> /dev/null
    echo "$1 downloaded successfully"
    mv "$1" "$CFGF/$1"
	echo "wkcr: move file $1 to $CFGF successfully" >> "wkcr.log"
}

# TODO Function to check if user enter good value
function validate {
	echo "Validation completed"
}

# Check user machine
if [ $(uname) == "Darwin" ]
then
	echo "wkcr: Using macos" >> "wkcr.log"
	machine="mac"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
then 
    echo "wkcr: Using linux" >> "wkcr.log"
    machine="Linux"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]
then
    echo "wkcr: Using windows 32 NT" >> "wkcr.log"
    machine="Win32"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]
then
    echo "wkcr: Using windows 64 NT" >> "wkcr.log"
    machine="Win64"
else
    echo "wkcr: Using undetected machine" >> "wckr.log"
fi

# Another script to check arguments
if [ -f args.sh ]
then
	# echo "args.sh File exist"
	if [ $# -ne 0 ]
	then
		echo "wkcr: Give file ./args.sh $1 parameter" >> "wkcr.log"
		source ./args.sh $1
	fi	
else 
	echo "File doesn't exists"
	curl -O "https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/args.sh"
	echo "wkcr: File args.sh downloaded " >> "wkcr.log"
fi

# Check if config folder exists
if [ -d $CFGF ]
then
	echo "wkcr: Directory exists" >> "wkcr.log"
else
	echo "wkcr: Direcotry doesn't exists, $CFGF created" >> "wkcr.log"
	mkdir "$CFGF"
fi

if [ ! -f $CONFIG ]
then
	echo "Missing $CONFIG"
	download "$CON"
	echo "Run script again config files downloaded"
	exit 0
else 
	echo "wkcr: $CONFIG exists " >> "wkcr.log"
	
	# Clear terminal window
	echo "wkcr: Terminal cleared " >> "wkcr.log"
	clear
	
	# Show some space for better view
	echo -e "\n"

	# Read and display menu 
	cat $CONFIG | while read LINE ;
	do
		echo $LINE
	done

	# User choice 
	echo -n "Your choice: "
	read choice

	# Check if user enter right value 
	while [[ ! $choice =~ ^[0-9]+$ ]] ; do
		echo -n "Wrong value type once more: "
		echo "wkcr: Give wrong values of $choice " >> "wkcr.log"
		read choice
	done
fi

# Check if config.txt exists
if [ ! -f "$CFGF/$FILECFG" ]
then
	download $FILECFG
	echo "wkcr: $FILECFG downloaded" >> "wkcr.log"
	echo "Run script again config files downloaded"
	exit 0
else
	# Load script variables
	echo "wkcr: $CFGF/$FILECFG loaded to script " >> "wkcr.log"
	source "$CFGF/$FILECFG"
fi

# Menu options
if [ $choice -eq 0 ] ;
then
	echo "Exited program"
	echo "wkcr: Program exited successfully " >> "wkcr.log"
	exit 0

elif [ $choice -eq 1 ] ;
then
	echo "wkcr: Bash project creating " >> "wkcr.log"
	echo -n "Give project folder / dir name: "
	read dir
	echo -n "Give file name that you want to create: "
	read file
	
	# When user enter script.sh this changes value of $file to be only script.sh not script.sh.sh
	if [[ $file =~ .sh$ ]] ;
	then
		file="$file"
	else
		file="$file.sh"
	fi

	echo "wkcr: Bash file name corrected " >> "wkcr.log"

	# Use funtion to check if folder exists on disk and ask user to delete it
	echo "wkcr: check if $dir exists " >> "wkcr.log"
	check "$dir"

	# Check if directory exists
	if [ -z $dir ] ;
	then
		echo "wkcr: Empty string to webdev directory: " >> "wkcr.log"
		if [ -e $file ]
		then
			echo "wkcr: File exists " >> "wckr.log"
			echo "$file File with that name already exists on your disk"
			exit 0
		else
			dir="Folder that you are in"
			touch $file
			echo "Created file $file in $dir"
			echo "wkcr: $file created in $dir " >> "wkcr.log"
		fi
	else
		if [ -d $dir ] ;
		then
			echo "$dir Folder with that name already exists on your disk"
			exit 0
		else
			mkdir $dir
			echo "wkcr: make directory $dir " >> "wkcr.log"
			touch "$dir/$file"
			echo "wkcr: create file $file in $dir " >> "wkcr.log"
			echo -e '#!/bin/bash \n\n#This is example bash program \n\necho "Hello World"' >> "$dir/$file"
			chmod a+x "$dir/$file"
			echo "wkcr: Permision a+x add to $file inside $dir " >> "wkcr.log"
			echo "Add all permissions to $file"
			echo -e "To execute commands type: \n\tcd $dir\n\t ./$file"
		fi
	fi

elif [ $choice -eq 2 ] ;
then
	# Web development variables
	cssFile=styles.css
	jsFile=script.js
	echo "wkcr: enter second menu option: " >> "wckr.log"
	echo -n "Folder name where you want to project be created: "
	read webDir

	# Check if directory exists
	if [ -d $webDir ] ;
	then
		echo "wkcr: $webDir exists on disk " >> "wkcr.log"
		echo "$webDir Folder with that name already exists on your disk"
		exit 0

	else 
		echo -n "Type what file structure you want(0,1,2): "
		read str

		if [ $str -eq 0 ]
		then
			# Check if example files exists
			if [ -f "config/example.css" ] || [ -f "config/example.js" ] ;
			then
				mkdir $webDir
				echo "wkcr: Directory $webDir was created" >> "wkcr.log"
				touch "$webDir/index.html" "$webDir/$cssFile" "$webDir/$jsFile"
				echo "wkcr: Create file index.html, $cssFile, $jsFile in $webDir" >> "wkcr.log"
				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
				echo "wkcr: Starters copied to project directory " >> "wkcr.log" 
			fi
		elif [ $str -eq 1 ]
		then
			# Check if example files exists
			if [ -f "config/example.css" ] && [ -f "config/example.js" ] ;
			then
				echo "wkcr: example.css, example.js exists" >> "wkcr.log"
				mkdir -p $webDir "$webDir/css" "$webDir/js"
				echo "wkcr: Made directories: $webDir $webDir/css $webDir/js" >> "wkcr.log"
				touch "$webDir/index.html" "$webDir/css/$cssFile" "$webDir/js/$jsFile"
				echo "wkcr: Made index.html, $cssFile in $webDir/css, $jsFile in $webDir/js" >> "wkcr.log"

				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
				
				echo "wkcr: Starters copied to project directory " >> "wkcr.log" 
			else 
				echo "wkcr: Missing example files for webdevelopment in option 2 in config folder " >> "wkcr.log"
				echo "Missing config files add it to current location"
				#TODO add check if user is using mac/linux/windows
				open .
				exit 0
			fi
		elif [ $str -eq 2 ]
		then
			echo "Structure with sass"
			# Check if example files exists
			if [ -f "config/example.css" ] && [ -f "config/example.js" ] && [ -f "config/example.scss" ];
			then
				echo "wkcr: example.css, example.js, example.scss exists" >> "wkcr.log"
				mkdir -p $webDir "$webDir/css" "$webDir/sass" "$webDir/js" "$webDir/sass"
				echo "wkcr: make $webDir $webDir/css $webDir/sass/ $webDir/js/ directories successfully" >> "wkcr.log"
				touch "$webDir/index.html" "$webDir/css/$cssFile" "$webDir/js/$jsFile" "$webDir/sass/variables.scss" "$webDir/sass/styles.scss"
				echo "wkcr: make index.html in root $webDir $cssFile file in $webDir/js/$jsFile $webDir/sass/variables.scss $webDir/sass/styles.scss successfully" >> "wkcr.log"

				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
				cp "config/sass/styles.scss" "$webDir/sass/styles.scss"
				cp "config/example.scss" "$webDir/sass/variables.scss"
				echo "Sass project created"
				echo "wkcr: copied starters from sass option in webdevelopment successfuly to $webDir " >> "wkcr.log"
			else 
				echo "wkcr: Missing example files for webdevelopment in option 3 in config folder " >> "wkcr.log"
				echo "Missing config files add it to current location"
				#TODO add check if user is using mac/linux/windows
				open .
				exit 0
			fi
		else
	
	echo "wkcr: Webdevelopment else option from folder structure if" >> "wkcr.log"
	echo "You typed wrong project structure, only available options 0,1,2 check docs $docs from more info"
	echo -n "Redirect to link (y/n): "
	read link

	if [ $link == "y" ];
	then
		#TODO add check if user is using mac/linux/windows
		open $docs
	fi

	fi
	
	fi
	
	# Tell user commands to type and open Finder / Explorator
	echo -e "\nProject created, to start development type: \n\n\t cd $webDir"
	open $webDir

elif [ $choice -eq 3 ] ;
then 
	echo "wkcr: Menu option 3 cpp folder creating" >> "wkcr.log"
	cppFile="main.cpp"
	echo -n "Give project folder name that you want to be created: "
	read cppDir
	if [ -d $cppDir ] ;
	then
		echo "wkcr: Folder $cppDir exists, from menu option 3" >> "wkcr.log"
		echo "$cppDir Folder with that name already exists on your disk"
		exit 0
	else
		mkdir $cppDir
		echo "wkcr: Menu option 3 $cppDir" >> "wkcr.log"
		touch "$cppDir/$cppFile"
		echo "wkcr: Menu option 3 $cppFile created in $cppDir" >> "wkcr.log"
		# Give starter point to file
		echo -e '#include <iostream>\n\n# example cpp code \n\nint main() {\n\n\tcout << "Hello World" << endl\n\n# your code here\n\n}' > "$cppDir/$cppFile"
		echo "wkcr: Menu option 3 include in $cppFile starter template" >> "wkcr.log"
	fi
	
	echo -n "Create class file (y/n): "
	read a

	if [[ "$a" == "y" ]] ;
	then
			echo -n "Give class name: "
			read b

			touch "$cppDir/$b.cpp" "$cppDir/$b.h"
			echo "wkcr: Menu option 3 create class files in $cppDir" >> "wkcr.log"
			# Starer point for class .cpp file
			echo -e '#include ''"'$b.h'"'' \n# your code here' > "$cppDir/$b.cpp"
			echo "wkcr: Menu option 3 add template to cpp classes" >> "wkcr.log"
			
			# Create uppercase guard to class header file
			echo $b | tr a-z A-Z > tmp
			echo "wkcr: Menu option 3 tmp created" >> "wkcr.log"
			for i in `cat tmp`
			do
				echo -e "#ifndef ${i}_H #include guard \n#define ${i}_H\n\n# your code here\n\n#endif /* ${i}_H */" > "$cppDir/$b.h"
			done
			
			# Remove tmp file 
			rm tmp
			echo "wkcr: Menu option 3 remove tmp file" >> "wkcr.log"

			echo -e "Project created \n\n\tcd $cppDir"
			#cd $cppDir
			#TODO add check if user is using mac/linux/windows
			open $cppDir
	elif [ "$a" == "n" ]
	then
			echo -e "Project created, cd $cppDir"
			# cd $cppDir 
			#TODO add check if user is using mac/linux/windows
			open $cppDir
			exit 0
	else 
		echo "wkcr: Menu option 3 creating classes error give something else than y/n" >> "wkcr.log"
		echo "Something wrong only avaiable options are y/n"
		exit 0
	fi


	
elif [ $choice -eq 4 ] ;
then 
	echo "wkcr: Menu option 4 entered" >> "wkcr.log"
	echo -n "Give project folder name: "
	read javaD

	# Use default value when user enter nothing
	if [ -z $javaD ] ;
	then
		javaD=$javaDir
	else
		javaD=$javaD
	fi

	echo "wkcr: Menu option 4 correct java file name" >> "wkcr.log"

	# Check if that directory exists
	if [ -d $javaD ]
	then
		echo "wkcr: Menu option 4 $javaD exists" >> "wkcr.log"
		echo "$javaD Folder with that name already exists"
		exit 0
	else
		mkdir $javaD
		echo "wkcr: Menu option 4 folder $javaD made" >> "wkcr.log"
		echo -n "Give file or files names to create: "
		read files
		for i in $files
		do
			touch "$javaD/$i.java"
			echo -e 'public class' $i ' {\n\tpublic static void main(String args[]) {\n\t\t// Example code\n\t\tSystem.out.println("Hello world");\n\n\t\t// Your code here\n\t}\n}' > "$javaD/$i.java"
			echo "wkcr: Menu option 4 $javaD/$i created and add template to file" >> "wkcr.log"
		done
	fi

	#TODO Add instruction to run java files
	echo -e "Project created \n\n\t cd $javaD"

elif [ $choice -eq 5 ] ;
then
	echo "wkcr: Menu option 5 entered" >> "wkcr.log"
	echo -n "Give project folder name that you want to be created "
	read c

	if [ -z $c ]
	then
		echo "wkcr: Menu option 5 c is empty set value of c to $DEFAULTPROJECTNAME" >> "wkcr.log"
		c=$DEFAULTPROJECTNAME
	fi

	# Check if folder exists
	if [ -d $c ] 
	then
		echo "$c Folder with that name already exists"
		echo "wkcr: Menu option 5 folder exists" >> "wkcr.log"
		exit 0
	else
		mkdir $c 
		echo "wkcr: Menu option 5 folder $c created" >> "wkcr.log"
		echo "Folder $c was created"
	fi

	echo -n "Give project extension (without .): "
	read extension
	
	if [ -z $extension ]
	then
		echo "wkcr: Menu option 5 empty extension" >> "wkcr.log"
		echo "Sorry, extension is required: "
		exit 0
	fi

	echo -n "Give file name or names to create (without extension ex script not script.EXTENSION): "
	read f

	if [ $extension == "py" ] ;
	then
		echo "Downloading python project"
		download example.py
		echo "wkcr: Menu option 5 python project downloaded" >> "wkcr.log"
	fi

	if [ $extension == "go" ] ;
	then
		echo "Downloading go project"
		download example.go
		echo "wkcr: Menu option 5 go project downloaded" >> "wkcr.log"
	fi

	if [ $extension == "ru" ] ;
	then
		echo "Downloading ru project"
		download example.ru
		echo "wkcr: Menu option 5 ruby project downloaded" >> "wkcr.log"
	fi


	for i in $f
	do
		#TODO validation preventing to create file with two extensions ex. script.py.py
		if [ -f "$c/$i.$extension" ]
		then 
			echo "$i exists in $c folder "
			echo "wkcr: Menu option 5 file $i exists in $c" >> "wkcr.log"
		else
			touch "$c/$i.$extension"
			cp "$CFGF/example.$extension" "$c/$i.$extension" 2> /dev/null
			echo "wkcr: Menu option 5 copied successfully" >> "wkcr.log"
		fi
	done

	echo -e "\nProject created, \n\n\tcd $c"

elif [ $choice -eq 6 ]
then
	echo "wkcr: Menu option 6 help option" >> "wkcr.log"
	echo "Missing some files I will try to help you"
	if [ -f help.sh ] ;
	then
		echo "wkcr: Menu option 5 execute help.sh file" >> "wkcr.log"
		exec ./help.sh
	else 
		# Download help.sh file
		echo "Downloading file "
		download "$REPO/help.sh"
		echo "wkcr: Menu option 6 downloaded help.sh file" >> "wkcr.log"
	fi


else 
	#TODO Add color here
	echo "This value doesn't appear in menu, check and try again"
	echo "wkcr: Menu option else menu option" >> "wkcr.log"
	echo "You typed wrong project structure, only available options 0,1,2,3,4,5,6 check docs $docs from more info"
	
	echo -n "Redirect to link (y/n): "
	read link

	if [ $link == "y" ];
	then
		#TODO add check if user is using mac/linux/windows
		open $docs
	fi

	exit 0
fi

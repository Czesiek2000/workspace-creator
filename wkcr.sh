#!/bin/bash
# Config file store all output on terminal
CFGF=config
CONFIG="$CFGF/config.txt"
# This file store all program default values of variables
FILECFG="$CFGF/filecfg"
source $FILECFG

# Clear terminal window
clear 

# Show some space for better view
echo -e "\n\n"

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

# Check if config files exists
if [ ! -f $CONFIG ]
then
	echo "$CONFIG file doesn't exists, can't run program"
	exit 0
fi

if [ ! -f $FILECFG ]
then
	echo "$FILECFG file doesn't exists, can't run program, this file needs to be located in the same directory as script directory"
	exit 0
fi

# Regex use later in script
RE=^[0-9]+$

# Read and display data on screen from config file
cat $CONFIG | while read LINE ;
do
	echo $LINE
done

echo -n "Your choice: "
read choice

# Check if user enter right value 
while [[ ! $choice =~ ^[0-9]+$ ]] ; do
 echo "Wrong value type once more: "
 read choice
done

# Menu options
if [ $choice -eq 1 ] ;
then
	#echo "Choose option 1, bash project will be creating "
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

	# Use funtion to check if folder exists on disk and ask user to delete it
	check "$dir"

	# Check if directory exists
	if [ -z $dir ] ;
	then
		if [ -e $file ]
		then
			echo "$file File with that name already exists on your disk"
			exit 0
		else
			dir="Folder that you are in"
			touch $file
			echo "Created file $file in $dir"
		fi
	else
		if [ -d $dir ] ;
		then
			echo "$dir Folder with that name already exists on your disk"
			exit 0
			#cd $dir
		else
			mkdir $dir
			#cd $dir
			touch "$dir/$file"
			echo -e '#!/bin/bash \n\n#This is example bash program \n\necho "Hello World"' >> "$dir/$file"
			chmod a+x "$dir/$file"
			echo "Add all permissions to $file"
			#cd ..
			echo -e "To execute commands type: \n\tcd $dir\n\t ./$file"
		fi
	fi

elif [ $choice -eq 2 ] ;
then
	# Web development variables
	cssFile=styles.css
	jsFile=script.js
	#echo "value 2 web development basic workspace"
	echo -n "Folder name where you want to project be created: "
	read webDir

	# Check if directory exists
	if [ -d $webDir ] ;
	then
		echo "$webDir Folder with that name already exists on your disk"
		exit 0

	else 
		echo -n "Type what file structure you want(0,1): "
		read str

		if [ $str -eq 0 ]
		then
			mkdir $webDir
			touch "$webDir/index.html" "$webDir/$cssFile" "$webDir/$jsFile"
			if [ -f "config/example.html" ] && [ -f "config/example.css" ] || [ -f "config/example.js" ] ;
			then
				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
			fi
		elif [ $str -eq 1 ]
		then
			mkdir -p $webDir "$webDir/css" "$webDir/js"
			touch "$webDir/index.html" "$webDir/css/$cssFile" "$webDir/js/$jsFile"
			if [ -f "config/example.html" ] && [ -f "config/example.css" ] && [ -f "config/example.js" ] ;
			then
				# Starters 
				echo -e '<!DOCTYPE html>\n<html lang="en">\n<head>\n\t<meta charset="UTF-8">\n\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t<title>Example HTML file</title>\n\t<link rel="stylesheet" href='"'$cssFile'"'></head>\n<body>\n\t<h1>Hello world</h1>\n\t<script src='"'$jsFile'"'></script>\n</body>\n</html>' >> "$webDir/index.html"
				cp "config/example.css" "$webDir/$cssFile"
				cp "config/example.js" "$webDir/$jsFile"
			else 
				echo "Missing config files add it to current location"
				# open .
				exit 0
			fi
		else
			# echo "Else here " 
		# 	##TODO Add docs variable with docs link
			docs=https://github.com
			echo "You typed wrong project structure, only available options 0,1, check docs $docs from more info"
		fi
	fi
	# Tell user commands to type and open Finder / Explorator
	echo -e "Project created, to start development type: \n\n\t cd $webDir"
	# open $webDir

elif [ $choice -eq 3 ] ;
then 
	#echo "value 3"
	cppFile="main.cpp"
	echo -n "Give project folder name that you want to be created: "
	read cppDir
	if [ -d $cppDir ] ;
	then
		echo "$cppDir Folder with that name already exists on your disk"
		exit 0
	else
		mkdir $cppDir
		touch "$cppDir/$cppFile"
		# Give starter point to file
		echo -e '#include <iostream>\n\n# example cpp code \n\nint main() {\n\n\tcout << "Hello World" << endl\n\n# your code here\n\n}' > "$cppDir/$cppFile"
	fi
	
	echo -n "Create class file (y/n): "
	read a

	if [[ "$a" == "y" ]] ;
	then
			echo -n "Give class name: "
			read b
			# Validation
			#while [ ! $b =~ ^[a-zA-Z]+$ ] ;
			#do
				#echo "Type once more class name "
				#read b
			#done
			touch "$cppDir/$b.cpp" "$cppDir/$b.h"
			# Starer point for class .cpp file
			echo -e '#include ''"'$b.h'"'' \n# your code here' > "$cppDir/$b.cpp"
			
			# Create uppercase guard to class header file
			echo $b | tr a-z A-Z > tmp
			for i in `cat tmp`
			do
				echo -e "#ifndef ${i}_H #include guard \n#define ${i}_H\n\n# your code here\n\n#endif /* ${i}_H */" > "$cppDir/$b.h"
			done
			# remove tmp file 
			rm tmp

			echo -e "Project created \n\n\tcd $cppDir"
			#cd $cppDir
			open .
	else 
			echo "Project created, cd $cppDir"
			cd $cppDir 
			open .
			exit 0
	fi

		#echo "Project created, cd $cppDir"
	
elif [ $choice -eq 4 ] ;
then 
	#echo "value 4"
	echo "Give project folder name  "
	read javaD

	# Use default value when user enter nothing
	if [ -z $javaD ] ;
	then
		javaD=$javaDir
	else
		javaD=$javaD
	fi

	# Check if that directory exists
	if [ -d $javaD ]
	then
		echo "$javaD Folder with that name already exists"
		exit 0
	else
		echo -n "Give file or files names to create: "
		read files
		for i in $files
		do
			touch "$javaD/$i.java"
		done
	fi

	echo -e "Project created \n\n\t cd $javaD"

elif [ $choice -eq 5 ] ;
then
	#echo "wartosc 5"
	echo -n "Give project folder name that you want to be created "
	read c
	
	if [ -z $c ] ;
	then
		echo "Project name create with default name "
		
	fi

	# Check if folder exists
	if [ -d $c ] 
	then
		echo "$c Folder with that name already exists"
		exit 0
	else
		mkdir $c 
		echo "Folder $c was created"
	fi

	echo -n "Give project extension (without .): "
	read extension
	
	if [ -z $extension ]
	then
		echo "Sorry, extension is required: "
		exit 0
	fi

	echo -n "Give file name or names to create (without extension ex .py): "
	read f

	for i in $f
	do
		#if [ $i =~ ($extension)$ ] ;
		#then
		#	touch "$c/$i"
		#	else
			touch "$c/$i.$extension"
		#fi
	done

	echo "Project created, cd $c"
elif [ $choice -eq 6 ]
then
	echo "Missing some files I will try to help you"

else 
	echo "This value doesn't appear in menu, check and try again"
	exit 0
fi
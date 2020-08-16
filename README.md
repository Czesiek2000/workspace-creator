# Workspace creator
![Language](https://img.shields.io/badge/Language-Bash-blue.svg?longCache=true&style=flat-square) ![License](https://img.shields.io/badge/License-MIT-red.svg?longCache=true&style=flat-square)   ![Version](https://img.shields.io/badge/Version-1.0-green.svg?longCache=true&style=flat-square)

This repository is made to simplify project creation and to automate boring stuff like creating files and folders

Project made with bash 

# Download script and start script
* using curl
```
curl -O https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/wkcr.sh

chmod +x wkcr.sh
```

* using wget
```
wget https://raw.githubusercontent.com/Czesiek2000/workspace-creator/master/wkcr.sh

chmod +x wkcr.sh
```
* using git - clone repository to your disk
```
git clone https://github.com/Czesiek2000/workspace-creator.git foldername
# If you didn't specify folder name project will clone to your current directory

cd foldername
```

## File structure 
Program generate file structure based on category and add simple starter template to each file 

* Bash script with argument
> Creates script inside folder that name is given in prompt
```
.
├── test            # Directory with name that you give
│   ├── script.sh   # Script name

```
* Bash script without argument
> When user doesn't give folder name script made file in workspace creator directory without folder
```
.
├── workspace-creator # current directory
│   ├── wkcr.sh # script name 
│   ├── help.sh # script 
│   ├── script.sh # script 
│   ├── README.md # README file

```
* Web development options
```
- Option 0

.
├── webDir          # Main folder
│   └── index.html   
│   └── styles.css
│   └── script.js   

- Option 1

.
├── webDir          # Main folder
│   └── index.html  # Main html file
|   ├── css         # Subfolder with css file
│   │   └── styles.css
|   ├── js          # Subfolder with js file
│   │   └── script.js


- Web development option 2

.
├── webDir            # Main folder
│   ├── index.html    
|   ├── css           # Subfolder with css file
│   │   └── styles.css
|   ├── js            # Subfolder with js file
│   │   └── script.js
|   ├── scss          # Subfolder with sass files
│   │   └── styles.scss
│   │   └── variables.scss
```

* C++ option
> Cpp option can be generated with or without class files 
```
- Without class files
.
├── cppDir          # Main folder
│   └── main.cpp

- With class files 
.
├── cppDir          # Main folder
│   └── main.cpp    # main cpp file   
│   └── main.cpp    # Header file
│   └── main.cpp    # Implementation cpp file
```
* Java option - can be generated one or multiple files
```
.
├── javaDir          # Main folder
│   └── Main.java    # Files generated
│   └── Test.java

```

* Custom option
```
.
├── FolderName                # Main folder
│   └── Filename.extension    # Files generated
│   └── Test.java

```

Description
wkcr can be execute with or without arguments example ./wkcr -h
```
Options available
    -h or --help help command 
    -v or --version show script version
    -g init with git inside specified folder
    -z zip file 
    -Uz unzip file
    -d docs link
More option comming
```
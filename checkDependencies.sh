#!/bin/sh

echo "Checking if all required dependence are installed..."
missing=0


# sha256sum
if ! command -v sha256sum &> /dev/null
then
	echo "sha256sum could not be found"
	missingCommands+=1
fi


# par2
if ! command -v par2create &> /dev/null
then
	echo "par2create could not be found"
	missingCommands+=1
fi

if ! command -v par2verify &> /dev/null
then
	echo "par2verify could not be found"
	missingCommands+=1
fi

# tar
if ! command -v tar &> /dev/null
then
	echo "tar could not be found"
	missingCommands+=1
fi


# tree
if ! command -v tree &> /dev/null
then
	echo "tree could not be found"
	missingCommands+=1
fi

# grep
if ! command -v grep &> /dev/null
then
	echo "tar could not be found"
	missingCommands+=1
fi

# readlink 
if ! command -v readlink &> /dev/null
then
	echo "readlink could not be found"
	missingCommands+=1
fi

# basename
if ! command -v basename &> /dev/null
then
	echo "basename could not be found"
	missingCommands+=1
fi

if [ $missingCommands -ne 0]
then
	echo "Some packages could not be found please fix before running backup and verify"
	exit 10
fi
echo "All required dependencies are present!"
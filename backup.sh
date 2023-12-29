#!/bin/bash

#
# Variables
#

# Source
backupSourceDirectories=("/example/path/to/what/should/be/backup/1" "/example/path/to/what/should/be/backup/2" "/example/path/to/what/should/be/backup/3") # CHANGE ME
treeSourceDirectories=("/can/be/the/same/as/above/or/more/paths" "/example/path/to/what/should/be/backup/1" "/example/path/to/what/should/be/backup/2") # CHANGE ME

# Destination
backupDestination="/this/should/be/the/destination/of/the/backups" # CHANGE ME

# tar error correction procentare default is 20%
errorCorrectionProcentare=20 # CHANGE ME

# system variables
today=$(date +%Y-%m-%d)
currentDirectory=$(pwd)




#
# Input validation
#
inputValidation=0

echo "Check backup source directories..."
for sourcePath in ${backupSourceDirectories[@]}; do
	# Check if directory exists
	if [ ! -d "$sourcePath" ]; then
		echo "$sourcePath does exist..."
		inputValidation+=1
	fi
done

echo "Check tree source directories..."
for sourcePath in ${treeSourceDirectories[@]}; do
	# Check if directory exists
	if [ ! -d "$sourcePath" ]; then
		echo "$sourcePath does exist..."
		inputValidation+=1
	fi
done

echo "Check backup destination directory..."
if [ ! -d "$backupDestination" ]; then
	echo "$backupDestination does exist..."
	inputValidation+=1
fi

if [ $inputValidation -ne 0 ]
then
	echo "Error: some paths are not present..."
	exit 10
fi


#
# Backup
#
echo "Starting backup..."
mkdir -p "$(readlink -m $backupDestination)/backup_$today"

for sourcePath in ${backupSourceDirectories[@]}; do
	# Creating backup directory
	destination="$(readlink -m $backupDestination)/backup_$today/$(basename $sourcePath).tar"
	echo "backing up to: $destination"

	# Backing up directory without compression and relative paths
	tar -cf $destination -C $sourcePath .

	# Creating sha256sum of the contents of the backup
	cd $sourcePath
	rm -f /tmp/sha256sum.sha256
	find . -type f -exec sha256sum {} \; >> /tmp/sha256sum.sha256
	cd $currentDirectory
	mv /tmp/sha256sum.sha256 $destination.sha256sum
done


#
# Tree
#
echo "Starting directory structure backup..."

for sourcePath in ${treeSourceDirectories[@]}; do
	# Creating tree backup file path
	directoryBackupDestination="$(readlink -m $backupDestination)/backup_$today/$(basename $sourcePath).txt"
	echo "Running directory tree for: $sourcePath"

	# Tree recursively including hidden files to text file
	tree -aR $sourcePath > $directoryBackupDestination
done


#
# SHA256SUM
#
echo "Creating SHA256 checksum for the backup..."

# Change in to backup directory create relative paths for the sha256sum
cd "$(readlink -m $backupDestination)/backup_$today/"

# Create sha256sum for all files and save the results in backup_today directory
rm -f sha256sum.sha256
find . -type f -exec sha256sum {} \; >> /tmp/sha256sum.sha256
mv /tmp/sha256sum.sha256 ./backup_$today.sha256

# Change back the directory
cd $currentDirectory

#
# Par2
#
echo "Creating par2 parity data for tar files..."

parRedundancy="-r$(grep -Eo '[0-9]+' <<< $errorCorrectionProcentare)"

find $backupDestination/backup_$today -iname "*.tar" -exec par2create -q $parRedundancy {} \;


#
# Done
#
echo "Backup done!"
#!/bin/bash

#
# Variables
#

# Backup source
backupDirectory="/this/should/be/the/destination/of/the/backups" # CHANGE ME

# system variables
currentDirectory=$(pwd)

#
# Input validation
#
inputValidation=0

echo "Check backup directory..."
if [ ! -d "$backupDirectory" ]; then
	echo "$backupDirectory does exist..."
	inputValidation+=1
fi

if [ $inputValidation -ne 0 ]
then
	echo "Error: some paths are not present..."
	exit 10
fi

#
# Preparations
#

# Get all the backups to an array
mapfile -d $'\0' backUpDirectories < <(find $backupDirectory -maxdepth 1 -mindepth 1 -type d -print0)


#
# Looping trough all backup directories
#
for sourcePath in ${backUpDirectories[@]}; do
	echo "Checking: $(basename $sourcePath)"
	cd $sourcePath

	# Creating verify log header
	cat >> ./verify_log.txt << EOF



###############################################################################
Beginning of backup verify:
Run date: $(date)
###############################################################################
EOF

	#
	# SHA256SUM
	#
	echo -e "\nVerifying SHA256 SUM:" | tee -a ./verify_log.txt
	sha256sum -c $(basename $sourcePath).sha256 | tee -a ./verify_log.txt


	#
	# Par2verify
	#
	echo -e "\nVerifying par2 archives:" | tee -a ./verify_log.txt
	find . -iname "*.tar" -exec par2verify -q {} \; | tee -a ./verify_log.txt


	cat >> ./verify_log.txt << EOF


###############################################################################
End of backup verify:
###############################################################################
EOF

	cd $currentDirectory
done
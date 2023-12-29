# Backup and verify
This simple script creates an tar backup of directories listed as well as an directory listing of the contents.

The purpose of the script is to be a more long term back up thus, being able to check and verify the state of the data is important. This is achieved with two tools:
1. Hash sums sha256sums are generated for all files and is checked on verify to see if the files have changed
2. To mitigate from minor bit rot par2 archives are created to repair the tar archives

All paths is also hardcoded via variables to make it easy to run multiple times and not have to worry what flags should be used. 


## Process
The process for backing up and verifying with these scripts are as follows.

### Prerequisites
1. `checkDependencies.sh` has been ran on the system and all required dependencies are installed
2. All backup directories are mounted
	1. *Note: This is not handeld by the script to make it more flexbale.*
3. Backup destination directory is mounted if applicable
	1. *Note: This is not handeld by the script to make it more flexbale.*
3. Example paths in the user variable section of `backup.sh` and `verify.sh` have been changed
	1. These variables are marked with `# CHANGE ME`

### Verify existing backups
1. Run `verify.sh` to check the state of the existing backups
	1. *Note: if it is the first backup this is not necessary*

### Backup
1. Run `backup.sh` to backup the directories and create sha256sum and par2 archives
#!/bin/bash

# The user typing: /bigBrother.sh target_path
target_path=$1
mydir="/${target_path#/*/*/}"
mydir=${mydir#"/"}

# Checks if the file does not exist and creates the file.
if [ ! -e "$target_path"/MrRobot ]; 
	then
	echo "Welcome to the Big Brother"
	touch "$target_path"/MrRobot

	#  -F: / – directory.
	#  nothing – normal file.
	#  @ – link file.
	#  * – Executable file
	ls -F -d "$target_path"/* > "$target_path"/MrRobot



else
	# Creates a new tmp file deleted at the end of your script
	touch "$target_path"/tmp
	ls -F -d "$target_path"/*  > "$target_path"/tmp
	diff "$target_path"/MrRobot "$target_path"/tmp | grep '^>' > "$target_path"/tmpCreatedList

	cat "$target_path"/tmpCreatedList | while read line
	do
		if [[ ! ($line == *"tmp"*) ]]
		then
			i=$((${#line}-1))
			lastChar="${line:$i:1}"

			if [[($lastChar == '/') ]]
			then
				line=$(basename "$line")	
				tmpEcho=$mydir'/'$line
				echo ‫‪"Folder created: $tmpEcho" 
				
			else
				line=$(basename "$line")
				tmpEcho=$mydir'/'$line
				echo ‫‪"File created: $tmpEcho"‬‬ 
			fi
		fi
	done
	

	diff "$target_path"/MrRobot "$target_path"/tmp | grep '^<' > "$target_path"/tmpDeletedList
	cat "$target_path"/tmpDeletedList | while read line
		do
		if [[ ! (($line == *"tmpCreatedList"*))]]
			then
			line=$(basename "$line")
			echo "File deleted: $line"
			delete_counter=$((delete_counter+1))
		fi	
	done


	# Updating the file for the next time and delete the tmp file
	rm "$target_path"/tmpDeletedList
	cp "$target_path"/tmp "$target_path"/MrRobot
	rm "$target_path"/tmpCreatedList
	rm "$target_path"/tmp
			
fi


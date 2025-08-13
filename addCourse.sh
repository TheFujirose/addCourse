#!/bin/bash
# files are as follows
# 1. folders named after course code
# 2. symbolic links named after course name
# arguement 1 is specified directory
# Author: Carson Fujita 
# Aug 13, 2025
#check if arguments exists
if [ $# -eq 0 -o $# -gt 2 ]; then 
		echo "Usage: addCourse [directory] [number of courses]" 1>&2
		exit 1
fi

# checks if the first arguement is invalid
if [ ! -d "$1" ]; then
	echo "First argument has to be a directory." 1>&2
	echo "Usage: addCourse [directory] [semester number]" 1>&2
	exit 1
else
	semester="$1"
fi

# checks if the second arguement is invalid
if [ -d "$2" ]; then
	echo "Second argument cannot be a directory." 1>&2
	echo "Usage: addCourse [directory] [number of courses]" 1>&2
	exit 1
	elif [[ ! "$2" =~ ^[0-9]+$ ]]; then #any number
		echo "Second argument must be a number." 1>&2
		echo "Usage: addCourse [directory] [number of courses]" 1>&2
		exit 1
	else
		courseAmount="$2"
fi

if [[ ! "$1" =~ //* ]]; then
	echo "Directory must start from root directory." 1>&2
	exit 1
fi

#used for setting amount of courses
declare -a courses
#used for course names
declare -a courseNames	
count=0 #counter for iteration	

until [ "$count" -ge "$courseAmount" ]; do
		echo -n "Enter course code: "
		read code
		#check if user already has written this code
		for courseCode in "${courses[@]}"; do 
			if [ "$courseCode" == "$code" ]; then
				echo "course $code already exists" 1>&2
				((count+=1))
				continue 2
			fi
		done
		#check if code has number at end
		if [[ ! "$code" =~ .*[0-9]+$ ]]; then
			echo "course code needs to have a number at the end" 1>&2
			continue
		#check if directory already exists
		elif [[ -d "$semester/$code" ]]; then
			echo "course directory $code already exists" 1>&2
			((count+=1))
			continue
		#check if code is in capitals? maybe default change them to capitals?
		elif [[ ! "$code" =~ ^[A-Z]+[0-9]+$ ]]; then
			echo "course code must be in capitals" 1>&2
			continue
		fi
			
		echo -n "Enter course name: " 
		read courseName

		for (( index=0; index<${#courseNames[@]}; index++ )); do
			name="${courseNames[$index]}"
			if [ "$courseName" == "$name" ]; then
				echo "Another course contains name: $courseName."
				echo "Would you still like to add this course?"
				echo -n "(y/n) or c to cancel: "
				read answer
				if [[ "$answer" =~ [Yy] ]]; then
					courses+=($code)
					courseNames+=("$courseName")
					((count++))
					echo "Course: $courseName ($code) added to list"
				elif [[ "$answer" =~ [Nn] ]]; then
					echo "Course: $courseName ($code) will not be added to list"
					echo "Change name of course $code."
					echo -n "Enter new name:"
					read courseName
					index=0 #start from top
					continue
				elif [[ "$answer" =~ [Cc] ]]; then
					echo "Course code: $code will not be added"
					continue 2 #continues to new code 
				else 
					echo "Please enter 'y' or 'n'."
				fi
			fi
		done

		courses+=($code)
		courseNames+=("$courseName")
		((count++))
		echo "Course: $courseName ($code) added to list"
done

for (( index=0; index<${#courseNames[@]}; index++ )); do
	echo "adding ${courseNames[$index]} (${courses[$index]})"
	mkdir "$semester/${courses[$index]}"
	ln -s "$semester/${courses[$index]}" "$semester/${courseNames[$index]}"

done

echo complete
exit 0;
#add all courses
#for courseCode in "${courses[@]}"; do
#	mkdir "$semester/$courseCode"


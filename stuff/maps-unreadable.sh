#!/usr/bin/env bash
#
# My Academic Paper Search (MAPS) project
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Sort unreadable (text-empty) PDF files
#
# April 24nd, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

# Assumes working from the current directory

# String to be displayed as a "progress indicator"
sp='/-\|'

echo ""
echo ""
echo "MAPS v. 0.1 - (c) Michele Giugliano, April 2019"
echo ""
echo ">>> Identifying text-empty PDF files in the current folder"
echo ""

echo ">>> Step 1: creating the unreadable_PDF folder..."
command mkdir  -pv ./unreadable_PDF
echo ">>> Done!"

#-------------------------------------------------------------------------------------------------------------------------
echo ">>> Step 2: replacing blanks and dots from PDF filenames..."
printf ' '

for file in ./*.pdf        # This does NOT work recursively, descending the subfolders!
do
	mypath=$(dirname "$file")
	mybase=$(basename "$file")
    myname=${mybase%.*}

	case $myname in   # I check for 'spaces', to speed up execution
		*\ * )
			#echo "$myname contains spaces!!"
			command mv "$file" "$mypath/${myname// /_}.pdf"
			myname="${myname// /_}"
			;;
		*)
			#echo "$myname does NOT contain 'spaces'."
			;;
	esac


	case $myname in   # I check for 'dots', to speed up execution
		*.* )
			#echo "$myname contains dots!!"
			command mv $mypath/$myname.pdf "$mypath/${myname//./_}.pdf"
			;;
		*)
			#echo "$myname does NOT contain 'dots'."
			;;

	esac

	# "progress indicator"
    printf '\b%.1s' "$sp"
	sp=${sp#?}${sp%???}
done
printf ' '
echo ">>> Done!"

#---------------------------------------------


echo ">>> Step 3: Checking files..."
printf ' '

for file in ./*.pdf        # This does NOT work recursively, descending the subfolders!
do
        textfile=$(basename "$file" .pdf).txt      # name of the (text) file, generated removing .pdf and adding .txt

        	pdftotext -f 1 -l 2 $file 2>/dev/null
			# pdftotext has been invoked, starting from (first) page 1 and finishing
			# at (last) page 2, standard error is redirected to NULL

			wordcount=$(wc -w $textfile | awk '{print $1}')
			if [ "$wordcount" == "0" ]; then 		# pdftotext could NOT create a valid text file
				command mv $file unreadable_PDF/
			fi
		command rm $textfile
		# "progress indicator"
        printf '\b%.1s' "$sp"
		sp=${sp#?}${sp%???}
done

printf ' '
echo ">>> Done!"







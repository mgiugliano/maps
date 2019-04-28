#!/usr/bin/env bash
#
# My Academic Paper Search (MAPS) project
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Maintain or bootstrap the PDF papers database metadata
# Invoke it with any (extra) input argument, to trigger
# an interactive prompt at renaming text-unreadable files.
#
# April 28th, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

# The env var ROOT_PDF_FOLDER should have been set in the .bash_profile

# Set the full path to the metadata subfolders...
TEXTSUB=$ROOT_PDF_FOLDER/.cache
SEARCHDIR=$TEXTSUB/data

# Let's store aside the current working directory...
CWD=$(pwd)

# String to be displayed as a "progress indicator"
sp='/-\|'

# Let's now change dir into the proper metadata subfolder
command cd $ROOT_PDF_FOLDER            # Change directory to the main PDF folder
echo ""
echo ""
echo "MAPS v. 0.1 - (c) Michele Giugliano, April 2019"
echo "Metadata maintenance script"
echo ""
echo "(invoke me with input arg. 'y', for interactive"
echo "renaming of text-unreadable PDF files)"
echo ""
echo ">>> Database root is $ROOT_PDF_FOLDER"
echo ""

printf ">>> Step 1: creating/checking for (sub)folder structure..."
command mkdir  -pv $SEARCHDIR
echo " Done!"

#---------------------------------------------
echo ">>> Step 2: replacing dots and blanks from PDF filenames..."
printf ' '

# By the "find -depth" command below, I search for *.pdf files in the root dir
# as well as, recursively, in any of its subfolders.

IFS=$'\n'; set -f # IFS (internal field seperator) temporarily set to the newline character
				  # (otherwise the recursive find below won't work with spaces in filanames)

#for file in ./*.pdf                       # This does NOT work recursively!
for file in $(find . -depth -name '*.pdf') # This does and it descends subfolders!
do
	mypath=$(dirname "$file") 			   # The file path is inferred here...
	mybase=$(basename "$file") 			   # The (basename) file name here...
	myname=${mybase%.*} 				   # The (basename) file name without suffix...

	case $myname in   # I first check for 'spaces', to speed up execution
		*\ * )
			#echo "$myname contains spaces!!"
			#echo "The original file is renamed, replacing spaces by underscores."
			command mv "$file" "$mypath/${myname// /_}.pdf"
			#echo "The (basename) file name is also amended, removing spaces..."
			myname="${myname// /_}"
			;;
		*)
			#echo "$myname does NOT contain 'spaces'."
			;;
	esac

	case $myname in   # I check for 'dots', to speed up execution
		*.* )
			#echo "$myname contains dots!!"
			#echo "The original file is renamed, replacing dots by underscores."
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
unset IFS; set +f # IFS set back to default

printf ' '
echo ">>> Done!"
#---------------------------------------------

echo ">>> Step 3: Creating metadata..."
printf ' '

IFS=$'\n'; set -f # IFS (internal field seperator) temporarily set to the newline character
				  # (otherwise the recursive find below won't work with spaces in filanames)

mycount=0 		  # Variable to count how many pdf files have been processed...

#for file in ./*.pdf                       # This does NOT work recursively!
for file in $(find . -depth -name '*.pdf') # This does and it descends subfolders!
do
        textfile=$(basename "$file" .pdf).txt      # name of the (text) file, generated removing .pdf and adding .txt

		if [ ! -f $TEXTSUB/$textfile ]; then 	   # If the metadata did NOT already existed,
			let "mycount++" 					   # Increase the file counter
			#echo "    Metadata or $file not found: creating it..."
        	pdftotext -f 1 -l 2 $file $TEXTSUB/$textfile 2>/dev/null
			# pdftotext has been invoked, starting from (first) page 1 and finishing
			# at (last) page 2, standard error is redirected to NULL
			# input argument is the PDF filename and output is the TXT filename

			# Things may go wrong: pdftotext may fail to extract text!
			# Let's count how many words are contained inside the TXT file...
			wordcount=$(wc -w $TEXTSUB/$textfile | awk '{print $1}')

			if [ "$wordcount" == "0" ]; then 		# pdftotext has failed
				echo "    WARNING: a file could not be parsed as text!"
				#echo "    WARNING: $file could not be parsed as text!"
 				# Then the metadata (TXT file) is set to the file name itself (so it is searchable!)

				if [ ! -z $1 ]; then 				# Executed if this script was called with an argument!
				  echo ""
				  echo ""
				  echo "    > $file"
				  echo "    Rename it? Enter the new file name (without .pdf) [ENTER to skip]: "
				  read varname
				  if [ -z "$varname" ]; then   				# empty - ENTER was pressed
				     echo $textfile > $TEXTSUB/$textfile  	# so I create it and populate it with the filename itself
				  else 										# The user has specified a new name...
				  	 mypath=$(dirname "$file")
                     mv $file $mypath/$varname.pdf
					 echo $varname > $TEXTSUB/$textfile
				  fi
				else
				    echo $textfile > $TEXTSUB/$textfile  	# so I create it and populate it with the filename itself
				fi
			fi

			# Remove \n and \r from the text file and generate an additional output
			# file (without suffix) inside the .text/x subfolder,  enabling multiline searching...
        	tr -d "\n\r" < $TEXTSUB/$textfile >$SEARCHDIR/$(basename "$file" .pdf)

		fi

		# "progress indicator"
        printf '\b%.1s' "$sp"
		sp=${sp#?}${sp%???}
done
unset IFS; set +f # IFS set back to default

printf ' '
echo ">>> Done!"

echo "Added $mycount (searchable) entries to the database!"
echo "In total, there are $(find . -depth -name '*.pdf' | wc -l) PDF files in root." #------------------------------------------------------------------------------------------------------------------------t-

# The previous working directory is restored...
command cd $CWD


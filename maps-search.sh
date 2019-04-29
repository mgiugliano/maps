#!/usr/bin/env bash
#
# My Academic Paper Search (MAPS) project
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Search command through the PDF papers database
#
# April 22nd, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

# The env var ROOT_PDF_FOLDER should have been set in the .bash_profile


# Set the  for spawning the PDF viewer (for macOs)
QUICKCMD="qlmanage -p"
EDITCMD="open"
REVEAL="open -R"
#EDITCMD="open -a /Applications/Preview.app/Contents/MacOS/Preview"
#EDITCMD="open -a /Applications/Skim.app/Contents/MacOS/Skim"

ver="MAPS v. 0.1 - (c) Michele Giugliano, April 2019"

echo ""
echo $ver
echo "Fuzzy Search"
echo ""
echo ">>> Database root is $ROOT_PDF_FOLDER"
echo ""
echo " ctrl-o / enter --> quick view"
echo " ctrl-e         --> edit PDF"
echo " ctrl-j         --> jump to (reveal in Finder) PDF"
echo ""
echo "Press ENTER to access the search..."
read

iterm_profile SSH

# Set the full path to the metadata subfolders...
TEXTSUB=$ROOT_PDF_FOLDER/.cache
SEARCHDIR=$TEXTSUB/data


# Let's store aside the current working directory...
CWD=$(pwd)

# Let's now change dir into the proper metadata subfolder
command cd $SEARCHDIR # Change directory to the metadata subfolder

# The fuzzy search itself... (see the comments below)

#entry=$(rg --no-line-number --no-messages -j0 -p --block-buffered --color=never --with-filename --no-heading . | fzf -e -i --select-1 --exit-0 --expect=ctrl-o,ctrl-e,ctrl-j --color=bg+:24 --delimiter=: -1 --nth=2.. --sync --algo=v2 --extended --reverse --preview="tput bold; echo {1}; tput sgr0; echo; cat $TEXTSUB/{1}.txt" --preview-window=right:70% | awk -F: '{print $1}' | cut -d'.' -f1)

entry=$(rg --no-line-number --no-messages -j0 -p --block-buffered --color=never --with-filename --no-heading . | fzf -e -i --select-1 --exit-0 --expect=ctrl-o,ctrl-e,ctrl-j --header="$ver" --margin 2% --color=bg+:24 --delimiter=: -1 --nth=2.. --sync --algo=v2 --extended --reverse --preview='tput bold; echo {1}; tput sgr0; echo; v=$(echo {q} | tr " " "|"); cat ../{1}.txt 2>/dev/null | ggrep -E "^|$v" -i --color=always' --preview-window=top:80%:wrap | awk -F: '{print $1}' | cut -d'.' -f1)

key=$(head -1 <<< "$entry")               # this may be empty or may be ctrl-j/o/e
file=$(head -2 <<< "$entry" | tail -1)    # this contains the file

if [ ! -z "$file" ]; then
	    fullpathfname=$(find $ROOT_PDF_FOLDER -depth -name $file.pdf);
		echo $fullpathfname
fi


if [ -n "$key" ]; then
  [ "$key" = ctrl-o ] && $QUICKCMD "$fullpathfname" >/dev/null 2>/dev/null
  [ "$key" = ctrl-e ] && $EDITCMD "$fullpathfname"
  [ "$key" = ctrl-j ] && $REVEAL "$fullpathfname"
else # key is empty - the user must have simply selected the file to navigate to
 	if [ -n "$file" ]; then
 		$QUICKCMD "$fullpathfname" >/dev/null 2>/dev/null
    else
	  command cd $CWD
	fi
fi


# Explanation of the above cryptic long command:
# - ripgrep is launched over the folder containing the text-converted and new line-removed files.
# - Next fzf is used to select the result, with preview from the text-converted (normal) files.
# - awk is finally used to isolate the filename, without the .txt suffix (to be later added a .pdf).


# If the user pressed ESC, then $entry is empty and the process aborted
# Otherwise, if not empty, the PDF viewer is spawned on the **corresponding** PDF file..
# Note however that while the "meta" files are all in the same folder, the original PDF
# may be inside a given subfolder (recursively explored, while building the database).
# This requires locating the pdf file first and then open it.

# The previous working directory is restored...
command cd $CWD
iterm_profile

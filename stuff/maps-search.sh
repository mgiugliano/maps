#!/usr/bin/env bash
#
# My Academic Paper Search (MAPS) project
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Search command through the PDF papers database
#
# April 22nd, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

# Set the  for spawning the PDF viewer (for macOs)
#CMD="open -a /Applications/Preview.app/Contents/MacOS/Preview"
CMD="qlmanage -p"

# Set the full path to the PDF database root...
ROOT_PDF_FOLDER=/Users/michi/papers
#ROOT_PDF_FOLDER=/Users/michi/Downloads/Export_Paper3


# Set the full path to the metadata subfolders...
TEXTSUB=$ROOT_PDF_FOLDER/.text
SEARCHDIR=$TEXTSUB/x

# Let's store aside the current working directory...
CWD=$(pwd)

# Let's now change dir into the proper metadata subfolder
command cd $SEARCHDIR # Change directory to the metadata subfolder

# The fuzzy search itself... (see the comments below)
entry=$(rg --no-line-number --no-messages -j0 -p --block-buffered --color=never --with-filename --no-heading . | fzf -e -i --color=bg+:24 --delimiter=: -1 --nth=2.. --sync --algo=v2 --extended --reverse --preview="tput bold; echo {1}; tput sgr0; echo; cat $TEXTSUB/{1}.txt" --preview-window=right:70% | awk -F: '{print $1}' | cut -d'.' -f1)

# Earlier version
#entry=$(rg --no-line-number --no-messages -j0 -p --block-buffered --color=never --with-filename --no-heading . | fzf -e -i --color=bg+:24 --delimiter=: -1 --nth=2.. --sync --algo=v2 --extended --reverse --preview="tput bold; echo {1}; tput sgr0; echo; bat -p --color=always --theme=zenburn $TEXTSUB/{1}.txt" --preview-window=right:50% | awk -F: '{print $1}' | cut -d'.' -f1)

# Note: my old "1-liner" featured an additional  | xargs -I % sh -c "$CMD $ROOT_PDF_FOLDER/%.pdf")

# Explanation of the above cryptic long command:
# - ripgrep is launched over the folder containing the text-converted and new line-removed files.
# - Next fzf is used to select the result, with preview from the text-converted (normal) files.
# - awk is finally used to isolate the filename, without the .txt suffix (to be later added a .pdf).


# If the user pressed ESC, then $entry is empty and the process aborted
# Otherwise, if not empty, the PDF viewer is spawned on the **corresponding** PDF file..
# Note however that while the "meta" files are all in the same folder, the original PDF
# may be inside a given subfolder (recursively explored, while building the database).
# This requires locating the pdf file first and then open it.
if [ ! -z "$entry" ]; then
	    fullpathfname=$(find $ROOT_PDF_FOLDER -depth -name $entry.pdf);
		echo $fullpathfname
		#$CMD $ROOT_PDF_FOLDER/$entry.pdf >/dev/null 2>/dev/null
		$CMD $fullpathfname >/dev/null 2>/dev/null
fi

# The previous working directory is restored...
command cd $CWD


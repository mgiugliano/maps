# My Academic Paper Search (MAPS)

MAPS is an experimental hack, working from the command line and
engineered for macOs.
This software facilitate the search and identification of a specific
academic PDF paper, from a number of other (unsorted) PDF files contained
in the same root folder (or subfolders).

Requires: (e.g. brew installed) 	fzf (a command line fuzzy-finder)
									ripgrep (a replacement for grep)
									pdftotext (PDF to text converter)
									ggrep (GNU grep)

Works in: bash shell (tested with version 5.02, under macOs only)

The software is basically comprised of two elementary bash scripts. The first
creates for each PDF file two text files, containing the text extracted
from the two first pages of the original PDF. This first script should be
invoked at the very beginning and every time a new PDF file is added to the
root folder.
The second script performs a fuzzy search on all the text extracted, and allows to
locate the corresponding PDF file and perform on it elementary operations such as
 - open it by a quick preview (pressing ENTER or ctrl-o)
 - open it with the PDF reader of choice (pressing ctrl-e)
 - reveal the file in its location by the Finder (pressing ctrl-j)

## Install
1. Add to your .bash_profile (or .bashrc) the shell environment variable

'''export ROOT_PDF_FOLDER=~/Dropbox/papers'''

Such a variable must contain the full path to the (root) folder where your PDF
library resides (even when organised into subfolders). Mine is "in the cloud"
so that I can have an elementary "synchronization" among computers and a
convenient backup of the precious files.

2. Copy (e.g.) into /usr/local/bin the files
 		maps-delete.sh
 		maps-maintain.sh
 		maps-search.sh

or simply copy them into a local folder (e.g. ~/maps-academic/).

3. Set an alias as the one indicated below:
'''alias s="~/maps-academic/maps-search.sh"'''

This work is largely inspired from and based on https://github.com/bellecp/fast-p
As an exercise in bash-fu, I have tried to imitate fast-p by myself.



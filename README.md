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
(and make them all executables, by chmod +x *.sh)

or simply copy them into a local folder (e.g. ~/maps-academic/).

3. Set an alias as the one indicated below:
'''alias s="~/maps-academic/maps-search.sh"'''

This work is largely inspired from and based on https://github.com/bellecp/fast-p
As an exercise in bash-fu, I have tried to imitate fast-p by myself.

## Use

Invoke (by the alias or directly) the maps-search.sh script.

## Motivations and Engineering

I have been a faithful user of Paper (until version 3), under macOs. That is a GUI app for managing a large number of academic PDF papers.

Entries could be nicely synchronized with PubMed, so that title, author names, volume and pages and other meta data became  automatically associated to each PDF and could be used to guide searches through the database and identify files. There were tons of additional functions, integration with bibliography managers, exporters, management of annotations, etc. I never really used.

Over the years, I grew particularly uncomfortable with  Papers: it often crashed, was very slow to fire up, and most importantly it compromised my actual files several times, resulting in missing files or orphan database entries.

I then considered the possibility of simplifying to the bare bones the functionality of a similar software, tailoring it to my use cases only, and I came out with a command line version of an elementary PDF manager I called MAPS - My Archive PDF Search Tool.

It does NOT have any built in PDF viewer, assuming the use of Preview (macOs default reader). It also does not have any synchronization or backup feature, assuming the implicit use of Dropbox or of another equivalent cloud service.

It does just one very basic task that I found myself doing over and over: fuzzy search and quickly retrieve the desired pdf.

Specifically,
- it expects a root folder full of unsorted PDF (including any subfolders containing PDF);
- It automatically creates (once for all or whenever a new file is added to the collection) textual metadata for each file;
- It allows a quick fuzzy text search of the corresponding pdf on the basis of the text contained in the first two pages of the PDF, or alternatively contained in the filename for those files that could not be text-parsed;

It is currently composed of two bash scripts. The first maintains the database, while the second implements the fuzzy search.

In a nutshell, the maintenance script first replace spaces in the file name of the PDF fikes (recursively visiting any subfolder of the "root" directory). Then, it calls pdftotext to obtain a textual snapshot of each pdf and stores each file in a hidden folder.
Using ripgrep (a grep replacement), in combination with fzf, allows later the fuzzy search on the text contained in every text file created during the first snapshot phase.
Thanks to fzf preview functionality, a textual preview of the found pdf file is presented to the user live, during the search.

In reality, the snapshot is performed twice, with the second one removing any new line character and allowing the search to occur behind the scene (and without affecting the preview) over multiple lines too.

It would be nice to have it all integrated with bibtex. One way would be to add the bibtex cite key in the filename of the file.




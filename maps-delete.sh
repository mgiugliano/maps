#!/usr/bin/env bash
#
# My Academic Paper Search (MAPS) project
# -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#
# Delete the PDF papers database metadata
#
# April 24nd, 2019 - Michele Giugliano, mgiugliano@gmail.com
#

# The env var ROOT_PDF_FOLDER should have been set in the .bash_profile

# Set the full path to the metadata subfolders...
TEXTSUB=$ROOT_PDF_FOLDER/.cache
SEARCHDIR=$TEXTSUB/data

echo ""
echo ""
echo "MAPS v. 0.1 - (c) Michele Giugliano, April 2019"
echo ""
echo ">>> Wiping out the metadata for the database root at $ROOT_PDF_FOLDER"
echo ">>> (the PDF files are left untouched!)"
echo ""

# The metadata is completely wiped out
command rm -r $TEXTSUB


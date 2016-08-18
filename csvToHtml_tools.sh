#!/bin/sh
#
#    MIT License
#    Copyright (c) 2016  Pierre-Yves Lapersonne (Twitter: @pylapp, Mail: pylapp(dot)pylapp(at)gmail(dot)com)
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#    The above copyright notice and this permission notice shall be included in all
#    copies or substantial portions of the Software.
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#    SOFTWARE.
#
#
# Author..............: pylapp
# Version.............: 5.0.0
# Since...............: 21/06/2016
# Description.........: Process a file/an input (mainly in CSV format) to HTML with CSS if needed.
#			This file must contain several columns: Plateform, Name, Description, Keywords, URL
#
# Usage: sh csvToHtml_tools.sh --help
# Usage: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml ] > myOutputFile.html
#


# ###### #
# CONFIG #
# ###### #

# HTML output for Readme.md Github's file or not ?
IS_HTML_LIMITED=false

# CSV separator...
CSV_SEPARATOR=';'

# Empty or useless rows
NUMBER_OF_LINES_TO_IGNORE=6

# Some CSS
CSS_STYLE="<style>
body {
	font-family: 'Roboto', sans-serif;
}
table, th, td {
	border: 1px solid black;
	border-collapse: collapse;
	padding: 10px;
}
th {
	background-color: #fafafa;
}
.pfOther {
	background-color: #9e9e9e;
}
.pfAndroid {
	background-color: #8bc34a;
}
.pfDesign {
	background-color: #e91e63;
}
.pfJavaScript {
	background-color: #ffeb3b;
}
.pfJava {
	background-color: #ff9800;
}
.pfKotlin {
	background-color: #3f51b5;
}
.pfWeb {
	background-color: #795548;
}
.name {
	text-align: center;
}
.url {
	color: #03a9f4;
}
.keywords {
	font-style: italic;
}	
</style>
"

# ######### #
# MAIN CODE #
# ######### #

# Check args: if --fullHtml option, use CSS ; if --limitedHTML option, do not use CSS ; if --help, display usage ; otherwise display usage
if [ "$#" -ne 1 ]; then
	echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help ]"
	exit 0	
fi

if [ $1 ]; then
	if [ "$1" = "--fullHtml" ]; then
		IS_HTML_LIMITED=false		
	elif [ "$1" = "--limitedHtml" ]; then
		IS_HTML_LIMITED=true;
	elif [ "$1" = "--help" ]; then
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0		
	else
		echo "USAGE: cat myFileToProcess.csv | sh csvToHtml_tools.sh [ --fullHtml | --limitedHtml | --help]"
		exit 0
	fi
fi

currentRowIndex=0;

# ***** Step 0 : Some CSS
if  ! $IS_HTML_LIMITED ; then
	echo $CSS_STYLE
fi


# ***** Step 1: Prepare the header of the output
echo "<table>"
	
# Proces each line of the input	
while read -r line; do

	# ***** Step 2: Ignore the useless rows
	if [ $currentRowIndex -lt $NUMBER_OF_LINES_TO_IGNORE ]
	then
		currentRowIndex=$(($currentRowIndex + 1))
		continue
	fi
	
	# ***** Step 3: Prepare the header of the line
	echo "\t<tr>"
	
	# ***** Step 4: Split the line and replace ; by \n, and delete useless "
	fieldIndex=0;
	echo $line | sed 's/;/\n/g' | while read -r item; do
		cleanItem=`echo $item | sed 's/\"//g'`
		# Add an good CSS class
		case "$fieldIndex" in
			0)
				case "$cleanItem" in
					*Android*)
						echo "\t\t<td class=\"pfAndroid\">" $cleanItem "</td>"	
					;;
					*Design*)
						echo "\t\t<td class=\"pfDesign\">" $cleanItem "</td>"	
					;;
					*Java*)
						echo "\t\t<td class=\"pfJava\">" $cleanItem "</td>"	
					;;
					*JS*)
						echo "\t\t<td class=\"pfJavaScript\">" $cleanItem "</td>"	
					;;
					*Kotlin*)
						echo "\t\t<td class=\"pfKotlin\">" $cleanItem "</td>"	
					;;
					*Web*)
						echo "\t\t<td class=\"pfWeb\">" $cleanItem "</td>"	
					;;
					*)
						echo "\t\t<td class=\"pfOther\">" $cleanItem "</td>"
					;;
				esac
				;;
			1)
				echo "\t\t<td class=\"name\">" $cleanItem "</td>"
				;;
			2)
				echo "\t\t<td class=\"description\">" $cleanItem "</td>"			
				;;
			3)
				echo "\t\t<td class=\"keywords\">" $cleanItem "</td>"			
				;;
			4)
				echo "\t\t<td class=\"url\">" $cleanItem "</td>"			
				;;
		esac
		fieldIndex=$(($fieldIndex + 1))
	done
	
	# ***** Step 5: Prepare the footer of the line
	echo "\t</tr>"
	
done

# ***** Step 6: Prepare the footer of the output
echo "</table>"

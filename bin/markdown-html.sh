#! /bin/bash

DEBUG="nonblank"

if hash readlink
then
	PATH_SCRIPT=`readlink -f $0`
else
	PATH_SCRIPT="$0"
fi

DIR_BASE=`dirname $PATH_SCRIPT`
DIR_BASE=`dirname $DIR_BASE`

if ! hash perl
then
	echo "this tool requires perl >= 5.6.0"
	exit 1
fi

BIN_MD_TOOL="$DIR_BASE/bin/Markdown.pl"

DIR_SITE_SOURCE="$1"
STYLE="$2"

if test -z $DIR_SITE_SOURCE
then
	echo "specify a directory with the site source"
	exit 1
fi

if ! test -d $DIR_SITE_SOURCE
then
	echo "the directory [$DIR_SITE_SOURCE] does not exists"
	exit 1
fi

if test -z "$STYLE"
then
	STYLE="default"
fi

if ! test -r "$DIR_BASE/styles/$STYLE.css"
then
	echo "style [$STYLE] does not exists"
	test ! -z $DEBUG && echo "$DIR_BASE/styles/$STYLE.css"
	exit 1
fi

cd $DIR_SITE_SOURCE
FILES_MARKDOWN=`find . -type f -name "*.md" 2> /dev/null`

DIR_SITE_OUTPUT="$DIR_SITE_SOURCE-html"
test -d $DIR_SITE_OUTPUT && rm -rf $DIR_SITE_OUTPUT
mkdir $DIR_SITE_OUTPUT

test ! -z $DEBUG && echo "created output directory [$DIR_SITE_OUTPUT]"

for FILE_MARKDOWN in $FILES_MARKDOWN
do
	PATH_CLEAN_FILE_MARKDOWN=`echo $FILE_MARKDOWN | sed s/^\.//g`
	FILE_NAME=`basename $FILE_MARKDOWN | tr -d .md`
	DIR_OUTPUT_FILE="$DIR_SITE_OUTPUT`dirname $PATH_CLEAN_FILE_MARKDOWN`"
	
	test ! -d $DIR_OUTPUT_FILE && mkdir $DIR_OUTPUT_FILE
	
	cat $DIR_BASE/fragments/1.html $DIR_BASE/styles/$STYLE.css $DIR_BASE/fragments/2.html > $DIR_OUTPUT_FILE/$FILE_NAME.html
	$BIN_MD_TOOL $FILE_MARKDOWN >> $DIR_OUTPUT_FILE/$FILE_NAME.html
	cat $DIR_BASE/fragments/3.html >> $DIR_OUTPUT_FILE/$FILE_NAME.html
done


# index creation
cat $DIR_BASE/fragments/1.html $DIR_BASE/styles/$STYLE.css $DIR_BASE/fragments/2.html > $DIR_SITE_OUTPUT/index.html
echo "<ul>" >> $DIR_SITE_OUTPUT/index.html

cd $DIR_SITE_OUTPUT

FILES_HTML=`find . -type f -name "*.html" 2> /dev/null`
for FILE_HTML in $FILES_HTML
do
	echo "<li><a href='$FILE_HTML'>$FILE_HTML</a></li>" >> $DIR_SITE_OUTPUT/index.html
done

echo "</ul>" >> $DIR_SITE_OUTPUT/index.html
cat $DIR_BASE/fragments/3.html >> $DIR_SITE_OUTPUT/index.html

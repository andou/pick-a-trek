#!/usr/bin/env bash

FILE=''
CONVERTED_SUFFIX='wb'

if [ -z "$1" ]
  then
    echo "Specify the image, please"
    exit 1
fi

if [[ -n $1 && -f $1 ]]; then
  FILE=$1
else
    echo "Specify a valid image, please"
    exit 1
fi

# https://imagemagick.org/script/escape.php
BASENAME=$(magick identify -verbose -format "%f" $FILE)
DIRECTORY=$(magick identify -verbose -format "%d" $FILE)
FILENAME=$(magick identify -verbose -format "%t" $FILE)
EXTENSION=$(magick identify -verbose -format "%e" $FILE)
ORIGINAL_DIM=$(magick identify -verbose -format "%b" $FILE)
ORIGINAL="$DIRECTORY/$FILENAME.$EXTENSION"
OUTPUT="$DIRECTORY/$FILENAME$CONVERTED_SUFFIX.$EXTENSION"
#echo "Filename   : $BASENAME"
#echo "Name       : $FILENAME"
#echo "Extension  : $EXTENSION"
#echo "Directory  : $DIRECTORY"
echo "Original   : $ORIGINAL"
echo "Dimensions : $ORIGINAL_DIM"

#echo "Output     : $OUTPUT"

magick identify -verbose -format \
"Sizes      : %[fx:w]x%[fx:h] pixels" $ORIGINAL
echo ""

echo "Resize command:"
echo "$ convert $ORIGINAL -resize 400 -strip -quality 85 $OUTPUT"
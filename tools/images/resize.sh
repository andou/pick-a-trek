#!/usr/bin/env bash
FILE=''
CONVERTED_SUFFIX='wb'
WIDTH=400
OVERWRITE='false'
DRYRUN='false'
STRIP='false'


print_usage() {
  cat << "EOF"
    Utilizzo
       bash ./tools/images/resize.sh [flags]

    Flags
        -h  Stampa questo help
        -i  File di input da ridimensionare
        -o  Sovrascrive il file
        -d  Dry run
        -w  Larghezza dell'immagine ("400" come default)
        -s  Suffisso per il file copia ridimensionato ("web" come default)
EOF
}


while getopts 'ohdti:w:s:' flag; do
  case "${flag}" in
    o) OVERWRITE='true' ;;
    d) DRYRUN='true' ;;
    t) STRIP='true' ;;
    s) CONVERTED_SUFFIX="${OPTARG}" ;;
    i) FILE="${OPTARG}" ;;
    w) WIDTH="${OPTARG}" ;;
    h) print_usage
       exit 1 ;;
    *) print_usage
       exit 1 ;;
  esac
done

if [ -z "$1" ]
  then
    echo "Specify the image, please"
    exit 1
fi

if [[ ! -n $FILE || ! -f $FILE ]]; then
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

if [ "$OVERWRITE" = "true" ]; then
  OUTPUT="$ORIGINAL"
else
  OUTPUT="$DIRECTORY/$FILENAME$CONVERTED_SUFFIX.$EXTENSION"
fi


if [ "$DRYRUN" = "true" ]; then
  echo "Resize command:"
  if [ "$STRIP" = "true" ]; then
    echo "$ convert $ORIGINAL -resize $WIDTH -strip -quality 85 $OUTPUT"
  else
    echo "$ convert $ORIGINAL -resize $WIDTH -quality 85 $OUTPUT"
  fi
else
  if [ "$STRIP" = "true" ]; then
    convert $ORIGINAL -resize $WIDTH -strip -quality 85 $OUTPUT
  else
    convert $ORIGINAL -resize $WIDTH -quality 85 $OUTPUT
  fi
fi
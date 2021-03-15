#!/bin/bash

if [ -z "$1" ]
  then
    echo "Specify GPX track to convert"
    exit 1
fi

GPX_FILE="$1"


if [ -z "$2" ]
  then
    POINTS="2000"
else
    POINTS="$2"
fi

echo "Simplifying $GPX_FILE to $POINTS points"

while true; do
    read -p "Proceed with track simplification? " yn
    case $yn in
        [Yy]* ) echo "Simplifying...";/Applications/GPSBabelFE.app/Contents/MacOS/gpsbabel -i gpx -f $GPX_FILE -x simplify,count=$POINTS -o gpx -F $GPX_FILE;break;;
        [Nn]* ) echo "No track simplify";break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "Also create a markdown file linked to the GPS track? " yn
    case $yn in
        [Yy]* ) echo "Creating";php create.php $GPX_FILE;break;;
        [Nn]* ) echo "No markdown file";break;;
        * ) echo "Please answer yes or no.";;
    esac
done

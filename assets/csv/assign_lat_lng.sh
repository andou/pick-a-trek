#!/bin/bash

if [ -z "$1" ]
  then
    echo "Specify CSV file to read"
    exit 1
fi

INPUT="$1"
OLDIFS=$IFS

IFS=','
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read Name Link Latitude Longitude
do
  find="https://www.pick-a-trek.it/"
  replace="../../_"
  MDFILE=${Link/$find/$replace}
  MDFILE=${MDFILE%/*}".markdown"
  if [[ ! -n $MDFILE || ! -f $MDFILE ]]; then
    echo "No valid file -> $MDFILE"
    #exit 1
  else
    echo "---"
    echo "name : $Name"
    echo "link : $MDFILE"
    echo "latitude : $Latitude"
    echo "longitude : $Longitude"
    sed -i '' -e '3s/^/latitude : '$Latitude'\n/' $MDFILE
    sed -i '' -e '3s/^/longitude : '$Longitude'\n/' $MDFILE
    #exit 0;
  fi
done < $INPUT
IFS=$OLDIFS
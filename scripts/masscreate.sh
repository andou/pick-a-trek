#!/bin/bash

tracks=`ls ../docs/assets/tracks/*.gpx`
for eachfile in $tracks
do
   echo $eachfile
   #/Applications/GPSBabelFE.app/Contents/MacOS/gpsbabel -t -i gpx -f $eachfile -x simplify,count=2000 -o gpx -F $simpl;
done

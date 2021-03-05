#!/bin/bash

tracks=`ls ../docs/assets/tracks/*.gpx`
for eachfile in $tracks
do
   echo $eachfile
   php create.php $eachfile
done

#!/bin/bash

tracks=`ls ../assets/tracks/*.gpx`
for eachfile in $tracks
do
   echo $eachfile
   php create.php $eachfile
done

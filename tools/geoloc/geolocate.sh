#!/usr/bin/env bash

LOC=""
KEY=$(cat ./tools/geoloc/opencage.key)

if [[ -n $1 ]]; then
  LOC=$1
else
    echo "Specify a valid location, please"
    exit 1
fi

LOC=$(echo -ne $LOC | xxd -plain | tr -d '\n' | sed 's/\(..\)/%\1/g');curl "https://api.opencagedata.com/geocode/v1/json?q="$LOC"&pretty=1&key="$KEY 2>/dev/null | jq '.results[] | (.formatted|tostring) + ": " + (.geometry.lat|tostring) + "," + (.geometry.lng|tostring)' | sed -r 's/["]+//g'
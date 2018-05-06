#!/bin/bash

MESSAGE=$1
URL=$2
CHANNEL=${3:-"#general"}
USERNAME=${4:-"RethinkBot"}
ICONEMOJI=${5:-":minidisc:"}

MESSAGE=`echo ${MESSAGE} | sed 's/\./\\\\./g'`
MESSAGE=`echo ${MESSAGE} | sed -e 's/;/\\\\;/g'`


JSON=`cat /slack.json \
| sed "s;{MESSAGE};${MESSAGE};g" \
| sed "s;{CHANNEL};${CHANNEL};g" \
| sed "s;{USERNAME};${USERNAME};g" \
| sed "s;{ICONEMOJI};${ICONEMOJI};g"`

curl -X POST \
--data-urlencode "payload=${JSON}" \
${URL}
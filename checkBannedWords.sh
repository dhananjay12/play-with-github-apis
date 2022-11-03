#!/usr/bin/env bash

PROPERTIES_FILE_NAME="./app.properties"
FILE_NAME="./myfile.txt"

#read the properties file and returns the value based on the key
function getPropVal {
    value= grep "${1}" $PROPERTIES_FILE_NAME | cut -d'=' -f2
	if [[ -z "$value" ]]; then
	   echo "Key not found"
	   exit 1
	fi
	echo $value
}
#Get the value with key
function getBannedWords {

BANNED_WORDS_FOUND=()

ALL_BANNED_WORDS_STRING=($(getPropVal 'banned'))

IFS=',' read -ra BANNED_WORDS <<< "$ALL_BANNED_WORDS_STRING"
for i in "${BANNED_WORDS[@]}"; do
  echo "Checking $i in $FILE_NAME"
  if grep -q $i "$FILE_NAME"; then
    BANNED_WORDS_FOUND+=($i)
  fi
done

echo "$BANNED_WORDS_FOUND"

}


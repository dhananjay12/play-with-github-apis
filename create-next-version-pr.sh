#!/usr/bin/env bash

PROPERTIES_FILE_NAME="./app.properties"
OWNER="dhananjay12"
REPO="play-with-github-apis"

#read the properties file and returns the value based on the key
function getPropVal {
    value= grep "${1}" $PROPERTIES_FILE_NAME | cut -d'=' -f2
	if [[ -z "$value" ]]; then
	   echo "Key not found"
	   exit 1
	fi
	echo $value
}

############################
#script function
############################
setProperty(){
  awk -v pat="^$1 = " -v value="$1 = $2" '{ if ($0 ~ pat) print value; else print $0; }' $3 > $3.tmp
  mv $3.tmp $3
}

#Get the value with key
function updateVersionAndCreatePR {

VERSION=($(getPropVal 'appVersion'))
echo $VERSION
# Read Semver fields
IFS=. read major minor patch <<EOF
$VERSION
EOF
# Increment patch version
# same as patch="$((patch + 1))"
((patch++))
NEW_VERSION=$major.$minor.$patch
echo $NEW_VERSION
setProperty "appVersion" "$NEW_VERSION" "app.properties"

BRANCH="update-$NEW_VERSION"
git config user.email "action@github.com"
git config user.name "GitHub Action"
git checkout -b $BRANCH
git add "app.properties"
git commit -m "Update - $VERSION"
git push --set-upstream origin $BRANCH

curl \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/repos/$OWNER/$REPO/pulls \
  -d "{\"title\":\"Update to new version\",\"body\":\"Please pull these awesome changes in!\",\"head\":\"$BRANCH\",\"base\":\"main\"}"
}


updateVersionAndCreatePR
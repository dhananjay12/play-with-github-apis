#!/usr/bin/env bas

$OWNER=$1
$REPO=$2
$PULL_NUMBER=$3

source ./checkBannedWords.sh

if [ ${#BANNED_WORDS_FOUND[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
  COMMENT_BODY="YOu have these banned words in the file : $BANNED_WORDS_FOUND"
    curl \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/comments \
      -d '{"body":"$COMMENT_BODY"}'
fi


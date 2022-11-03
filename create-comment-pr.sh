#!/usr/bin/env bash

$PULL_NUMBER=$1

source ./checkBannedWords.sh

if [ ${#BANNED_WORDS_FOUND[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
  COMMENT_BODY="YOu have these banned words in the file : $BANNED_WORDS_FOUND"
    curl \
      -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      https://api.github.com/repos/dhananjay12/play-with-github-apis/pulls/$PULL_NUMBER/comments \
      -d '{"body":"$COMMENT_BODY"}'
fi


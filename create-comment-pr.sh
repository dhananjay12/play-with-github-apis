#!/usr/bin/env bash

PULL_NUMBER=${1}
echo "Create comment PULL_NUMBER =  $PULL_NUMBER"
OWNER="dhananjay12"
REPO="play-with-github-apis"

source ./checkBannedWords.sh
source ./get-exsisting-coment.sh $PULL_NUMBER

if [ ${#BANNED_WORDS_FOUND[@]} -eq 0 ]; then
    echo "No errors, hooray"
    if [[ -n $REVIEW_ID ]]; then
    echo "https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/reviews/$REVIEW_ID"
    curl \
      -X DELETE \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/reviews/$REVIEW_ID
   fi
else
  if [[ -n $REVIEW_ID ]];
  then
        echo "updating Existing review"
        COMMENT_BODY="{\"body\":\"You have these banned words in the file : $BANNED_WORDS_FOUND\" }"
        echo $COMMENT_BODY
        curl \
          -X PUT \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/reviews/$REVIEW_ID \
          -d "$COMMENT_BODY"
  else
        echo "updating Existing review"
        COMMENT_BODY="{\"body\":\"You have these banned words in the file : $BANNED_WORDS_FOUND\", \"event\":\"REQUEST_CHANGES\" }"
        echo $COMMENT_BODY
        curl \
          -X POST \
          -H "Accept: application/vnd.github+json" \
          -H "Authorization: Bearer ${GITHUB_TOKEN}" \
          https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/reviews \
          -d "$COMMENT_BODY"
  fi


fi


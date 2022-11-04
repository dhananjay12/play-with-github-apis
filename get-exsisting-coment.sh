#!/usr/bin/env bash

PULL_NUMBER=${1}
github_bot_name="github-actions[bot]"

echo "Get comment PULL_NUMBER =  $PULL_NUMBER"

    REVIEW_ID=`curl \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: Bearer ${GITHUB_TOKEN}" \
      https://api.github.com/repos/$OWNER/$REPO/pulls/$PULL_NUMBER/reviews | \
      jq -rM ".[] |
      {id: .id, commented_by: .user.login , state: .state} |
      select (.commented_by == \"$github_bot_name\") |
      select (.state == \"CHANGES_REQUESTED\") |
      [.id] |
      @csv" 2>/dev/null | head -1`

echo "Review ID = $REVIEW_ID"

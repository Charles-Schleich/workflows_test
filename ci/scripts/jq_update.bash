
readonly version="1.2.3"

JQ=".version=\"$version\""

cat "./ts_project/package.json" | jq "$JQ" 
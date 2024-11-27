
readonly live_run=${LIVE_RUN:-false}

if [[ ${live_run} ]]; then
    npm publish --provenance --access public
else
    npm publish --dry-run
fi



#!/usr/bin/env bash

declare query=$1

function getRunningApps() {
  declare -a apps
  declare rawResults=$(osascript <<'SCRIPT'
tell application "System Events"
	set listOfProcesses to (name of every process where background only is false)
end tell
set results to {}
repeat with visibleProcess in listOfProcesses
  set the |results| to the |results| & visibleProcess
end repeat
return results
SCRIPT
)
  echo ${rawResults} | sed 's/, /\'$'\n/g' | sort
}

declare xmlItems="<?xml version=\"1.0\"?><items>"
IFS=$'\n'
# Case insensitive comparison
shopt -s nocasematch
for app in $(getRunningApps); do
  if [[ ${app} == ${query}* ]] || [ -z ${query} ]; then
    # Get icon for app
    declare pathToApp=`ps -u $USER -o command | grep -v grep | grep "${app}" | head -n 1 | sed -e 's/\-psn.*//' | sed -e 's/\.app.*/.app/g'`
    declare icon="<icon type=\"fileicon\">${pathToApp}</icon>"
    declare title="<title>${app}</title>"
    declare item="<item uid=\"${app}\" arg=\"${app}\" autocomplete=\"${app}\" type=\"file\">${title}${icon}</item>"
    xmlItems="${xmlItems}${item}"
  fi
done
echo "${xmlItems}</items>"

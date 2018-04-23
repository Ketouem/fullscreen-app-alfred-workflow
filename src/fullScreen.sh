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
  set escapedName to "\"" & visibleProcess & "\""
  set the |results| to the |results| & escapedName
end repeat
return results
SCRIPT
)
  echo ${rawResults} | sed 's/, /\'$'\n/g'
}

function getIconForApp() {
  declare appName=$1
  declare pathToApp=$(ps -u $USER -o command | grep "${appName}.app" | head -n 1 | grep -Eio ".*(${appName}\.app)")
  declare iconName=$(cat ${pathToApp}/Contents/Info.plist | grep -A1 CFBundleIconFile | tail -n 1 | grep -Ev "<string[\/]?>")
  echo $iconName
}

getIconForApp $query
# declare xml="<?xml version=\"1.0\"?><items>"
# IFS=$'\n'
# shopt -s nocasematch
# for app in $(getRunningApps); do
#   declare trimmedApp=$(echo ${app} | tr -d "\"")
#   # Case insensitive comparison
#   if [[ ${trimmedApp} == ${query}* ]] || [ -z "${query}" ]; then
#     xml="${xml}<item uid=${app} arg=${app} autocomplete=${app} type=\"file\"><title>${trimmedApp}</title></item>"
#   fi
# done
# echo "${xml}</items>"

#!/bin/bash
function get_workspaces()
{
    i3-msg -t get_workspaces \
  | jq '.[] | select(.focused==true).name' \
  | cut -d"\"" -f2
}

WORKSPACE=$(get_workspaces)

if [ -n "${WORKSPACE}" ]
then
    emacsclient -c -F "((name . \"${WORKSPACE}\"))"
fi

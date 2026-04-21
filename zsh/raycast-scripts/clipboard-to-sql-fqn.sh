#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Clipboard to SQL FQN
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗂️
# @raycast.packageName Clipboard Tools
# @raycast.description Reformat clipboard path-like string to SQL fully-qualified name

pbpaste \
  | tr -d '\n\r' \
  | sed 's| */ *|.|g' \
  | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' \
  | tr -d '\n' \
  | pbcopy

# Optional: show what got copied
osascript -e "display notification \"$(pbpaste)\" with title \"Copied SQL FQN\""

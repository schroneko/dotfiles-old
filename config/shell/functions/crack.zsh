#!/usr/bin/env zsh

function crack {
  emulate -L zsh

  if (( $# != 1 )); then
    echo "Usage: crack <zipfile>"
    echo "Description: Attempts to crack the password of a protected zip file"
    return 1
  fi

  if ! which zip2john > /dev/null; then
    echo "Error: john-jumbo is not installed"
    echo "To install: brew install john-jumbo"
    return 1
  fi

  local zipfile="$1"

  if [[ ! -f "$zipfile" ]]; then
    echo "Error: File '$zipfile' does not exist"
    return 1
  fi

  if ! file "$zipfile" | grep -q "Zip archive data"; then
    echo "Error: '$zipfile' is not a zip file"
    return 1
  fi

  local tmp
  tmp=$(mktemp) || {
    echo "Error: Failed to create temporary file"
    return 1
  }

  trap "rm -f '$tmp'" EXIT

  echo "Processing zip file..."
  if ! zip2john "$zipfile" > "$tmp" 2>/dev/null; then
    echo "Error: Failed to process zip file with zip2john"
    return 1
  fi

  echo "Attempting to crack password..."
  if ! john --incremental=ASCII "$tmp" 2>/dev/null >/dev/null; then
    echo "Error: Failed to crack password with john"
    return 1
  fi

  local password
  password=$(john --show "$tmp" 2>/dev/null | awk -F: 'NR==1 {print $2}')

  if [[ -n "$password" ]]; then
    echo "Success! Password found: $password"
    return 0
  else
    echo "Failed to find password"
    return 1
  fi
}

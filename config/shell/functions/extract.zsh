#!/usr/bin/env zsh

function extract {
  emulate -L zsh

  function usage {
    cat << 'EOF'
Usage: extract <directory> [options]
Extract and format contents of files in a directory.

Options:
    --ext <extension>     Filter files by extension (without dot)
    --output <filename>   Specify output file (default: output.txt)
    --exclude <pattern>   Exclude files matching pattern
    --max-size <size>     Skip files larger than size (in MB)

Examples:
    extract ~/projects --ext js
    extract ./docs --output documentation.txt
    extract ./src --exclude "test|spec" --ext ts
EOF
  }

  # Default values
  local directory=""
  local extension=""
  local output_file="output.txt"
  local exclude_pattern=""
  local max_size=10  # Default max file size in MB

  # Parse arguments
  while (( $# > 0 )); do
    case "$1" in
      --ext)
        shift
        extension="$1"
        ;;
      --output)
        shift
        output_file="$1"
        ;;
      --exclude)
        shift
        exclude_pattern="$1"
        ;;
      --max-size)
        shift
        max_size="$1"
        ;;
      --help)
        usage
        return 0
        ;;
      *)
        if [[ -z "$directory" ]]; then
          directory="$1"
        else
          print "Error: Unexpected argument '$1'"
          usage
          return 1
        fi
        ;;
    esac
    shift
  done

  # Validate directory
  if [[ -z "$directory" ]]; then
    print "Error: Directory not specified"
    usage
    return 1
  fi

  if [[ ! -d "$directory" ]]; then
    print "Error: '$directory' is not a directory"
    return 1
  fi

  # Create temporary file with cleanup trap
  local tmp
  tmp=$(mktemp) || {
    print "Error: Failed to create temporary file"
    return 1
  }
  trap "rm -f '$tmp'" EXIT

  function process_files {
    local find_cmd="find \"$directory\" -type f -not -path '*/\.*'"

    # Add extension filter if specified
    if [[ -n "$extension" ]]; then
      find_cmd+=" -name \"*.$extension\""
    fi

    # Add exclude pattern if specified
    if [[ -n "$exclude_pattern" ]]; then
      find_cmd+=" -not -regex \".*($exclude_pattern).*\""
    fi

    # Add size filter
    find_cmd+=" -size -${max_size}M"

    # Count total files
    local total_files
    total_files=$(eval $find_cmd | wc -l | tr -d ' ')
    local processed_files=0

    eval $find_cmd | while read -r file; do
      # Show progress
      (( processed_files++ ))
      printf "\rProcessing files... %d/%d" "$processed_files" "$total_files"

      # Get relative path
      local rel_path="${file#$directory/}"

      # Write file content with XML-style tags
      print "<${rel_path}>" >> "$tmp"
      cat "$file" >> "$tmp"
      print "</${rel_path}>" >> "$tmp"
      print "" >> "$tmp"
    done

    print  # New line after progress indicator
  }

  print "Starting extraction..."
  process_files

  # Move temporary file to final destination
  if ! mv "$tmp" "$output_file"; then
    print "Error: Failed to create output file"
    return 1
  fi

  print "Extraction complete. Results saved in $output_file"
  print "Processed files: $(grep -c '^<.*>$' "$output_file")"
}

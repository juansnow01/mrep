#!/bin/bash


usage() {
    echo "Usage: $0 <man-page> <search-string> [-c <context-lines>] [-i]"
    echo "  <man-page>:       The manual page to search."
    echo "  <search-string>:  The string to search for."
    echo "  -c <context-lines>: Number of context lines to show around matches (default: 3)."
    echo "  -i:               Perform a case-insensitive search."
    exit 1
}
# Default values
context_lines=3
case_insensitive=false

if [ "$#" -lt 2 ]; then
    usage
fi
man_page="$1"
search_string="$2"

shift 2

while getopts ":c:i" opt; do
    case ${opt} in
        c)
            context_lines=$OPTARG
            ;;
        i)
            case_insensitive=true
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

if ! man -w "$man_page" > /dev/null 2>&1; then
    echo "Error: The man page for '$man_page' does not exist."
    exit 1
fi

grep_command="grep --color=always -C $context_lines"

if $case_insensitive; then
    grep_command+=" -i"
fi

man "$man_page" | eval "$grep_command \"$search_string\""

if [ $? -ne 0 ]; then
    echo "No matches found for '$search_string' in the man page for '$man_page'."
    exit 1
fi

#!/bin/bash

# VARIABLES
directory="${1:-.}" name="${2:-main}"

RES="\033[0m"
BLD="\033[1m"
UND="\033[4m"
RED="\033[0;31m"
GRN="\033[0;32m"
BLU="\033[0;34m"
YEL="\033[0;33m"

echo -e "${BLD}COBWEB${RES} | bash-based GnuCOBOL compilation tool"
echo

# INPUT VALIDATION/CHECKS
if [ ! -d "$directory" ]; then
    echo -e "${RED}[!] Nonexistent directory '$directory'.${RES}"
    exit 1
fi

if [ -z "$1" ]; then
    echo -e "${YEL}[*] No directory provided${RES}      -> Defaulting to './'"
    echo -e "   -> Defaulting to './'"
fi
if [ -z "$2" ]; then
    echo -e "${YEL}[*] No output name provided${RES}    -> Defaulting to 'main'."
    echo -e "
fi

# LOCATE ALL .CBL FILES
cbl_files=($(find "$directory" -type f -iname "*.cbl"))
cbl_files_count=${#cbl_files[@]}

if [ $cbl_files_count -eq 0 ]; then
    echo "No COBOL files found."
    exit 1
fi

if [ $cbl_files_count -eq 1 ]; then
    echo -e "${BLU}[i] Located ${cbl_files_count} file:${RES}"
else
    echo -e "${BLU}[i] Located ${cbl_files_count} files:${RES}"
fi

echo -e "   - ${cbl_files[@]}"
echo

if command -v cobc >/dev/null 2>&1; then
    echo "Compiling with cobc..."
    cobc -x -o "${name}" "${cbl_files[@]}"
    echo "Executable 'main' created. Run with ./main"
else
    echo "Error: GnuCOBOL (cobc) not installed. Install with: sudo apt install gnucobol"
    exit 1
fi

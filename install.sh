#!/bin/bash

# COBWEB v1.0
# https://github.com/theluqmn/cobweb

# VARIABLES
directory="${2:-./}" name="${1:-main}"

RES="\033[0m"
BLD="\033[1m"
UND="\033[4m"
RED="\033[0;31m"
GRN="\033[0;32m"
BLU="\033[0;34m"
YEL="\033[0;33m"

echo -e "${BLD}COBWEB | bash-based GnuCOBOL compilation tool ${RES}"
echo -e "v1.0 - https://github.com/theluqmn/cobweb"
echo

# INPUT VALIDATION
if [ ! -d "$directory" ]; then
    echo
    echo -e "${RED}[!] Nonexistent directory '$directory'.${RES}"
    exit 1
fi
if [ -z "$1" ]; then
    echo -e "${YEL}[*] No output name provided!${RES}   Defaulting to 'main'.${RES}"
fi
if [ -z "$2" ]; then
    echo -e "${YEL}[*] No directory provided!${RES}     Defaulting to './'.${RES}"
    echo
fi

# LOCATING FILES
echo -e "${UND}Locating COBOL files...${RES}"

cbl_files=($(find "$directory" -type f \( -iname "*.cbl" -o -iname "*.cob" \)))
cbl_files_count=${#cbl_files[@]}

if [ $cbl_files_count -eq 0 ]; then
    echo "${BLU}[i] No COBOL files found.${RES}"
    exit 1
fi
if [ $cbl_files_count -eq 1 ]; then
    echo -e "${BLU}[i] Located ${cbl_files_count} file:${RES} ${cbl_files[@]}"
else
    echo -e "${BLU}[i] Located ${cbl_files_count} files:${RES} ${cbl_files[@]}"
fi

# COMPILATION
if command -v cobc >/dev/null 2>&1; then
    main_file=$(find "$directory" -type f \( -iname "*main*.cbl" -o -iname "*main*.cob" \) | head -1)
    if [ -z "$main_file" ]; then
        echo -e "${RED}[!] No main file found (looking for *main*.cbl/cob)${RES}"
        exit 1
    fi
    echo -e "${BLU}[i] Located main file${RES}"

    echo
    echo -e "${UND}Compiling files...${RES}"
    
    echo -e "${BLU}[i] Compiling main...${RES}"
    cobc -x -c "$main_file" -o "${name}.o"
    
    echo -e "${BLU}[i] Compiling subprograms:${RES}"
    other_files=($(find "$directory" -type f \( -iname "*.cbl" -o -iname "*.cob" \) | grep -v "$main_file"))
    for file in "${other_files[@]}"; do
        obj_name="${file%.*}.o"
        echo -e "${BLD}$file${RES}"
        cobc -c "$file" -o "$obj_name"
    done
    
    echo
    echo -e "${UND}Linking files...${RES}"
    obj_files=("${name}.o")
    for file in "${other_files[@]}"; do
        obj_files+=("${file%.*}.o")
    done
    cobc -x -o "${name}" "${obj_files[@]}"
    
    echo
    echo -e "${UND}Removing object files...${RES}"
    rm -f "${name}.o" "${other_files[@]%.cbl}.o" "${other_files[@]%.cob}.o"
    
    echo
    echo -e "${GRN}[✓] Executable '${name}' created!${RES}"
else
    echo -e "${RED}[!] GnuCOBOL (cobc) not installed.${RES}"
    read -p "Would you like to install? (y/n): " install
    if [ "$install" = "y" ]; then
        echo -e "${BLU}[i] Proceeding to installation...${RES}"
        sudo apt install gnucobol
    else
        exit 1
    fi
fi
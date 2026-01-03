#!/bin/bash

# COBWEB v1.0
# https://github.com/theluqmn/cobweb

# VARIABLES
arg_name="${1:-main}" arg_main="${2:-main.cbl}" arg_directory="${3:-./}"

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
if [ ! -d "$arg_directory" ]; then
    echo
    echo -e "${RED}[!] Nonexistent directory '$arg_directory'.${RES}"
    exit 1
fi
if [ -z "$1" ]; then
    echo -e "${YEL}[*] No output name provided!${RES}   Defaulting to 'main'.${RES}"
fi
if [ -z "$2" ]; then
    echo -e "${YEL}[*] No main file specified!${RES}    Defaulting to '${arg_directory}main.cbl'.${RES}"
fi
if [ -z "$3" ]; then
    echo -e "${YEL}[*] No directory provided!${RES}     Defaulting to './'.${RES}"
    echo
fi

# LOCATING FILES
echo -e "${UND}Locating COBOL files...${RES}"

cbl_files=($(find "$arg_directory" -type f \( -iname "*.cbl" -o -iname "*.cob" \)))
cbl_files_count=${#cbl_files[@]}

if [ $cbl_files_count -eq 0 ]; then
    echo -e "${RED}[!] No COBOL files found.${RES}"
    exit 1
fi
if [ $cbl_files_count -eq 1 ]; then
    echo -e "${BLU}[i] Located ${cbl_files_count} file:${RES} ${cbl_files[@]}"
else
    echo -e "${BLU}[i] Located ${cbl_files_count} files:${RES} ${cbl_files[@]}"
fi

if command -v cobc >/dev/null 2>&1; then # VERIFY IF GNUCOBOL INSTALLED
    main_base="${arg_main%.*}"
    main_file=$(find "$arg_directory" -type f \( \
        -iname "${main_base}.cbl" -o -iname "${main_base}.cob" -o \
        -iname "${main_base}.CBL" -o -iname "${main_base}.COB" \) | head -1)

    if [ -z "$main_file" ]; then
        echo -e "${RED}[!] No main file found (tried: ${main_base}.cbl/cob/CBL/COB)${RES}"
        exit 1
    fi
    echo -e "${BLU}[i] Located main: ${main_file}${RES}"


    # COMPILATION
    echo
    echo -e "${UND}Compiling files...${RES}"
    
    echo -e "${BLU}[i] Compiling main...${RES}"
    cobc -x -c "$main_file" -o "${arg_name}.o"
    
    echo -e "${BLU}[i] Compiling subprograms:${RES}"
    other_files=($(find "$arg_directory" -type f \( -iname "*.cbl" -o -iname "*.cob" \) | grep -v "$main_file"))
    for file in "${other_files[@]}"; do
        obj_name="${file%.*}.o"
        echo -e "${BLD}$file${RES}"
        cobc -c "$file" -o "$obj_name"
    done
    
    # LINKING MAIN EXECUTABLE AND SUBPROGRAM OBJECT FILES
    echo
    echo -e "${UND}Linking files...${RES}"
    obj_files=("${arg_name}.o")
    for file in "${other_files[@]}"; do
        obj_files+=("${file%.*}.o")
    done
    cobc -x -o "${arg_name}" "${obj_files[@]}"
    
    # CLEANUP
    echo
    echo -e "${UND}Removing object files...${RES}"
    rm -f "${arg_name}.o"
    find . -maxdepth 2 -name "*.o" -delete
    
    echo
    echo -e "${GRN}[✓] Executable '${arg_name}' created!${RES}"
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
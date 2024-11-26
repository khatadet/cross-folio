#!/bin/sh
dirpath=$(dirname "$(readlink -f "$0")")
# echo "Directory ปัจจุบันของไฟล์คือ: $dirpath"
cd "$dirpath"
fastapi dev main.py
# python3 main.py
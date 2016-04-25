#!/bin/bash

# icoconv.sh
# Copyright 2016 Christopher Simpkins
# Adapted from shell script by Denilson Sá at https://superuser.com/questions/40623/icons-command-line-generator#40629
# MIT License

# Dependencies:
#    1. imagemagick (http://www.imagemagick.org/)
#    2. icoutils (http://www.nongnu.org/icoutils/)

# Usage: ./icoconv.sh [png filepath]

if [[ -f "$1" ]]; then
	SOURCE="$1"
	BASE=`basename "${SOURCE}" .png`
else
	echo "[iconconv.sh] ERROR: $1 does not appear to be a valid .png file"
fi

# Resize png image to 16x16 through 256x256 for the ico file
convert "${SOURCE}" -thumbnail 16x16 "${BASE}_16.png"
convert "${SOURCE}" -thumbnail 32x32 "${BASE}_32.png"
convert "${SOURCE}" -thumbnail 48x48 "${BASE}_48.png"
convert "${SOURCE}" -thumbnail 64x64 "${BASE}_64.png"
convert "${SOURCE}" -thumbnail 256x256 "${BASE}_256.png"

if [[ $? -eq 0 ]]; then
	echo "Image resizes completed successfully."
else
	echo "Image resizes failed."
	exit 1
fi

# compile all sizes into the ico file
icotool -c -o "${BASE}.ico" "${BASE}"_{16,32,48,64,256}.png

if [[ $? -eq 0 ]]; then
	echo "Successful conversion of '$1' to '${BASE}.ico'"
	rm -f  "${BASE}"_{16,32,48,64,256}.png
else
	echo "Conversion to an ico file failed."
	exit 1
fi

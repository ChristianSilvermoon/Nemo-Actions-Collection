#!/bin/bash

if [ "$(command -v ffmpeg)" = "" ]; then
	zenity --error --title="gif2webm" --text "ffmpeg is unavailable"
	exit
fi 


for file in "$@"; do
	oldFile="${file}"
	newFile="${file/%\.gif/.webm}"
(
	ffmpeg -y -i "$oldFile" -r 16 -c:v libvpx -crf 4 -quality good -cpu-used 0 -b:v 500K -crf 12 -pix_fmt yuv420p -movflags faststart "$newFile"
) |
	zenity --progress \
		--title="gif2webm" \
		--text="Converting...\nFrom \"$oldFile\"\nTo \"$newFile\"" \
		--pulsate \
		--auto-close \
		--no-cancel
done

exit



if [ "$?" != "0" ]; then
	zenity --error --title="gif2webm" --text="An unknown error occured."
else
	zenity --info --title="gif2webm" --text="Finished Conversions!"
fi

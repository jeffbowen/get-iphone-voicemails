#!/bin/bash
#
# Author: Jeff Bowen (jeff.d.bowen@gmail.com)
#
# Bash script to copy voicemails out of an iPhone backup.

BACKUPS="${HOME}/Library/Application Support/MobileSync/Backup/"
LATEST="${BACKUPS}"$(ls -t "${BACKUPS}" | head -n 1)/
DESTINATION="${HOME}/Downloads/Voicemails/"

MODDATE=$(stat -f "%Sm" -t "%A, %B %d, %Y at %r" "${LATEST}")
printf "Latest iPhone backup is from $MODDATE.\n"
read -rs -p "Copy voicemails from this backup (Y/n)?" -n 1
printf "\n"
if [[ ! ${REPLY:-Y} =~ ^[Yy]$ ]]
then
  exit 1
fi

VOICEMAILS=()
cd "${LATEST}"
printf "\r0 voicemails found..."
for i in {{0..9},{a..f}}
do
  FILES=$(file ${i}* | grep "Adaptive Multi-Rate Codec" | cut -d: -f1)
  for file in ${FILES}
  do
    VOICEMAILS+=(${file})
  done
  # Update status message
  if [ -n "${FILES}" ]
  then
    printf "\r${#VOICEMAILS[*]} voicemails found..."
  fi
done
printf "\n"
mkdir -p "${DESTINATION}"
for voicemail in ${VOICEMAILS[*]}
do
  cp ${voicemail} ${DESTINATION}${voicemail}.amr
done
printf "Done. "
if [ -n "${VOICEMAILS[*]}" ]
then
  printf "${#VOICEMAILS[*]} voicemails copied to \"${DESTINATION}\".\n"
  open ${DESTINATION}
else
  printf "No voicemails were found. Please make sure you do not have the\n"
  printf "\"Encrypt iPhone backup\" option selected in your iPhone Backups\n"
  printf "settings in iTunes.\n"
fi

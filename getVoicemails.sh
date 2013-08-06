#!/bin/bash
#
# Author: Jeff Bowen (jeff.d.bowen@gmail.com)
#
# Bash script to copy voicemails out of an iPhone backup.

BACKUPS="${HOME}/Library/Application Support/MobileSync/Backup/"
LATEST="${BACKUPS}"$(ls -t "${BACKUPS}" | head -n 1)/
DESTINATION="${HOME}/Downloads/Voicemails"
VOICEMAIL_DIR="HomeDomain-Library/Voicemail"
VOICEMAIL_DB_HASH=$(echo -n "${VOICEMAIL_DIR}/voicemail.db" | openssl sha1)

# For future use
CONTACTS_DB="HomeDomain-Library/AddressBook/AddressBook.sqlitedb"

# Have user confirm selected backup
MODDATE=$(stat -f "%Sm" -t "%A, %B %d, %Y at %r" "${LATEST}")
printf "Latest iPhone backup is from $MODDATE.\n"
read -rs -p "Copy voicemails from this backup (Y/n)?" -n 1
printf "\n"
if [[ ! ${REPLY:-Y} =~ ^[Yy]$ ]]
then
  exit 1
fi

cd "${LATEST}"
mkdir -p "${DESTINATION}"

# Retrieve and copy voicemails
SQL="select ROWID, date, sender from voicemail"
VOICEMAILS=$(sqlite3 ${VOICEMAIL_DB_HASH} "${SQL}")
VOICEMAIL_COUNT=$(sqlite3 ${VOICEMAIL_DB_HASH} "select count(*) from voicemail")
for voicemail in ${VOICEMAILS}
do
  ID=$(echo ${voicemail} | awk -F"|" '{ print $1 }')
  DATE=$(echo ${voicemail} | awk -F"|" '{ print $2 }')
  DISPLAY_DATE=$(date -j -f %s ${DATE} +"%Y-%m-%d at %I.%M.%S %p")
  FROM=$(echo ${voicemail} | awk -F"|" '{ print $3 }')
  if [ -z "$FROM" ]; then
    FROM="Unknown"
  fi
  VM=$(echo -n "${VOICEMAIL_DIR}/${ID}.amr" | openssl sha1)
  cp ${VM} ${DESTINATION}/"${DISPLAY_DATE}"\ from\ ${FROM}.amr
done

# Display results
printf "Done. "
if [ -n "${VOICEMAIL_COUNT}" ]
then
  printf "${VOICEMAIL_COUNT} voicemails copied to \"${DESTINATION}\".\n"
  open ${DESTINATION}
else
  printf "No voicemails were found. Please make sure you do not have the\n"
  printf "\"Encrypt iPhone backup\" option selected in your iPhone Backups\n"
  printf "settings in iTunes.\n"
fi

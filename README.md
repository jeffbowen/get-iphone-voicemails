Get iPhone Voicemails
=====================

This simple Bash script will copy all voicemails out of your latest iOS 10+ device
backup to your `~/Downloads/` directory.

Prerequesites
-------------

* macOS/OS X
* iTunes
* An iOS 10+ device backup

Usage
-----

In iTunes, back up your iPhone by connecting it to your computer and choosing
"File > Devices > Back Up". Ensure you do not have the "Encrypt iPhone backup"
option enabled. Once your iPhone is backed up, download and execute the script:

    curl --remote-name https://raw.githubusercontent.com/jeffbowen/get-iphone-voicemails/master/get_voicemails
    bash get_voicemails

Once the script completes, it will open the new directory containing your
voicemails (`~/Downloads/Voicemails/`).

To Do
-----

* Add ability to handle encrypted backups
* Distinguish between iPhone and other iOS device backups
* Rename voicemail files with caller names, numbers, and timestamps

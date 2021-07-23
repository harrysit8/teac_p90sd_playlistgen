# Teac playlist generator
a bash script that generate playlist for **HA-P90SD** base on directory structure

### Caution
Please **backup your existing .ppl** inside /PLAYLISTS first, as the script will overide the existing .ppl in your PLAYLISTS folder if the name of the playlist is same as one of you folder!!!

### QuickStart
put it under your root directory of SD card and
```
cd [to_your_sdcard]
bash genplaylist.sh
```
### Limitation
This script won't work with Hangul（Korea characters) on MacOS, as the characters generated in the .ppl is not regonized with P90-SD.
Hangul is diassembled to Korea alphabetic on MacOS, but most of the application/browser(such as chrome, vscode, but not notepad++) assemble it automatically.
//It should be the problem caused by Itunes/Apple Music when exacting CD audio named with Hangul.


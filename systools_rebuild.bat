@echo off
color 0a
cd ..
@echo on
cd FluffyBestie
echo Rebuilding Systools
haxelib run lime rebuild systools windows
echo Finished Systools rebuild
pause
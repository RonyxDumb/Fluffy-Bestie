@echo off
color 0a
cd ..
@echo on
cd Fluffy-Bestie
echo Rebuilding Systools
haxelib run lime rebuild systools windows
echo Finished Systools rebuild
pause

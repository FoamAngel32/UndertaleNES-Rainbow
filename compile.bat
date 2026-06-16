@echo off

:: sources
ca65 -g --debug-info -I src -o obj/crt0.o src/main.s -DCHR_CHIPS=2

:: libraries

:: link
ld65 -o "roms/undertale.nes" -C nes.cfg --dbgfile "roms/undertale.dbg" obj/crt0.o

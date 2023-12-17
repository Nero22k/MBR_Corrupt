GOTO EndComment1
Microsoft (R) Segmented Executable Linker  Version 5.60.339
Microsoft (R) Macro Assembler Version 6.14.8444
:EndComment1

ml.exe /nologo /AT /c /Fl bootloader.asm
link16.exe bootloader.obj, bootloader.exe,,,,
ml.exe /nologo /AT /c /Fl second_stage.asm
link16.exe second_stage.obj, second_stage.exe,,,,

python3.9 dump_to_bin.py -i bootloader.exe -o bootloader.bin -s 512
python3.9 dump_to_bin.py -i second_stage.exe -o second_stage.bin -s 1024

copy /b bootloader.bin+second_stage.bin payload.bin

del *.obj
del *.lst
del *.map
del bootloader.exe second_stage.exe
del bootloader.bin second_stage.bin

pause
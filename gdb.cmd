target remote localhost:1234
set disassembly-flavor intel
symbol-file ./build/elfLoader.elf
layout src
b main
c

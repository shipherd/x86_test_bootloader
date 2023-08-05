import sys
import subprocess
def compileAll():
    compileMBR()
    compileLoader()
    compileKernel()
def compileMBR():
    exec('nasm -i ./mbr -o ./build/mbr.bin ./mbr/mbr.asm')
    #exec('nasm -i ./mbr -o ./build/mbr.o -f elf32 -F dwarf -g ./mbr/mbr.asm')
    #exec('ld -Ttext=0x7c00 -m elf_i386 ./build/mbr.o -o ./build/mbr.elf')
    #exec('objcopy -O binary ./build/mbr.elf ./build/mbr.bin')
def compileLoader():
    exec('gcc -masm=intel -nostartfiles -m32 -c -g -O3 -ffreestanding -fno-asynchronous-unwind-tables -fno-pic -Wall -I. -o ./build/elfLoader.o ./kernel/elfLoader.c')
    exec('ld -e main -T ./kernel/elfLoader.ld -build-id=none --nmagic -static -nostdlib -m elf_i386 -o ./build/elfLoader.elf ./build/elfLoader.o')
    exec('objcopy -O binary ./build/elfLoader.elf ./build/elfLoader.bin')
def compileKernel():
    exec('gcc -masm=intel -m32 -c -g -O3 -nostartfiles -ffreestanding -fno-pic -Wall -I. -o ./build/kernel.o ./kernel/kernel.c')
    exec('ld -e main -Ttext 0x200000 -build-id=none --nmagic -static -nostdlib -m elf_i386 -o ./build/kernel.elf ./build/kernel.o')
def writeMBR():
    exec('dd if=./build/mbr.bin of=disk.img bs=512 count=1 conv=notrunc')
def writeLoader():
    exec('dd if=./build/elfLoader.bin of=disk.img bs=512 count=64 seek=2 conv=notrunc')
def writeKernel():
    pass
def writeAll():
    writeMBR()
    writeLoader()
    writeKernel()
def qemuDbg():
    exec('qemu-system-i386 -show-cursor -S -s -m 4096 -drive format=raw,file=./disk.img')
def exec(cmd):
    process = subprocess.Popen(cmd.split(), stdout=subprocess.PIPE)
    return process.communicate()

argFuns = {
    '--ca':compileAll,
    '--cm':compileMBR,
    '--cl':compileLoader,
    '--ck':compileKernel,
    '--wa':writeAll,
    '--wm':writeMBR,
    '--wl':writeLoader,
    '--wk':writeKernel,
    '--dbg':qemuDbg,
}
for arg in sys.argv[1:]:
    argFuns[arg]()

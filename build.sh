mkdir -p asm
mkdir -p bin

llc -march=x86 src/kernel.ll -o asm/kernel.s
gcc -m32 -Wall -ffreestanding -nostdlib -c asm/kernel.s -o bin/kernel.o
ld -melf_i386 -Tlinker.ld bin/kernel.o -o bin/kernel.bin

cp bin/kernel.bin iso/boot

grub-mkrescue -o llvm-hello.iso iso
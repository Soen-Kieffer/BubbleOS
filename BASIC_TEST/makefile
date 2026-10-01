all:
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin BASIC.asm -o BASIC.bin
	cat boot.bin BASIC.bin > os-imageBASIC.bin
	rm boot.bin BASIC.bin

run:
	qemu-system-x86_64 -drive format=raw,file=os-imageBASIC.bin
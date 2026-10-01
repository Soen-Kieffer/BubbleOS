all:
	nasm -f bin boot.asm -o boot.bin
	nasm -f bin bubble.asm -o bubble.bin
	cat boot.bin bubble.bin > os-image.bin
	rm boot.bin bubble.bin

run:
	qemu-system-x86_64 -drive format=raw,file=os-image.bin
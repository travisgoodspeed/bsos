
all: disk.fd

disk.fd: boot.bin kernel.bin
	cat boot.bin kernel.bin >disk.fd
	#Add an extra block to ensure none are non-filled.
	dd if=/dev/zero  bs=512 count=1 >>disk.fd
kernel.bin: kernel.c
	bcc -0 -c kernel.c
	bcc -0 -c screen.c
	bcc -0 -c keyboard.c
	bcc -0 -c menu.c
	bcc -0 -c memory.c
	ld86 -0 -M -T 0x7e00 -d kernel.o menu.o screen.o memory.o keyboard.o -o kernel.bin

run: runqemu
runqemu: all
	qemu-system-i386 -fda disk.fd
runbochs: all
	bochs-bin -q 'boot:a' 'floppya: 1_44=disk.fd, status=inserted' 'display_library: sdl'
runbochsx: all
	bochs-bin -q 'boot:a' 'floppya: 1_44=disk.fd, status=inserted' 'display_library: x'

boot.bin: boot.s
	yasm -f bin -o boot.bin boot.s 
	hd boot.bin
clean:
	rm -f *.o *.bin *.fd
dis: kernel.bin
	rasm2 -o 0x7e00 -d -b 16 "`cat kernel.bin| hexdump -v -e '/1 "%02X "'`"

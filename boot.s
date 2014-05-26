;;; BSOS Bootloader by Travis Goodspeed
	
;;; Kind thanks to Pierre Ancelot for getting me started.
;;; http://www.neko-consulting.com/blogs/2


[BITS 16]     ;Set code generation to 16 bit mode
[ORG 0x7C00]  ;Set code start address to 7C00h

[SEGMENT .text]

jmp start			;Code execution begins at the beginning.

bootmsg db 10, 'BSOS BL 0.01', 10, 13, 'by Travis Goodspeed', 10, 10, 13, 0
errormsg db 'You have been eaten by a grue.  Sorry.', 10, 13, 0
bootone db '1) Reading kernel from disk.', 10, 13, 0
boottwo db '2) Executing kernel.', 10, 13, 0


start:
;----------------
  mov si, bootmsg		;Load message into Source Index Register.
  call printstring		;Print the hello message.
  call printmemsize
  ;; call printsegments
;----------------

  xor ax, ax			;Zero AX
  mov ds, ax			;Zero DS
  xor dl, dl			;Zero DL
  int 0x13
  jc reboot


  mov si, bootone		;Tell the user we're about to begin.
  call printstring

;;; Read a sector looking for the kernel.
	
  ;; mov ax, 0x1000		;Load to 1000:0000 -> 0x10000
  mov ax, 0x7e0		;Load to 07E0:0000 -> 0x7E00

  mov es, ax			
  xor bx, bx

  ;; mov ax, 0x0201  ;Read (02) One (01) sector.
  mov ax, 0x0210  ;Read (02) Sixteen (10) sector.
  mov ch, 0       ;Cylinder 0
  mov cl, 2       ;Sector   2 (These begin at 1 not 0.)
  mov dh, 0       ;Head     0 (Top side of a floppy.)
  mov dl, 0       ;Lecteur de disquettes
  int 0x13

  jc reboot

;-------------------
;Execute the kernel

  mov ax, 0x7e00
  mov si, ax
  call printsector


  mov si, boottwo		;Tell the user we're about to begin.
  call printstring


  db 0xea			;JMP to kernel
  ;; dw 0, 0x1000			;at 0x10000
  dw 0, 0x07E0			;at 0x7E00
	

  call reboot

;-------------------
;Message printing

printstring:       ;Print a zero-terminated string.
  lodsb        ;Load String Byte
  cmp al, 0    ;If the byte is 0, then we're done.
  je done
  mov ah, 0xE  ;Display the character.
  int 0x10
  jmp printstring

done:
  ret

oxstr db '0x', 0
bytesstr db ' bytes of memory detected.', 10, 13, 0
segmentsstr db 'Segments: ', 0
commastr db ', ', 0
newlinestr db 10, 13, 0


;; printsegments:
;; 	mov si, segmentsstr
;; 	call printstring

;; 	mov ax, cs		;Code Segment
;; 	call printhex
;; 	mov si, commastr
;; 	call printstring

;; 	mov ax, ds		;Data Segment
;; 	call printhex
;; 	mov si, commastr
;; 	call printstring

;; 	mov ax, ss		;Stack Segment
;; 	call printhex
;; 	mov si, commastr
;; 	call printstring

;; 	mov ax, es		;Extra Segment
;; 	call printhex
;; 	mov si, newlinestr
;; 	call printstring

	
;; 	ret

printmemsize:			;Prints the number of memory bytes.
	mov si, oxstr
	call printstring
	
	call memsize		;AX now holds memory size.
	call printhex		;Print the value in AX.

	mov si, bytesstr
	call printstring
	ret
	
printhex:			;Print a 16-bit word from AX.
	mov bx, ax
	SHR ax, 12
	call printhexnybble
	mov ax, bx
	SHR ax, 8
	call printhexnybble
	mov ax, bx
	SHR ax, 4
	call printhexnybble
	mov ax, bx
	call printhexnybble
	ret
printsector:			;Print 512 bytes from SI.
	xor cx, cx
printhexloop:	
	lodsw
	call printhex
	call printspace
	add cx, 2
	cmp cx, 0x200
	jne printhexloop
	ret
hextable db '0123456789ABCDEF'
printhexnybble:
	push ax
	push si	
	and ax, 0x000F
	add ax, hextable
	mov si, ax
	lodsb			;Load String Byte
	mov ah, 0x0E
	int 0x10
	pop si
	pop ax
	ret
printspace:
	mov ax, 0x0E20
	int 0x10
	ret
memsize:
	xor ax, ax
	;;  Switch to the BIOS (= request low memory size).
	int 0x12
	;;  The carry flag is set, it failed.
	jc reboot
	;;  Test the A-register with itself.
	test ax, ax
	;;  The zero flag is set, it failed.
	jz reboot
	;; Else return the value in AX.
	ret

;------
;REBOOT

reboot:

  mov si, errormsg
  call printstring
stall jmp stall			;loop
  db 0xea
  dw 0x0000
  dw 0xFFFF  ;And the system reboots.

;-------------------
;Zero the sector except for closing magic word.

  times 510-($-$$) db 0
  dw 0xAA55




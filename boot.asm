	bits 16
	mov ax, 0x7c0
	mov ds, ax
	mov ax, 0x7e0
	mov ss, ax
	mov sp, 0x2000

clearscreen:
	push bp
	mov bp,sp
	pusha

	mov ah, 0x07 ;Tells BIOS to scroll down
	mov al, 0x00 ;clear window
	mov bh, 0x07 ;white on black
	mov cx, 0x00 ;Specify clearing top left screen (0,0)
	mov dh, 0x18 ;18 in hex - 24 rows of chars
	mov dl, 0x4f ;4f in hex - 79 columns of chars
	int 0x10 ;Calls graphic interrupt

	popa
	mov sp,bp
	pop bp
	ret
	
movecursor:
	push bp
	mov bp,sp
	pusha

	mov dx, [bp+4] ;Get the argument from the stack
	mov ah, 0x02   ;Set cursor position
	mov bh, 0x00   ;Setting page to 0 since double buffering is not used
	int 0x10

	popa
	mov sp, bp
	pop bp
	ret
	

	

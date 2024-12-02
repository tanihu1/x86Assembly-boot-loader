	bits 16
	mov ax, 0x7c0
	mov ds, ax
	mov ax, 0x7e0
	mov ss, ax
	mov sp, 0x2000

	call clearscreen

	push 0x0000
	call movecursor
	add sp,2

	push msg
	call print
	add sp,2

	cli
	hlt

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

print:
	push bp,
	mov bp, sp
	pusha
	mov si, [bp+4] ;Pointer to data
	mov bh, 0x00   ;page number 0, still no double buffering
	mov bl, 0x00   ;foreground color is ignored in text mode
	mov ah, 0x0E   ;Print characters to TTY


.char:
	mov al, [si]   ;Get current char from pointer pos
	add si, 1      ;We want to incremeant untill null terminator
	or al, 0
	je .return     ;If string is done, return
	int 0x10       ;Print character if not done
	jmp .char      ;loop

.return:
	popa
	mov sp,bp
	pop bp
	ret
	

msg: db "Assembly is not so bad.",0

times 510-($-$$) db 0
dw 0xAA55

[bits 16]
clearFirstPage:
;Parameters: None
;Return: None
	;Clear first page in Color Text Mode
	push cx
	push ax
	push ds
	push bx
	mov cx, (80*25)/2-1
	mov ax, 0xb800
	mov ds, ax
	mov bx, 0
	CLEAR:
	mov dword [bx], 0x00
	add bx, 4
	loop CLEAR
	pop bx
	pop ds
	pop ax
	pop cx
	ret
hideCursor:
;Parameters: None
;Return: None
	;Set invisible cursor
	push cx
	push ax
	mov cx, 0x2607
	mov ah, 0x1
	int 0x10
	pop ax
	pop cx
	ret
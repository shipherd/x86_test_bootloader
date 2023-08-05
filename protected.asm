[bits 16]
loadGDT:
;Parameters: BX=Address to GDT Size and Base, BP=Base address to save GDT. All with DS in default.
;Return: None
	;#0 Reserved
	mov dword [ds:bp], 0x00000000
	mov dword [ds:bp+0x4], 0x00000000
	;#1 Code Segment, 4 GiB, Starts at 0x0
	mov dword [ds:bp+0x8], 0x0000FFFF
	mov dword [ds:bp+0xC], 0x00CF9F00
	;#2 Data Segment, 4 GiB, Starts at 0x0
	mov dword [ds:bp+0x10], 0x0000FFFF
	mov dword [ds:bp+0x14], 0x00CF9200
	;#3 Stack Segment, 4 GiB, Starts at 0xFFFFFFFF
	mov dword [ds:bp+0x18], 0xFFFF0000
	mov dword [ds:bp+0x1C], 0xFFC097FF

	lgdt [bx]
	ret

openA20:
;Parameters: None
;Return: None
	push ax
	in al, 0x92
	or al, 0x02
	out 0x92, al
	pop ax
	ret
enable32bit:
;Parameters: None
;Return: None
	push edx
	mov edx, cr0
	or edx, 1
	mov cr0, edx
	pop edx
	ret
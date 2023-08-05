LOADER_ENTRY equ 0x00100000; Skip the first 1 MiB of Memory
LOADER_SIZE_IN_SECTORS equ 64; Read 64 sectors for Loader
[bits 16]
Entry:
	;Setup Stack
	mov ax, 0x8000
	mov ss, ax
	mov sp, 0xFFFF
	
	call clearFirstPage
	call hideCursor
	
	mov ax, 0x7C0
	mov ds, ax 
	mov bx, gdt;DS:[gdt]
	mov bp, 0xFF00
	call loadGDT
	cli; No Interrupt
	call openA20
	call enable32bit
	jmp 0x8:Protected_Entry+0xc7c00
	[bits 32]
Protected_Entry:
	;Setup Data Segment Descriptor
	mov ax, 0x10
	mov ds, ax
	;Setup Stack Segment Descriptor
	mov ax, 0x18
	mov ss, ax
	;Read from primary disk, 64 sectors
	mov dx, 0x1F2
	mov al, LOADER_SIZE_IN_SECTORS
	out dx, al
	;LBA LOW, Start at Sector 2 (Sector 0 = MBR, Skip one Sector)
	mov dx, 0x1f3
	mov al, 0x02
	out dx, al
	;LBA MID
	mov dx, 0x1f4
	mov al, 0x00
	out dx, al
	;LBA HIGH
	mov dx, 0x1f5
	out dx, al
	;LBA DEVICE
	mov dx, 0x1f6
	mov al, 0xe0
	out dx, al
	;LBA Read
	mov dx, 0x1f7
	mov al, 0x20
	out dx, al
loop_wait:;Wait until the buffer is ready
	in al, dx
	and al, 0x88
	cmp al, 0x8
	jnz loop_wait
	;read data
	mov dx, 0x1f0
	mov ecx, LOADER_SIZE_IN_SECTORS*512/2
	mov ebx, LOADER_ENTRY;Load Loader to LOADER_ENTRY
read:
	in ax, dx
	mov [ebx], ax
	add ebx, 2
	dec ecx
	cmp ecx, 0
	jnz read
	jmp LOADER_ENTRY-0x7C00
%include"utility.asm"
%include"protected.asm"
;GDT size and base address
gdt:
gdtSize dw 0x001F
gdtBase dd 0x00017B00;0x7C00+0xFF00

times 510-($-$$) db 0xFF
db 0x55, 0xaa
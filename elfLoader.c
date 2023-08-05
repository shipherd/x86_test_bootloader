__asm__("jmp main;");
void main(){
	__asm__("mov eax, 0x80000000;");
	__asm__("cpuid;");
	while(1);
}

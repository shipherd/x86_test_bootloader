char* a = "This is a string";
void cpystr(char * str, char * dest){
	while(*str!='\0'){
		*dest = *str;
		str++;
		dest++;
	}
}

void main(){
	char * str = "Hello World!";
	cpystr(a,(char*) 0x2FFFFF);
	cpystr(str, (char*)0x3FFFFF);

	while(1);
}
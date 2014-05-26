void printch(c) char c;
{
  asm "mov ah, #0x0E";
  asm "int 0x10";
}

char nybbles[]="0123456789abcdef";
void printnybble(c) int c;
{
  printch(nybbles[c&0xF]);
}

void printhex(c) int c;
{
  printnybble(c>>12);
  printnybble(c>>8);
  printnybble(c>>4);
  printnybble(c);
  //printch(' ');
}

void print(c) char *c; 
{
  while(*c)
    printch(*c++);
}

void cls(){
  int i=0;
  while(i++<64) print("\r\n");
  
  /*
  asm("mov ax, #0x0600");
  asm("mov bx, #0x4300");
  asm("mov cx, #0x5050");
  asm("mov dx, #0x0000");
  
  asm("int #0x10");
  */
}

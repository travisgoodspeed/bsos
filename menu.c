#include "all.h"

int mainmenulst[]={
  'm', "Memory Viewer", memmenu,
  //  'd', "Disk Routines", diskmenu,
  'a', "About", aboutmenu,
  0x0000
};


void printmenulst(list)
     int *list;
{
  int i=0;
  while(list[i]){
    printch((char) list[i++]);
    print(" -- ");
    print(list[i++]);
    print("\r\n");
    i++; // Skip the pointer.
  }
  print("\r\n");
}

void callfn(adr)
     int adr();
{
  printhex(adr);
  print("About to call.");
  adr();
  print("Did that work?");
}

void execmenulst(list)
     int *list;
{
  int i=0;
  int c, pressed;
  pressed=getkey();
  
  while(list[i]){
    c=list[i++];
    i++; //Ignore the string.
    if(c==pressed){
      print("Trying to call 0x");
      printhex(list[i]);
      print("\r\n");
      callfn(list[i]);
      print("Call complete.");
      return;
    }
    i++; // Skip the pointer.
  }
}

void mainmenu(){
  printmenulst(mainmenulst);
  //execmenulst(mainmenulst);  //broken
  
  switch(getkey()){
  case 'a':
    aboutmenu();
    break;
  case 'm':
    memmenu();
    break;
  default:
    print("Unsupported function.\r\n");
  }
}

void memmenu(){
  int *ptr=0x0;
  int *i;
  int segment=0; //TODO make this variable.
  
  while(1){
    cls();
    print("Memory at ");
    printaddr(segment,ptr);
    print("\r\n");
    
    for(i=ptr;i<ptr+0x100;i++){
      printhex(peek(segment,i));
      print(" ");
    }
    print("Press: n, p, N, P, or q\r\n");
    switch(getkey()){
    case 'q': return;
    case 'n':
      ptr+=0x100;
      break;
    case 'p':
      ptr-=0x100;
      break;
    case 'N':
      ptr+=0x1000;
      break;
    case 'P':
      ptr-=0x1000;
      break;
    }
  }
}

void diskmenu(){
  print("Coming soon.\r\n");
}

void aboutmenu(){
  print("\r\n\r\n\
This is a minimal operating system by Travis Goodspeed for 16-bit Real\r\n\
Mode 8086 on an IBM PC.  It was written in order to learn about the\r\n\
8086, and it quite likely will serve no use for you.  It is free\r\n\
without any strings attached, but please give credit were credit is\r\n\
due if you fork it.\r\n\
\r\n\
Also, and this is very important, you should use the included hex viewer\r\n\
to poke around this machine's memory.  The boot sector at 0000:7C000\r\n\
is likely a good place to start.\r\n");
  anykey();
}


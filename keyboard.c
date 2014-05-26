#include "keyboard.h"


char getkey(){
  asm "xor ax,ax";
  asm "int 0x16";
}

void anykey(){
  print("Press the 'any' key to continue.");
  getkey();
  print("\r\n");
}

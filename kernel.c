#include "all.h"

void main();
void entrypoint(){
  main();
}





char welcome[]="\r\n ____ ____   ___  ____\r\n| __ ) ___| / _ \\/ ___|\r\n|  _ \\___ \\| | | \\___ \\\r\n| |_) |__) | |_| |___) |\r\n|____/____/ \\___/|____/\r\nBerliner Spargel Operating System\r\nMein Deutsch is nicht so gut, aber es ist Spargel zeit!\r\nby Travis Goodspeed\r\n\r\n\r\n";





void main(){
  
  while(1) {
    cls();
    print(welcome);
    mainmenu();
  }
}




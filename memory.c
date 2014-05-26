/*! \file memory.c
  \brief Memory access routines for Real Mode 8086.
*/

int printaddr(segment,offset)
     int segment;
     int *offset;
{
  int h=(segment>>12);
  int l=(segment<<4)+((int)offset);
  printhex(segment);
  printch(':');
  printhex(offset);
  printch('=');
  printnybble(h);
  printhex(l);
}

int peek(segment,offset)
     int segment;
     int *offset;
{
  //TODO peek() Call BIOS or set segment.
  return offset[0];
}



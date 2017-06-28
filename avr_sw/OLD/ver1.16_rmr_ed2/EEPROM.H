// eeprom.h
//
// Header file for eeprom.c
//
// v1.0 2003-03-24 Original.
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#ifndef _EEPROM_INCLUDED_
#define _EEPROM_INCLUDED_

void eeprom_write (int address, unsigned char data);
unsigned char eeprom_read (int address);

#endif
//-------END OF EEPROM.H -------------------------------------------------

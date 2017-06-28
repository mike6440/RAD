// chipinfo.h
//
// This header file has no corresponding .c
// Use it to include chip specific headers and macros
// chipinfo stands for "chip information"
//
// Select target chip with the define following _CHIPINFO_INCLUDED_
//
// v1.0 2003-02-13 Original.  Includes 90s8535.
// v1.1 2003-02-14 Had forgotten the *_INCLUDED stuff.
// v1.2 2003-02-14 Renamed CHIPINFO.H.
// v1.3 2003-02-14 Add #define CHIPINFO_FCK clock frequency.
// v1.4 2003-02-16 Add 90S8535 UART bit positions.
// v1.5 2003-02-17 Add 90S8535 ADC bit positions and masks.
// v1.6 2003-02-19 Change CHIPINFO_FCK from 4 MHz to 3.6864 MHz
// v1.7 2003-02-20 Add 90S8535 WATCHDOG bit positions and mask.
// v1.8 2003-03-24 Add 90S8535 EEPROM and SREG bit positions.
// v1.9 2004-02-09 Change AVRAT90S8535 to ATMEGA16 uProc
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#ifndef _CHIPINFO_INCLUDED_
#define _CHIPINFO_INCLUDED_

#define MEGA64  // THIS SELECTS THE TARGET CHIP

#ifdef MEGA64  // ................................begin chip ATMEGA64
#undef MEGA64  // no longer needed

// general chip information
#include <mega64.h>
#define CHIPINFO_FCK (8000000L)

// adc register bit positions and masks
#define MUXMASK (7)  // ADMUX mask
#define ADEN    (7)  // ADC Enable -- ADCSR
#define ADSC    (6)  // ADC Start Conversion
#define ADFR    (5)  // ADC Free Running Select
#define ADIF    (4)  // ADC Interrupt Flag
#define ADIE    (3)  // ADC Interrupt Enable
#define PSMASK  (7)  // prescaler mask
#define CHIPINFO_FADC   (200000L)       // maximum input clock

// eeprom register EECR bit positions
#define EERIE   (3)  // EEPROM Ready Interrupt Enable
#define EEMWE   (2)  // EEPROM Master Write Enable
#define EEWE    (1)  // EEPROM Write Enable
#define EERE    (0)  // EEPROM Read Enable

// status register SREG bit positions
#define SREG_I  (7)  // Global Interrupt Enable
#define SREG_T  (6)  // Bit Copy Storage
#define SREG_H  (5)  // Half-carry Flag
#define SREG_S  (4)  // Sign Bit (S = N xor V)
#define SREG_V  (3)  // Two's Complement Overflow Flag
#define SREG_N  (2)  // Negative Flag
#define SREG_Z  (1)  // Zero Flag
#define SREG_C  (0)  // Carry Flag

// uart register bit positions
#define RXC0     (7)  // UART Receive Complete -- USR
#define TXC0     (6)  // UART Transmit Complete
#define UDRE0    (5)  // UART Data Register Empty
#define FE0      (4)  // Framing Error
#define DOR0     (3)  // OverRun
#define RXCIE0   (7)  // RX Complete Interrupt Enable -- UCR
#define TXCIE0   (6)  // TX Complete Interrupt Enable
#define UDRIE0   (5)  // UART Data Register Empty Interrupt Enable
#define RXEN0    (4)  // Receiver Enable
#define TXEN0    (3)  // Transmitter Enable
#define CHR9    (2)  // 9 Bit Characters
#define RXB8    (1)  // Receive Data Bit 8
#define TXB8    (0)  // Transmit Data Bit 8

// watchdog WDTCR register bit positions and mask
#define WDTOE   (4)  // Watchdog Turn-off Enable
#define WDE     (3)  // Watchdog Enable
#define PMASK   (7)  // prescaler mask
#define CHIPINFO_FWD    (1000000L)      // Hz at Vcc = 5.0V

#endif  // end chip ATMEGA64

#endif
//-------END OF CHIPINFO.H --------------------------------------------

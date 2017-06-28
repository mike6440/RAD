// watchdog.c
//
// Atmel AVR chip function file
//
// Package to control the watchdog timeout reset
//
// v1.0 2003-02-21 Original.  Uses assembler instruction for pet.
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#include "chipinfo.h"    // Contains target chip specific information
#include "watchdog.h"    // Header file for this function package

//---------------------------------------------------------------------

void
watchdog_enable (char pvalue) {

  // This function will enable the watchdog timer
  // so the watchdog must be petted frequently to
  // avoid a chip reset.

  // pvalue influences the prescaling of the watchdog's oscillator.
  // From the ATMega64 data sheet,
  // the prescale seems to be 2**(14+pvalue).
  // Thus pvalue=0 will timeout fastest and pvalue=7 slowest.
    
  watchdog_pet ();
  WDTCR = (1 << WDE) | (pvalue & PMASK);
  watchdog_pet ();

  return;
  }  // end function watchdog_enable

void
watchdog_disable (void) {

  watchdog_pet ();

  // write 1 to WD turn off enable and enable bits only
  WDTCR |= (1 << WDTOE) | (1 << WDE);

  // Future: I should really worry about an interrupt occurring
  // at this point since WDTOE only lives for four clock cycles.
    
  // write 0 to WD enable bit only
  WDTCR &= !(1 << WDE);

  return;
  }  // end function watchdog_disable

void
watchdog_pet (void) {
  #asm ("wdr");
  return;
  }  // end function watchdog_pet

//-------END OF WATCHDOG.C --------------------------------------------

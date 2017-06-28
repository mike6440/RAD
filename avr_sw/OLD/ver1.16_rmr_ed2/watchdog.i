// watchdog.c
//
// Atmel AVR chip function file
//
// Package to control the watchdog timeout reset
//
// v1.0 2003-02-21 Original.  Uses assembler instruction for pet.
//
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


void
void
watchdog_enable (char pvalue) {

  // so the watchdog must be petted frequently to
  // avoid a chip reset.

  // From the ATMega64 data sheet,
  // the prescale seems to be 2**(14+pvalue).
  // Thus pvalue=0 will timeout fastest and pvalue=7 slowest.
    
  WDTCR = (1 << WDE) | (pvalue & PMASK);
  watchdog_pet ();

  }  // end function watchdog_enable

watchdog_disable (void) {


  WDTCR |= (1 << WDTOE) | (1 << WDE);

  // at this point since WDTOE only lives for four clock cycles.
    
  WDTCR &= !(1 << WDE);

  }  // end function watchdog_disable

watchdog_pet (void) {
  #asm ("wdr");
  return;
  }  // end function watchdog_pet

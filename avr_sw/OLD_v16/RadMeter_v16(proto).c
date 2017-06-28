//*** reynolds comments lines
// v13 :: search on 'v13' to see changes and coments.
// v15 :: rmr edits to RE version 14.  See "v15" or "//v15" for chgs.
// This version v16 is only a version to edit until I get the actual from Ray
/*********************************************
This program was produced by the
CodeWizardAVR V1.23.8c Standard
Automatic Program Generator
© Copyright 1998-2003 HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : NOAA Radiometer Interface Board
Version : 
Date    : 12/20/2004
Author  : Ray Edwards                     
Company : Brookhaven National Laboratory  
Comments: Revision History
	1.0 - Start with simple timed operation 12/22/04 
    1.1 - Build user menu and implement eeprom variables 03/24/05
    1.13 - Bigelow mods.  see "v13" comments
      * spread out the print statement a bit.
      * timeout in Main_Menu
      
//*** search on these comments     
/********************************************
Chip type           : ATmega64
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*********************************************/
//*** REVISION B NOV 2007    
/********************************************
Chip type           : ATmega128
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 1024
*********************************************/
#include <delay.h>
#include <stdio.h>
#include <stdlib.h> 
#include <spi.h> 
#include <math.h>
#include "thermistor.h"
#include "pir.h"
#include "psp.h"
#include <mega128.h>
#include <eeprom.h>
#include <ds1302.h>

// DS1302 Real Time Clock port init
#asm
   .equ __ds1302_port=0x18
   .equ __ds1302_io=4
   .equ __ds1302_sclk=5
   .equ __ds1302_rst=6
#endasm

#define RXB8 	1
#define TXB8 	0
#define UPE 	2
#define OVR 	3
#define FE 	    4
#define UDRE 	5
#define RXC 	7
#define BATT	7
#define PCTEMP	6
#define VREF	5  
#define ALL	    8       
#define NSAMPS	100
#define NCHANS	8

// watchdog WDTCR register bit positions and mask
#define WDCE   (4)  // Watchdog Turn-off Enable
#define WDE     (3)  // Watchdog Enable
#define PMASK   (7)  // prescaler mask    
#define WATCHDOG_PRESCALE (7)    
//#define XTAL	16000000
#define XTAL 3686400
#define BAUD	19200  //default terminal setting
#define OK	1
#define NOTOK	0 
#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define MENU_TIMEOUT 30
//v15 v16
#define VERSION "1.16"
#define VERDATE "2008/08/06"

// Get a character from the USART1 Receiver
#pragma used+
char getchar1(void)
{
char status,data;
while (1)
      {
      while (((status=UCSR1A) & RX_COMPLETE)==0);
      data=UDR1;
      if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         return data;
      };
}
#pragma used-

// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}
#pragma used-

//PROTOTYPES
void ATMega128_Setup(void);
void SignOn(void);
float ReadBattVolt(void);
float ReadRefVolt(void); 
float ReadAVRTemp();
void Heartbeat(void);
int SerByteAvail(void);  
int ClearScreen(void);
int Read_Max186(int, int); 
float RL10052Temp (unsigned int v2, int ref, int res);
void Main_Menu(void);
void ReadAnalog( int chan );
void MeanStdev(double *sum, double *sum2, int N, double missing);
void SampleADC(void);

//GLOBAL VARIABLES
//COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
float COEFFA = 	.0033540172; 
float COEFFB = 	.00032927261; 
float COEFFC =	.0000041188325;
float COEFFD = -.00000016472972;

unsigned char h, m, s, now, then;
unsigned char dt, mon, yr;
int state;
unsigned char version[10] = "1.15";  //v15
unsigned char verdate[20] = "2008/06/25";  //v15 
double Tabs = 273.15;
int adc[NCHANS];   

//SETUP EEPROM VARIABLES AND INITIALIZE
eeprom float psp = 7.72E-6;			//PSP COEFF
eeprom float pir = 3.68E-6;			//PIR COEFF
eeprom int looptime = 10;			//NMEA OUTPUT SCHEDULE
eeprom int Cmax = 2048;				//A/D COUNTS MAX VALUE
eeprom float RrefC = 33042.0; 		//CASE REFERENCE RESISTOR VALUE
eeprom float RrefD = 33046.0;     	//DOME REFERENCE RESISTOR VALUE
eeprom float Vtherm = 4.0963;		//THERMISTOR SUPPLY VOLTAGE
eeprom float Vadc = 4.0960;			//A/D REFERENCE VOLTAGE 
// v15 -- note this offset is in mv as it is subtracted from the 
// from the ADC count.  Same for PSPadc_offset
eeprom float PIRadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
eeprom float PIRadc_gain = 815.0;
eeprom float PSPadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
eeprom float PSPadc_gain = 125.0;
eeprom int   Id_address = 00;		//$RAD** address $RAD00 is default


/******************************************************************************************
MAIN
******************************************************************************************/
void main(void)
{

	double ADC0_mV, ADC1_mV, ADC2_mV, ADC3_mV, ADC4_mV, ADC5_mV, ADC6_mV, ADC7_mV;  //v16
	int nsamps;             
	double BattV, AVRTemp, RefV;
	double vt, Rt, Pt;
	double tcase, tdome;
	double sw, lw, C_c, C_d;
 	
	state = 0;
	Cmax = 2048;
	
    ATMega128_Setup();
    SignOn();
    Heartbeat();
    
	printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
	printf(" Software Version %s, %s\n\r", version, verdate);
	printf(" Current EEPROM values:\n\r");
	printf(" Identifier Header= $RAD%02d\n\r", Id_address);
	printf(" PSP Coeff= %.2E\n\r", psp);
	printf(" PIR Coeff= %.2E\n\r", pir);
	printf(" Interval Time (secs)= %d\n\r", looptime);
	printf(" Cmax= %d\n\r", Cmax);
	printf(" Reference Resistor Case= %.1f\n\r", RrefC);
	printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
	printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
	printf(" PIR ADC Offset= %.2f mv\n\r", PIRadc_offset);
	printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
	printf(" PSP ADC Offset= %.2f mv\n\r", PSPadc_offset);
	printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
	putchar('\r'); // CR
	putchar('\n'); // LF
	//*** check, do we want <cr><lf> or <lf><cr> ??
	// v15, the end of an output line will be <cr><lf>
	//v16 this was skipped in prev version
	
	//Heartbeat();
	//*** why no heartbeat? 
    
	
	//v16 -- add the additional loop to clear the sum variables.
	while (1) {
		ADC0_mV = ADC1_mV = ADC2_mV = ADC3_mV = ADC4_mV = ADC5_mV = ADC6_mV = ADC7_mV = 0;  
		nsamps = 0;
		
	    // SETUP FOR TIMED OPERATION
    	rtc_get_time(&h,&m,&s);
    	then = s;       

		//v16 summation loop
		while (1) {
			//PSP THERMOPILE
			ADC0_mV += Read_Max186(0,0); 	//PSP Sig 
			// PIR THERMOPILE
			ADC1_mV += Read_Max186(1,0); 	//PIR Sig
			// CASE TEMPERATURE
			ADC2_mV += Read_Max186(2,0);
			// DOME TEMPERATURE
			ADC3_mV += Read_Max186(3,0);

			rtc_get_time(&h,&m,&s); 
			if( abs((int)s - (int)then) >= looptime ) break;
			else {
				then = s;
				nsamps ++;
			}
		}  
		Heartbeat();
		
		ADC0_mV /= nsamps;
		ADC1_mV /= nsamps;
		ADC2_mV /= nsamps;
		ADC3_mV /= nsamps;
		
		// TEMPS, VOLTAGES
		BattV = ReadBattVolt();  
		RefV = ReadRefVolt();
		AVRTemp = ReadAVRTemp();
		
		// PSP COMPUTE -- sw
		PSPSW( ADC0_mV, psp, PSPadc_offset, PSPadc_gain, &sw);
		
		// PIR THERMOPLE -- ADC1_mV
		
		// TCASE COMPUTE -- tcase
		therm_circuit_ground(ADC2_mV, Cmax, RrefC, Vadc, Vadc, &vt, &Rt, &Pt);
		tcase = ysi46000(Rt,Pt);

		// TDOME COMPUTE -- tdome
		therm_circuit_ground(ADC3_mV, Cmax, RrefD, Vadc, Vadc, &vt, &Rt, &Pt);
		tdome = ysi46000(Rt,Pt);
		
		// LW COMPUTATION -- lw
		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, tcase, tdome, 4.0, &lw, &C_c, &C_d);
				
		//Diagnostic Printout
		//printf("ADC0_mV= %f, \n\r",
		//	ADC1_mV, ADC2_mV, ADC3_mV, ADC0_mV);
		//printf("then= %d, now= %d\n\r", then, now);
			
		//OUTPUT STRING // v16
		rtc_get_date(&dt, &mon, &yr);
		rtc_get_time(&h,&m,&s);
		// if(h > 12) h = h - 12;  //12 hour clock
		//v13 I opened up the print statement a bit.
		//v16 Talker code = WI, So the prefix will be WIR for Weather Instrument, Radiometer
		//v16 <cr><lf> here.
		printf("\n\r$WIR%02d,%02d/%02d/%02d,%02d:%02d:%02d,%4d,%6.1f,%6.2f,%6.2f,%6.2f,%7.2f,%5.1f,%5.1f\r\n", 
		   Id_address, yr, mon, dt, h, m, s, nsamps, ADC1_mV, lw, tcase, tdome, sw, AVRTemp, BattV);

		//Check for menu call
		if( SerByteAvail() && getchar() == 'T' ) Main_Menu();	
	}
} 

/******************** PROGRAM FUNCTIONS ***********************************/
/**************************************************************************/

float ReadAVRTemp(void)
/**********************************************
	Returns Temperature on Board in DegC
**********************************************/
{  
	int RefVMilliVolts, AVRVMilliVolts;
	float AVRTemp;
	
    RefVMilliVolts = ( Read_Max186(VREF, 1) );
	AVRVMilliVolts = ( Read_Max186(PCTEMP, 1) );
	AVRTemp = RL10052Temp(AVRVMilliVolts, (RefVMilliVolts*2), 10010);
	
	return AVRTemp;
}

float ReadBattVolt(void)
/**********************************************
	Returns Main Power Input in Volts
**********************************************/
{ 
	int BattVMilliVolts;
	float BattV;
	
	BattVMilliVolts = ( Read_Max186(BATT, 1) );
 	BattV = ((BattVMilliVolts)/100.0) + 1.2;
 	
 	return BattV;
}


float ReadRefVolt(void)
/**********************************************
	Returns A/D Reference Voltage in Volts
**********************************************/
{ 
	int RefVMilliVolts;
	float RefV;
	
	RefVMilliVolts = ( Read_Max186(VREF,1) );
 	RefV = ((RefVMilliVolts * 2) /1000);
 	
 	return RefV;
}

void Heartbeat(void)
/*************************************
Heartbeat on PortE bit 2
*************************************/
{
	
	PORTE=0X04;
	delay_ms(15);
	PORTE=0X00; 
	delay_ms(500);
}

void SignOn(void)
/********************************************
 PROGRAM START
********************************************/
{
	ClearScreen();
	
	printf("\n\r\n\rSIGNON RADIOMETER INTERFACE V%s, %s\n\r", version, verdate);   //v1.14
	printf("\n\rDigital Interface Board - Rev B. Nov 2007\n\r");
	rtc_get_time(&h,&m,&s);
	
	printf("Program Start time is: %02d:%02d:%02d\n\r", h, m, s);
	rtc_get_date(&dt, &mon, &yr);
	printf("Program Start date is: %02d/%02d/%02d\n\r", yr, mon, dt);
	printf("\n\rHit 'T' for Main Menu.\n\r"); 
    printf("\n\r");
}

void ATMega128_Setup(void)
/*************************************
Initialization for AVR ATMega128 chip
*************************************/
{   
	// Input/Output Ports initialization
	// Port A initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
	PORTA=0x00;
	DDRA=0x00;
	
	// Port C initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
	PORTC=0x03;
	DDRC=0x03;
	
	// Port D initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
	PORTD=0x00;
	DDRD=0x00;
	
	// Port E initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
	PORTE=0x00;
	DDRE=0x04;
	
	// Port F initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
	PORTF=0x00;
	DDRF=0x00;
	
	// Port G initialization
	// Func0=In Func1=In Func2=In Func3=In Func4=In 
	// State0=T State1=T State2=T State3=T State4=T 
	PORTG=0x00;
	DDRG=0x00;
	
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=FFh
	// OC0 output: Disconnected
	ASSR=0x00;
	TCCR0=0x00;
	TCNT0=0x00;
	OCR0=0x00;
	
	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: Timer 1 Stopped
	// Mode: Normal top=FFFFh
	// OC1A output: Discon.
	// OC1B output: Discon.
	// OC1C output: Discon.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	TCCR1A=0x00;
	TCCR1B=0x00;
	TCNT1H=0x00;
	TCNT1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;
	OCR1CH=0x00;
	OCR1CL=0x00;
	
	// Timer/Counter 2 initialization
	// Clock source: System Clock
	// Clock value: Timer 2 Stopped
	// Mode: Normal top=FFh
	// OC2 output: Disconnected
	TCCR2=0x00;
	TCNT2=0x00;
	OCR2=0x00;
	
	// Timer/Counter 3 initialization
	// Clock source: System Clock
	// Clock value: Timer 3 Stopped
	// Mode: Normal top=FFFFh
	// OC3A output: Discon.
	// OC3B output: Discon.
	// OC3C output: Discon.
	TCCR3A=0x00;
	TCCR3B=0x00;
	TCNT3H=0x00;
	TCNT3L=0x00;
	OCR3AH=0x00;
	OCR3AL=0x00;
	OCR3BH=0x00;
	OCR3BL=0x00;
	OCR3CH=0x00;
	OCR3CL=0x00;
	
	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// INT2: Off
	// INT3: Off
	// INT4: Off
	// INT5: Off
	// INT6: Off
	// INT7: Off
	EICRA=0x00;
	EICRB=0x00;
	EIMSK=0x00;
	
	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x00;
	ETIMSK=0x00;
	
	// USART0 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART0 Receiver: On
	// USART0 Transmitter: On
	// USART0 Mode: Asynchronous
	// USART0 Baud rate: 19200
	UCSR0A=0x00;
	UCSR0B=0x18;
	UCSR0C=0x06;
	UBRR0H=0x00;
	UBRR0L=XTAL/16/BAUD-1;
	
	// USART1 initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART1 Receiver: On
	// USART1 Transmitter: On
	// USART1 Mode: Asynchronous
	// USART1 Baud rate: 9600
	UCSR1A=0x00;
	UCSR1B=0x18;
	UCSR1C=0x06;
	UBRR1H=0x00;
	UBRR1L=0x33;
	
	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	// Analog Comparator Output: Off
	ACSR=0x80;
	SFIOR=0x00;
	
	// Port B initialization
	PORTB=0x01;
	DDRB=0x07;
	
	// SPI initialization
	// SPI Type: Master
	// SPI Clock Rate: 1MHz
	// SPI Clock Phase: 1
	// SPI Clock Polarity: 0
	// SPI Data Order: MSB First
	// SETUP for MAX186 on SPI
	//SPCR = (1<<SPE) | (1<<MSTR) ; // SPI enable, Master mode, 1MHz Clk
	SPCR = 0x51;
	SPSR=0x01;
	
	// DS1302 Real Time Clock initialization
	// Trickle charger: Off
	rtc_init(0,0,0); 
	
}  

int SerByteAvail(void)
/********************************
Check the serial port for characters
returns a 1 if true 0 for not true
*********************************/
{   
	if (UCSR0A >= 0x7f)
	{
	    //printf("Character found!\n\r");
		return 1;
	}
	 return 0;
}      

int ClearScreen(void)
/*********************************************
Routine to clear the terminal screen.
**********************************************/
{ 
	int i; 
	i=0;
	while (i<25)
	{
		printf("\n\r");
		i++;
	} 
	return OK;
}

int Read_Max186(int channel, int mode)
/**************************************************
Routine to read external Max186 A-D Converter.
Control word sets Unipolar mode, Single-Ended Input,
External Clock.
Mode: 	0 = Bipolar (-VRef/2 to +VRef/2)
 		1 = Unipolar ( 0 to VRef )		
**************************************************/
{
	unsigned int rb1, rb2, rb3;
	int data_out;
	long din;
	
	data_out=0;
	rb1=rb2=rb3=0; 
	
	if (mode == 1) //DO UNIPOLAR (0 - VREF)
	{
		if(channel==0)		/*Set din to correct A/D channel*/
			din=0x8F;		// 10001111
		else if(channel==1)
			din=0xCF;		// 11001111
		else if(channel==2)
			din=0x9F;		// 10011111
		else if(channel==3)
			din=0xDF;		// 11011111
		else if(channel==4)
			din=0xAF;		// 10101111
		else if(channel==5)
			din=0xEF;		// 11101111
		else if(channel==6)
			din=0xBF;		// 10111111
		else if(channel==7)
			din=0xFF;	 	// 11111111
	} 
	else	//DO BIPOLAR (-VREF/2 - +VREF/2)
	{
		if(channel==0)		/*Set din to correct A/D channel*/
			din=0x87;		// 10000111
		else if(channel==1)
			din=0xC7;		// 11000111
		else if(channel==2)
			din=0x97;		// 10010111
		else if(channel==3)
			din=0xD7;		// 11010111
		else if(channel==4)
			din=0xA7;		// 10100111
		else if(channel==5)
			din=0xE7;		// 11100111
		else if(channel==6)
			din=0xB7;		// 10110111
		else if(channel==7)
			din=0xF7;	 	// 11110111
	}
    
	// START A-D
	PORTB = 0x07;
	PORTB = 0x06; 	//Selects CS- lo 
	
	// Send control byte ch7, Uni, Sgl, ext clk
	rb1 = ( spi(din) );		//Sends the coversion code from above
	// Send/Rcv HiByte
	rb2 = ( spi(0x00) );		//Receive byte 2 (MSB) 
	// Send/Rcv LoByte
	rb3 = ( spi(0x00) );		//Receive byte 3 (LSB)
		
	PORTB = 0x07;		//Selects CS- hi
    
	// Calculation to counts
	if(mode == 1) //UNIPOLAR
	{
		rb2 = rb2 << 1;
		rb3 = rb3 >> 3;
		data_out = ( (rb2*16) + rb3 ) ;
	}
	else if(mode == 0) //BIPOLAR
	{
		rb2 = rb2 << 1;
		rb3 = rb3 >> 3;
		data_out = ((rb2*16) + rb3);
		if(data_out >= 2048) data_out -= 4096;
	}
	else {  // v15 we need this.
		data_out = 0;
	}
			
	//printf("Data Out= %d\n\r", data_out);   
	
	
	return data_out;
}   


float RL10052Temp (unsigned int v2, int ref, int res)
/***********************************
Calculates Thermistor Temperature
v2 = A to D Milli Volts 0-4096
ref = reference voltage to circuit
res = reference divider resistor
***********************************/
{
	float v1, r2, it, Temp, dum;
	float term1, term2, term3;
			
	v1 = (float)ref - (float)v2;
	it = v1/(float)res;
	r2 = (float)v2/it;		    //find resistance of thermistor
	dum = (float)log(r2/(float)res);
	
	// Diagnostic
	//printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\n\r", v2, v1, it, r2, dum);
	
	term1 = COEFFA + (COEFFB * dum);
	term2 = COEFFC * (dum*dum);
	term3 = COEFFD * ((dum*dum)*dum);
   	Temp = term1 + term2 + term3;
	//printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\n\r", term1, term2, term3, Temp);
	//Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	//	printf("Temp= %f\n\r", Temp);

return Temp;
} 

void Main_Menu(void)
/*************************************************
*************************************************/
{ 
	char ch;
	int ltime;
	char msg[12];
	int i; 
	unsigned long t1, t2;  //v1.13

			
	printf("\n\r");
	printf("\n\r RAD%02d BOARD (REV B) VERSION: %s, VERSION DATE: %s\n\r", Id_address, version, verdate);
	printf(" ----------EEPROM PARAMETERS----------------------------\n\r");
	printf("PSP Coeff= %.2E, PIR Coeff= %.2E\n\r", psp, pir);
	printf("PIRadc_gain= %.1f, PIRadc_offset= %.1f\n\r", PIRadc_gain, PIRadc_offset);                   
	printf("PSPadc_gain= %.1f, PSPadc_offset= %.1f\n\r", PSPadc_gain, PSPadc_offset);
	printf(" ---------DATE & TIME SETTING---------------------------\n\r"); 
    printf("'T' -->Set the date/time.\n\r");
    printf(" ---------PSP SETTINGS----------------------------------\n\r");
    printf("'p' -->Set PSP coefficient. 'g' -->Set PSP amplifier gain value.\n\r"); 
    printf("'o' -->Set PSP amplifier output offset, mv.\n\r");  //v15
    printf(" ---------PIR SETTINGS----------------------------------\n\r");
    printf("'I' -->Set PIR coefficient. 'G' -->Set PIR amplifier gain value.\n\r");
    printf("'O' -->Set PIR amplifier output offset, mv.\n\r");  //v15
    printf("'C' -->Set Case (R8) value. 'D' -->Set Dome (R9) value.\n\r");
    printf("'V' -->Set Thermistor/ADC Reference Voltage (TP2) value.\n\r");
    printf(" ---------TIMING SETTING--------------------------------\n\r");
    printf("'L' -->Set Output time in seconds.\n\r");
    printf(" -------------------------------------------------------\n\r");
    printf("'S' -->Sample 12 bit A to D. 'A' -->Change Identifier String.\n\r");
    printf("'X' -->Exit this menu, return to operation.\n\r");
    printf("=========================================================\n\r");
    printf("Command?>");
	
	// ***************************************
	// WAITING FOR A CHARACTER.  TIMEOUT.  v13
	// ***************************************
	rtc_get_time(&h,&m,&s);
	t1 = h*3600 + m*60 + s;
	while (1) 
	{
		// CHECK INPUT BUFFER FOR A CHARACTER
		if ( SerByteAvail() )
		{
			ch = getchar();
			break;
		}
		// CHECK CURRENT TIME FOR A TIMEOUT
		rtc_get_time(&h,&m,&s);
		t2 = h*3600 + m*60 + s;		 
		if ( abs(t2-t1) > MENU_TIMEOUT )     //v13 30 sec timeout
		{
			printf("\n\rTIMEOUT: Return to sampling\n\r");
			return;
		}
	}	
	switch (ch) 
	{
		//*** echo characters typed.  See PRP code.
		// SET THE REAL-TIME CLOCK TIME
		case 'T':
		case 't': 
		    printf("System date/time (YY/MM/DD, hh:mm:ss) is %02d/%02d/%02d, %02d:%02d:%02d\n\r", yr, mon, dt, h, m, s);
			printf("Enter new date, time (yyMMdd,hhmmss):  ");
			
			scanf("%2d%2d%2d,%2d%2d%2d", &yr, &mon, &dt, &h, &m, &s);  // v15 -- read in date and time all at once
			// v15 -- check all at once
			if( (yr < 7 || yr > 99 || mon < 1 || mon > 12 || dt < 1 || dt > 31 || 
			h < 0 || h >= 24 || m < 0 || m >= 60 || (s >= 60) ) 
			{
				printf("\n\rIncorrect time entered, check format.\n\r");
				break;
			}
			else 
			{
				rtc_set_date(dt, mon, yr);
				rtc_set_time(h, m, s);
				printf("\n\r%02d-%02d-%02d, %02d:%02d:%02d saved.\n\r", yr, mon, dt, h, m, s);
			}
			break;
		
		// SET AVERAGING INTERVAL IN SECS
		case 'L' :
		case 'l' : 
			printf("Change Output Interval in secs\n\r");
			printf("Current Interval is: %d secs\n\r", looptime);
			printf("Enter new output interval in secs: ");
			for (i=0; i<5; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}
			if(atof(msg) > 3600 || atof(msg) <= 0)    //v13 increased limit to 1/2 hour //v15 increased to one hour
			{
				printf("\n\rOut of Range.\n\r");
				break;
			}
			else 
			{
				ltime = atof(msg);
				looptime = ltime;
				printf("\n\rLooptime is now set to %d seconds.\n\r", looptime); 
			}
			
			break;  
		
		// PSP COEFFICIENT
		case 'p' :
			printf("Change PSP Coefficient\n\r");
			printf("Current PSP Coefficient is: %.2E\n\r", psp);
			printf("Enter New PSP Coefficient: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}
			if(atof(msg) >= 20.0E-6 || atof(msg) <= 0.1E-6)  //v15  expand range
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				psp = atof(msg);
				printf("\n\rPSP Coefficient is now set to %.2E\n\r", psp); 
			}
			break;
		
		case 'g' :
			printf("Change PSP Amplifier Gain Value\n\r");
			printf("Current PSP Amplifier Gain Value: %.2f\n\r", PSPadc_gain);
			printf("Enter New PSP Amplifier Gain Value: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i] );
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}
			if(atof(msg) >= 300 || atof(msg) <= 10)  //v15  expand range 
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				PSPadc_gain = atof(msg);
				printf("\n\rPSP Amplifier Gain is now set to %.2f\n\r", PSPadc_gain); 
			}
			break;

		case 'o' :
			printf("Change PSP Amplifier Offset Value\n\r");
			printf("Current PSP Amplifier Offset Value: %.2f\n\r", PSPadc_offset);
			printf("Enter New PSP Amplifier Offset Value: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) > 500 || atof(msg) < -500)  //v15  expand range
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				PSPadc_offset = atof(msg);
				printf("\n\rPSP Amplifier Offset is now set to %.2f\n\r", PSPadc_offset); 
			}
			break;

		case 'G' :
			printf("Change PIR Amplifier Gain Value\n\r");
			printf("Current PIR Amplifier Gain Value: %.2f\n\r", PIRadc_gain);
			printf("Enter New PIR Amplifier Gain Value: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) > 1500 || atof(msg) < 500 )  //v15  expand range
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				PIRadc_gain = atof(msg);
				printf("\n\rPIR Amplifier Gain is now set to %.2f\n\r", PIRadc_gain); 
			}
			break;

		case 'O' :
			printf("Change PIR Amplifier Offset Value\n\r");
			printf("Current PIR Amplifier Offset Value: %.2f\n\r", PIRadc_offset);
			printf("Enter New PIR Amplifier Offset Value: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) > 200 || atof(msg) < -200)  //v15  expand range
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				PIRadc_offset = atof(msg);
				printf("\n\rPIR Amplifier Offset is now set to %.2f\n\r", PIRadc_offset); 
			}
			break;

		case 'I' :  // 'l' or 'I' This is capital Eye
			printf("Change PIR Coefficient\n\r");
			printf("Current PIR Coefficient is: %E\n\r", pir);
			printf("Enter New PIR Coefficient: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				pir = atof(msg);
				printf("\n\rPIR Coefficient is now set to %E\n\r", pir); 
			}
			break;
		case 'C' :
			printf("Change Case Reference Resistor (R9)\n\r");
			printf("Current Case Reference Resistor is: %.1f\n\r", RrefC);
			printf("Enter New Case Reference Resistance: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}
			if( atof(msg) > 40000 || atof(msg) < 5000)
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				RrefC = atof(msg);
				printf("\n\rCase Reference Resistor is now set to %.1f\n\r", RrefC); 
			}
			break;
		case 'D' :
			printf("Change Dome Reference Resistor (R10)\n\r");
			printf("Current Dome Reference Resistor is: %.1f\n\r", RrefD);
			printf("Enter New Dome Reference Resistance: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) > 40000 || atof(msg) < 5000)
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				RrefD = atof(msg);
				printf("\n\rDome Reference Resistor is now set to %.1f\n\r", RrefD); 
			}
			break;
		case 'V' :
			printf("Change Thermistor Reference Voltage\n\r");
			printf("Current Thermistor Reference Voltage is: %.4f\n\r", Vtherm);
			printf("Enter New Thermistor Reference Voltage: ");
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atof(msg) > 6.0 || atof(msg) < 2.0)  //v15  expand range
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else 
			{
				Vtherm = atof(msg);
				Vadc = Vtherm;
				printf("\n\rThermistor Reference Voltage is now set to %.4f\n\r", Vtherm); 
			}
			break;
		case 'A' :
			printf("Change Identifier Address\n\r");
			printf("Current Identifier Address: $RAD%02d\n\r", Id_address);
			printf("Enter New Identifier Address (0-99): ");
			
			for (i=0; i<20; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					i--;
					break;
				}
			}                        
			if(atoi(msg) > 99 || atoi(msg) < 00)
			{
				printf("\n\rOut of Range\n\r");
				break;
			}
			else
			{
				Id_address = atoi(msg);
				printf("\n\rIdentifier String now set to: $RAD%02d\n\r", Id_address); 
			}
			break;	                                         
		case 'X' :
		case 'x' :
			printf("\n\r Returning to operation...\n\r\n\r");
			return;  //v13 RETURN FROM THIS S/R 
			break;
		case 'S' :
			SampleADC();
			break;
		case 'Z' :
		case 'z' :
			printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
			printf(" Software Version %s, %s\n\r", version, verdate);
			printf(" Current EEPROM values:\n\r");
			printf(" Identifier Header= $RAD%02d\n\r", Id_address);
			printf(" PSP Coeff= %.2E\n\r", psp);
			printf(" PIR Coeff= %.2E\n\r", pir);
			printf(" Interval Time (secs)= %d\n\r", looptime);
			printf(" Cmax= %d\n\r", Cmax);
			printf(" Reference Resistor Case= %.1f\n\r", RrefC);
			printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
			printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
			printf(" PIR ADC Offset= %.2f\n\r", PIRadc_offset);
			printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
			printf(" PSP ADC Offset= %.2f\n\r", PSPadc_offset);
			printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
			printf("\n\r");
			//v15 -- we need to wait here for a character press
			break;
			
		//v13 INVALID KEY ENTRY -- RE-CALL MENU
		default : printf("Invalid key\n\r");
			//v13 printf("\n\r Returning to operation...\n\r\n\r");
			Main_Menu();
	} // end switch
	
	//v13 -- recall s/r
	Main_Menu();
	//printf("Returning to operation...\n\r\n\r");
	//return;
}	//end menu

void SampleADC(void)
/********************************************************
Test the ADC circuit
**********************************************************/
{
	double ddum[8], ddumsq[8];
	int i, npts;          
	int missing;
	
	missing = -999;

	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	npts=0;
	printf("\n\r");
	while( !SerByteAvail() )
	{
		ReadAnalog(ALL);
		printf("%7d %7d %7d %7d %7d %7d %7d %7d\n\r",
		adc[0],adc[1],adc[2],adc[3],
		adc[4],adc[5],adc[6],adc[7]);
		for(i=0; i<8; i++)
		{
			ddum[i] += (double)adc[i];
			ddumsq[i] += (double)adc[i] * (double)adc[i];
		}
		npts++;
		delay_ms(1000);
		
		Heartbeat();
	}
	printf("\n\r");
	for(i=0; i<8; i++)
		MeanStdev((ddum+i), (ddumsq+i), npts, missing);

	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r",
		ddum[0],ddum[1],ddum[2],ddum[3],
		ddum[4],ddum[5],ddum[6],ddum[7]);
	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r\n\r",
		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
		
		Heartbeat();
	return;
}

void	MeanStdev(double *sum, double *sum2, int N, double missing)
/********************************************
Compute mean and standard deviation from the count, the sum and the sum of squares.
991101
Note that the mean and standard deviation are computed from the sum and the sum of 
squared values and are returned in the same memory location.
*********************************************/
{
	if( N <= 2 )
	{
		*sum = missing;
		*sum2 = missing;
	}
	else
	{
		*sum /= (double)N;		// mean value
		*sum2 = *sum2/(double)N - (*sum * *sum); // sumsq/N - mean^2
		*sum2 = *sum2 * (double)N / (double)(N-1); // (N/N-1) correction
		if( *sum2 < 0 ) *sum2 = 0;
		else *sum2 = sqrt(*sum2);
	}
	return;
}
void ReadAnalog( int chan )
/************************************************************
Read 12 bit analog A/D Converter Max186
************************************************************/
{
	int i;
	if( chan == ALL )
	{
		for(i=0;i<8;i++)
		{	
			adc[i] = Read_Max186(i, 0);
		   //	printf("adc[i] = %d, isamp = %d, i = %d\n\r", adc[i], i);
		}
	}
	else if( chan >= 0 && chan <=7 )
	{
		adc[chan] = Read_Max186(chan, 0);
	}
    return;
} 
    

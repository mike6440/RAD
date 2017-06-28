//*** reynolds comments lines
// v13 :: search on 'v13' to see changes and coments.
// v15 :: rmr edits to RE version 14.  See "v15" or "//v15" for chgs.
// v16 080812 :: rmr edits.  Sent to re for compile and install.
//	1. Rewrite main section with float while loops.
//	2. Change \n\r to \r\n == <cr><lf>
// v17 081030 :: reynolds edits using rmrco computer in Seattle
//
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
      
Mike Reynolds - RMR Co.
      
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
#include <spi.h> 
#include <mega128.h>
#include <ds1302.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>
#include <ctype.h>
//#include "thermistor.h"
//#include "pir.h"
//#include "psp.h"
#include "eeprom.h"


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
//#define VERSION "1.16"
//#define VERDATE "2008/08/13"

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
unsigned Main_Menu(void);
void ReadAnalog( int chan );
void MeanStdev(float *sum, float *sum2, int N, float missing);
void SampleADC(void);
//************* THERMISTOR ****************************
//float ysi46041CountToRes(float c);
float ysi46041(float r, float *c); 
float ysi46000(float Rt, float Pt);
void therm_circuit_ground(float c, float C_max, float R_ref, float V_therm, float V_adc,
	float *v_t, float *R_t, float *P_t);
//****** PIR ***************************************
void PirTcTd2LW(float vp, float kp, float PIRadc_offset, float PIRadc_gain, float tc, float td, float k, 
	float *lw, float *C_c, float *C_d);  
float SteinhartHart(float C[], float R);
extern float Tabs;
//******** PSP ******************************
float PSPSW(float vp, float kp, float PSPadc_offset, float PSPadc_gain, float *sw);



//GLOBAL VARIABLES
//COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
float COEFFA = 	.0033540172; 
float COEFFB = 	.00032927261; 
float COEFFC =	.0000041188325;
float COEFFD = -.00000016472972;

unsigned char h, m, s;
unsigned char dt, mon, yr;
int t_now, t_end;  // v16 used for sampling loops
int state;
unsigned char version[10] = "1.17";  //v15  v16 v17
unsigned char verdate[20] = "2008/10/30";  //v15 v16 v17
float Tabs = 273.15;
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

	float ADC0_mV, ADC1_mV, ADC2_mV, ADC3_mV, ADC4_mV, ADC5_mV, ADC6_mV, ADC7_mV;  //v16
	unsigned long nsamps;  // v16 to prevent overflow.
	float BattV, AVRTemp, RefV;
	float vt, Rt, Pt;
	float tcase, tdome;
	float sw, lw, C_c, C_d;
    char ch;
	
	
 	
	state = 0;
	Cmax = 2048;
	
    ATMega128_Setup();
    SignOn();
    Heartbeat();
    
	printf("\r\n***** SMART DIGITAL INTERFACE *****\r\n");
	printf(" Software Version %s, %s\r\n", version, verdate);
	printf(" Current EEPROM values:\r\n");
	printf(" Identifier Header= $WIR%02d\r\n", Id_address);
	printf(" PSP Coeff= %.2E\r\n", psp);
	printf(" PIR Coeff= %.2E\r\n", pir);
	printf(" Interval Time (secs)= %d\r\n", looptime);
	printf(" Cmax= %d\r\n", Cmax);
	printf(" Reference Resistor Case= %.1f\r\n", RrefC);
	printf(" Reference Resistor Dome= %.1f\r\n", RrefD);
	printf(" Vtherm= %.4f, Vadc= %.4f\r\n", Vtherm, Vadc);
	printf(" PIR ADC Offset= %.2f mv\r\n", PIRadc_offset);
	printf(" PIR ADC Gain= %.2f\r\n", PIRadc_gain);
	printf(" PSP ADC Offset= %.2f mv\r\n", PSPadc_offset);
	printf(" PSP ADC Gain= %.2f\r\n", PSPadc_gain);
    printf(" ID    DATE      TIME       #   PIR     LW    TCASE    TDOME     SW   T-AVR   BATT\r\n");
    printf("-----------------------------------------------------------------------------------\r\n");
    delay_ms(1000);
    	
	//v16 -- add the additional loop to clear the sum variables.
	while (1) {
		ADC0_mV = ADC1_mV = ADC2_mV = ADC3_mV = ADC4_mV = ADC5_mV = ADC6_mV = ADC7_mV = 0;  
		nsamps = 0;
		
		// SETUP FOR TIMED OPERATION
		// We define the loop at the top of the hour.
		// Note t_end can be = 0
		rtc_get_time(&h,&m,&s);		
		t_end = ((int)m * 60 + (int)s) / looptime; //v16 integer number of loops in current hour.
		t_end = ((t_end+1) * looptime) % 3600;  // hour seconds to the end of current loop. No overflow.
		
		//v16 summation loop
		while (1) {
			//v16 get the time at the start of the loop.
			rtc_get_time(&h,&m,&s); 
			t_now = (int)m * 60 + (int)s;  //v16 seconds in this hour
            
    		//Check for menu call
	    	if( SerByteAvail() ) {
                ch = getchar();
                //printf("Character %c entered\r\n", ch);
                if ( ch == 'T' ) Main_Menu();
                if ( ch == 'H' ) {
                    printf(" ID    DATE      TIME       #   PIR     LW   TCASE   TDOME    SW   T-AVR   BATT\r\n");
                    printf("---------------------------------------------------------------------------------\r\n");
                }
            }	
			
			//v16 when the time exceeds the end second, close this average.
			if( t_now >= t_end) break;
			else {
				//PSP THERMOPILE
				ADC0_mV += Read_Max186(0,0); 	//PSP Sig 
				// PIR THERMOPILE
				ADC1_mV += Read_Max186(1,0); 	//PIR Sig
				// CASE TEMPERATURE
				ADC2_mV += Read_Max186(2,0);
				// DOME TEMPERATURE
				ADC3_mV += Read_Max186(3,0);
				
				//v16 we set the sample rate to 10 Hz
				delay_ms(100);
				nsamps++;
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
		
		// PIR THERMOPLE == ADC1_mV
		
		// TCASE COMPUTE -- tcase
		therm_circuit_ground(ADC2_mV, Cmax, RrefC, Vadc, Vadc, &vt, &Rt, &Pt);
		tcase = ysi46000(Rt,Pt);
		
		// TDOME COMPUTE -- tdome
		therm_circuit_ground(ADC3_mV, Cmax, RrefD, Vadc, Vadc, &vt, &Rt, &Pt);
		tdome = ysi46000(Rt,Pt);
		
		// LW COMPUTATION -- lw
		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, tcase, tdome, 4.0, &lw, &C_c, &C_d);
				
		//OUTPUT STRING // v16
		rtc_get_date(&dt, &mon, &yr);
		rtc_get_time(&h,&m,&s);
		//v13 I opened up the print statement a bit.
		//v16 Talker code = WI, So the prefix will be WIR for Weather Instrument, Radiometer
		//v16 <cr><lf> here.  Also remove \r\n at the beginning.
		printf("$WIR%02d,%02d/%02d/%02d,%02d:%02d:%02d,%4d,%6.1f,%6.2f,%6.2f,%6.2f,%7.2f,%5.1f,%5.1f\r\n", 
		   Id_address, yr, mon, dt, h, m, s, nsamps, ADC1_mV, lw, tcase, tdome, sw, AVRTemp, BattV);
/***********************		
		//Check for menu call
		if( SerByteAvail() ) {
            ch = getchar();
            //printf("Character %c entered\r\n", ch);
            if ( ch == 'T' ) Main_Menu();
            if ( ch == 'H' ) {
                printf(" ID    DATE      TIME       #   PIR     LW   TCASE   TDOME    SW   T-AVR   BATT\r\n");
                printf("---------------------------------------------------------------------------------\r\n");
            }
        }	
**************/
	}
} 

/******************** PROGRAM FUNCTIONS ***********************************/
/**************************************************************************/

void SignOn(void)
/********************************************
 PROGRAM START
********************************************/
{
	ClearScreen();
	//v16 <cr><lf>  change \n\r to \r\n throughout
	printf("\r\n\r\nSIGNON RADIOMETER INTERFACE V%s, %s\r\n", version, verdate);   //v1.14
	printf("\r\nDigital Interface Board - Rev B. Nov 2007\r\n");
	rtc_get_time(&h,&m,&s);
	
	printf("Program Start time is: %02d:%02d:%02d\r\n", h, m, s);
	rtc_get_date(&dt, &mon, &yr);
	printf("Program Start date is: %02d/%02d/%02d\r\n", yr, mon, dt);
	printf("\r\nHit 'T' for Main Menu.\r\n"); 
    printf("\r\n");
}

unsigned Main_Menu(void)
/*************************************************
*************************************************/
{ 
    char ch;
    int ltime;
    char msg[12], str[3];
    int i; 
    unsigned long t1, t2, datetime;  //v1.13            
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
			printf("\r\nTIMEOUT: Return to sampling\r\n");
			return(1);
		}
	}	
	switch (ch) 
	{
		//*** echo characters typed.  See PRP code.
        
        // MAIN MENU
        case '?':
        case '/':
    		rtc_get_date(&dt, &mon, &yr);
        	rtc_get_time(&h,&m,&s);
            printf("\r\n");
            printf("\r\n WIR%02d BOARD (REV B) VERSION: %s, VERSION DATE: %s\r\n", Id_address, version, verdate);
            printf("Current datetime: %02d%02d%02d,%02d%02d%02d\r\n",yr,mon,dt,h,m,s);
           // printf("'Z' for eeprom setup\r\n");
            printf(" -----PSP SETTINGS\r\n");
            printf("'k' -->Set PSP coefficient (%.2E v/(W/m^2))\r\n", psp);
            printf("'g' -->Set PSP amplifier gain value. (%.1f)\r\n",PSPadc_gain);
            printf("'o' -->Set PSP amplifier offset, mv. (%.1f mv)\r\n",PSPadc_offset);
            printf(" -----PIR SETTINGS\r\n");
            printf("'K' -->Set PIR coefficient (%.2E v/(W/m^2))\r\n", pir);
            printf("'G' -->Set PIR amplifier gain value. (%.1f)\r\n",PIRadc_gain);
            printf("'O' -->Set PIR amplifier offset, mv. (%.1f mv)\r\n",PIRadc_offset);
            printf("'C' -->Set Case Rref (%.1f ohms).\r\n", RrefC); 
            printf("'D' -->Set Dome Rref (%.1f ohms).\r\n", RrefD);
            printf("'V' -->Set Thermistor Reference & ADC Reference Voltage (%.1f mV).\r\n", Vtherm);
			printf(" Cmax= %d\r\n", Cmax);
            printf(" ---------DATE & TIME SETTING---------------------------\r\n"); 
            printf("'T' -->Set the date/time.\r\n");
            printf(" ---------TIMING SETTING--------------------------------\r\n");
            printf("'L' -->Set Output time in seconds. (%d)\r\n", looptime);
            printf(" -------------------------------------------------------\r\n");
            printf("'S' -->Sample 12 bit A to D.\r\n");
            printf("'A' -->Change Identifier String. (%02d)\r\n",Id_address );
            printf("'X' -->Exit this menu, return to operation.\r\n");
            printf("=========================================================\r\n");    
        break;
        
		// SET THE REAL-TIME CLOCK TIME
		case 'T':
		case 't': 
    		rtc_get_date(&dt, &mon, &yr);
        	rtc_get_time(&h,&m,&s);
		    printf("System datetime (yyMMddhhmmss) is %02d%02d%02d%02d%02d%02d\r\n", yr, mon, dt, h, m, s);
			printf("Enter new datetime exactly (yyMMddhhmmss):  ");
            // ENTER DATETIME CHECK EACH CHARACTER
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
                if ( ! isdigit(msg[i]) ) {
                    printf("datetime error, %c\r\n",msg[i]);
                    break;
                }
                else {
                    putchar(msg[i]);
                }
            }
            if (i < 12) {
                printf("datetime error2\r\n");
                break;
            }
            msg[i]='\0';
            str[2]='\0';
            printf("\r\ndatetime string = %s\r\n", msg);
            str[0]=msg[0]; str[1]=msg[1]; yr = atoi(str); // year
            str[0]=msg[2]; str[1]=msg[3]; mon = atoi(str); // month
            str[0]=msg[4]; str[1]=msg[5]; dt = atoi(str); // day
            str[0]=msg[6]; str[1]=msg[7]; h = atoi(str); // hour
            str[0]=msg[8]; str[1]=msg[9]; m = atoi(str); // min
            str[0]=msg[10]; str[1]=msg[11]; s = atoi(str); // sec
            printf("yr = %d\r\n", yr);
			if( (yr <= 7 || yr > 99) ||
			  (mon <=0 || mon > 12) ||
			  (dt <= 0 || dt > 31) ||
			  (h < 0 || h > 23) ||
			  (m < 0 || m > 59) ||
			  (s < 0 || s > 59) ) {
                 printf("datetime error\r\n");
            } else {
                printf("Set datetime: %02d%02d%02d,%02d%02d%02d\r\n",yr,mon,dt,h,m,s);
				rtc_set_time(h, m, s);
				rtc_set_date(dt, mon, yr);
            }
    		rtc_get_date(&dt, &mon, &yr);
        	rtc_get_time(&h,&m,&s);
            printf("Current datetime: %02d%02d%02d,%02d%02d%02d\r\n",yr,mon,dt,h,m,s);
            
        break;

		
		// SET AVERAGING INTERVAL IN SECS
		case 'L' :
		case 'l' : 
			printf("Change Output Interval in secs\r\n");
			printf("Current Interval is: %d secs\r\n", looptime);
			printf("Enter new output interval in secs: ");
			for (i=0; i<5; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
                    msg[i]='\0';
					break;
				}
			}
			if(atof(msg) > 3600 || atof(msg) <= 0)    //v13 increased limit to 1/2 hour //v15 increased to one hour
			{
				printf("\r\nOut of Range.\r\n");
				break;
			}
			else 
			{
				ltime = atof(msg);
				looptime = ltime;
				printf("\r\nLooptime is now set to %d seconds.\r\n", looptime); 
			}			
			break;  
		
		// PSP COEFFICIENT
		case 'k' :
			printf("Change PSP Coefficient\r\n");
			printf("Current PSP Coefficient is: %.2E\r\n", psp);
			printf("Enter New PSP Coefficient: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}
			if(atof(msg) >= 20.0E-6 || atof(msg) <= 0.1E-6)  //v15  expand range
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				psp = atof(msg);
				printf("\r\nPSP Coefficient is now set to %.2E\r\n", psp); 
			}
			break;
		
		case 'g' :
			printf("Change PSP Amplifier Gain Value\r\n");
			printf("Current PSP Amplifier Gain Value: %.2f\r\n", PSPadc_gain);
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
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				PSPadc_gain = atof(msg);
				printf("\r\nPSP Amplifier Gain is now set to %.2f\r\n", PSPadc_gain); 
			}
			break;

		case 'o' :
			printf("Change PSP Amplifier Offset Value\r\n");
			printf("Current PSP Amplifier Offset Value: %.2f\r\n", PSPadc_offset);
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
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				PSPadc_offset = atof(msg);
				printf("\r\nPSP Amplifier Offset is now set to %.2f\r\n", PSPadc_offset); 
			}
			break;

		case 'G' :
			printf("Change PIR Amplifier Gain Value\r\n");
			printf("Current PIR Amplifier Gain Value: %.2f\r\n", PIRadc_gain);
			printf("Enter New PIR Amplifier Gain Value: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atof(msg) > 1500 || atof(msg) < 500 )  //v15  expand range
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				PIRadc_gain = atof(msg);
				printf("\r\nPIR Amplifier Gain is now set to %.2f\r\n", PIRadc_gain); 
			}
			break;

		case 'O' :
			printf("Change PIR Amplifier Offset Value\r\n");
			printf("Current PIR Amplifier Offset Value: %.2f\r\n", PIRadc_offset);
			printf("Enter New PIR Amplifier Offset Value: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atof(msg) > 900 || atof(msg) < -900)  //v15  expand range
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				PIRadc_offset = atof(msg);
				printf("\r\nPIR Amplifier Offset is now set to %.2f\r\n", PIRadc_offset); 
			}
			break;

		case 'K' :
			printf("Change PIR Coefficient\r\n");
			printf("Current PIR Coefficient is: %E\r\n", pir);
			printf("Enter New PIR Coefficient: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				pir = atof(msg);
				printf("\r\nPIR Coefficient is now set to %E\r\n", pir); 
			}
			break;
		case 'C' :
			printf("Change Case Reference Resistor (R8)\r\n");
			printf("Current Case Reference Resistor is: %.1f\r\n", RrefC);
			printf("Enter New Case Reference Resistance: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}
			if( atof(msg) > 40000 || atof(msg) < 5000)
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				RrefC = atof(msg);
				printf("\r\nCase Reference Resistor is now set to %.1f\r\n", RrefC); 
			}
			break;
		case 'D' :
			printf("Change Dome Reference Resistor (R9)\r\n");
			printf("Current Dome Reference Resistor is: %.1f\r\n", RrefD);
			printf("Enter New Dome Reference Resistance: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atof(msg) > 40000 || atof(msg) < 5000)
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				RrefD = atof(msg);
				printf("\r\nDome Reference Resistor is now set to %.1f\r\n", RrefD); 
			}
			break;
		case 'V' :
			printf("Change Thermistor Reference Voltage\r\n");
			printf("Current Thermistor Reference Voltage is: %.4f\r\n", Vtherm);
			printf("Enter New Thermistor Reference Voltage: ");
			for (i=0; i<12; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atof(msg) > 6.0 || atof(msg) < 2.0)  //v15  expand range
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else 
			{
				Vtherm = atof(msg);
				Vadc = Vtherm;
				printf("\r\nThermistor Reference Voltage is now set to %.4f\r\n", Vtherm); 
			}
			break;
		case 'A' :
        case 'a':
			printf("Change Identifier Address\r\n");
			printf("Current Identifier Address: $WIR%02d\r\n", Id_address);
			printf("Enter New Identifier Address (00-99): ");
			
			for (i=0; i<2; i++)
			{
				msg[i] = getchar();
				printf("%c", msg[i]);
				if (msg[i] == '\n' || msg[i] == '\r')
				{
					msg[i]='\0';
					break;
				}
			}                        
			if(atoi(msg) > 99 || atoi(msg) < 00)
			{
				printf("\r\nOut of Range\r\n");
				break;
			}
			else
			{
				Id_address = atoi(msg);
				printf("\r\nIdentifier String now set to: $WIR%02d\r\n", Id_address); 
			}
			break;	                                         
		case 'S' :
        case 's':
			SampleADC();
			break;

		case 'X' :
		case 'x' :
            printf("RETURN TO SAMPLE\r\n");
            printf(" ID    DATE      TIME       #   PIR     LW   TCASE   TDOME    SW   T-AVR   BATT\r\n");
            printf("---------------------------------------------------------------------------------\r\n");
    		return(1);  //v13 RETURN FROM THIS S/R 
		break;
        
		//v13 INVALID KEY ENTRY -- RE-CALL MENU
		default : printf("Invalid key\r\n");
			//v13 printf("\r\n Returning to operation...\r\n\r\n");
		break;
        
	} // end switch
	
	//v13 -- recall s/r
	Main_Menu();
	//printf("Returning to operation...\r\n\r\n");
	//return;
}	//end menu



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
	    //printf("Character found!\r\n");
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
		printf("\r\n");  // v16 <cr><lf>
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
			
	//printf("Data Out= %d\r\n", data_out);   
	
	
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
	//printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\r\n", v2, v1, it, r2, dum);
	
	term1 = COEFFA + (COEFFB * dum);
	term2 = COEFFC * (dum*dum);
	term3 = COEFFD * ((dum*dum)*dum);
   	Temp = term1 + term2 + term3;
	//printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\r\n", term1, term2, term3, Temp);
	//Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	//	printf("Temp= %f\r\n", Temp);

return Temp;
} 

void SampleADC(void)
/********************************************************
Test the ADC circuit
**********************************************************/
{
	float ddum[8], ddumsq[8];
	int i, npts;          
	int missing;
	
	missing = -999;

	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	npts=0;
	printf("\r\n");
	while( !SerByteAvail() )
	{
		ReadAnalog(ALL);
		printf("%7d %7d %7d %7d %7d %7d %7d %7d\r\n",
		adc[0],adc[1],adc[2],adc[3],
		adc[4],adc[5],adc[6],adc[7]);
		for(i=0; i<8; i++)
		{
			ddum[i] += (float)adc[i];
			ddumsq[i] += (float)adc[i] * (float)adc[i];
		}
		npts++;
		delay_ms(1000);
		
		Heartbeat();
	}
	printf("\r\n");
	for(i=0; i<8; i++)
		MeanStdev((ddum+i), (ddumsq+i), npts, missing);

	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n",
		ddum[0],ddum[1],ddum[2],ddum[3],
		ddum[4],ddum[5],ddum[6],ddum[7]);
	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n\r\n",
		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
		
		Heartbeat();
	return;
}

void	MeanStdev(float *sum, float *sum2, int N, float missing)
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
		*sum /= (float)N;		// mean value
		*sum2 = *sum2/(float)N - (*sum * *sum); // sumsq/N - mean^2
		*sum2 = *sum2 * (float)N / (float)(N-1); // (N/N-1) correction
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
		}
	}
	else if( chan >= 0 && chan <=7 )
	{
		adc[chan] = Read_Max186(chan, 0);
	}
    return;
} 


//************* THERMISTOR ****************************
float ysi46041(float r, float *c)
/************************************************************
	Description: Best fit of Steinhart Hart equation to YSI
	tabulated data from -10C to 60C for H mix 10k thermistors.
	Given the thermistor temperature in Kelvin.

	The lack of precision in the YSI data is evident around
	9999/10000 Ohm transition.  Scatter approaches 10mK before,
	much less after.  Probably some systemmatics at the 5mK level
	as a result.  Another decimal place in the impedances would 
	have come in very handy.  The YSI-derived coefficients read
	10mK cold or some through the same interval.

	Mandatory parameters:
	R - Thermistor resistance(s) in Ohms
	C - Coefficients of fit from isarconf.icf file specific
	to each thermistor.
************************************************************/
{ 
float t1, LnR;
	if(r>0)
	{
		LnR = log(r);
		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
	}
	else t1 = 0;
	
	return t1;
}

float ysi46041CountToRes(float c)
/**************************************************************
	Description: Converts raw counts to resistance for the 
	YSI46041 10K thermistors.
**************************************************************/
{
	float  r=0;
		
		r = 10000.0 * c / (5.0 - c);
		
		return r;
}
float ysi46000(float Rt, float Pt)
/*************************************************************/
// Uses the Steinhart-Hart equations to compute the temperature 
// in degC from thermistor resistance.  S-S coeficients are 
// either computed from calibrations or tests, or are provided by 
// the manufacturer.  Reynolds has Matlab routines for computing 
// the S-S coefficients.
//                                                               
//	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
//	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
//  Tc = Tk - 273.15;
//
// correction for self heating.
// For no correction set P_t = 0;
// deltaT = p(watts) / .004 (W/degC)
//
//rmr 050128
/*************************************************************/
{
	float x;
	float C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
	// ysi46041, matlab steinharthart_fit(), 0--40 degC
	x = SteinhartHart(C, Rt);
	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
	//printf("ysi46000: Cal temp = %.5f\r\n",x);
	
	x = x - Pt/.004; // return temperature in degC
	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
	return x;

} 
void therm_circuit_ground(float c, float C_max, float R_ref, float V_therm, float V_adc,
	float *v_t, float *R_t, float *P_t)
/*************************************************************/
//Compute the thermistor resistance for a resistor divider circuit 
//with reference voltage (V_therm), reference resistor (R_ref), 
//thermistor is connected to GROUND.  The ADC compares a reference 
//voltage (V_adc) with the thermistor voltage (v_t) and gives an adc 
//count (c).  The ADC here is unipolar and referenced to ground.
//The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
//Input:
//  c = ADC count.
//  C_max = maximum count, typically 4096.
//  R_ref = reference resistor (ohms)
//  V_therm = thermistor circuit reference voltage 
//  V_adc = ADC reference voltage.
//Output:
//  v_t = thermistor voltage (volts)
//  R_t = thermistor resistance (ohms)
//  P_t = power dissipated by the thermistor (watts)
//	(for self heating correction)
//example
//	float cx, Cmax, Rref, Vtherm, Vadc;
//	float vt, Rt, Pt;
//	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
//	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
// vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
/*************************************************************/
{
	float x;
	
	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
	
	*v_t = V_adc * (c/2) / C_max;
	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	*R_t = *v_t / x;  // v/I
	*P_t = x * x * *R_t;  // I^2 R = power
	
	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);

	return;
}


//******** PSP ******************************
float PSPSW(float vp, float kp, float PSPadc_offset, float PSPadc_gain, float *sw)
/**********************************************************
%input
%  vp = thermopile voltage
%  kp = thermopile calibration factor in volts/ W m^-2.
%  gainPSP[2] is the offset and gain for the preamp circuit
%     The thermopile net radiance is given by vp/kp, but
%     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
%     where vp' is the actual voltage on the thermopile.
%	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
%  e = thermopile computed flux in W/m^2 
%    
%  no arguments ==> test mode
%  sw = corrected shortwave flux, W/m^2
%  
%000928 changes eps to 0.98 per {fairall98}
%010323 back to 1.0 per Fairall
% v14 080603 rmr -- 
/**********************************************************/
{

	float e; // w/m^2 on the thermopile
	  
	//diagnostic printout
	//printf("vp= %.2f, kp= %.2e, Offset= %.2f, Gain= %.2f\n\r", vp, kp, PSPadc_offset, PSPadc_gain);
	
	// THERMOPILE IRRADIANCE
	e = ( ( ( ( vp - PSPadc_offset) / PSPadc_gain ) / 1000 ) / kp );
	
	//diagnostic printout
	//printf("PSP: e = %.4e\r\n", e);
	
	*sw = e;
	
	return e;
}


//****** PIR ***************************************
void PirTcTd2LW(float vp, float kp, float PIRadc_offset, float PIRadc_gain, float tc, float td, float k, 
	float *lw, float *C_c, float *C_d)
/**********************************************************
%input  // v15 -- enhanced comments
%  vp = output in counts of thew ADC circuit.  In ADC counts.
%  kp = thermopile calibration factor in volts/ W m^-2.
%  PIRadc_offset = the constant (B) in a straight line fit of 
%     vp = M * v_pir + B
%  PIRadc_gain = M, the gain term.
%     The thermopile net radiance is given by (v_pir / kp), but
%     if a preamp is used, then the measured voltage vp = B + M * vp'
%     where vp' is the actual voltage on the thermopile.
%	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
%  e = thermopile computed flux in W/m^2 
%  tc = case degC 
%  td = dome degC 
%  k = calib coef, usually = 4.
%  no arguments ==> test mode
%output
%  lw = corrected longwave flux, W/m^2
%  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
%000928 changes eps to 0.98 per {fairall98}
%010323 back to 1.0 per Fairall
% v15 -- tweak the code for the RAD operation
/**********************************************************/
{
	float Tc,Td;
	float sigma=5.67e-8;
	float eps = 1;
	float x,y;
	float e; // w/m^2 on the thermopile
	
	// THERMOPILE IRRADIANCE
	e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
	//printf("PirTcTd2LW: e = %.4e\r\n", e);
	
	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
	Tc = tc + Tabs;
	Td = td + Tabs;
	x = Tc * Tc * Tc * Tc; // Tc^4
	y = Td * Td * Td * Td; // Td^4
	
	// Corrections
	*C_c = eps * sigma * x;
	*C_d =  - k * sigma * (y - x);
	
	// Final computation
	*lw = e + *C_c + *C_d;
	
	return;
}
float SteinhartHart(float C[], float R) 
/*************************************************************/
// Uses the Steinhart-Hart equations to compute the temperature 
// in degC from thermistor resistance.  
// See http://www.betatherm.com/stein.htm
//The Steinhart-Hart thermistor equation is named for two oceanographers 
//associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
//The first publication of the equation was by I.S. Steinhart & S.R. Hart 
//in "Deep Sea Research" vol. 15 p. 497 (1968).
//S-S coeficients are
// either computed from calibrations or tests, or are provided by 
// the manufacturer.  Reynolds has Matlab routines for computing 
// the S-S coefficients.
//
//	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
//	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
//  Tc = Tk - 273.15;
//example
// C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
// ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
// ysi46041, matlab steinharthart_fit()
// R = 25000;     Tc = 25.00C
// rmr 050128
/*************************************************************/
{
	float x;
//	float Tabs = 273.15;  // defined elsewhere

	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
	
	x = log(R);
	x = C[0] + x * ( C[1] + C[2] * x * x );
	x = 1/x - Tabs;
	
	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
	return x;
}


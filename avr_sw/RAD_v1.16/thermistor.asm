
;CodeVisionAVR C Compiler V1.25.1 Standard
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 3.686400 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : long, width, precision
;(s)scanf features      : long, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "thermistor.vec"
	.INCLUDE "thermistor.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x1000)
	LDI  R25,HIGH(0x1000)
	LDI  R26,LOW(0x100)
	LDI  R27,HIGH(0x100)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

	OUT  RAMPZ,R24

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x10FF)
	OUT  SPL,R30
	LDI  R30,HIGH(0x10FF)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x500)
	LDI  R29,HIGH(0x500)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500
;       1 //v13 This is the beginning of config control for the RAD converter.
;       2 
;       3 #include <math.h> 
;       4 #include <pir.h>
;       5 
;       6 double ysi46041(double r, double *c)
;       7 /************************************************************
;       8 	Description: Best fit of Steinhart Hart equation to YSI
;       9 	tabulated data from -10C to 60C for H mix 10k thermistors.
;      10 	Given the thermistor temperature in Kelvin.
;      11 
;      12 	The lack of precision in the YSI data is evident around
;      13 	9999/10000 Ohm transition.  Scatter approaches 10mK before,
;      14 	much less after.  Probably some systemmatics at the 5mK level
;      15 	as a result.  Another decimal place in the impedances would 
;      16 	have come in very handy.  The YSI-derived coefficients read
;      17 	10mK cold or some through the same interval.
;      18 
;      19 	Mandatory parameters:
;      20 	R - Thermistor resistance(s) in Ohms
;      21 	C - Coefficients of fit from isarconf.icf file specific
;      22 	to each thermistor.
;      23 ************************************************************/
;      24 { 

	.CSEG
;      25 double t1, LnR;
;      26 	if(r>0)
;	r -> Y+10
;	*c -> Y+8
;	t1 -> Y+4
;	LnR -> Y+0
;      27 	{
;      28 		LnR = log(r);
;      29 		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
;      30 	}
;      31 	else t1 = 0;
;      32 	
;      33 	return t1;
;      34 }
;      35 
;      36 double ysi46041CountToRes(double c)
;      37 /**************************************************************
;      38 	Description: Converts raw counts to resistance for the 
;      39 	YSI46041 10K thermistors.
;      40 **************************************************************/
;      41 {
;      42 	double  r=0;
;      43 		
;      44 		r = 10000.0 * c / (5.0 - c);
;	c -> Y+4
;	r -> Y+0
;      45 		
;      46 		return r;
;      47 }
;      48 double ysi46000(double Rt, double Pt)
;      49 /*************************************************************/
;      50 // Uses the Steinhart-Hart equations to compute the temperature 
;      51 // in degC from thermistor resistance.  S-S coeficients are 
;      52 // either computed from calibrations or tests, or are provided by 
;      53 // the manufacturer.  Reynolds has Matlab routines for computing 
;      54 // the S-S coefficients.
;      55 //                                                               
;      56 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;      57 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;      58 //  Tc = Tk - 273.15;
;      59 //
;      60 // correction for self heating.
;      61 // For no correction set P_t = 0;
;      62 // deltaT = p(watts) / .004 (W/degC)
;      63 //
;      64 //rmr 050128
;      65 /*************************************************************/
;      66 {
_ysi46000:
;      67 	double x;
;      68 	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
;      69 	// ysi46041, matlab steinharthart_fit(), 0--40 degC
;      70 	x = SteinhartHart(C, Rt);
	SBIW R28,16
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x6*2)
	LDI  R31,HIGH(_0x6*2)
	CALL __INITLOCB
;	Rt -> Y+20
;	Pt -> Y+16
;	x -> Y+12
;	C -> Y+0
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 22
	CALL __PUTPARD1
	CALL _SteinhartHart
	CALL SUBOPT_0x0
;      71 	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
;      72 	//printf("ysi46000: Cal temp = %.5f\r\n",x);
;      73 	
;      74 	x = x - Pt/.004; // return temperature in degC
	__GETD2S 16
	__GETD1N 0x3B83126F
	CALL __DIVF21
	CALL SUBOPT_0x1
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
;      75 	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
;      76 	return x;
	ADIW R28,24
	RET
;      77 
;      78 } 
;      79 void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
;      80 	double *v_t, double *R_t, double *P_t)
;      81 /*************************************************************/
;      82 //Compute the thermistor resistance for a resistor divider circuit 
;      83 //with reference voltage (V_therm), reference resistor (R_ref), 
;      84 //thermistor is connected to GROUND.  The ADC compares a reference 
;      85 //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc 
;      86 //count (c).  The ADC here is unipolar and referenced to ground.
;      87 //The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
;      88 //Input:
;      89 //  c = ADC count.
;      90 //  C_max = maximum count, typically 4096.
;      91 //  R_ref = reference resistor (ohms)
;      92 //  V_therm = thermistor circuit reference voltage 
;      93 //  V_adc = ADC reference voltage.
;      94 //Output:
;      95 //  v_t = thermistor voltage (volts)
;      96 //  R_t = thermistor resistance (ohms)
;      97 //  P_t = power dissipated by the thermistor (watts)
;      98 //	(for self heating correction)
;      99 //example
;     100 //	double cx, Cmax, Rref, Vtherm, Vadc;
;     101 //	double vt, Rt, Pt;
;     102 //	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
;     103 //	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
;     104 // vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
;     105 /*************************************************************/
;     106 {
_therm_circuit_ground:
;     107 	double x;
;     108 	
;     109 	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
;     110 	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
;     111 	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
;     112 	
;     113 	*v_t = V_adc * (c/2) / C_max;
	SBIW R28,4
;	c -> Y+26
;	C_max -> Y+22
;	R_ref -> Y+18
;	V_therm -> Y+14
;	V_adc -> Y+10
;	*v_t -> Y+8
;	*R_t -> Y+6
;	*P_t -> Y+4
;	x -> Y+0
	__GETD2S 26
	__GETD1N 0x40000000
	CALL __DIVF21
	__GETD2S 10
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 22
	CALL __DIVF21
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __PUTDP1
;     114 	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	CALL SUBOPT_0x4
	__GETD2S 14
	CALL SUBOPT_0x2
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 18
	CALL SUBOPT_0x5
;     115 	*R_t = *v_t / x;  // v/I
	CALL SUBOPT_0x4
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
;     116 	*P_t = x * x * *R_t;  // I^2 R = power
	CALL SUBOPT_0x6
	CALL SUBOPT_0x8
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x9
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __PUTDP1
;     117 	
;     118 	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
;     119 
;     120 	return;
	ADIW R28,30
	RET
;     121 }
;     122 
;     123 
;     124 
;     125 #include "PSP.h"
;     126 
;     127 /*******************************************************************************************/
;     128 
;     129 float PSPSW(double vp, double kp, double PSPadc_offset, double PSPadc_gain, double *sw)
;     130 /**********************************************************
;     131 %input
;     132 %  vp = thermopile voltage
;     133 %  kp = thermopile calibration factor in volts/ W m^-2.
;     134 %  gainPSP[2] is the offset and gain for the preamp circuit
;     135 %     The thermopile net radiance is given by vp/kp, but
;     136 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;     137 %     where vp' is the actual voltage on the thermopile.
;     138 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;     139 %  e = thermopile computed flux in W/m^2 
;     140 %    
;     141 %  no arguments ==> test mode
;     142 %  sw = corrected shortwave flux, W/m^2
;     143 %  
;     144 %000928 changes eps to 0.98 per {fairall98}
;     145 %010323 back to 1.0 per Fairall
;     146 % v14 080603 rmr -- 
;     147 /**********************************************************/
;     148 {
_PSPSW:
;     149 
;     150 	double e; // w/m^2 on the thermopile 
;     151 	
;     152 	// THERMOPILE IRRADIANCE
;     153 	e = ( (((vp - PSPadc_offset) / PSPadc_gain) /1000) / kp );
	SBIW R28,4
;	vp -> Y+18
;	kp -> Y+14
;	PSPadc_offset -> Y+10
;	PSPadc_gain -> Y+6
;	*sw -> Y+4
;	e -> Y+0
	__GETD2S 10
	__GETD1S 18
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 14
	CALL SUBOPT_0x5
;     154 	//printf("PSP: e = %.4e\r\n", e);
;     155 	
;     156 	*sw = e;
	CALL SUBOPT_0x6
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __PUTDP1
;     157 	
;     158 	return e;
	CALL SUBOPT_0x6
	ADIW R28,22
	RET
;     159 }
;     160 //*** reynolds comments lines
;     161 // v13 :: search on 'v13' to see changes and coments.
;     162 // v15 :: rmr edits to RE version 14.  See "v15" or "//v15" for chgs.
;     163 // v16 080812 :: rmr edits.  Sent to re for compile and install.
;     164 //	1. Rewrite main section with double while loops.
;     165 //	2. Change \n\r to \r\n == <cr><lf>
;     166 /*********************************************
;     167 This program was produced by the
;     168 CodeWizardAVR V1.23.8c Standard
;     169 Automatic Program Generator
;     170 © Copyright 1998-2003 HP InfoTech s.r.l.
;     171 http://www.hpinfotech.ro
;     172 e-mail:office@hpinfotech.ro
;     173 
;     174 Project : NOAA Radiometer Interface Board
;     175 Version : 
;     176 Date    : 12/20/2004
;     177 Author  : Ray Edwards                     
;     178 Company : Brookhaven National Laboratory  
;     179 Comments: Revision History
;     180 	1.0 - Start with simple timed operation 12/22/04 
;     181     1.1 - Build user menu and implement eeprom variables 03/24/05
;     182     1.13 - Bigelow mods.  see "v13" comments
;     183       * spread out the print statement a bit.
;     184       * timeout in Main_Menu
;     185       
;     186 //*** search on these comments     
;     187 /********************************************
;     188 Chip type           : ATmega64
;     189 Program type        : Application
;     190 Clock frequency     : 8.000000 MHz
;     191 Memory model        : Small
;     192 External SRAM size  : 0
;     193 Data Stack size     : 1024
;     194 *********************************************/
;     195 //*** REVISION B NOV 2007    
;     196 /********************************************
;     197 Chip type           : ATmega128
;     198 Program type        : Application
;     199 Clock frequency     : 16.000000 MHz
;     200 Memory model        : Small
;     201 External SRAM size  : 0
;     202 Data Stack size     : 1024
;     203 *********************************************/
;     204 #include <delay.h>
;     205 #include <stdio.h>
;     206 #include <stdlib.h> 
;     207 #include <spi.h> 
;     208 #include <math.h>
;     209 #include "thermistor.h"
;     210 #include "pir.h"
;     211 #include "psp.h"
;     212 #include <mega128.h>
;     213 #include <eeprom.h>
;     214 #include <ds1302.h>
;     215 
;     216 // DS1302 Real Time Clock port init
;     217 #asm
;     218    .equ __ds1302_port=0x18
   .equ __ds1302_port=0x18
;     219    .equ __ds1302_io=4
   .equ __ds1302_io=4
;     220    .equ __ds1302_sclk=5
   .equ __ds1302_sclk=5
;     221    .equ __ds1302_rst=6
   .equ __ds1302_rst=6
;     222 #endasm
;     223 
;     224 #define RXB8 	1
;     225 #define TXB8 	0
;     226 #define UPE 	2
;     227 #define OVR 	3
;     228 #define FE 	    4
;     229 #define UDRE 	5
;     230 #define RXC 	7
;     231 #define BATT	7
;     232 #define PCTEMP	6
;     233 #define VREF	5  
;     234 #define ALL	    8       
;     235 #define NSAMPS	100
;     236 #define NCHANS	8
;     237 
;     238 // watchdog WDTCR register bit positions and mask
;     239 #define WDCE   (4)  // Watchdog Turn-off Enable
;     240 #define WDE     (3)  // Watchdog Enable
;     241 #define PMASK   (7)  // prescaler mask    
;     242 #define WATCHDOG_PRESCALE (7)    
;     243 //#define XTAL	16000000
;     244 #define XTAL 3686400
;     245 #define BAUD	19200  //default terminal setting
;     246 #define OK	1
;     247 #define NOTOK	0 
;     248 #define FRAMING_ERROR (1<<FE)
;     249 #define PARITY_ERROR (1<<UPE)
;     250 #define DATA_OVERRUN (1<<OVR)
;     251 #define DATA_REGISTER_EMPTY (1<<UDRE)
;     252 #define RX_COMPLETE (1<<RXC)
;     253 #define MENU_TIMEOUT 30
;     254 //v15 v16
;     255 #define VERSION "1.16"
;     256 #define VERDATE "2008/08/13"
;     257 
;     258 // Get a character from the USART1 Receiver
;     259 #pragma used+
;     260 char getchar1(void)
;     261 {
;     262 char status,data;
;     263 while (1)
;	status -> R16
;	data -> R17
;     264       {
;     265       while (((status=UCSR1A) & RX_COMPLETE)==0);
;     266       data=UDR1;
;     267       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;     268          return data;
;     269       };
;     270 }
;     271 #pragma used-
;     272 
;     273 // Write a character to the USART1 Transmitter
;     274 #pragma used+
;     275 void putchar1(char c)
;     276 {
;     277 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
;     278 UDR1=c;
;     279 }
;     280 #pragma used-
;     281 
;     282 //PROTOTYPES
;     283 void ATMega128_Setup(void);
;     284 void SignOn(void);
;     285 float ReadBattVolt(void);
;     286 float ReadRefVolt(void); 
;     287 float ReadAVRTemp();
;     288 void Heartbeat(void);
;     289 int SerByteAvail(void);  
;     290 int ClearScreen(void);
;     291 int Read_Max186(int, int); 
;     292 float RL10052Temp (unsigned int v2, int ref, int res);
;     293 void Main_Menu(void);
;     294 void ReadAnalog( int chan );
;     295 void MeanStdev(double *sum, double *sum2, int N, double missing);
;     296 void SampleADC(void);
;     297 
;     298 //GLOBAL VARIABLES
;     299 //COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
;     300 float COEFFA = 	.0033540172; 

	.DSEG
_COEFFA:
	.BYTE 0x4
;     301 float COEFFB = 	.00032927261; 
_COEFFB:
	.BYTE 0x4
;     302 float COEFFC =	.0000041188325;
_COEFFC:
	.BYTE 0x4
;     303 float COEFFD = -.00000016472972;
_COEFFD:
	.BYTE 0x4
;     304 
;     305 unsigned char h, m, s, now, then;
;     306 unsigned char dt, mon, yr;
;     307 int state;
;     308 unsigned char version[10] = "1.16";  //v15  v16
_version:
	.BYTE 0xA
;     309 unsigned char verdate[20] = "2008/08/13";  //v15 v16
_verdate:
	.BYTE 0x14
;     310 double Tabs = 273.15;
_Tabs:
	.BYTE 0x4
;     311 int adc[NCHANS];   
_adc:
	.BYTE 0x10
;     312 
;     313 //SETUP EEPROM VARIABLES AND INITIALIZE
;     314 eeprom float psp = 7.72E-6;			//PSP COEFF

	.ESEG
_psp:
	.DW  0x8526
	.DW  0x3701
;     315 eeprom float pir = 3.68E-6;			//PIR COEFF
_pir:
	.DW  0xF5EB
	.DW  0x3676
;     316 eeprom int looptime = 10;			//NMEA OUTPUT SCHEDULE
_looptime:
	.DW  0xA
;     317 eeprom int Cmax = 2048;				//A/D COUNTS MAX VALUE
_Cmax:
	.DW  0x800
;     318 eeprom float RrefC = 33042.0; 		//CASE REFERENCE RESISTOR VALUE
_RrefC:
	.DW  0x1200
	.DW  0x4701
;     319 eeprom float RrefD = 33046.0;     	//DOME REFERENCE RESISTOR VALUE
_RrefD:
	.DW  0x1600
	.DW  0x4701
;     320 eeprom float Vtherm = 4.0963;		//THERMISTOR SUPPLY VOLTAGE
_Vtherm:
	.DW  0x14E4
	.DW  0x4083
;     321 eeprom float Vadc = 4.0960;			//A/D REFERENCE VOLTAGE 
_Vadc:
	.DW  0x126F
	.DW  0x4083
;     322 // v15 -- note this offset is in mv as it is subtracted from the 
;     323 // from the ADC count.  Same for PSPadc_offset
;     324 eeprom float PIRadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PIRadc_offset:
	.DW  0x0
	.DW  0x0
;     325 eeprom float PIRadc_gain = 815.0;
_PIRadc_gain:
	.DW  0xC000
	.DW  0x444B
;     326 eeprom float PSPadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PSPadc_offset:
	.DW  0x0
	.DW  0x0
;     327 eeprom float PSPadc_gain = 125.0;
_PSPadc_gain:
	.DW  0x0
	.DW  0x42FA
;     328 eeprom int   Id_address = 00;		//$RAD** address $RAD00 is default
_Id_address:
	.DW  0x0
;     329 
;     330 
;     331 /******************************************************************************************
;     332 MAIN
;     333 ******************************************************************************************/
;     334 void main(void)
;     335 {

	.CSEG
_main:
;     336 
;     337 	double ADC0_mV, ADC1_mV, ADC2_mV, ADC3_mV, ADC4_mV, ADC5_mV, ADC6_mV, ADC7_mV;  //v16
;     338 	int nsamps;             
;     339 	double BattV, AVRTemp, RefV;
;     340 	double vt, Rt, Pt;
;     341 	double tcase, tdome;
;     342 	double sw, lw, C_c, C_d;
;     343  	
;     344 	state = 0;
	SBIW R28,63
	SBIW R28,17
;	ADC0_mV -> Y+76
;	ADC1_mV -> Y+72
;	ADC2_mV -> Y+68
;	ADC3_mV -> Y+64
;	ADC4_mV -> Y+60
;	ADC5_mV -> Y+56
;	ADC6_mV -> Y+52
;	ADC7_mV -> Y+48
;	nsamps -> R16,R17
;	BattV -> Y+44
;	AVRTemp -> Y+40
;	RefV -> Y+36
;	vt -> Y+32
;	Rt -> Y+28
;	Pt -> Y+24
;	tcase -> Y+20
;	tdome -> Y+16
;	sw -> Y+12
;	lw -> Y+8
;	C_c -> Y+4
;	C_d -> Y+0
	CLR  R12
	CLR  R13
;     345 	Cmax = 2048;
	LDI  R30,LOW(2048)
	LDI  R31,HIGH(2048)
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMWRW
;     346 	
;     347     ATMega128_Setup();
	RCALL _ATMega128_Setup
;     348     SignOn();
	RCALL _SignOn
;     349     Heartbeat();
	RCALL _Heartbeat
;     350     
;     351 	printf("\r\n***** SMART DIGITAL INTERFACE *****\r\n");
	CALL SUBOPT_0xD
;     352 	printf(" Software Version %s, %s\r\n", version, verdate);
;     353 	printf(" Current EEPROM values:\r\n");
;     354 	printf(" Identifier Header= $RAD%02d\r\n", Id_address);
;     355 	printf(" PSP Coeff= %.2E\r\n", psp);
;     356 	printf(" PIR Coeff= %.2E\r\n", pir);
	CALL SUBOPT_0xE
;     357 	printf(" Interval Time (secs)= %d\r\n", looptime);
	CALL SUBOPT_0xF
;     358 	printf(" Cmax= %d\r\n", Cmax);
	CALL SUBOPT_0x10
;     359 	printf(" Reference Resistor Case= %.1f\r\n", RrefC);
	CALL SUBOPT_0x11
;     360 	printf(" Reference Resistor Dome= %.1f\r\n", RrefD);
	CALL SUBOPT_0x12
;     361 	printf(" Vtherm= %.4f, Vadc= %.4f\r\n", Vtherm, Vadc);
	CALL SUBOPT_0x13
;     362 	printf(" PIR ADC Offset= %.2f mv\r\n", PIRadc_offset);
	__POINTW1FN _0,312
	CALL SUBOPT_0x14
;     363 	printf(" PIR ADC Gain= %.2f\r\n", PIRadc_gain);
	CALL SUBOPT_0x15
;     364 	printf(" PSP ADC Offset= %.2f mv\r\n", PSPadc_offset);
	__POINTW1FN _0,361
	CALL SUBOPT_0x16
;     365 	printf(" PSP ADC Gain= %.2f\r\n", PSPadc_gain);
	CALL SUBOPT_0x17
;     366 	putchar('\r'); // CR
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
;     367 	putchar('\n'); // LF
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
;     368 	//*** check, do we want <cr><lf> or <lf><cr> ??
;     369 	// v15, the end of an output line will be <cr><lf>
;     370 	//v16 this was skipped in prev version
;     371 	
;     372 	//Heartbeat();
;     373 	//*** why no heartbeat? 
;     374     
;     375 	
;     376 	//v16 -- add the additional loop to clear the sum variables.
;     377 	while (1) {
_0x16:
;     378 		ADC0_mV = ADC1_mV = ADC2_mV = ADC3_mV = ADC4_mV = ADC5_mV = ADC6_mV = ADC7_mV = 0;  
	CALL SUBOPT_0x18
	__PUTD1S 48
	__PUTD1S 52
	__PUTD1S 56
	__PUTD1S 60
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
;     379 		nsamps = 0;
	__GETWRN 16,17,0
;     380 		
;     381 	    // SETUP FOR TIMED OPERATION
;     382     	rtc_get_time(&h,&m,&then);
	CALL SUBOPT_0x1D
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x1E
;     383 
;     384 		//v16 summation loop
;     385 		while (1) {
_0x19:
;     386 			//PSP THERMOPILE
;     387 			ADC0_mV += Read_Max186(0,0); 	//PSP Sig 
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1F
	RCALL _Read_Max186
	CALL SUBOPT_0x20
	CALL __ADDF12
	CALL SUBOPT_0x1C
;     388 			// PIR THERMOPILE
;     389 			ADC1_mV += Read_Max186(1,0); 	//PIR Sig
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	RCALL _Read_Max186
	CALL SUBOPT_0x22
	CALL __ADDF12
	CALL SUBOPT_0x1B
;     390 			// CASE TEMPERATURE
;     391 			ADC2_mV += Read_Max186(2,0);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x23
	RCALL _Read_Max186
	CALL SUBOPT_0x24
	CALL __ADDF12
	CALL SUBOPT_0x1A
;     392 			// DOME TEMPERATURE
;     393 			ADC3_mV += Read_Max186(3,0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x23
	RCALL _Read_Max186
	CALL SUBOPT_0x25
	CALL __ADDF12
	CALL SUBOPT_0x19
;     394 
;     395 			rtc_get_time(&h,&m,&s); 
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x26
;     396 			if( abs((int)s - (int)then) >= looptime ) break;
	MOV  R26,R6
	CLR  R27
	MOV  R30,R8
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	ST   -Y,R27
	ST   -Y,R26
	CALL _abs
	MOVW R0,R30
	CALL SUBOPT_0x27
	CP   R0,R30
	CPC  R1,R31
	BRSH _0x1B
;     397 			else {
;     398 				then = s;
	MOV  R8,R6
;     399 				nsamps ++;
	__ADDWRN 16,17,1
;     400 			}
;     401 		}  
	RJMP _0x19
_0x1B:
;     402 		Heartbeat();
	RCALL _Heartbeat
;     403 		
;     404 		ADC0_mV /= nsamps;
	MOVW R30,R16
	CALL SUBOPT_0x20
	CALL __DIVF21
	CALL SUBOPT_0x1C
;     405 		ADC1_mV /= nsamps;
	MOVW R30,R16
	CALL SUBOPT_0x22
	CALL __DIVF21
	CALL SUBOPT_0x1B
;     406 		ADC2_mV /= nsamps;
	MOVW R30,R16
	CALL SUBOPT_0x24
	CALL __DIVF21
	CALL SUBOPT_0x1A
;     407 		ADC3_mV /= nsamps;
	MOVW R30,R16
	CALL SUBOPT_0x25
	CALL __DIVF21
	CALL SUBOPT_0x19
;     408 		
;     409 		// TEMPS, VOLTAGES
;     410 		BattV = ReadBattVolt();  
	RCALL _ReadBattVolt
	__PUTD1S 44
;     411 		RefV = ReadRefVolt();
	RCALL _ReadRefVolt
	__PUTD1S 36
;     412 		AVRTemp = ReadAVRTemp();
	RCALL _ReadAVRTemp
	__PUTD1S 40
;     413 		
;     414 		// PSP COMPUTE -- sw
;     415 		PSPSW( ADC0_mV, psp, PSPadc_offset, PSPadc_gain, &sw);
	MOVW R26,R28
	SUBI R26,LOW(-(76))
	SBCI R27,HIGH(-(76))
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	MOVW R30,R28
	ADIW R30,28
	ST   -Y,R31
	ST   -Y,R30
	CALL _PSPSW
;     416 		
;     417 		// PIR THERMOPLE == ADC1_mV
;     418 		
;     419 		// TCASE COMPUTE -- tcase
;     420 		therm_circuit_ground(ADC2_mV, Cmax, RrefC, Vadc, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(68))
	SBCI R27,HIGH(-(68))
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
;     421 		tcase = ysi46000(Rt,Pt);
	CALL SUBOPT_0x30
;     422 
;     423 		// TDOME COMPUTE -- tdome
;     424 		therm_circuit_ground(ADC3_mV, Cmax, RrefD, Vadc, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(64))
	SBCI R27,HIGH(-(64))
	CALL SUBOPT_0x28
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
;     425 		tdome = ysi46000(Rt,Pt);
	CALL SUBOPT_0x32
;     426 		
;     427 		// LW COMPUTATION -- lw
;     428 		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, tcase, tdome, 4.0, &lw, &C_c, &C_d);
	MOVW R26,R28
	SUBI R26,LOW(-(72))
	SBCI R27,HIGH(-(72))
	CALL SUBOPT_0x28
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	CALL SUBOPT_0x36
	__GETD1N 0x40800000
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,34
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,32
	ST   -Y,R31
	ST   -Y,R30
	CALL _PirTcTd2LW
;     429 				
;     430 		//Diagnostic Printout
;     431 		//printf("ADC0_mV= %f, \r\n",
;     432 		//	ADC1_mV, ADC2_mV, ADC3_mV, ADC0_mV);
;     433 		//printf("then= %d, now= %d\r\n", then, now);
;     434 			
;     435 		//OUTPUT STRING // v16
;     436 		rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x37
;     437 		rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x26
;     438 		// if(h > 12) h = h - 12;  //12 hour clock
;     439 		//v13 I opened up the print statement a bit.
;     440 		//v16 Talker code = WI, So the prefix will be WIR for Weather Instrument, Radiometer
;     441 		//v16 <cr><lf> here.  Also remove \r\n at the beginning.
;     442 		printf("$WIR%02d,%02d/%02d/%02d,%02d:%02d:%02d,%4d,%6.1f,%6.2f,%6.2f,%6.2f,%7.2f,%5.1f,%5.1f\r\n", 
;     443 		   Id_address, yr, mon, dt, h, m, s, nsamps, ADC1_mV, lw, tcase, tdome, sw, AVRTemp, BattV);
	__POINTW1FN _0,410
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	MOVW R30,R16
	CALL SUBOPT_0x3B
	__GETD1SX 106
	CALL __PUTPARD1
	__GETD1S 46
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3C
	CALL __PUTPARD1
	__GETD1SX 94
	CALL __PUTPARD1
	__GETD1SX 102
	CALL __PUTPARD1
	LDI  R24,60
	CALL _printf
	ADIW R28,62
;     444 
;     445 		//Check for menu call
;     446 		if( SerByteAvail() && getchar() == 'T' ) Main_Menu();	
	RCALL _SerByteAvail
	SBIW R30,0
	BREQ _0x1F
	CALL _getchar
	CPI  R30,LOW(0x54)
	BREQ _0x20
_0x1F:
	RJMP _0x1E
_0x20:
	RCALL _Main_Menu
;     447 	}
_0x1E:
	RJMP _0x16
;     448 } 
_0x21:
	RJMP _0x21
;     449 
;     450 /******************** PROGRAM FUNCTIONS ***********************************/
;     451 /**************************************************************************/
;     452 
;     453 float ReadAVRTemp(void)
;     454 /**********************************************
;     455 	Returns Temperature on Board in DegC
;     456 **********************************************/
;     457 {  
_ReadAVRTemp:
;     458 	int RefVMilliVolts, AVRVMilliVolts;
;     459 	float AVRTemp;
;     460 	
;     461     RefVMilliVolts = ( Read_Max186(VREF, 1) );
	SBIW R28,4
	CALL __SAVELOCR4
;	RefVMilliVolts -> R16,R17
;	AVRVMilliVolts -> R18,R19
;	AVRTemp -> Y+4
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
;     462 	AVRVMilliVolts = ( Read_Max186(PCTEMP, 1) );
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	RCALL _Read_Max186
	MOVW R18,R30
;     463 	AVRTemp = RL10052Temp(AVRVMilliVolts, (RefVMilliVolts*2), 10010);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R16
	LSL  R30
	ROL  R31
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10010)
	LDI  R31,HIGH(10010)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _RL10052Temp
	CALL SUBOPT_0x3F
;     464 	
;     465 	return AVRTemp;
	CALL SUBOPT_0x40
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;     466 }
;     467 
;     468 float ReadBattVolt(void)
;     469 /**********************************************
;     470 	Returns Main Power Input in Volts
;     471 **********************************************/
;     472 { 
_ReadBattVolt:
;     473 	int BattVMilliVolts;
;     474 	float BattV;
;     475 	
;     476 	BattVMilliVolts = ( Read_Max186(BATT, 1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	BattVMilliVolts -> R16,R17
;	BattV -> Y+2
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x3E
;     477  	BattV = ((BattVMilliVolts)/100.0) + 1.2;
	MOVW R30,R16
	CALL SUBOPT_0x41
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F99999A
	CALL __ADDF12
	CALL SUBOPT_0x42
;     478  	
;     479  	return BattV;
	RJMP _0x1F5
;     480 }
;     481 
;     482 
;     483 float ReadRefVolt(void)
;     484 /**********************************************
;     485 	Returns A/D Reference Voltage in Volts
;     486 **********************************************/
;     487 { 
_ReadRefVolt:
;     488 	int RefVMilliVolts;
;     489 	float RefV;
;     490 	
;     491 	RefVMilliVolts = ( Read_Max186(VREF,1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	RefVMilliVolts -> R16,R17
;	RefV -> Y+2
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3E
;     492  	RefV = ((RefVMilliVolts * 2) /1000);
	MOVW R30,R16
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
;     493  	
;     494  	return RefV;
_0x1F5:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     495 }
;     496 
;     497 void Heartbeat(void)
;     498 /*************************************
;     499 Heartbeat on PortE bit 2
;     500 *************************************/
;     501 {
_Heartbeat:
;     502 	
;     503 	PORTE=0X04;
	LDI  R30,LOW(4)
	OUT  0x3,R30
;     504 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x43
;     505 	PORTE=0X00; 
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     506 	delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x43
;     507 }
	RET
;     508 
;     509 void SignOn(void)
;     510 /********************************************
;     511  PROGRAM START
;     512 ********************************************/
;     513 {
_SignOn:
;     514 	ClearScreen();
	RCALL _ClearScreen
;     515 	//v16 <cr><lf>  change \n\r to \r\n throughout
;     516 	printf("\r\n\r\nSIGNON RADIOMETER INTERFACE V%s, %s\r\n", version, verdate);   //v1.14
	__POINTW1FN _0,497
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x44
	CALL SUBOPT_0x45
;     517 	printf("\r\nDigital Interface Board - Rev B. Nov 2007\r\n");
	__POINTW1FN _0,539
	CALL SUBOPT_0x46
;     518 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x26
;     519 	
;     520 	printf("Program Start time is: %02d:%02d:%02d\r\n", h, m, s);
	__POINTW1FN _0,585
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x47
;     521 	rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x37
;     522 	printf("Program Start date is: %02d/%02d/%02d\r\n", yr, mon, dt);
	__POINTW1FN _0,625
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
;     523 	printf("\r\nHit 'T' for Main Menu.\r\n"); 
	__POINTW1FN _0,665
	CALL SUBOPT_0x46
;     524     printf("\r\n");
	CALL SUBOPT_0x49
;     525 }
	RET
;     526 
;     527 void ATMega128_Setup(void)
;     528 /*************************************
;     529 Initialization for AVR ATMega128 chip
;     530 *************************************/
;     531 {   
_ATMega128_Setup:
;     532 	// Input/Output Ports initialization
;     533 	// Port A initialization
;     534 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     535 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     536 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     537 	DDRA=0x00;
	OUT  0x1A,R30
;     538 	
;     539 	// Port C initialization
;     540 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     541 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     542 	PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
;     543 	DDRC=0x03;
	OUT  0x14,R30
;     544 	
;     545 	// Port D initialization
;     546 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     547 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     548 	PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     549 	DDRD=0x00;
	OUT  0x11,R30
;     550 	
;     551 	// Port E initialization
;     552 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     553 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     554 	PORTE=0x00;
	OUT  0x3,R30
;     555 	DDRE=0x04;
	LDI  R30,LOW(4)
	OUT  0x2,R30
;     556 	
;     557 	// Port F initialization
;     558 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     559 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     560 	PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;     561 	DDRF=0x00;
	STS  97,R30
;     562 	
;     563 	// Port G initialization
;     564 	// Func0=In Func1=In Func2=In Func3=In Func4=In 
;     565 	// State0=T State1=T State2=T State3=T State4=T 
;     566 	PORTG=0x00;
	STS  101,R30
;     567 	DDRG=0x00;
	STS  100,R30
;     568 	
;     569 	// Timer/Counter 0 initialization
;     570 	// Clock source: System Clock
;     571 	// Clock value: Timer 0 Stopped
;     572 	// Mode: Normal top=FFh
;     573 	// OC0 output: Disconnected
;     574 	ASSR=0x00;
	OUT  0x30,R30
;     575 	TCCR0=0x00;
	OUT  0x33,R30
;     576 	TCNT0=0x00;
	OUT  0x32,R30
;     577 	OCR0=0x00;
	OUT  0x31,R30
;     578 	
;     579 	// Timer/Counter 1 initialization
;     580 	// Clock source: System Clock
;     581 	// Clock value: Timer 1 Stopped
;     582 	// Mode: Normal top=FFFFh
;     583 	// OC1A output: Discon.
;     584 	// OC1B output: Discon.
;     585 	// OC1C output: Discon.
;     586 	// Noise Canceler: Off
;     587 	// Input Capture on Falling Edge
;     588 	TCCR1A=0x00;
	OUT  0x2F,R30
;     589 	TCCR1B=0x00;
	OUT  0x2E,R30
;     590 	TCNT1H=0x00;
	OUT  0x2D,R30
;     591 	TCNT1L=0x00;
	OUT  0x2C,R30
;     592 	OCR1AH=0x00;
	OUT  0x2B,R30
;     593 	OCR1AL=0x00;
	OUT  0x2A,R30
;     594 	OCR1BH=0x00;
	OUT  0x29,R30
;     595 	OCR1BL=0x00;
	OUT  0x28,R30
;     596 	OCR1CH=0x00;
	STS  121,R30
;     597 	OCR1CL=0x00;
	STS  120,R30
;     598 	
;     599 	// Timer/Counter 2 initialization
;     600 	// Clock source: System Clock
;     601 	// Clock value: Timer 2 Stopped
;     602 	// Mode: Normal top=FFh
;     603 	// OC2 output: Disconnected
;     604 	TCCR2=0x00;
	OUT  0x25,R30
;     605 	TCNT2=0x00;
	OUT  0x24,R30
;     606 	OCR2=0x00;
	OUT  0x23,R30
;     607 	
;     608 	// Timer/Counter 3 initialization
;     609 	// Clock source: System Clock
;     610 	// Clock value: Timer 3 Stopped
;     611 	// Mode: Normal top=FFFFh
;     612 	// OC3A output: Discon.
;     613 	// OC3B output: Discon.
;     614 	// OC3C output: Discon.
;     615 	TCCR3A=0x00;
	STS  139,R30
;     616 	TCCR3B=0x00;
	STS  138,R30
;     617 	TCNT3H=0x00;
	STS  137,R30
;     618 	TCNT3L=0x00;
	STS  136,R30
;     619 	OCR3AH=0x00;
	STS  135,R30
;     620 	OCR3AL=0x00;
	STS  134,R30
;     621 	OCR3BH=0x00;
	STS  133,R30
;     622 	OCR3BL=0x00;
	STS  132,R30
;     623 	OCR3CH=0x00;
	STS  131,R30
;     624 	OCR3CL=0x00;
	STS  130,R30
;     625 	
;     626 	// External Interrupt(s) initialization
;     627 	// INT0: Off
;     628 	// INT1: Off
;     629 	// INT2: Off
;     630 	// INT3: Off
;     631 	// INT4: Off
;     632 	// INT5: Off
;     633 	// INT6: Off
;     634 	// INT7: Off
;     635 	EICRA=0x00;
	STS  106,R30
;     636 	EICRB=0x00;
	OUT  0x3A,R30
;     637 	EIMSK=0x00;
	OUT  0x39,R30
;     638 	
;     639 	// Timer(s)/Counter(s) Interrupt(s) initialization
;     640 	TIMSK=0x00;
	OUT  0x37,R30
;     641 	ETIMSK=0x00;
	STS  125,R30
;     642 	
;     643 	// USART0 initialization
;     644 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     645 	// USART0 Receiver: On
;     646 	// USART0 Transmitter: On
;     647 	// USART0 Mode: Asynchronous
;     648 	// USART0 Baud rate: 19200
;     649 	UCSR0A=0x00;
	OUT  0xB,R30
;     650 	UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     651 	UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     652 	UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;     653 	UBRR0L=XTAL/16/BAUD-1;
	LDI  R30,LOW(11)
	OUT  0x9,R30
;     654 	
;     655 	// USART1 initialization
;     656 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     657 	// USART1 Receiver: On
;     658 	// USART1 Transmitter: On
;     659 	// USART1 Mode: Asynchronous
;     660 	// USART1 Baud rate: 9600
;     661 	UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;     662 	UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
;     663 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     664 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     665 	UBRR1L=0x33;
	LDI  R30,LOW(51)
	STS  153,R30
;     666 	
;     667 	// Analog Comparator initialization
;     668 	// Analog Comparator: Off
;     669 	// Analog Comparator Input Capture by Timer/Counter 1: Off
;     670 	// Analog Comparator Output: Off
;     671 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     672 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     673 	
;     674 	// Port B initialization
;     675 	PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
;     676 	DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;     677 	
;     678 	// SPI initialization
;     679 	// SPI Type: Master
;     680 	// SPI Clock Rate: 1MHz
;     681 	// SPI Clock Phase: 1
;     682 	// SPI Clock Polarity: 0
;     683 	// SPI Data Order: MSB First
;     684 	// SETUP for MAX186 on SPI
;     685 	//SPCR = (1<<SPE) | (1<<MSTR) ; // SPI enable, Master mode, 1MHz Clk
;     686 	SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     687 	SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0xE,R30
;     688 	
;     689 	// DS1302 Real Time Clock initialization
;     690 	// Trickle charger: Off
;     691 	rtc_init(0,0,0); 
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
;     692 	
;     693 }  
	RET
;     694 
;     695 int SerByteAvail(void)
;     696 /********************************
;     697 Check the serial port for characters
;     698 returns a 1 if true 0 for not true
;     699 *********************************/
;     700 {   
_SerByteAvail:
;     701 	if (UCSR0A >= 0x7f)
	IN   R30,0xB
	CPI  R30,LOW(0x7F)
	BRLO _0x22
;     702 	{
;     703 	    //printf("Character found!\r\n");
;     704 		return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
;     705 	}
;     706 	 return 0;
_0x22:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
;     707 }      
;     708 
;     709 int ClearScreen(void)
;     710 /*********************************************
;     711 Routine to clear the terminal screen.
;     712 **********************************************/
;     713 { 
_ClearScreen:
;     714 	int i; 
;     715 	i=0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
;     716 	while (i<25)
_0x23:
	__CPWRN 16,17,25
	BRGE _0x25
;     717 	{
;     718 		printf("\r\n");  // v16 <cr><lf>
	CALL SUBOPT_0x49
;     719 		i++;
	__ADDWRN 16,17,1
;     720 	} 
	RJMP _0x23
_0x25:
;     721 	return OK;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LD   R16,Y+
	LD   R17,Y+
	RET
;     722 }
;     723 
;     724 int Read_Max186(int channel, int mode)
;     725 /**************************************************
;     726 Routine to read external Max186 A-D Converter.
;     727 Control word sets Unipolar mode, Single-Ended Input,
;     728 External Clock.
;     729 Mode: 	0 = Bipolar (-VRef/2 to +VRef/2)
;     730  		1 = Unipolar ( 0 to VRef )		
;     731 **************************************************/
;     732 {
_Read_Max186:
;     733 	unsigned int rb1, rb2, rb3;
;     734 	int data_out;
;     735 	long din;
;     736 	
;     737 	data_out=0;
	SBIW R28,6
	CALL __SAVELOCR6
;	channel -> Y+14
;	mode -> Y+12
;	rb1 -> R16,R17
;	rb2 -> R18,R19
;	rb3 -> R20,R21
;	data_out -> Y+10
;	din -> Y+6
	LDI  R30,0
	STD  Y+10,R30
	STD  Y+10+1,R30
;     738 	rb1=rb2=rb3=0; 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R20,R30
	MOVW R18,R30
	MOVW R16,R30
;     739 	
;     740 	if (mode == 1) //DO UNIPOLAR (0 - VREF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x26
;     741 	{
;     742 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x27
;     743 			din=0x8F;		// 10001111
	__GETD1N 0x8F
	RJMP _0x1F6
;     744 		else if(channel==1)
_0x27:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x29
;     745 			din=0xCF;		// 11001111
	__GETD1N 0xCF
	RJMP _0x1F6
;     746 		else if(channel==2)
_0x29:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x2B
;     747 			din=0x9F;		// 10011111
	__GETD1N 0x9F
	RJMP _0x1F6
;     748 		else if(channel==3)
_0x2B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x2D
;     749 			din=0xDF;		// 11011111
	__GETD1N 0xDF
	RJMP _0x1F6
;     750 		else if(channel==4)
_0x2D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x2F
;     751 			din=0xAF;		// 10101111
	__GETD1N 0xAF
	RJMP _0x1F6
;     752 		else if(channel==5)
_0x2F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x31
;     753 			din=0xEF;		// 11101111
	__GETD1N 0xEF
	RJMP _0x1F6
;     754 		else if(channel==6)
_0x31:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x33
;     755 			din=0xBF;		// 10111111
	__GETD1N 0xBF
	RJMP _0x1F6
;     756 		else if(channel==7)
_0x33:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x35
;     757 			din=0xFF;	 	// 11111111
	__GETD1N 0xFF
_0x1F6:
	__PUTD1S 6
;     758 	} 
_0x35:
;     759 	else	//DO BIPOLAR (-VREF/2 - +VREF/2)
	RJMP _0x36
_0x26:
;     760 	{
;     761 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x37
;     762 			din=0x87;		// 10000111
	__GETD1N 0x87
	RJMP _0x1F7
;     763 		else if(channel==1)
_0x37:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x39
;     764 			din=0xC7;		// 11000111
	__GETD1N 0xC7
	RJMP _0x1F7
;     765 		else if(channel==2)
_0x39:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x3B
;     766 			din=0x97;		// 10010111
	__GETD1N 0x97
	RJMP _0x1F7
;     767 		else if(channel==3)
_0x3B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x3D
;     768 			din=0xD7;		// 11010111
	__GETD1N 0xD7
	RJMP _0x1F7
;     769 		else if(channel==4)
_0x3D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x3F
;     770 			din=0xA7;		// 10100111
	__GETD1N 0xA7
	RJMP _0x1F7
;     771 		else if(channel==5)
_0x3F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x41
;     772 			din=0xE7;		// 11100111
	__GETD1N 0xE7
	RJMP _0x1F7
;     773 		else if(channel==6)
_0x41:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x43
;     774 			din=0xB7;		// 10110111
	__GETD1N 0xB7
	RJMP _0x1F7
;     775 		else if(channel==7)
_0x43:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x45
;     776 			din=0xF7;	 	// 11110111
	__GETD1N 0xF7
_0x1F7:
	__PUTD1S 6
;     777 	}
_0x45:
_0x36:
;     778     
;     779 	// START A-D
;     780 	PORTB = 0x07;
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     781 	PORTB = 0x06; 	//Selects CS- lo 
	LDI  R30,LOW(6)
	OUT  0x18,R30
;     782 	
;     783 	// Send control byte ch7, Uni, Sgl, ext clk
;     784 	rb1 = ( spi(din) );		//Sends the coversion code from above
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _spi
	MOV  R16,R30
	CLR  R17
;     785 	// Send/Rcv HiByte
;     786 	rb2 = ( spi(0x00) );		//Receive byte 2 (MSB) 
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R18,R30
	CLR  R19
;     787 	// Send/Rcv LoByte
;     788 	rb3 = ( spi(0x00) );		//Receive byte 3 (LSB)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R20,R30
	CLR  R21
;     789 		
;     790 	PORTB = 0x07;		//Selects CS- hi
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     791     
;     792 	// Calculation to counts
;     793 	if(mode == 1) //UNIPOLAR
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x46
;     794 	{
;     795 		rb2 = rb2 << 1;
	CALL SUBOPT_0x4A
;     796 		rb3 = rb3 >> 3;
;     797 		data_out = ( (rb2*16) + rb3 ) ;
;     798 	}
;     799 	else if(mode == 0) //BIPOLAR
	RJMP _0x47
_0x46:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x48
;     800 	{
;     801 		rb2 = rb2 << 1;
	CALL SUBOPT_0x4A
;     802 		rb3 = rb3 >> 3;
;     803 		data_out = ((rb2*16) + rb3);
;     804 		if(data_out >= 2048) data_out -= 4096;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0x800)
	LDI  R30,HIGH(0x800)
	CPC  R27,R30
	BRLT _0x49
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(4096)
	SBCI R31,HIGH(4096)
	STD  Y+10,R30
	STD  Y+10+1,R31
;     805 	}
_0x49:
;     806 	else {  // v15 we need this.
	RJMP _0x4A
_0x48:
;     807 		data_out = 0;
	LDI  R30,0
	STD  Y+10,R30
	STD  Y+10+1,R30
;     808 	}
_0x4A:
_0x47:
;     809 			
;     810 	//printf("Data Out= %d\r\n", data_out);   
;     811 	
;     812 	
;     813 	return data_out;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;     814 }   
;     815 
;     816 
;     817 float RL10052Temp (unsigned int v2, int ref, int res)
;     818 /***********************************
;     819 Calculates Thermistor Temperature
;     820 v2 = A to D Milli Volts 0-4096
;     821 ref = reference voltage to circuit
;     822 res = reference divider resistor
;     823 ***********************************/
;     824 {
_RL10052Temp:
;     825 	float v1, r2, it, Temp, dum;
;     826 	float term1, term2, term3;
;     827 			
;     828 	v1 = (float)ref - (float)v2;
	SBIW R28,32
;	v2 -> Y+36
;	ref -> Y+34
;	res -> Y+32
;	v1 -> Y+28
;	r2 -> Y+24
;	it -> Y+20
;	Temp -> Y+16
;	dum -> Y+12
;	term1 -> Y+8
;	term2 -> Y+4
;	term3 -> Y+0
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	CALL SUBOPT_0x41
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x2
	__PUTD1S 28
;     829 	it = v1/(float)res;
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x41
	__GETD2S 28
	CALL __DIVF21
	CALL SUBOPT_0x30
;     830 	r2 = (float)v2/it;		    //find resistance of thermistor
	CALL SUBOPT_0x4B
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 20
	CALL __DIVF21
	__PUTD1S 24
;     831 	dum = (float)log(r2/(float)res);
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4C
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x3
;     832 	
;     833 	// Diagnostic
;     834 	//printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\r\n", v2, v1, it, r2, dum);
;     835 	
;     836 	term1 = COEFFA + (COEFFB * dum);
	LDS  R26,_COEFFB
	LDS  R27,_COEFFB+1
	LDS  R24,_COEFFB+2
	LDS  R25,_COEFFB+3
	CALL __MULF12
	LDS  R26,_COEFFA
	LDS  R27,_COEFFA+1
	LDS  R24,_COEFFA+2
	LDS  R25,_COEFFA+3
	CALL SUBOPT_0x4D
;     837 	term2 = COEFFC * (dum*dum);
	CALL SUBOPT_0x4E
	LDS  R26,_COEFFC
	LDS  R27,_COEFFC+1
	LDS  R24,_COEFFC+2
	LDS  R25,_COEFFC+3
	CALL __MULF12
	CALL SUBOPT_0x3F
;     838 	term3 = COEFFD * ((dum*dum)*dum);
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x1
	CALL __MULF12
	LDS  R26,_COEFFD
	LDS  R27,_COEFFD+1
	LDS  R24,_COEFFD+2
	LDS  R25,_COEFFD+3
	CALL __MULF12
	CALL SUBOPT_0x4F
;     839    	Temp = term1 + term2 + term3;
	CALL SUBOPT_0x40
	CALL SUBOPT_0x50
	CALL __ADDF12
	CALL SUBOPT_0x8
	CALL __ADDF12
	CALL SUBOPT_0x51
;     840 	//printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\r\n", term1, term2, term3, Temp);
;     841 	//Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
;     842 	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	CALL SUBOPT_0x52
	CALL SUBOPT_0xB
	__GETD1N 0x438B0000
	CALL SUBOPT_0x2
	CALL SUBOPT_0x51
;     843 	//	printf("Temp= %f\r\n", Temp);
;     844 
;     845 return Temp;
	ADIW R28,38
	RET
;     846 } 
;     847 
;     848 void Main_Menu(void)
;     849 /*************************************************
;     850 *************************************************/
;     851 { 
_Main_Menu:
;     852 	char ch;
;     853 	int ltime;
;     854 	char msg[12];
;     855 	int i; 
;     856 	unsigned long t1, t2;  //v1.13
;     857 
;     858 			
;     859 	printf("\r\n");
	SBIW R28,20
	CALL __SAVELOCR5
;	ch -> R16
;	ltime -> R17,R18
;	msg -> Y+13
;	i -> R19,R20
;	t1 -> Y+9
;	t2 -> Y+5
	CALL SUBOPT_0x49
;     860 	printf("\r\n RAD%02d BOARD (REV B) VERSION: %s, VERSION DATE: %s\r\n", Id_address, version, verdate);
	__POINTW1FN _0,692
	CALL SUBOPT_0x38
	CALL SUBOPT_0x44
	CALL SUBOPT_0x47
;     861 	printf(" ----------EEPROM PARAMETERS----------------------------\r\n");
	__POINTW1FN _0,749
	CALL SUBOPT_0x46
;     862 	printf("PSP Coeff= %.2E, PIR Coeff= %.2E\r\n", psp, pir);
	__POINTW1FN _0,808
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x33
	CALL SUBOPT_0x45
;     863 	printf("PIRadc_gain= %.1f, PIRadc_offset= %.1f\r\n", PIRadc_gain, PIRadc_offset);                   
	__POINTW1FN _0,843
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x34
	CALL SUBOPT_0x45
;     864 	printf("PSPadc_gain= %.1f, PSPadc_offset= %.1f\r\n", PSPadc_gain, PSPadc_offset);
	__POINTW1FN _0,884
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x45
;     865 	printf(" ---------DATE & TIME SETTING---------------------------\r\n"); 
	__POINTW1FN _0,925
	CALL SUBOPT_0x46
;     866     printf("'T' -->Set the date/time.\r\n");
	__POINTW1FN _0,984
	CALL SUBOPT_0x46
;     867     printf(" ---------PSP SETTINGS----------------------------------\r\n");
	__POINTW1FN _0,1012
	CALL SUBOPT_0x46
;     868     printf("'p' -->Set PSP coefficient. 'g' -->Set PSP amplifier gain value.\r\n"); 
	__POINTW1FN _0,1071
	CALL SUBOPT_0x46
;     869     printf("'o' -->Set PSP amplifier output offset, mv.\r\n");  //v15
	__POINTW1FN _0,1138
	CALL SUBOPT_0x46
;     870     printf(" ---------PIR SETTINGS----------------------------------\r\n");
	__POINTW1FN _0,1184
	CALL SUBOPT_0x46
;     871     printf("'I' -->Set PIR coefficient. 'G' -->Set PIR amplifier gain value.\r\n");
	__POINTW1FN _0,1243
	CALL SUBOPT_0x46
;     872     printf("'O' -->Set PIR amplifier output offset, mv.\r\n");  //v15
	__POINTW1FN _0,1310
	CALL SUBOPT_0x46
;     873     printf("'C' -->Set Case (R8) value. 'D' -->Set Dome (R9) value.\r\n");
	__POINTW1FN _0,1356
	CALL SUBOPT_0x46
;     874     printf("'V' -->Set Thermistor/ADC Reference Voltage (TP2) value.\r\n");
	__POINTW1FN _0,1414
	CALL SUBOPT_0x46
;     875     printf(" ---------TIMING SETTING--------------------------------\r\n");
	__POINTW1FN _0,1473
	CALL SUBOPT_0x46
;     876     printf("'L' -->Set Output time in seconds.\r\n");
	__POINTW1FN _0,1532
	CALL SUBOPT_0x46
;     877     printf(" -------------------------------------------------------\r\n");
	__POINTW1FN _0,1569
	CALL SUBOPT_0x46
;     878     printf("'S' -->Sample 12 bit A to D. 'A' -->Change Identifier String.\r\n");
	__POINTW1FN _0,1628
	CALL SUBOPT_0x46
;     879     printf("'X' -->Exit this menu, return to operation.\r\n");
	__POINTW1FN _0,1692
	CALL SUBOPT_0x46
;     880     printf("=========================================================\r\n");
	__POINTW1FN _0,1738
	CALL SUBOPT_0x46
;     881     printf("Command?>");
	__POINTW1FN _0,1798
	CALL SUBOPT_0x46
;     882 	
;     883 	// ***************************************
;     884 	// WAITING FOR A CHARACTER.  TIMEOUT.  v13
;     885 	// ***************************************
;     886 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x26
;     887 	t1 = h*3600 + m*60 + s;
	CALL SUBOPT_0x53
	__PUTD1S 9
;     888 	while (1) 
_0x4B:
;     889 	{
;     890 		// CHECK INPUT BUFFER FOR A CHARACTER
;     891 		if ( SerByteAvail() )
	CALL _SerByteAvail
	SBIW R30,0
	BREQ _0x4E
;     892 		{
;     893 			ch = getchar();
	CALL _getchar
	MOV  R16,R30
;     894 			break;
	RJMP _0x4D
;     895 		}
;     896 		// CHECK CURRENT TIME FOR A TIMEOUT
;     897 		rtc_get_time(&h,&m,&s);
_0x4E:
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x26
;     898 		t2 = h*3600 + m*60 + s;		 
	CALL SUBOPT_0x53
	__PUTD1S 5
;     899 		if ( abs(t2-t1) > MENU_TIMEOUT )     //v13 30 sec timeout
	__GETD2S 9
	CALL __SUBD12
	ST   -Y,R31
	ST   -Y,R30
	RCALL _abs
	SBIW R30,31
	BRLO _0x4F
;     900 		{
;     901 			printf("\r\nTIMEOUT: Return to sampling\r\n");
	__POINTW1FN _0,1808
	CALL SUBOPT_0x46
;     902 			return;
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;     903 		}
;     904 	}	
_0x4F:
	RJMP _0x4B
_0x4D:
;     905 	switch (ch) 
	MOV  R30,R16
;     906 	{
;     907 		//*** echo characters typed.  See PRP code.
;     908 		// SET THE REAL-TIME CLOCK TIME
;     909 		case 'T':
	CPI  R30,LOW(0x54)
	BREQ _0x54
;     910 		case 't': 
	CPI  R30,LOW(0x74)
	BREQ PC+3
	JMP _0x55
_0x54:
;     911 		    printf("System date/time (YY/MM/DD, hh:mm:ss) is %02d/%02d/%02d, %02d:%02d:%02d\r\n", yr, mon, dt, h, m, s);
	__POINTW1FN _0,1840
	CALL SUBOPT_0x48
	CALL SUBOPT_0x3A
	LDI  R24,24
	CALL _printf
	ADIW R28,26
;     912 			printf("Enter new time (hhmmss):  ");
	__POINTW1FN _0,1914
	CALL SUBOPT_0x46
;     913 			
;     914 			scanf(" %2d%2d%2d", &h, &m, &s);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x4
	CALL __PUTPARD1
	__GETD1N 0x5
	CALL __PUTPARD1
	__GETD1N 0x6
	CALL SUBOPT_0x54
;     915 		
;     916 			if( (h >= 24) || (m >= 60) || (s >= 60) ) 
	LDI  R30,LOW(24)
	CP   R4,R30
	BRSH _0x57
	LDI  R30,LOW(60)
	CP   R5,R30
	BRSH _0x57
	CP   R6,R30
	BRLO _0x56
_0x57:
;     917 			{
;     918 				printf("\r\nIncorrect time entered, check format.\r\n");
	__POINTW1FN _0,1952
	CALL SUBOPT_0x46
;     919 				break;
	RJMP _0x52
;     920 			}
;     921 			else 
_0x56:
;     922 			{
;     923 				rtc_set_time(h, m, s);
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R6
	CALL _rtc_set_time
;     924 				printf("\r\n%02d:%02d:%02d saved.\r\n", h, m, s);
	__POINTW1FN _0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x47
;     925 			}
;     926 			printf("\r\nSet Date (DDmmYY): ");
	__POINTW1FN _0,2020
	CALL SUBOPT_0x46
;     927 			scanf(" %2d%2d%2d", &dt, &mon, &yr);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x9
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	__GETD1N 0xB
	CALL SUBOPT_0x54
;     928 			
;     929 		
;     930 			if( (yr <= 7 || yr > 99) ||
;     931 				(mon <=0 || mon > 12) ||
;     932 				(dt <= 0 || dt > 31) ) 
	LDI  R30,LOW(7)
	CP   R30,R11
	BRSH _0x5B
	LDI  R30,LOW(99)
	CP   R30,R11
	BRSH _0x5C
_0x5B:
	RJMP _0x5D
_0x5C:
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x5E
	LDI  R30,LOW(12)
	CP   R30,R10
	BRSH _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
	LDI  R30,LOW(0)
	CP   R30,R9
	BRSH _0x60
	LDI  R30,LOW(31)
	CP   R30,R9
	BRSH _0x61
_0x60:
	RJMP _0x5D
_0x61:
	RJMP _0x5A
_0x5D:
;     933 				{
;     934 					printf("\r\nIncorrect date entered, check format.\r\n");
	__POINTW1FN _0,2042
	CALL SUBOPT_0x46
;     935 					break;
	RJMP _0x52
;     936 				}
;     937 				else 
_0x5A:
;     938 				{   
;     939 					rtc_set_date(dt, mon, yr);
	ST   -Y,R9
	ST   -Y,R10
	ST   -Y,R11
	CALL _rtc_set_date
;     940 					printf("\r\n\r\n%02d/%02d/%02d saved.\r\n", yr, mon, dt);
	__POINTW1FN _0,2084
	CALL SUBOPT_0x48
	CALL SUBOPT_0x47
;     941 				}
;     942 			//printf("\r\n");
;     943 			
;     944 			break;
	RJMP _0x52
;     945 		
;     946 		// SET AVERAGING INTERVAL IN SECS
;     947 		case 'L' :
_0x55:
	CPI  R30,LOW(0x4C)
	BREQ _0x65
;     948 		case 'l' : 
	CPI  R30,LOW(0x6C)
	BREQ PC+3
	JMP _0x66
_0x65:
;     949 			printf("Change Output Interval in secs\r\n");
	__POINTW1FN _0,2112
	CALL SUBOPT_0x46
;     950 			printf("Current Interval is: %d secs\r\n", looptime);
	__POINTW1FN _0,2145
	CALL SUBOPT_0x55
;     951 			printf("Enter new output interval in secs: ");
	__POINTW1FN _0,2176
	CALL SUBOPT_0x46
;     952 			for (i=0; i<5; i++)
	__GETWRN 19,20,0
_0x68:
	__CPWRN 19,20,5
	BRGE _0x69
;     953 			{
;     954 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;     955 				printf("%c", msg[i]);
;     956 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0x6B
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0x6A
_0x6B:
;     957 				{
;     958 					i--;
	__SUBWRN 19,20,1
;     959 					break;
	RJMP _0x69
;     960 				}
;     961 			}
_0x6A:
	__ADDWRN 19,20,1
	RJMP _0x68
_0x69:
;     962 			if(atof(msg) > 3600 || atof(msg) <= 0)    //v13 increased limit to 1/2 hour //v15 increased to one hour
	CALL SUBOPT_0x59
	__GETD1N 0x45610000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x6E
	CALL SUBOPT_0x59
	CALL __CPD02
	BRLT _0x6D
_0x6E:
;     963 			{
;     964 				printf("\r\nOut of Range.\r\n");
	__POINTW1FN _0,2215
	CALL SUBOPT_0x46
;     965 				break;
	RJMP _0x52
;     966 			}
;     967 			else 
_0x6D:
;     968 			{
;     969 				ltime = atof(msg);
	CALL SUBOPT_0x5A
	CALL __CFD1
	__PUTW1R 17,18
;     970 				looptime = ltime;
	__GETW1R 17,18
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMWRW
;     971 				printf("\r\nLooptime is now set to %d seconds.\r\n", looptime); 
	__POINTW1FN _0,2233
	CALL SUBOPT_0x55
;     972 			}
;     973 			
;     974 			break;  
	RJMP _0x52
;     975 		
;     976 		// PSP COEFFICIENT
;     977 		case 'p' :
_0x66:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x71
;     978 			printf("Change PSP Coefficient\r\n");
	__POINTW1FN _0,2272
	CALL SUBOPT_0x46
;     979 			printf("Current PSP Coefficient is: %.2E\r\n", psp);
	__POINTW1FN _0,2297
	CALL SUBOPT_0x5B
;     980 			printf("Enter New PSP Coefficient: ");
	__POINTW1FN _0,2332
	CALL SUBOPT_0x46
;     981 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x73:
	__CPWRN 19,20,20
	BRGE _0x74
;     982 			{
;     983 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;     984 				printf("%c", msg[i]);
;     985 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0x76
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0x75
_0x76:
;     986 				{
;     987 					i--;
	__SUBWRN 19,20,1
;     988 					break;
	RJMP _0x74
;     989 				}
;     990 			}
_0x75:
	__ADDWRN 19,20,1
	RJMP _0x73
_0x74:
;     991 			if(atof(msg) >= 20.0E-6 || atof(msg) <= 0.1E-6)  //v15  expand range
	CALL SUBOPT_0x59
	__GETD1N 0x37A7C5AC
	CALL __CMPF12
	BRSH _0x79
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5C
	BREQ PC+2
	BRCC PC+3
	JMP  _0x79
	RJMP _0x78
_0x79:
;     992 			{
;     993 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;     994 				break;
	RJMP _0x52
;     995 			}
;     996 			else 
_0x78:
;     997 			{
;     998 				psp = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMWRD
;     999 				printf("\r\nPSP Coefficient is now set to %.2E\r\n", psp); 
	__POINTW1FN _0,2377
	CALL SUBOPT_0x5B
;    1000 			}
;    1001 			break;
	RJMP _0x52
;    1002 		
;    1003 		case 'g' :
_0x71:
	CPI  R30,LOW(0x67)
	BREQ PC+3
	JMP _0x7C
;    1004 			printf("Change PSP Amplifier Gain Value\r\n");
	__POINTW1FN _0,2416
	CALL SUBOPT_0x46
;    1005 			printf("Current PSP Amplifier Gain Value: %.2f\r\n", PSPadc_gain);
	__POINTW1FN _0,2450
	CALL SUBOPT_0x5E
;    1006 			printf("Enter New PSP Amplifier Gain Value: ");
	__POINTW1FN _0,2491
	CALL SUBOPT_0x46
;    1007 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x7E:
	__CPWRN 19,20,20
	BRGE _0x7F
;    1008 			{
;    1009 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1010 				printf("%c", msg[i] );
;    1011 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0x81
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0x80
_0x81:
;    1012 				{
;    1013 					i--;
	__SUBWRN 19,20,1
;    1014 					break;
	RJMP _0x7F
;    1015 				}
;    1016 			}
_0x80:
	__ADDWRN 19,20,1
	RJMP _0x7E
_0x7F:
;    1017 			if(atof(msg) >= 300 || atof(msg) <= 10)  //v15  expand range 
	CALL SUBOPT_0x59
	__GETD1N 0x43960000
	CALL __CMPF12
	BRSH _0x84
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5F
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x84
	RJMP _0x83
_0x84:
;    1018 			{
;    1019 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1020 				break;
	RJMP _0x52
;    1021 			}
;    1022 			else 
_0x83:
;    1023 			{
;    1024 				PSPadc_gain = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMWRD
;    1025 				printf("\r\nPSP Amplifier Gain is now set to %.2f\r\n", PSPadc_gain); 
	__POINTW1FN _0,2528
	CALL SUBOPT_0x5E
;    1026 			}
;    1027 			break;
	RJMP _0x52
;    1028 
;    1029 		case 'o' :
_0x7C:
	CPI  R30,LOW(0x6F)
	BREQ PC+3
	JMP _0x87
;    1030 			printf("Change PSP Amplifier Offset Value\r\n");
	__POINTW1FN _0,2570
	CALL SUBOPT_0x46
;    1031 			printf("Current PSP Amplifier Offset Value: %.2f\r\n", PSPadc_offset);
	__POINTW1FN _0,2606
	CALL SUBOPT_0x16
;    1032 			printf("Enter New PSP Amplifier Offset Value: ");
	__POINTW1FN _0,2649
	CALL SUBOPT_0x46
;    1033 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x89:
	__CPWRN 19,20,20
	BRGE _0x8A
;    1034 			{
;    1035 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1036 				printf("%c", msg[i]);
;    1037 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0x8C
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0x8B
_0x8C:
;    1038 				{
;    1039 					i--;
	__SUBWRN 19,20,1
;    1040 					break;
	RJMP _0x8A
;    1041 				}
;    1042 			}                        
_0x8B:
	__ADDWRN 19,20,1
	RJMP _0x89
_0x8A:
;    1043 			if(atof(msg) > 500 || atof(msg) < -500)  //v15  expand range
	CALL SUBOPT_0x59
	CALL SUBOPT_0x60
	BREQ PC+4
	BRCS PC+3
	JMP  _0x8F
	CALL SUBOPT_0x59
	__GETD1N 0xC3FA0000
	CALL __CMPF12
	BRSH _0x8E
_0x8F:
;    1044 			{
;    1045 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1046 				break;
	RJMP _0x52
;    1047 			}
;    1048 			else 
_0x8E:
;    1049 			{
;    1050 				PSPadc_offset = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMWRD
;    1051 				printf("\r\nPSP Amplifier Offset is now set to %.2f\r\n", PSPadc_offset); 
	__POINTW1FN _0,2688
	CALL SUBOPT_0x16
;    1052 			}
;    1053 			break;
	RJMP _0x52
;    1054 
;    1055 		case 'G' :
_0x87:
	CPI  R30,LOW(0x47)
	BREQ PC+3
	JMP _0x92
;    1056 			printf("Change PIR Amplifier Gain Value\r\n");
	__POINTW1FN _0,2732
	CALL SUBOPT_0x46
;    1057 			printf("Current PIR Amplifier Gain Value: %.2f\r\n", PIRadc_gain);
	__POINTW1FN _0,2766
	CALL SUBOPT_0x61
;    1058 			printf("Enter New PIR Amplifier Gain Value: ");
	__POINTW1FN _0,2807
	CALL SUBOPT_0x46
;    1059 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x94:
	__CPWRN 19,20,20
	BRGE _0x95
;    1060 			{
;    1061 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1062 				printf("%c", msg[i]);
;    1063 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0x97
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0x96
_0x97:
;    1064 				{
;    1065 					i--;
	__SUBWRN 19,20,1
;    1066 					break;
	RJMP _0x95
;    1067 				}
;    1068 			}                        
_0x96:
	__ADDWRN 19,20,1
	RJMP _0x94
_0x95:
;    1069 			if(atof(msg) > 1500 || atof(msg) < 500 )  //v15  expand range
	CALL SUBOPT_0x59
	__GETD1N 0x44BB8000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x9A
	CALL SUBOPT_0x59
	CALL SUBOPT_0x60
	BRSH _0x99
_0x9A:
;    1070 			{
;    1071 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1072 				break;
	RJMP _0x52
;    1073 			}
;    1074 			else 
_0x99:
;    1075 			{
;    1076 				PIRadc_gain = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMWRD
;    1077 				printf("\r\nPIR Amplifier Gain is now set to %.2f\r\n", PIRadc_gain); 
	__POINTW1FN _0,2844
	CALL SUBOPT_0x61
;    1078 			}
;    1079 			break;
	RJMP _0x52
;    1080 
;    1081 		case 'O' :
_0x92:
	CPI  R30,LOW(0x4F)
	BREQ PC+3
	JMP _0x9D
;    1082 			printf("Change PIR Amplifier Offset Value\r\n");
	__POINTW1FN _0,2886
	CALL SUBOPT_0x46
;    1083 			printf("Current PIR Amplifier Offset Value: %.2f\r\n", PIRadc_offset);
	__POINTW1FN _0,2922
	CALL SUBOPT_0x14
;    1084 			printf("Enter New PIR Amplifier Offset Value: ");
	__POINTW1FN _0,2965
	CALL SUBOPT_0x46
;    1085 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x9F:
	__CPWRN 19,20,20
	BRGE _0xA0
;    1086 			{
;    1087 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1088 				printf("%c", msg[i]);
;    1089 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xA2
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xA1
_0xA2:
;    1090 				{
;    1091 					i--;
	__SUBWRN 19,20,1
;    1092 					break;
	RJMP _0xA0
;    1093 				}
;    1094 			}                        
_0xA1:
	__ADDWRN 19,20,1
	RJMP _0x9F
_0xA0:
;    1095 			if(atof(msg) > 200 || atof(msg) < -200)  //v15  expand range
	CALL SUBOPT_0x59
	__GETD1N 0x43480000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xA5
	CALL SUBOPT_0x59
	__GETD1N 0xC3480000
	CALL __CMPF12
	BRSH _0xA4
_0xA5:
;    1096 			{
;    1097 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1098 				break;
	RJMP _0x52
;    1099 			}
;    1100 			else 
_0xA4:
;    1101 			{
;    1102 				PIRadc_offset = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMWRD
;    1103 				printf("\r\nPIR Amplifier Offset is now set to %.2f\r\n", PIRadc_offset); 
	__POINTW1FN _0,3004
	CALL SUBOPT_0x14
;    1104 			}
;    1105 			break;
	RJMP _0x52
;    1106 
;    1107 		case 'I' :  // 'l' or 'I' This is capital Eye
_0x9D:
	CPI  R30,LOW(0x49)
	BREQ PC+3
	JMP _0xA8
;    1108 			printf("Change PIR Coefficient\r\n");
	__POINTW1FN _0,3048
	CALL SUBOPT_0x46
;    1109 			printf("Current PIR Coefficient is: %E\r\n", pir);
	__POINTW1FN _0,3073
	CALL SUBOPT_0x62
;    1110 			printf("Enter New PIR Coefficient: ");
	__POINTW1FN _0,3106
	CALL SUBOPT_0x46
;    1111 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xAA:
	__CPWRN 19,20,20
	BRGE _0xAB
;    1112 			{
;    1113 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1114 				printf("%c", msg[i]);
;    1115 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xAD
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xAC
_0xAD:
;    1116 				{
;    1117 					i--;
	__SUBWRN 19,20,1
;    1118 					break;
	RJMP _0xAB
;    1119 				}
;    1120 			}                        
_0xAC:
	__ADDWRN 19,20,1
	RJMP _0xAA
_0xAB:
;    1121 			if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
	CALL SUBOPT_0x59
	__GETD1N 0x3727C5AC
	CALL __CMPF12
	BRSH _0xB0
	CALL SUBOPT_0x59
	CALL SUBOPT_0x5C
	BREQ PC+2
	BRCC PC+3
	JMP  _0xB0
	RJMP _0xAF
_0xB0:
;    1122 			{
;    1123 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1124 				break;
	RJMP _0x52
;    1125 			}
;    1126 			else 
_0xAF:
;    1127 			{
;    1128 				pir = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMWRD
;    1129 				printf("\r\nPIR Coefficient is now set to %E\r\n", pir); 
	__POINTW1FN _0,3134
	CALL SUBOPT_0x62
;    1130 			}
;    1131 			break;
	RJMP _0x52
;    1132 		case 'C' :
_0xA8:
	CPI  R30,LOW(0x43)
	BREQ PC+3
	JMP _0xB3
;    1133 			printf("Change Case Reference Resistor (R9)\r\n");
	__POINTW1FN _0,3171
	CALL SUBOPT_0x46
;    1134 			printf("Current Case Reference Resistor is: %.1f\r\n", RrefC);
	__POINTW1FN _0,3209
	CALL SUBOPT_0x63
;    1135 			printf("Enter New Case Reference Resistance: ");
	__POINTW1FN _0,3252
	CALL SUBOPT_0x46
;    1136 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xB5:
	__CPWRN 19,20,20
	BRGE _0xB6
;    1137 			{
;    1138 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1139 				printf("%c", msg[i]);
;    1140 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xB8
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xB7
_0xB8:
;    1141 				{
;    1142 					i--;
	__SUBWRN 19,20,1
;    1143 					break;
	RJMP _0xB6
;    1144 				}
;    1145 			}
_0xB7:
	__ADDWRN 19,20,1
	RJMP _0xB5
_0xB6:
;    1146 			if( atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x59
	CALL SUBOPT_0x64
	BREQ PC+4
	BRCS PC+3
	JMP  _0xBB
	CALL SUBOPT_0x59
	CALL SUBOPT_0x65
	BRSH _0xBA
_0xBB:
;    1147 			{
;    1148 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1149 				break;
	RJMP _0x52
;    1150 			}
;    1151 			else 
_0xBA:
;    1152 			{
;    1153 				RrefC = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMWRD
;    1154 				printf("\r\nCase Reference Resistor is now set to %.1f\r\n", RrefC); 
	__POINTW1FN _0,3290
	CALL SUBOPT_0x63
;    1155 			}
;    1156 			break;
	RJMP _0x52
;    1157 		case 'D' :
_0xB3:
	CPI  R30,LOW(0x44)
	BREQ PC+3
	JMP _0xBE
;    1158 			printf("Change Dome Reference Resistor (R10)\r\n");
	__POINTW1FN _0,3337
	CALL SUBOPT_0x46
;    1159 			printf("Current Dome Reference Resistor is: %.1f\r\n", RrefD);
	__POINTW1FN _0,3376
	CALL SUBOPT_0x66
;    1160 			printf("Enter New Dome Reference Resistance: ");
	__POINTW1FN _0,3419
	CALL SUBOPT_0x46
;    1161 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xC0:
	__CPWRN 19,20,20
	BRGE _0xC1
;    1162 			{
;    1163 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1164 				printf("%c", msg[i]);
;    1165 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xC3
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xC2
_0xC3:
;    1166 				{
;    1167 					i--;
	__SUBWRN 19,20,1
;    1168 					break;
	RJMP _0xC1
;    1169 				}
;    1170 			}                        
_0xC2:
	__ADDWRN 19,20,1
	RJMP _0xC0
_0xC1:
;    1171 			if(atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x59
	CALL SUBOPT_0x64
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC6
	CALL SUBOPT_0x59
	CALL SUBOPT_0x65
	BRSH _0xC5
_0xC6:
;    1172 			{
;    1173 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1174 				break;
	RJMP _0x52
;    1175 			}
;    1176 			else 
_0xC5:
;    1177 			{
;    1178 				RrefD = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMWRD
;    1179 				printf("\r\nDome Reference Resistor is now set to %.1f\r\n", RrefD); 
	__POINTW1FN _0,3457
	CALL SUBOPT_0x66
;    1180 			}
;    1181 			break;
	RJMP _0x52
;    1182 		case 'V' :
_0xBE:
	CPI  R30,LOW(0x56)
	BREQ PC+3
	JMP _0xC9
;    1183 			printf("Change Thermistor Reference Voltage\r\n");
	__POINTW1FN _0,3504
	CALL SUBOPT_0x46
;    1184 			printf("Current Thermistor Reference Voltage is: %.4f\r\n", Vtherm);
	__POINTW1FN _0,3542
	CALL SUBOPT_0x67
;    1185 			printf("Enter New Thermistor Reference Voltage: ");
	__POINTW1FN _0,3590
	CALL SUBOPT_0x46
;    1186 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xCB:
	__CPWRN 19,20,20
	BRGE _0xCC
;    1187 			{
;    1188 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1189 				printf("%c", msg[i]);
;    1190 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xCE
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xCD
_0xCE:
;    1191 				{
;    1192 					i--;
	__SUBWRN 19,20,1
;    1193 					break;
	RJMP _0xCC
;    1194 				}
;    1195 			}                        
_0xCD:
	__ADDWRN 19,20,1
	RJMP _0xCB
_0xCC:
;    1196 			if(atof(msg) > 6.0 || atof(msg) < 2.0)  //v15  expand range
	CALL SUBOPT_0x59
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xD1
	CALL SUBOPT_0x59
	__GETD1N 0x40000000
	CALL __CMPF12
	BRSH _0xD0
_0xD1:
;    1197 			{
;    1198 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1199 				break;
	RJMP _0x52
;    1200 			}
;    1201 			else 
_0xD0:
;    1202 			{
;    1203 				Vtherm = atof(msg);
	CALL SUBOPT_0x5A
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMWRD
;    1204 				Vadc = Vtherm;
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMWRD
;    1205 				printf("\r\nThermistor Reference Voltage is now set to %.4f\r\n", Vtherm); 
	__POINTW1FN _0,3631
	CALL SUBOPT_0x67
;    1206 			}
;    1207 			break;
	RJMP _0x52
;    1208 		case 'A' :
_0xC9:
	CPI  R30,LOW(0x41)
	BREQ PC+3
	JMP _0xD4
;    1209 			printf("Change Identifier Address\r\n");
	__POINTW1FN _0,3683
	CALL SUBOPT_0x46
;    1210 			printf("Current Identifier Address: $RAD%02d\r\n", Id_address);
	__POINTW1FN _0,3711
	CALL SUBOPT_0x68
;    1211 			printf("Enter New Identifier Address (0-99): ");
	__POINTW1FN _0,3750
	CALL SUBOPT_0x46
;    1212 			
;    1213 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xD6:
	__CPWRN 19,20,20
	BRGE _0xD7
;    1214 			{
;    1215 				msg[i] = getchar();
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x57
;    1216 				printf("%c", msg[i]);
;    1217 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xA)
	BREQ _0xD9
	CALL SUBOPT_0x58
	CPI  R26,LOW(0xD)
	BRNE _0xD8
_0xD9:
;    1218 				{
;    1219 					i--;
	__SUBWRN 19,20,1
;    1220 					break;
	RJMP _0xD7
;    1221 				}
;    1222 			}                        
_0xD8:
	__ADDWRN 19,20,1
	RJMP _0xD6
_0xD7:
;    1223 			if(atoi(msg) > 99 || atoi(msg) < 00)
	CALL SUBOPT_0x69
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRGE _0xDC
	CALL SUBOPT_0x69
	MOVW R26,R30
	SBIW R26,0
	BRGE _0xDB
_0xDC:
;    1224 			{
;    1225 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x5D
;    1226 				break;
	RJMP _0x52
;    1227 			}
;    1228 			else
_0xDB:
;    1229 			{
;    1230 				Id_address = atoi(msg);
	CALL SUBOPT_0x69
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMWRW
;    1231 				printf("\r\nIdentifier String now set to: $RAD%02d\r\n", Id_address); 
	__POINTW1FN _0,3788
	CALL SUBOPT_0x68
;    1232 			}
;    1233 			break;	                                         
	RJMP _0x52
;    1234 		case 'X' :
_0xD4:
	CPI  R30,LOW(0x58)
	BREQ _0xE0
;    1235 		case 'x' :
	CPI  R30,LOW(0x78)
	BRNE _0xE1
_0xE0:
;    1236 			printf("\r\n Returning to operation...\r\n\r\n");
	__POINTW1FN _0,3831
	CALL SUBOPT_0x46
;    1237 			return;  //v13 RETURN FROM THIS S/R 
	RJMP _0x1F4
;    1238 			break;
;    1239 		case 'S' :
_0xE1:
	CPI  R30,LOW(0x53)
	BRNE _0xE2
;    1240 			SampleADC();
	RCALL _SampleADC
;    1241 			break;
	RJMP _0x52
;    1242 		case 'Z' :
_0xE2:
	CPI  R30,LOW(0x5A)
	BREQ _0xE4
;    1243 		case 'z' :
	CPI  R30,LOW(0x7A)
	BRNE _0xE6
_0xE4:
;    1244 			printf("\r\n***** SMART DIGITAL INTERFACE *****\r\n");
	CALL SUBOPT_0xD
;    1245 			printf(" Software Version %s, %s\r\n", version, verdate);
;    1246 			printf(" Current EEPROM values:\r\n");
;    1247 			printf(" Identifier Header= $RAD%02d\r\n", Id_address);
;    1248 			printf(" PSP Coeff= %.2E\r\n", psp);
;    1249 			printf(" PIR Coeff= %.2E\r\n", pir);
	CALL SUBOPT_0xE
;    1250 			printf(" Interval Time (secs)= %d\r\n", looptime);
	CALL SUBOPT_0xF
;    1251 			printf(" Cmax= %d\r\n", Cmax);
	CALL SUBOPT_0x10
;    1252 			printf(" Reference Resistor Case= %.1f\r\n", RrefC);
	CALL SUBOPT_0x11
;    1253 			printf(" Reference Resistor Dome= %.1f\r\n", RrefD);
	CALL SUBOPT_0x12
;    1254 			printf(" Vtherm= %.4f, Vadc= %.4f\r\n", Vtherm, Vadc);
	CALL SUBOPT_0x13
;    1255 			printf(" PIR ADC Offset= %.2f\r\n", PIRadc_offset);
	__POINTW1FN _0,3864
	CALL SUBOPT_0x14
;    1256 			printf(" PIR ADC Gain= %.2f\r\n", PIRadc_gain);
	CALL SUBOPT_0x15
;    1257 			printf(" PSP ADC Offset= %.2f\r\n", PSPadc_offset);
	__POINTW1FN _0,3888
	CALL SUBOPT_0x16
;    1258 			printf(" PSP ADC Gain= %.2f\r\n", PSPadc_gain);
	CALL SUBOPT_0x17
;    1259 			printf("\r\n");
	CALL SUBOPT_0x49
;    1260 			//v15 -- we need to wait here for a character press
;    1261 			break;
	RJMP _0x52
;    1262 			
;    1263 		//v13 INVALID KEY ENTRY -- RE-CALL MENU
;    1264 		default : printf("Invalid key\r\n");
_0xE6:
	__POINTW1FN _0,3912
	CALL SUBOPT_0x46
;    1265 			//v13 printf("\r\n Returning to operation...\r\n\r\n");
;    1266 			Main_Menu();
	CALL _Main_Menu
;    1267 	} // end switch
_0x52:
;    1268 	
;    1269 	//v13 -- recall s/r
;    1270 	Main_Menu();
	CALL _Main_Menu
;    1271 	//printf("Returning to operation...\r\n\r\n");
;    1272 	//return;
;    1273 }	//end menu
_0x1F4:
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;    1274 
;    1275 void SampleADC(void)
;    1276 /********************************************************
;    1277 Test the ADC circuit
;    1278 **********************************************************/
;    1279 {
_SampleADC:
;    1280 	double ddum[8], ddumsq[8];
;    1281 	int i, npts;          
;    1282 	int missing;
;    1283 	
;    1284 	missing = -999;
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR6
;	ddum -> Y+38
;	ddumsq -> Y+6
;	i -> R16,R17
;	npts -> R18,R19
;	missing -> R20,R21
	__GETWRN 20,21,64537
;    1285 
;    1286 	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	CALL SUBOPT_0x18
	__PUTD1SX 66
	__PUTD1SX 62
	__PUTD1S 58
	__PUTD1S 54
	__PUTD1S 50
	__PUTD1S 46
	__PUTD1S 42
	__PUTD1S 38
;    1287 	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	CALL SUBOPT_0x18
	__PUTD1S 34
	__PUTD1S 30
	__PUTD1S 26
	__PUTD1S 22
	__PUTD1S 18
	__PUTD1S 14
	__PUTD1S 10
	CALL SUBOPT_0x6A
;    1288 	npts=0;
	__GETWRN 18,19,0
;    1289 	printf("\r\n");
	CALL SUBOPT_0x49
;    1290 	while( !SerByteAvail() )
_0xE7:
	CALL _SerByteAvail
	SBIW R30,0
	BREQ PC+3
	JMP _0xE9
;    1291 	{
;    1292 		ReadAnalog(ALL);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ReadAnalog
;    1293 		printf("%7d %7d %7d %7d %7d %7d %7d %7d\r\n",
;    1294 		adc[0],adc[1],adc[2],adc[3],
;    1295 		adc[4],adc[5],adc[6],adc[7]);
	__POINTW1FN _0,3926
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc
	LDS  R31,_adc+1
	CALL SUBOPT_0x3B
	__GETW1MN _adc,2
	CALL SUBOPT_0x3B
	__GETW1MN _adc,4
	CALL SUBOPT_0x3B
	__GETW1MN _adc,6
	CALL SUBOPT_0x3B
	__GETW1MN _adc,8
	CALL SUBOPT_0x3B
	__GETW1MN _adc,10
	CALL SUBOPT_0x3B
	__GETW1MN _adc,12
	CALL SUBOPT_0x3B
	__GETW1MN _adc,14
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x6B
;    1296 		for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xEB:
	__CPWRN 16,17,8
	BRLT PC+3
	JMP _0xEC
;    1297 		{
;    1298 			ddum[i] += (double)adc[i];
	CALL SUBOPT_0x6C
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1299 			ddumsq[i] += (double)adc[i] * (double)adc[i];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6D
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1300 		}
	__ADDWRN 16,17,1
	RJMP _0xEB
_0xEC:
;    1301 		npts++;
	__ADDWRN 18,19,1
;    1302 		delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x43
;    1303 		
;    1304 		Heartbeat();
	CALL _Heartbeat
;    1305 	}
	RJMP _0xE7
_0xE9:
;    1306 	printf("\r\n");
	CALL SUBOPT_0x49
;    1307 	for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xEE:
	__CPWRN 16,17,8
	BRGE _0xEF
;    1308 		MeanStdev((ddum+i), (ddumsq+i), npts, missing);
	CALL SUBOPT_0x6C
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,8
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R20
	CALL SUBOPT_0x41
	CALL __PUTPARD1
	RCALL _MeanStdev
;    1309 
;    1310 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n",
	__ADDWRN 16,17,1
	RJMP _0xEE
_0xEF:
;    1311 		ddum[0],ddum[1],ddum[2],ddum[3],
;    1312 		ddum[4],ddum[5],ddum[6],ddum[7]);
	__POINTW1FN _0,3960
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6E
	__GETD1SX 72
	CALL __PUTPARD1
	__GETD1SX 80
	CALL __PUTPARD1
	__GETD1SX 88
	CALL __PUTPARD1
	__GETD1SX 96
	CALL __PUTPARD1
	CALL SUBOPT_0x6B
;    1313 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n\r\n",
;    1314 		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
;    1315 		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
	__POINTW1FN _0,4010
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6F
	CALL __PUTPARD1
	__GETD1S 16
	CALL __PUTPARD1
	__GETD1S 24
	CALL __PUTPARD1
	__GETD1S 32
	CALL __PUTPARD1
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x6B
;    1316 		
;    1317 		Heartbeat();
	CALL _Heartbeat
;    1318 	return;
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
;    1319 }
;    1320 
;    1321 void	MeanStdev(double *sum, double *sum2, int N, double missing)
;    1322 /********************************************
;    1323 Compute mean and standard deviation from the count, the sum and the sum of squares.
;    1324 991101
;    1325 Note that the mean and standard deviation are computed from the sum and the sum of 
;    1326 squared values and are returned in the same memory location.
;    1327 *********************************************/
;    1328 {
_MeanStdev:
;    1329 	if( N <= 2 )
;	*sum -> Y+8
;	*sum2 -> Y+6
;	N -> Y+4
;	missing -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRGE _0xF0
;    1330 	{
;    1331 		*sum = missing;
	CALL SUBOPT_0x6
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __PUTDP1
;    1332 		*sum2 = missing;
	CALL SUBOPT_0x6
	RJMP _0x1F8
;    1333 	}
;    1334 	else
_0xF0:
;    1335 	{
;    1336 		*sum /= (double)N;		// mean value
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	PUSH R27
	PUSH R26
	CALL __GETD1P
	CALL SUBOPT_0x70
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1337 		*sum2 = *sum2/(double)N - (*sum * *sum); // sumsq/N - mean^2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x70
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x4
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
;    1338 		*sum2 = *sum2 * (double)N / (double)(N-1); // (N/N-1) correction
	CALL SUBOPT_0x9
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x41
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	CALL SUBOPT_0x41
	CALL SUBOPT_0x7
;    1339 		if( *sum2 < 0 ) *sum2 = 0;
	CALL SUBOPT_0x9
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRGE _0xF2
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x18
	RJMP _0x1F9
;    1340 		else *sum2 = sqrt(*sum2);
_0xF2:
	CALL SUBOPT_0x9
	CALL __PUTPARD1
	CALL _sqrt
_0x1F8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
_0x1F9:
	CALL __PUTDP1
;    1341 	}
;    1342 	return;
	RJMP _0x1F3
;    1343 }
;    1344 void ReadAnalog( int chan )
;    1345 /************************************************************
;    1346 Read 12 bit analog A/D Converter Max186
;    1347 ************************************************************/
;    1348 {
_ReadAnalog:
;    1349 	int i;
;    1350 	if( chan == ALL )
	ST   -Y,R17
	ST   -Y,R16
;	chan -> Y+2
;	i -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0xF4
;    1351 	{
;    1352 		for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0xF6:
	__CPWRN 16,17,8
	BRGE _0xF7
;    1353 		{	
;    1354 			adc[i] = Read_Max186(i, 0);
	MOVW R30,R16
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x1F
	CALL _Read_Max186
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1355 		}
	__ADDWRN 16,17,1
	RJMP _0xF6
_0xF7:
;    1356 	}
;    1357 	else if( chan >= 0 && chan <=7 )
	RJMP _0xF8
_0xF4:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,0
	BRLT _0xFA
	SBIW R26,8
	BRLT _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
;    1358 	{
;    1359 		adc[chan] = Read_Max186(chan, 0);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x23
	CALL _Read_Max186
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1360 	}
;    1361     return;
_0xF9:
_0xF8:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1362 } 
;    1363     
;    1364 #include "PIR.h"
;    1365 
;    1366 /*******************************************************************************************/
;    1367 
;    1368 void PirTcTd2LW(double vp, double kp, double PIRadc_offset, double PIRadc_gain, double tc, double td, double k, 
;    1369 	double *lw, double *C_c, double *C_d)
;    1370 /**********************************************************
;    1371 %input  // v15 -- enhanced comments
;    1372 %  vp = output in counts of thew ADC circuit.  In ADC counts.
;    1373 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1374 %  PIRadc_offset = the constant (B) in a straight line fit of 
;    1375 %     vp = M * v_pir + B
;    1376 %  PIRadc_gain = M, the gain term.
;    1377 %     The thermopile net radiance is given by (v_pir / kp), but
;    1378 %     if a preamp is used, then the measured voltage vp = B + M * vp'
;    1379 %     where vp' is the actual voltage on the thermopile.
;    1380 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1381 %  e = thermopile computed flux in W/m^2 
;    1382 %  tc = case degC 
;    1383 %  td = dome degC 
;    1384 %  k = calib coef, usually = 4.
;    1385 %  no arguments ==> test mode
;    1386 %output
;    1387 %  lw = corrected longwave flux, W/m^2
;    1388 %  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
;    1389 %000928 changes eps to 0.98 per {fairall98}
;    1390 %010323 back to 1.0 per Fairall
;    1391 % v15 -- tweak the code for the RAD operation
;    1392 /**********************************************************/
;    1393 {
_PirTcTd2LW:
;    1394 	double Tc,Td;
;    1395 	double sigma=5.67e-8;
;    1396 	double eps = 1;
;    1397 	double x,y;
;    1398 	double e; // w/m^2 on the thermopile
;    1399 	
;    1400 	// THERMOPILE IRRADIANCE
;    1401 	e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
	SBIW R28,28
	LDI  R24,8
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	LDI  R30,LOW(_0xFC*2)
	LDI  R31,HIGH(_0xFC*2)
	CALL __INITLOCB
;	vp -> Y+58
;	kp -> Y+54
;	PIRadc_offset -> Y+50
;	PIRadc_gain -> Y+46
;	tc -> Y+42
;	td -> Y+38
;	k -> Y+34
;	*lw -> Y+32
;	*C_c -> Y+30
;	*C_d -> Y+28
;	Tc -> Y+24
;	Td -> Y+20
;	sigma -> Y+16
;	eps -> Y+12
;	x -> Y+8
;	y -> Y+4
;	e -> Y+0
	__GETD2S 50
	__GETD1S 58
	CALL __SUBF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 46
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 54
	CALL SUBOPT_0x5
;    1402 	//printf("PirTcTd2LW: e = %.4e\r\n", e);
;    1403 	
;    1404 	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
;    1405 	Tc = tc + Tabs;
	CALL SUBOPT_0x72
	__GETD2S 42
	CALL __ADDF12
	__PUTD1S 24
;    1406 	Td = td + Tabs;
	CALL SUBOPT_0x72
	__GETD2S 38
	CALL __ADDF12
	CALL SUBOPT_0x30
;    1407 	x = Tc * Tc * Tc * Tc; // Tc^4
	__GETD1S 24
	CALL SUBOPT_0x73
	CALL SUBOPT_0x73
	CALL SUBOPT_0x73
	CALL SUBOPT_0x74
;    1408 	y = Td * Td * Td * Td; // Td^4
	__GETD1S 20
	CALL SUBOPT_0x75
	CALL SUBOPT_0x75
	CALL SUBOPT_0x75
	CALL SUBOPT_0x3F
;    1409 	
;    1410 	// Corrections
;    1411 	*C_c = eps * sigma * x;
	__GETD1S 16
	CALL SUBOPT_0x1
	CALL __MULF12
	CALL SUBOPT_0x50
	CALL __MULF12
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __PUTDP1
;    1412 	*C_d =  - k * sigma * (y - x);
	__GETD1S 34
	CALL __ANEGF1
	__GETD2S 16
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x50
	CALL SUBOPT_0x40
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CALL __PUTDP1
;    1413 	
;    1414 	// Final computation
;    1415 	*lw = e + *C_c + *C_d;
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __GETD1P
	CALL SUBOPT_0x8
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	LDD  R26,Y+32
	LDD  R27,Y+32+1
	CALL __PUTDP1
;    1416 	
;    1417 	return;
	ADIW R28,62
	RET
;    1418 }
;    1419 double SteinhartHart(double C[], double R) 
;    1420 /*************************************************************/
;    1421 // Uses the Steinhart-Hart equations to compute the temperature 
;    1422 // in degC from thermistor resistance.  
;    1423 // See http://www.betatherm.com/stein.htm
;    1424 //The Steinhart-Hart thermistor equation is named for two oceanographers 
;    1425 //associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
;    1426 //The first publication of the equation was by I.S. Steinhart & S.R. Hart 
;    1427 //in "Deep Sea Research" vol. 15 p. 497 (1968).
;    1428 //S-S coeficients are
;    1429 // either computed from calibrations or tests, or are provided by 
;    1430 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1431 // the S-S coefficients.
;    1432 //
;    1433 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1434 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1435 //  Tc = Tk - 273.15;
;    1436 //example
;    1437 // C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
;    1438 // ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
;    1439 // ysi46041, matlab steinharthart_fit()
;    1440 // R = 25000;     Tc = 25.00C
;    1441 // rmr 050128
;    1442 /*************************************************************/
;    1443 {
_SteinhartHart:
;    1444 	double x;
;    1445 //	double Tabs = 273.15;  // defined elsewhere
;    1446 
;    1447 	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
;    1448 	
;    1449 	x = log(R);
	SBIW R28,4
;	*C -> Y+8
;	R -> Y+4
;	x -> Y+0
	CALL SUBOPT_0x40
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x4F
;    1450 	x = C[0] + x * ( C[1] + C[2] * x * x );
	CALL SUBOPT_0x4
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	__GETD2Z 4
	PUSH R25
	PUSH R24
	PUSH R27
	PUSH R26
	__GETD2Z 8
	CALL SUBOPT_0x6
	CALL __MULF12
	CALL SUBOPT_0x8
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x8
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x4F
;    1451 	x = 1/x - Tabs;
	CALL SUBOPT_0x6
	CALL SUBOPT_0x52
	CALL __DIVF21
	LDS  R26,_Tabs
	LDS  R27,_Tabs+1
	LDS  R24,_Tabs+2
	LDS  R25,_Tabs+3
	CALL __SUBF12
	CALL SUBOPT_0x4F
;    1452 	
;    1453 	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
;    1454 	return x;
	CALL SUBOPT_0x6
_0x1F3:
	ADIW R28,10
	RET
;    1455 }
;    1456 
;    1457 

_abs:
    ld   r30,y+
    ld   r31,y+
    sbiw r30,0
    brpl __abs0
    com  r30
    com  r31
    adiw r30,1
__abs0:
    ret
_log:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x76
	CALL __CPD02
	BRLT _0xFD
	__GETD1N 0xFF7FFFFF
	RJMP _0x1F2
_0xFD:
	CALL SUBOPT_0xA
	CALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x76
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0xFE
	CALL SUBOPT_0xA
	CALL SUBOPT_0x76
	CALL __ADDF12
	CALL SUBOPT_0x6A
	__SUBWRN 16,17,1
_0xFE:
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	CALL SUBOPT_0x2
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0xA
	CALL SUBOPT_0x52
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x6A
	CALL SUBOPT_0xA
	CALL SUBOPT_0x76
	CALL __MULF12
	CALL SUBOPT_0x42
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x2
	CALL SUBOPT_0x76
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 2
	__GETD1N 0x3FD4114D
	CALL SUBOPT_0x2
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	__GETD2N 0x3F317218
	CALL SUBOPT_0x41
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x1F2:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G6:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0xFF
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0x100
_0xFF:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0x100:
	ADIW R28,3
	RET
__print_G6:
	SBIW R28,12
	CALL __SAVELOCR6
	LDI  R16,0
_0x101:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	ADIW R30,1
	STD  Y+22,R30
	STD  Y+22+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x103
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x107
	CPI  R19,37
	BRNE _0x108
	LDI  R16,LOW(1)
	RJMP _0x109
_0x108:
	CALL SUBOPT_0x78
_0x109:
	RJMP _0x106
_0x107:
	CPI  R30,LOW(0x1)
	BRNE _0x10A
	CPI  R19,37
	BRNE _0x10B
	CALL SUBOPT_0x78
	RJMP _0x1FA
_0x10B:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x10C
	LDI  R17,LOW(1)
	RJMP _0x106
_0x10C:
	CPI  R19,43
	BRNE _0x10D
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x106
_0x10D:
	CPI  R19,32
	BRNE _0x10E
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x106
_0x10E:
	RJMP _0x10F
_0x10A:
	CPI  R30,LOW(0x2)
	BRNE _0x110
_0x10F:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x111
	ORI  R17,LOW(128)
	RJMP _0x106
_0x111:
	RJMP _0x112
_0x110:
	CPI  R30,LOW(0x3)
	BRNE _0x113
_0x112:
	CPI  R19,48
	BRLO _0x115
	CPI  R19,58
	BRLO _0x116
_0x115:
	RJMP _0x114
_0x116:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x106
_0x114:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x117
	LDI  R16,LOW(4)
	RJMP _0x106
_0x117:
	RJMP _0x118
_0x113:
	CPI  R30,LOW(0x4)
	BRNE _0x11A
	CPI  R19,48
	BRLO _0x11C
	CPI  R19,58
	BRLO _0x11D
_0x11C:
	RJMP _0x11B
_0x11D:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x106
_0x11B:
_0x118:
	CPI  R19,108
	BRNE _0x11E
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x106
_0x11E:
	RJMP _0x11F
_0x11A:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x106
_0x11F:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x124
	CALL SUBOPT_0x79
	LD   R30,X
	CALL SUBOPT_0x7A
	RJMP _0x125
_0x124:
	CPI  R30,LOW(0x73)
	BRNE _0x127
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7B
	CALL _strlen
	MOV  R16,R30
	RJMP _0x128
_0x127:
	CPI  R30,LOW(0x70)
	BRNE _0x12A
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7B
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x128:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x12C
	CP   R21,R16
	BRLO _0x12D
_0x12C:
	RJMP _0x12B
_0x12D:
	MOV  R16,R21
_0x12B:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x12E
_0x12A:
	CPI  R30,LOW(0x64)
	BREQ _0x131
	CPI  R30,LOW(0x69)
	BRNE _0x132
_0x131:
	ORI  R17,LOW(4)
	RJMP _0x133
_0x132:
	CPI  R30,LOW(0x75)
	BRNE _0x134
_0x133:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x135
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x74
	LDI  R16,LOW(10)
	RJMP _0x136
_0x135:
	__GETD1N 0x2710
	CALL SUBOPT_0x74
	LDI  R16,LOW(5)
	RJMP _0x136
_0x134:
	CPI  R30,LOW(0x58)
	BRNE _0x138
	ORI  R17,LOW(8)
	RJMP _0x139
_0x138:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x177
_0x139:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x13B
	__GETD1N 0x10000000
	CALL SUBOPT_0x74
	LDI  R16,LOW(8)
	RJMP _0x136
_0x13B:
	__GETD1N 0x1000
	CALL SUBOPT_0x74
	LDI  R16,LOW(4)
_0x136:
	CPI  R21,0
	BREQ _0x13C
	ANDI R17,LOW(127)
	RJMP _0x13D
_0x13C:
	LDI  R21,LOW(1)
_0x13D:
	SBRS R17,1
	RJMP _0x13E
	CALL SUBOPT_0x79
	CALL __GETD1P
	RJMP _0x1FB
_0x13E:
	SBRS R17,2
	RJMP _0x140
	CALL SUBOPT_0x79
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x1FB
_0x140:
	CALL SUBOPT_0x79
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x1FB:
	__PUTD1S 12
	SBRS R17,2
	RJMP _0x142
	CALL SUBOPT_0x1
	CALL __CPD20
	BRGE _0x143
	CALL SUBOPT_0x7C
	CALL __ANEGD1
	CALL SUBOPT_0x0
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x143:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x144
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x145
_0x144:
	ANDI R17,LOW(251)
_0x145:
_0x142:
	MOV  R18,R21
_0x12E:
	SBRC R17,0
	RJMP _0x146
_0x147:
	CP   R16,R20
	BRSH _0x14A
	CP   R18,R20
	BRLO _0x14B
_0x14A:
	RJMP _0x149
_0x14B:
	SBRS R17,7
	RJMP _0x14C
	SBRS R17,2
	RJMP _0x14D
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0x14E
_0x14D:
	LDI  R19,LOW(48)
_0x14E:
	RJMP _0x14F
_0x14C:
	LDI  R19,LOW(32)
_0x14F:
	CALL SUBOPT_0x78
	SUBI R20,LOW(1)
	RJMP _0x147
_0x149:
_0x146:
_0x150:
	CP   R16,R21
	BRSH _0x152
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x153
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x7A
	CPI  R20,0
	BREQ _0x154
	SUBI R20,LOW(1)
_0x154:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x153:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x7A
	CPI  R20,0
	BREQ _0x155
	SUBI R20,LOW(1)
_0x155:
	SUBI R21,LOW(1)
	RJMP _0x150
_0x152:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x156
_0x157:
	CPI  R18,0
	BREQ _0x159
	SBRS R17,3
	RJMP _0x15A
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x1FC
_0x15A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x1FC:
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G6
	CPI  R20,0
	BREQ _0x15C
	SUBI R20,LOW(1)
_0x15C:
	SUBI R18,LOW(1)
	RJMP _0x157
_0x159:
	RJMP _0x15D
_0x156:
_0x15F:
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x1
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x161
	SBRS R17,3
	RJMP _0x162
	SUBI R19,-LOW(55)
	RJMP _0x163
_0x162:
	SUBI R19,-LOW(87)
_0x163:
	RJMP _0x164
_0x161:
	SUBI R19,-LOW(48)
_0x164:
	SBRC R17,4
	RJMP _0x166
	CPI  R19,49
	BRSH _0x168
	CALL SUBOPT_0x50
	__CPD2N 0x1
	BRNE _0x167
_0x168:
	RJMP _0x16A
_0x167:
	CP   R21,R18
	BRLO _0x16B
	RJMP _0x1FD
_0x16B:
	CP   R20,R18
	BRLO _0x16D
	SBRS R17,0
	RJMP _0x16E
_0x16D:
	RJMP _0x16C
_0x16E:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x16F
_0x1FD:
	LDI  R19,LOW(48)
_0x16A:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x170
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x7A
	CPI  R20,0
	BREQ _0x171
	SUBI R20,LOW(1)
_0x171:
_0x170:
_0x16F:
_0x166:
	CALL SUBOPT_0x78
	CPI  R20,0
	BREQ _0x172
	SUBI R20,LOW(1)
_0x172:
_0x16C:
	SUBI R18,LOW(1)
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x1
	CALL __MODD21U
	CALL SUBOPT_0x0
	LDD  R30,Y+16
	CALL SUBOPT_0x50
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x74
	CALL SUBOPT_0x6F
	CALL __CPD10
	BREQ _0x160
	RJMP _0x15F
_0x160:
_0x15D:
	SBRS R17,0
	RJMP _0x173
_0x174:
	CPI  R20,0
	BREQ _0x176
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x7A
	RJMP _0x174
_0x176:
_0x173:
_0x177:
_0x125:
_0x1FA:
	LDI  R16,LOW(0)
_0x106:
	RJMP _0x101
_0x103:
	CALL __LOADLOCR6
	ADIW R28,24
	RET
_printf:
	PUSH R15
	CALL SUBOPT_0x7D
	CALL __print_G6
	RJMP _0x1F0
__get_G6:
	ST   -Y,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x178
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x179
_0x178:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x17A
	CALL __GETW1P
	LD   R30,Z
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x17B
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x17B:
	RJMP _0x17C
_0x17A:
	CALL _getchar
	MOV  R16,R30
_0x17C:
_0x179:
	MOV  R30,R16
	LDD  R16,Y+0
	ADIW R28,5
	RET
__scanf_G6:
	SBIW R28,7
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	STD  Y+11,R30
	STD  Y+12,R30
_0x17D:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ADIW R30,1
	STD  Y+17,R30
	STD  Y+17+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x17F
	CALL SUBOPT_0x7E
	BREQ _0x180
_0x181:
	CALL SUBOPT_0x7F
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x184
	CALL SUBOPT_0x7E
	BRNE _0x185
_0x184:
	RJMP _0x183
_0x185:
	RJMP _0x181
_0x183:
	STD  Y+12,R18
	RJMP _0x186
_0x180:
	CPI  R18,37
	BREQ PC+3
	JMP _0x187
	LDI  R20,LOW(0)
_0x188:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
	CPI  R18,48
	BRLO _0x18C
	CPI  R18,58
	BRLO _0x18B
_0x18C:
	RJMP _0x18A
_0x18B:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x188
_0x18A:
	CPI  R18,0
	BRNE _0x18E
	RJMP _0x17F
_0x18E:
_0x18F:
	CALL SUBOPT_0x7F
	MOV  R19,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BRNE _0x18F
	CPI  R19,0
	BRNE _0x192
	RJMP _0x193
_0x192:
	STD  Y+12,R19
	CPI  R20,0
	BRNE _0x194
	LDI  R20,LOW(255)
_0x194:
	LDI  R21,LOW(0)
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x198
	CALL SUBOPT_0x80
	CALL SUBOPT_0x7F
	MOVW R26,R16
	ST   X,R30
	RJMP _0x197
_0x198:
	CPI  R30,LOW(0x73)
	BRNE _0x199
	CALL SUBOPT_0x80
_0x19A:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x19C
	CALL SUBOPT_0x7F
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x19E
	CALL SUBOPT_0x7E
	BREQ _0x19D
_0x19E:
	RJMP _0x19C
_0x19D:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R18
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x19A
_0x19C:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x197
_0x199:
	CPI  R30,LOW(0x6C)
	BRNE _0x1A1
	LDI  R21,LOW(1)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
_0x1A1:
	LDI  R30,LOW(1)
	STD  Y+10,R30
	MOV  R30,R18
	CPI  R30,LOW(0x64)
	BREQ _0x1A6
	CPI  R30,LOW(0x69)
	BRNE _0x1A7
_0x1A6:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	RJMP _0x1A8
_0x1A7:
	CPI  R30,LOW(0x75)
	BRNE _0x1A9
_0x1A8:
	LDI  R19,LOW(10)
	RJMP _0x1A4
_0x1A9:
	CPI  R30,LOW(0x78)
	BRNE _0x1AA
	LDI  R19,LOW(16)
	RJMP _0x1A4
_0x1AA:
	CPI  R30,LOW(0x25)
	BRNE _0x1AD
	RJMP _0x1AC
_0x1AD:
	LDD  R30,Y+11
	RJMP _0x1F1
_0x1A4:
	__CLRD1S 6
_0x1AE:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1B0
	CALL SUBOPT_0x7F
	MOV  R18,R30
	CPI  R30,LOW(0x21)
	BRLO _0x1B2
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x1B3
	CPI  R18,45
	BRNE _0x1B4
	LDI  R30,LOW(255)
	STD  Y+10,R30
	RJMP _0x1AE
_0x1B4:
	LDI  R30,LOW(1)
	STD  Y+10,R30
_0x1B3:
	CPI  R18,48
	BRLO _0x1B2
	CPI  R18,97
	BRLO _0x1B7
	SUBI R18,LOW(87)
	RJMP _0x1B8
_0x1B7:
	CPI  R18,65
	BRLO _0x1B9
	SUBI R18,LOW(55)
	RJMP _0x1BA
_0x1B9:
	SUBI R18,LOW(48)
_0x1BA:
_0x1B8:
	CP   R18,R19
	BRLO _0x1BB
_0x1B2:
	STD  Y+12,R18
	RJMP _0x1B0
_0x1BB:
	MOV  R30,R19
	CALL SUBOPT_0x76
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R18
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ADDD12
	CALL SUBOPT_0x6A
	RJMP _0x1AE
_0x1B0:
	LDD  R30,Y+10
	CALL SUBOPT_0x76
	CALL __CBD1
	CALL __MULD12U
	CALL SUBOPT_0x6A
	CPI  R21,0
	BREQ _0x1BC
	CALL SUBOPT_0x80
	CALL SUBOPT_0xA
	MOVW R26,R16
	CALL __PUTDP1
	RJMP _0x1BD
_0x1BC:
	CALL SUBOPT_0x80
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x1BD:
_0x197:
	LDD  R30,Y+11
	SUBI R30,-LOW(1)
	STD  Y+11,R30
	RJMP _0x1BE
_0x187:
_0x1AC:
	CALL SUBOPT_0x7F
	CP   R30,R18
	BREQ _0x1BF
_0x193:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x1C0
	LDI  R30,LOW(255)
	RJMP _0x1F1
_0x1C0:
	RJMP _0x17F
_0x1BF:
_0x1BE:
_0x186:
	RJMP _0x17D
_0x17F:
	LDD  R30,Y+11
_0x1F1:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
_scanf:
	PUSH R15
	CALL SUBOPT_0x7D
	CALL __scanf_G6
_0x1F0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
_atoi:
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
	ST   -Y,R30
	CALL _isspace
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
	ST   -Y,R30
	CALL _isdigit
   	tst  r30
   	breq __atoi6
   	mov  r30,r22
   	mov  r31,r23
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	mov  r30,r22
   	mov  r31,r23
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
_atof:
	SBIW R28,10
	CALL __SAVELOCR6
	__CLRD1S 8
_0x1C1:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x1C3
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1C1
_0x1C3:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R20,43
	BRNE _0x1C4
	RJMP _0x1FE
_0x1C4:
	CPI  R20,45
	BRNE _0x1C6
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x1FE:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1C6:
	LDI  R30,LOW(0)
	MOV  R21,R30
	MOV  R20,R30
	__GETWRS 16,17,16
_0x1C7:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BRNE _0x1CA
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R20,R30
	CPI  R30,0
	BREQ _0x1C9
_0x1CA:
	OR   R21,R20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1C7
_0x1C9:
	__GETWRS 18,19,16
	CPI  R21,0
	BREQ _0x1CC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1CD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x1CF
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	SUBI R30,LOW(48)
	RCALL SUBOPT_0x50
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0x5F
	CALL __DIVF21
	RCALL SUBOPT_0x74
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1CD
_0x1CF:
_0x1CC:
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x0
_0x1D0:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x1D2
	LD   R30,X
	SUBI R30,LOW(48)
	RCALL SUBOPT_0x1
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	CALL __MULF12
	RCALL SUBOPT_0x50
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x81
	RJMP _0x1D0
_0x1D2:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R20,X
	CPI  R20,101
	BREQ _0x1D4
	CPI  R20,69
	BREQ _0x1D4
	RJMP _0x1D3
_0x1D4:
	LDI  R30,LOW(0)
	MOV  R21,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R20,X
	CPI  R20,43
	BRNE _0x1D6
	RJMP _0x1FF
_0x1D6:
	CPI  R20,45
	BRNE _0x1D8
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x1FF:
	__ADDWRN 18,19,1
_0x1D8:
_0x1D9:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x1DB
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R20
	SUBI R30,LOW(48)
	MOV  R21,R30
	RJMP _0x1D9
_0x1DB:
	CPI  R21,39
	BRLO _0x1DC
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x1DD
	__GETD1N 0xFF7FFFFF
	RJMP _0x1EF
_0x1DD:
	__GETD1N 0x7F7FFFFF
	RJMP _0x1EF
_0x1DC:
	LDI  R20,LOW(32)
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x0
_0x1DE:
	CPI  R20,0
	BREQ _0x1E0
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x0
	MOV  R30,R21
	AND  R30,R20
	BREQ _0x1E1
	RCALL SUBOPT_0x81
_0x1E1:
	LSR  R20
	RJMP _0x1DE
_0x1E0:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x1E2
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x50
	CALL __DIVF21
	RJMP _0x200
_0x1E2:
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x50
	CALL __MULF12
_0x200:
	__PUTD1S 8
_0x1D3:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x1E4
	RCALL SUBOPT_0x6F
	CALL __ANEGF1
	RCALL SUBOPT_0x74
_0x1E4:
	RCALL SUBOPT_0x6F
_0x1EF:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x1E5:
	SBIS 0xE,7
	RJMP _0x1E5
	IN   R30,0xF
	ADIW R28,1
	RET
_rtc_init:
	LD   R30,Y
	ANDI R30,LOW(0x3)
	ST   Y,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x1E8
	LD   R30,Y
	ORI  R30,LOW(0xA0)
	ST   Y,R30
_0x1E8:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x1E9
	LD   R30,Y
	ORI  R30,4
	RJMP _0x201
_0x1E9:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x1EB
	LD   R30,Y
	ORI  R30,8
	RJMP _0x201
_0x1EB:
	LDI  R30,LOW(0)
_0x201:
	ST   Y,R30
	RCALL SUBOPT_0x82
	LDI  R30,LOW(144)
	ST   -Y,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x83
	RJMP _0x1ED
_rtc_get_time:
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x84
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x84
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(129)
	RCALL SUBOPT_0x84
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RJMP _0x1EE
_rtc_set_time:
	RCALL SUBOPT_0x82
	LDI  R30,LOW(132)
	RCALL SUBOPT_0x85
	LDI  R30,LOW(130)
	RCALL SUBOPT_0x86
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x87
	RJMP _0x1ED
_rtc_get_date:
	LDI  R30,LOW(135)
	RCALL SUBOPT_0x84
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(137)
	RCALL SUBOPT_0x84
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(141)
	RCALL SUBOPT_0x84
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
_0x1EE:
	ADIW R28,6
	RET
_rtc_set_date:
	RCALL SUBOPT_0x82
	LDI  R30,LOW(134)
	RCALL SUBOPT_0x85
	LDI  R30,LOW(136)
	RCALL SUBOPT_0x86
	LDI  R30,LOW(140)
	RCALL SUBOPT_0x87
_0x1ED:
	ADIW R28,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x0
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL __DIVF21
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __DIVF21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0xD:
	__POINTW1FN _0,16
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0,56
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_version)
	LDI  R31,HIGH(_version)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(_verdate)
	LDI  R31,HIGH(_verdate)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	__POINTW1FN _0,83
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0,109
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,140
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,159
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 51 TIMES, CODE SIZE REDUCTION:197 WORDS
SUBOPT_0xE:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	__POINTW1FN _0,178
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	__POINTW1FN _0,206
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__POINTW1FN _0,218
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	__POINTW1FN _0,251
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13:
	__POINTW1FN _0,284
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__POINTW1FN _0,339
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	__POINTW1FN _0,388
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	__PUTD1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	__PUTD1SX 68
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	__PUTD1SX 72
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	__PUTD1SX 76
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _rtc_get_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__GETD2SX 76
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	__GETD2SX 72
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	__GETD2SX 68
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x25:
	__GETD2SX 64
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	CALL __GETD1P
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	CALL __PUTPARD1
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2F:
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,52
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,50
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,48
	ST   -Y,R31
	ST   -Y,R30
	CALL _therm_circuit_ground
	__GETD1S 28
	CALL __PUTPARD1
	__GETD1S 28
	CALL __PUTPARD1
	JMP  _ysi46000

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	__GETD1S 36
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _rtc_get_date

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x38:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x39:
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R10
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x3A:
	MOV  R30,R4
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R5
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R6
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3C:
	CALL __PUTPARD1
	__GETD1SX 62
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	CALL _Read_Max186
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x41:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x42:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(_version)
	LDI  R31,HIGH(_version)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(_verdate)
	LDI  R31,HIGH(_verdate)
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:257 WORDS
SUBOPT_0x46:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x39

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x49:
	__POINTW1FN _0,53
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4A:
	LSL  R18
	ROL  R19
	LSR  R21
	ROR  R20
	LSR  R21
	ROR  R20
	LSR  R21
	ROR  R20
	MOVW R30,R18
	CALL __LSLW4
	ADD  R30,R20
	ADC  R31,R21
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	__GETD2S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	CALL __ADDF12
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4E:
	__GETD1S 12
	RCALL SUBOPT_0x1
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x50:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	RCALL SUBOPT_0x32
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x53:
	MOV  R30,R4
	LDI  R31,0
	LDI  R26,LOW(3600)
	LDI  R27,HIGH(3600)
	CALL __MULW12U
	MOVW R22,R30
	MOV  R26,R5
	LDI  R30,LOW(60)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R22
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x54:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _scanf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x55:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x27
	CALL __CWD1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x56:
	__GETW1R 19,20
	MOVW R26,R28
	ADIW R26,13
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x57:
	ST   X,R30
	__POINTW1FN _0,2212
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,15
	ADD  R26,R19
	ADC  R27,R20
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x58:
	MOVW R26,R28
	ADIW R26,13
	ADD  R26,R19
	ADC  R27,R20
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x59:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	RCALL _atof
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5A:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	RJMP _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD1N 0x33D6BF95
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5D:
	__POINTW1FN _0,2360
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__GETD1N 0x43FA0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x62:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x2D
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	__GETD1N 0x471C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	__GETD1N 0x459C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x31
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x68:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x69:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6A:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	LDI  R24,32
	CALL _printf
	ADIW R28,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,38
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6D:
	MOVW R30,R16
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RJMP SUBOPT_0x41

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x6E:
	__GETD1S 40
	CALL __PUTPARD1
	__GETD1S 48
	CALL __PUTPARD1
	__GETD1S 56
	CALL __PUTPARD1
	__GETD1SX 64
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6F:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x41
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x72:
	LDS  R30,_Tabs
	LDS  R31,_Tabs+1
	LDS  R22,_Tabs+2
	LDS  R23,_Tabs+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	RCALL SUBOPT_0x4C
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x74:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	__GETD2S 20
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x76:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x78:
	ST   -Y,R19
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G6

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x79:
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	SBIW R26,4
	STD  Y+20,R26
	STD  Y+20+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7A:
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7B:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x7D:
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,0
	STD  Y+2,R30
	STD  Y+2+1,R30
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	ST   -Y,R18
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x7F:
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __get_G6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x80:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	SBIW R26,4
	STD  Y+15,R26
	STD  Y+15+1,R27
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x81:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x5F
	CALL __MULF12
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x82:
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x83:
	ST   -Y,R30
	CALL _ds1302_write
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x84:
	ST   -Y,R30
	CALL _ds1302_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x85:
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x86:
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x87:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _bin2bcd
	RJMP SUBOPT_0x83

_isdigit:
	ldi  r30,1
	ld   r31,y+
	cpi  r31,'0'
	brlo __isdigit0
	cpi  r31,'9'+1
	brlo __isdigit1
__isdigit0:
	clr  r30
__isdigit1:
	ret

_isspace:
	ldi  r30,1
	ld   r31,y+
	cpi  r31,' '
	breq __isspace1
	cpi  r31,9
	brlo __isspace0
	cpi  r31,14
	brlo __isspace1
__isspace0:
	clr  r30
__isspace1:
	ret

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x39A
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

_bcd2bin:
	ld   r30,y
	swap r30
	andi r30,0xf
	mov  r26,r30
	lsl  r26
	lsl  r26
	add  r30,r26
	lsl  r30
	ld   r26,y+
	andi r26,0xf
	add  r30,r26
	ret

_bin2bcd:
	ld   r26,y+
	clr  r30
__bin2bcd0:
	subi r26,10
	brmi __bin2bcd1
	subi r30,-16
	rjmp __bin2bcd0
__bin2bcd1:
	subi r26,-10
	add  r30,r26
	ret

_ds1302_read:
	ld   r30,y+
	sbr  r30,1
	rcall __ds1302_write0
	cbi  __ds1302_port,__ds1302_io
	cbi  __ds1302_port-1,__ds1302_io
	ldi  r26,8
__ds1302_read0:
	clc
	sbic __ds1302_port-2,__ds1302_io
	sec
	ror  r30
	sbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x2
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x2
	dec  r26
	brne __ds1302_read0
__ds1302_rst0:
	cbi  __ds1302_port,__ds1302_rst
	__DELAY_USB 0x6
	ret

_ds1302_write:
	ldd  r30,y+1
	cbr  r30,1
	rcall __ds1302_write0
	ld   r30,y
	rcall __ds1302_write1
	adiw r28,2
	rjmp __ds1302_rst0

__ds1302_write0:
	sbi  __ds1302_port-1,__ds1302_sclk
	sbi  __ds1302_port-1,__ds1302_io
	sbi  __ds1302_port-1,__ds1302_rst
	sbi  __ds1302_port,__ds1302_rst
	__DELAY_USB 0x6
__ds1302_write1:
	ldi  r26,8
__ds1302_write2:
	ror  r30
	cbi  __ds1302_port,__ds1302_io
	brcc __ds1302_write3
	sbi  __ds1302_port,__ds1302_io
__ds1302_write3:
	nop
	nop
	nop
	nop
	sbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x2
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x2
	dec  r26
	brne __ds1302_write2
	ret

_sqrt:
	sbiw r28,4
	push r21
	ldd  r25,y+7
	tst  r25
	brne __sqrt0
	adiw r28,8
	rjmp __zerores
__sqrt0:
	brpl __sqrt1
	adiw r28,8
	rjmp __maxres
__sqrt1:
	push r20
	ldi  r20,66
	ldd  r24,y+6
	ldd  r27,y+5
	ldd  r26,y+4
__sqrt2:
	st   y,r24
	std  y+1,r25
	std  y+2,r26
	std  y+3,r27
	movw r30,r26
	movw r22,r24
	ldd  r26,y+4
	ldd  r27,y+5
	ldd  r24,y+6
	ldd  r25,y+7
	rcall __divf21
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	rcall __addf12
	rcall __unpack1
	dec  r23
	rcall __repack
	ld   r24,y
	ldd  r25,y+1
	ldd  r26,y+2
	ldd  r27,y+3
	eor  r26,r30
	andi r26,0xf8
	brne __sqrt4
	cp   r27,r31
	cpc  r24,r22
	cpc  r25,r23
	breq __sqrt3
__sqrt4:
	dec  r20
	breq __sqrt3
	movw r26,r30
	movw r24,r22
	rjmp __sqrt2
__sqrt3:
	pop  r20
	pop  r21
	adiw r28,8
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

__ANEGD1:
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQB12:
	CP   R30,R26
	LDI  R30,1
	BREQ __EQB12T
	CLR  R30
__EQB12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R19
	CLR  R20
	LDI  R21,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R19
	ROL  R20
	SUB  R0,R30
	SBC  R1,R31
	SBC  R19,R22
	SBC  R20,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R19,R22
	ADC  R20,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R21
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOV  R24,R19
	MOV  R25,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOV  R23,R31
	MOV  R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOV  R0,R30
	MOV  R1,R31
	MOV  R30,R22
	MOV  R31,R23
	RCALL __EEPROMWRW
	MOV  R30,R0
	MOV  R31,R1
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	MOV  R21,R30
	MOV  R30,R26
	MOV  R26,R21
	MOV  R21,R31
	MOV  R31,R27
	MOV  R27,R21
	MOV  R21,R22
	MOV  R22,R24
	MOV  R24,R21
	MOV  R21,R23
	MOV  R23,R25
	MOV  R25,R21
	MOV  R21,R0
	MOV  R0,R1
	MOV  R1,R21
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF129
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __REPACK
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __MAXRES
	RJMP __MINRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	LSR  R22
	ROR  R31
	ROR  R30
	LSR  R24
	ROR  R27
	ROR  R26
	PUSH R20
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R25,24
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R1
	ROL  R20
	ROL  R21
	ROL  R26
	ROL  R27
	ROL  R24
	DEC  R25
	BRNE __DIVF212
	MOV  R30,R1
	MOV  R31,R20
	MOV  R22,R21
	LSR  R26
	ADC  R30,R25
	ADC  R31,R25
	ADC  R22,R25
	POP  R20
	TST  R22
	BRMI __DIVF215
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD20:
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:

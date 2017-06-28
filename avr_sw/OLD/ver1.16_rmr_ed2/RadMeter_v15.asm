
;CodeVisionAVR C Compiler V1.25.1 Standard
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 3.686400 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : long, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
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

	.INCLUDE "RadMeter_v15.vec"
	.INCLUDE "RadMeter_v15.inc"

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
;       1 //*** reynolds comments lines
;       2 // v13 :: search on 'v13' to see changes and coments.
;       3 // v15 :: rmr edits to RE version 14.  See "v15" or "//v15" for chgs.
;       4 /*********************************************
;       5 This program was produced by the
;       6 CodeWizardAVR V1.23.8c Standard
;       7 Automatic Program Generator
;       8 © Copyright 1998-2003 HP InfoTech s.r.l.
;       9 http://www.hpinfotech.ro
;      10 e-mail:office@hpinfotech.ro
;      11 
;      12 Project : NOAA Radiometer Interface Board
;      13 Version : 
;      14 Date    : 12/20/2004
;      15 Author  : Ray Edwards                     
;      16 Company : Brookhaven National Laboratory  
;      17 Comments: Revision History
;      18 	1.0 - Start with simple timed operation 12/22/04 
;      19     1.1 - Build user menu and implement eeprom variables 03/24/05
;      20     1.13 - Bigelow mods.  see "v13" comments
;      21       * spread out the print statement a bit.
;      22       * timeout in Main_Menu
;      23       
;      24 //*** search on these comments     
;      25 /********************************************
;      26 Chip type           : ATmega64
;      27 Program type        : Application
;      28 Clock frequency     : 8.000000 MHz
;      29 Memory model        : Small
;      30 External SRAM size  : 0
;      31 Data Stack size     : 1024
;      32 *********************************************/
;      33 //*** REVISION B NOV 2007    
;      34 /********************************************
;      35 Chip type           : ATmega128
;      36 Program type        : Application
;      37 Clock frequency     : 16.000000 MHz
;      38 Memory model        : Small
;      39 External SRAM size  : 0
;      40 Data Stack size     : 1024
;      41 *********************************************/
;      42 #include <delay.h>
;      43 #include <stdio.h>
;      44 #include <stdlib.h> 
;      45 #include <spi.h> 
;      46 #include <math.h>
;      47 #include "thermistor.h"
;      48 #include "pir.h"
;      49 #include "psp.h"
;      50 #include <mega128.h>
;      51 #include <eeprom.h>
;      52 #include <ds1302.h>
;      53 
;      54 // DS1302 Real Time Clock port init
;      55 #asm
;      56    .equ __ds1302_port=0x18
   .equ __ds1302_port=0x18
;      57    .equ __ds1302_io=4
   .equ __ds1302_io=4
;      58    .equ __ds1302_sclk=5
   .equ __ds1302_sclk=5
;      59    .equ __ds1302_rst=6
   .equ __ds1302_rst=6
;      60 #endasm
;      61 
;      62 #define RXB8 	1
;      63 #define TXB8 	0
;      64 #define UPE 	2
;      65 #define OVR 	3
;      66 #define FE 	    4
;      67 #define UDRE 	5
;      68 #define RXC 	7
;      69 #define BATT	7
;      70 #define PCTEMP	6
;      71 #define VREF	5  
;      72 #define ALL	    8       
;      73 #define NSAMPS	100
;      74 #define NCHANS	8
;      75 
;      76 // watchdog WDTCR register bit positions and mask
;      77 #define WDCE   (4)  // Watchdog Turn-off Enable
;      78 #define WDE     (3)  // Watchdog Enable
;      79 #define PMASK   (7)  // prescaler mask    
;      80 #define WATCHDOG_PRESCALE (7)    
;      81 //#define XTAL	16000000
;      82 #define XTAL 3686400
;      83 #define BAUD	19200  //default terminal setting
;      84 #define OK	1
;      85 #define NOTOK	0 
;      86 #define FRAMING_ERROR (1<<FE)
;      87 #define PARITY_ERROR (1<<UPE)
;      88 #define DATA_OVERRUN (1<<OVR)
;      89 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      90 #define RX_COMPLETE (1<<RXC)
;      91 #define MENU_TIMEOUT 30
;      92 //v15
;      93 #define VERSION "1.15"
;      94 #define VERDATE "2008/06/25"
;      95 
;      96 // Get a character from the USART1 Receiver
;      97 #pragma used+
;      98 char getchar1(void)
;      99 {

	.CSEG
;     100 char status,data;
;     101 while (1)
;	status -> R16
;	data -> R17
;     102       {
;     103       while (((status=UCSR1A) & RX_COMPLETE)==0);
;     104       data=UDR1;
;     105       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;     106          return data;
;     107       };
;     108 }
;     109 #pragma used-
;     110 
;     111 // Write a character to the USART1 Transmitter
;     112 #pragma used+
;     113 void putchar1(char c)
;     114 {
;     115 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
;     116 UDR1=c;
;     117 }
;     118 #pragma used-
;     119 
;     120 //PROTOTYPES
;     121 void ATMega128_Setup(void);
;     122 void SignOn(void);
;     123 float ReadBattVolt(void);
;     124 float ReadRefVolt(void); 
;     125 float ReadAVRTemp();
;     126 void Heartbeat(void);
;     127 int SerByteAvail(void);  
;     128 int ClearScreen(void);
;     129 int Read_Max186(int, int); 
;     130 float RL10052Temp (unsigned int v2, int ref, int res);
;     131 void Main_Menu(void);
;     132 void ReadAnalog( int chan );
;     133 void MeanStdev(double *sum, double *sum2, int N, double missing);
;     134 void SampleADC(void);
;     135 
;     136 //GLOBAL VARIABLES
;     137 //COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
;     138 float COEFFA = 	.0033540172; 

	.DSEG
_COEFFA:
	.BYTE 0x4
;     139 float COEFFB = 	.00032927261; 
_COEFFB:
	.BYTE 0x4
;     140 float COEFFC =	.0000041188325;
_COEFFC:
	.BYTE 0x4
;     141 float COEFFD = -.00000016472972;
_COEFFD:
	.BYTE 0x4
;     142 
;     143 unsigned char h, m, s, now, then;
;     144 unsigned char dt, mon, yr;
;     145 int state;
;     146 unsigned char version[10] = "1.15";  //v15
_version:
	.BYTE 0xA
;     147 unsigned char verdate[20] = "2008/06/25";  //v15 
_verdate:
	.BYTE 0x14
;     148 double Tabs = 273.15;
_Tabs:
	.BYTE 0x4
;     149 int adc[NCHANS];   
_adc:
	.BYTE 0x10
;     150 
;     151 //SETUP EEPROM VARIABLES AND INITIALIZE
;     152 eeprom float psp = 7.72E-6;			//PSP COEFF

	.ESEG
_psp:
	.DW  0x8526
	.DW  0x3701
;     153 eeprom float pir = 3.68E-6;			//PIR COEFF
_pir:
	.DW  0xF5EB
	.DW  0x3676
;     154 eeprom int looptime = 10;			//NMEA OUTPUT SCHEDULE
_looptime:
	.DW  0xA
;     155 eeprom int Cmax = 2048;				//A/D COUNTS MAX VALUE
_Cmax:
	.DW  0x800
;     156 eeprom float RrefC = 33042.0; 		//CASE REFERENCE RESISTOR VALUE
_RrefC:
	.DW  0x1200
	.DW  0x4701
;     157 eeprom float RrefD = 33046.0;     	//DOME REFERENCE RESISTOR VALUE
_RrefD:
	.DW  0x1600
	.DW  0x4701
;     158 eeprom float Vtherm = 4.0963;		//THERMISTOR SUPPLY VOLTAGE
_Vtherm:
	.DW  0x14E4
	.DW  0x4083
;     159 eeprom float Vadc = 4.0960;			//A/D REFERENCE VOLTAGE 
_Vadc:
	.DW  0x126F
	.DW  0x4083
;     160 // v15 -- note this offset is in mv as it is subtracted from the 
;     161 // from the ADC count.  Same for PSPadc_offset
;     162 eeprom float PIRadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PIRadc_offset:
	.DW  0x0
	.DW  0x0
;     163 eeprom float PIRadc_gain = 815.0;
_PIRadc_gain:
	.DW  0xC000
	.DW  0x444B
;     164 eeprom float PSPadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PSPadc_offset:
	.DW  0x0
	.DW  0x0
;     165 eeprom float PSPadc_gain = 125.0;
_PSPadc_gain:
	.DW  0x0
	.DW  0x42FA
;     166 eeprom int   Id_address = 00;		//$RAD** address $RAD00 is default
_Id_address:
	.DW  0x0
;     167 
;     168 
;     169 /******************************************************************************************
;     170 MAIN
;     171 ******************************************************************************************/
;     172 void main(void)
;     173 {

	.CSEG
_main:
;     174 
;     175 	int ADC0_mV, ADC1_mV, cx1, cx2;  
;     176 	int nsamps;             
;     177 	double BattV, AVRTemp, RefV;
;     178 	double vt, Rt, Pt;
;     179 	double Tc, Td;
;     180 	double tcase, tdome;
;     181 	double sw, lw, C_c, C_d;
;     182 	double pir_cum, psp_cum;
;     183  	
;     184 	state = 0;
	SBIW R28,63
	SBIW R28,5
;	ADC0_mV -> R16,R17
;	ADC1_mV -> R18,R19
;	cx1 -> R20,R21
;	cx2 -> Y+66
;	nsamps -> Y+64
;	BattV -> Y+60
;	AVRTemp -> Y+56
;	RefV -> Y+52
;	vt -> Y+48
;	Rt -> Y+44
;	Pt -> Y+40
;	Tc -> Y+36
;	Td -> Y+32
;	tcase -> Y+28
;	tdome -> Y+24
;	sw -> Y+20
;	lw -> Y+16
;	C_c -> Y+12
;	C_d -> Y+8
;	pir_cum -> Y+4
;	psp_cum -> Y+0
	CLR  R12
	CLR  R13
;     185 	Cmax = 2048;
	LDI  R30,LOW(2048)
	LDI  R31,HIGH(2048)
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMWRW
;     186 	
;     187     ATMega128_Setup();
	RCALL _ATMega128_Setup
;     188     SignOn();
	RCALL _SignOn
;     189     Heartbeat();
	RCALL _Heartbeat
;     190     
;     191 	printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
	CALL SUBOPT_0x0
;     192 	printf(" Software Version %s, %s\n\r", version, verdate);
;     193 	printf(" Current EEPROM values:\n\r");
;     194 	printf(" Identifier Header= $RAD%02d\n\r", Id_address);
;     195 	printf(" PSP Coeff= %.2E\n\r", psp);
;     196 	printf(" PIR Coeff= %.2E\n\r", pir);
	CALL SUBOPT_0x1
;     197 	printf(" Interval Time (secs)= %d\n\r", looptime);
	CALL SUBOPT_0x2
;     198 	printf(" Cmax= %d\n\r", Cmax);
	CALL SUBOPT_0x3
;     199 	printf(" Reference Resistor Case= %.1f\n\r", RrefC);
	CALL SUBOPT_0x4
;     200 	printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
	CALL SUBOPT_0x5
;     201 	printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
	CALL SUBOPT_0x6
;     202 	printf(" PIR ADC Offset= %.2f mv\n\r", PIRadc_offset);
	__POINTW1FN _0,312
	CALL SUBOPT_0x7
;     203 	printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
	CALL SUBOPT_0x8
;     204 	printf(" PSP ADC Offset= %.2f mv\n\r", PSPadc_offset);
	__POINTW1FN _0,361
	CALL SUBOPT_0x9
;     205 	printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
	CALL SUBOPT_0xA
;     206 	putchar('\n');
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
;     207 	putchar('\r');
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
;     208 	//*** check, do we want <cr><lf> or <lf><cr> ??
;     209 	// v15, the end of an output line will be <cr><lf>
;     210 	
;     211 	//Heartbeat();
;     212 	//*** why no heartbeat? 
;     213     
;     214     // SETUP FOR TIMED OPERATION
;     215     rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0xB
;     216     now = s;       
;     217     nsamps = 1;
	CALL SUBOPT_0xC
;     218     psp_cum = 0;
	__CLRD1S 0
;     219 
;     220 	while (1)
_0x12:
;     221 	{
;     222 		// TEMPS, VOLTAGES
;     223 		BattV = ReadBattVolt();  
	RCALL _ReadBattVolt
	__PUTD1S 60
;     224 		RefV = ReadRefVolt();
	RCALL _ReadRefVolt
	__PUTD1S 52
;     225 		AVRTemp = ReadAVRTemp();
	RCALL _ReadAVRTemp
	__PUTD1S 56
;     226   		
;     227 		// CALCULATE CASE TEMPERATURE
;     228 		cx1 = ( Read_Max186(2,0) );
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xD
	MOVW R20,R30
;     229 		// v15 -- Change Vtherm to Vadc.  The two are the same and generated by Max186.
;     230 		therm_circuit_ground(cx1, Cmax, RrefC, Vadc, Vadc, &vt, &Rt, &Pt);
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
;     231 		Tc = ysi46000(Rt,Pt);
	__PUTD1S 36
;     232 		tcase += Tc;
	CALL SUBOPT_0x13
	CALL __ADDF12
	CALL SUBOPT_0x14
;     233 	
;     234 		// CALCULATE DOME TEMPERATURE
;     235 		cx2 = ( Read_Max186(3,0) );
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xD
	__PUTW1SX 66
;     236 		// v15 -- Change Vtherm to Vadc.  The two are the same and generated by Max186.
;     237 		therm_circuit_ground(cx2, Cmax, RrefD, Vadc, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(66))
	SBCI R27,HIGH(-(66))
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	CALL SUBOPT_0xF
	CALL SUBOPT_0x16
	CALL SUBOPT_0x11
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
;     238 		Td = ysi46000(Rt,Pt);
	__PUTD1S 32
;     239 		tdome += Td;
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
;     240 		
;     241 		//CALCULATE LW (PIR)
;     242 		//v15, Note the count from the max186 is used for volts.
;     243 		// This assumes the Vref = 4.096.  This is not exactly right.
;     244 		// However, we will be fitting v_in and adc so any differences are 
;     245 		// accounted for.
;     246 		ADC1_mV = ( Read_Max186(1,0) ); 	//PIR Sig
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xD
	MOVW R18,R30
;     247 		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, Tc, Td, 4.0, &lw, &C_c, &C_d);
	MOVW R30,R18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	__GETD1N 0x40800000
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,44
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,42
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,40
	ST   -Y,R31
	ST   -Y,R30
	CALL _PirTcTd2LW
;     248 		pir_cum += lw;
	CALL SUBOPT_0x1E
	__GETD2S 4
	CALL __ADDF12
	CALL SUBOPT_0x1F
;     249 					
;     250 		//CALCULATE SW (PSP)
;     251 		//v15, Note the count from the max186 is used for volts.
;     252 		// This assumes the Vref = 4.096.  This is not exactly right.
;     253 		ADC0_mV = ( Read_Max186(0,0) ); 	//PSP Sig 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xD
	CALL SUBOPT_0x20
;     254 		PSPSW( ADC0_mV, psp, PSPadc_offset, PSPadc_gain, &sw);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	CALL _PSPSW
;     255 		psp_cum += sw; 
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
;     256 			
;     257 			//Diagnostic Printout
;     258  //           	printf("PIRmV= %d, CasemV= %d, DomemV= %d, PSPmV= %d\n\r",
;     259  //          			ADC1_mV, cx1, cx2, ADC0_mV);
;     260 //              printf("then= %d, now= %d\n\r", then, now);
;     261 		
;     262 		rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0xB
;     263 		now = s;
;     264 		//
;     265 		if( abs((int)now - (int)then) >= looptime ) 
	MOV  R26,R7
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
	BRSH PC+3
	JMP _0x15
;     266 		{   
;     267 			//OUTPUT STRING
;     268 			pir_cum = pir_cum/nsamps;     //avg pir sig
	CALL SUBOPT_0x28
	__GETD2S 4
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1F
;     269 			tcase = tcase/nsamps;         //avg case temp pir
	CALL SUBOPT_0x28
	CALL SUBOPT_0x13
	CALL SUBOPT_0x29
	CALL SUBOPT_0x14
;     270 			tdome = tdome/nsamps;         //avg dome temp pir
	CALL SUBOPT_0x28
	CALL SUBOPT_0x17
	CALL SUBOPT_0x29
	__PUTD1S 24
;     271 			psp_cum = psp_cum/nsamps;     //avg psp sig
	CALL SUBOPT_0x28
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
;     272 			rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x2B
;     273 			rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2C
;     274 			// if(h > 12) h = h - 12;  //12 hour clock
;     275 			//v13 I opened up the print statement a bit.
;     276 			printf("\n\r$RAD%02d,%02d/%02d/%02d,%02d:%02d:%02d,%4d,%4d,%6.2f,%6.2f,%6.2f,%7.2f,%5.1f,%5.1f\n\r", 
;     277 			   Id_address, yr, mon, dt, h, m, s, nsamps, ADC1_mV, pir_cum, tcase, tdome, psp_cum, AVRTemp, BattV);
	__POINTW1FN _0,410
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	__GETW1SX 94
	CALL SUBOPT_0x30
	MOVW R30,R18
	CALL SUBOPT_0x30
	__GETD1S 42
	CALL SUBOPT_0x31
	CALL SUBOPT_0x31
	CALL __PUTPARD1
	__GETD1S 50
	CALL __PUTPARD1
	__GETD1SX 110
	CALL __PUTPARD1
	__GETD1SX 118
	CALL __PUTPARD1
	LDI  R24,60
	CALL _printf
	ADIW R28,62
;     278 	   		
;     279 			rtc_get_time(&h,&m,&s); 
	CALL SUBOPT_0x2C
;     280 			then = s;
	MOV  R8,R6
;     281 			nsamps = 1;
	CALL SUBOPT_0xC
;     282 			Heartbeat();                	   	
	RCALL _Heartbeat
;     283 		}
;     284 		nsamps++;
_0x15:
	MOVW R26,R28
	SUBI R26,LOW(-(64))
	SBCI R27,HIGH(-(64))
	CALL SUBOPT_0x32
;     285 		//Check for menu call
;     286 		if( SerByteAvail() && getchar() == 'T' ) Main_Menu();
	RCALL _SerByteAvail
	SBIW R30,0
	BREQ _0x17
	CALL _getchar
	CPI  R30,LOW(0x54)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
	RCALL _Main_Menu
;     287 
;     288 	}; //*** why the semicolon?  This is probably unnecessary 
_0x16:
	RJMP _0x12
;     289 } 
_0x19:
	RJMP _0x19
;     290 
;     291 /******************** PROGRAM FUNCTIONS ***********************************/
;     292 /**************************************************************************/
;     293 
;     294 float ReadAVRTemp(void)
;     295 /**********************************************
;     296 	Returns Temperature on Board in DegC
;     297 **********************************************/
;     298 {  
_ReadAVRTemp:
;     299 	int RefVMilliVolts, AVRVMilliVolts;
;     300 	float AVRTemp;
;     301 	
;     302     RefVMilliVolts = ( Read_Max186(VREF, 1) );
	SBIW R28,4
	CALL __SAVELOCR4
;	RefVMilliVolts -> R16,R17
;	AVRVMilliVolts -> R18,R19
;	AVRTemp -> Y+4
	CALL SUBOPT_0x33
	MOVW R16,R30
;     303 	AVRVMilliVolts = ( Read_Max186(PCTEMP, 1) );
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x34
	MOVW R18,R30
;     304 	AVRTemp = RL10052Temp(AVRVMilliVolts, (RefVMilliVolts*2), 10010);
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
	CALL SUBOPT_0x1F
;     305 	
;     306 	return AVRTemp;
	CALL SUBOPT_0x35
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;     307 }
;     308 
;     309 float ReadBattVolt(void)
;     310 /**********************************************
;     311 	Returns Main Power Input in Volts
;     312 **********************************************/
;     313 { 
_ReadBattVolt:
;     314 	int BattVMilliVolts;
;     315 	float BattV;
;     316 	
;     317 	BattVMilliVolts = ( Read_Max186(BATT, 1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	BattVMilliVolts -> R16,R17
;	BattV -> Y+2
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x34
	CALL SUBOPT_0x20
;     318  	BattV = ((BattVMilliVolts)/100.0) + 1.2;
	CALL SUBOPT_0x36
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F99999A
	CALL __ADDF12
	CALL SUBOPT_0x37
;     319  	
;     320  	return BattV;
	RJMP _0x224
;     321 }
;     322 
;     323 
;     324 float ReadRefVolt(void)
;     325 /**********************************************
;     326 	Returns A/D Reference Voltage in Volts
;     327 **********************************************/
;     328 { 
_ReadRefVolt:
;     329 	int RefVMilliVolts;
;     330 	float RefV;
;     331 	
;     332 	RefVMilliVolts = ( Read_Max186(VREF,1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	RefVMilliVolts -> R16,R17
;	RefV -> Y+2
	CALL SUBOPT_0x33
	CALL SUBOPT_0x20
;     333  	RefV = ((RefVMilliVolts * 2) /1000);
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
;     334  	
;     335  	return RefV;
_0x224:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     336 }
;     337 
;     338 void Heartbeat(void)
;     339 /*************************************
;     340 Heartbeat on PortE bit 2
;     341 *************************************/
;     342 {
_Heartbeat:
;     343 	
;     344 	PORTE=0X04;
	LDI  R30,LOW(4)
	OUT  0x3,R30
;     345 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x38
;     346 	PORTE=0X00; 
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     347 	delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x38
;     348 }
	RET
;     349 
;     350 void SignOn(void)
;     351 /********************************************
;     352  PROGRAM START
;     353 ********************************************/
;     354 {
_SignOn:
;     355 	ClearScreen();
	RCALL _ClearScreen
;     356 	
;     357 	printf("\n\r\n\rSIGNON RADIOMETER INTERFACE V%s, %s\n\r", version, verdate);   //v1.14
	__POINTW1FN _0,497
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
;     358 	printf("\n\rDigital Interface Board - Rev B. Nov 2007\n\r");
	__POINTW1FN _0,539
	CALL SUBOPT_0x3B
;     359 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2C
;     360 	
;     361 	printf("Program Start time is: %02d:%02d:%02d\n\r", h, m, s);
	__POINTW1FN _0,585
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x3C
;     362 	rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x2B
;     363 	printf("Program Start date is: %02d/%02d/%02d\n\r", yr, mon, dt);
	__POINTW1FN _0,625
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
;     364 	printf("\n\rHit 'T' for Main Menu.\n\r"); 
	__POINTW1FN _0,665
	CALL SUBOPT_0x3B
;     365     printf("\n\r");
	CALL SUBOPT_0x3E
;     366 }
	RET
;     367 
;     368 void ATMega128_Setup(void)
;     369 /*************************************
;     370 Initialization for AVR ATMega128 chip
;     371 *************************************/
;     372 {   
_ATMega128_Setup:
;     373 	// Input/Output Ports initialization
;     374 	// Port A initialization
;     375 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     376 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     377 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     378 	DDRA=0x00;
	OUT  0x1A,R30
;     379 	
;     380 	// Port C initialization
;     381 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     382 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     383 	PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
;     384 	DDRC=0x03;
	OUT  0x14,R30
;     385 	
;     386 	// Port D initialization
;     387 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     388 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     389 	PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     390 	DDRD=0x00;
	OUT  0x11,R30
;     391 	
;     392 	// Port E initialization
;     393 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     394 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     395 	PORTE=0x00;
	OUT  0x3,R30
;     396 	DDRE=0x04;
	LDI  R30,LOW(4)
	OUT  0x2,R30
;     397 	
;     398 	// Port F initialization
;     399 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     400 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     401 	PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;     402 	DDRF=0x00;
	STS  97,R30
;     403 	
;     404 	// Port G initialization
;     405 	// Func0=In Func1=In Func2=In Func3=In Func4=In 
;     406 	// State0=T State1=T State2=T State3=T State4=T 
;     407 	PORTG=0x00;
	STS  101,R30
;     408 	DDRG=0x00;
	STS  100,R30
;     409 	
;     410 	// Timer/Counter 0 initialization
;     411 	// Clock source: System Clock
;     412 	// Clock value: Timer 0 Stopped
;     413 	// Mode: Normal top=FFh
;     414 	// OC0 output: Disconnected
;     415 	ASSR=0x00;
	OUT  0x30,R30
;     416 	TCCR0=0x00;
	OUT  0x33,R30
;     417 	TCNT0=0x00;
	OUT  0x32,R30
;     418 	OCR0=0x00;
	OUT  0x31,R30
;     419 	
;     420 	// Timer/Counter 1 initialization
;     421 	// Clock source: System Clock
;     422 	// Clock value: Timer 1 Stopped
;     423 	// Mode: Normal top=FFFFh
;     424 	// OC1A output: Discon.
;     425 	// OC1B output: Discon.
;     426 	// OC1C output: Discon.
;     427 	// Noise Canceler: Off
;     428 	// Input Capture on Falling Edge
;     429 	TCCR1A=0x00;
	OUT  0x2F,R30
;     430 	TCCR1B=0x00;
	OUT  0x2E,R30
;     431 	TCNT1H=0x00;
	OUT  0x2D,R30
;     432 	TCNT1L=0x00;
	OUT  0x2C,R30
;     433 	OCR1AH=0x00;
	OUT  0x2B,R30
;     434 	OCR1AL=0x00;
	OUT  0x2A,R30
;     435 	OCR1BH=0x00;
	OUT  0x29,R30
;     436 	OCR1BL=0x00;
	OUT  0x28,R30
;     437 	OCR1CH=0x00;
	STS  121,R30
;     438 	OCR1CL=0x00;
	STS  120,R30
;     439 	
;     440 	// Timer/Counter 2 initialization
;     441 	// Clock source: System Clock
;     442 	// Clock value: Timer 2 Stopped
;     443 	// Mode: Normal top=FFh
;     444 	// OC2 output: Disconnected
;     445 	TCCR2=0x00;
	OUT  0x25,R30
;     446 	TCNT2=0x00;
	OUT  0x24,R30
;     447 	OCR2=0x00;
	OUT  0x23,R30
;     448 	
;     449 	// Timer/Counter 3 initialization
;     450 	// Clock source: System Clock
;     451 	// Clock value: Timer 3 Stopped
;     452 	// Mode: Normal top=FFFFh
;     453 	// OC3A output: Discon.
;     454 	// OC3B output: Discon.
;     455 	// OC3C output: Discon.
;     456 	TCCR3A=0x00;
	STS  139,R30
;     457 	TCCR3B=0x00;
	STS  138,R30
;     458 	TCNT3H=0x00;
	STS  137,R30
;     459 	TCNT3L=0x00;
	STS  136,R30
;     460 	OCR3AH=0x00;
	STS  135,R30
;     461 	OCR3AL=0x00;
	STS  134,R30
;     462 	OCR3BH=0x00;
	STS  133,R30
;     463 	OCR3BL=0x00;
	STS  132,R30
;     464 	OCR3CH=0x00;
	STS  131,R30
;     465 	OCR3CL=0x00;
	STS  130,R30
;     466 	
;     467 	// External Interrupt(s) initialization
;     468 	// INT0: Off
;     469 	// INT1: Off
;     470 	// INT2: Off
;     471 	// INT3: Off
;     472 	// INT4: Off
;     473 	// INT5: Off
;     474 	// INT6: Off
;     475 	// INT7: Off
;     476 	EICRA=0x00;
	STS  106,R30
;     477 	EICRB=0x00;
	OUT  0x3A,R30
;     478 	EIMSK=0x00;
	OUT  0x39,R30
;     479 	
;     480 	// Timer(s)/Counter(s) Interrupt(s) initialization
;     481 	TIMSK=0x00;
	OUT  0x37,R30
;     482 	ETIMSK=0x00;
	STS  125,R30
;     483 	
;     484 	// USART0 initialization
;     485 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     486 	// USART0 Receiver: On
;     487 	// USART0 Transmitter: On
;     488 	// USART0 Mode: Asynchronous
;     489 	// USART0 Baud rate: 19200
;     490 	UCSR0A=0x00;
	OUT  0xB,R30
;     491 	UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     492 	UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     493 	UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;     494 	UBRR0L=XTAL/16/BAUD-1;
	LDI  R30,LOW(11)
	OUT  0x9,R30
;     495 	
;     496 	// USART1 initialization
;     497 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     498 	// USART1 Receiver: On
;     499 	// USART1 Transmitter: On
;     500 	// USART1 Mode: Asynchronous
;     501 	// USART1 Baud rate: 9600
;     502 	UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;     503 	UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
;     504 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     505 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     506 	UBRR1L=0x33;
	LDI  R30,LOW(51)
	STS  153,R30
;     507 	
;     508 	// Analog Comparator initialization
;     509 	// Analog Comparator: Off
;     510 	// Analog Comparator Input Capture by Timer/Counter 1: Off
;     511 	// Analog Comparator Output: Off
;     512 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     513 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     514 	
;     515 	// Port B initialization
;     516 	PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
;     517 	DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;     518 	
;     519 	// SPI initialization
;     520 	// SPI Type: Master
;     521 	// SPI Clock Rate: 1MHz
;     522 	// SPI Clock Phase: 1
;     523 	// SPI Clock Polarity: 0
;     524 	// SPI Data Order: MSB First
;     525 	// SETUP for MAX186 on SPI
;     526 	//SPCR = (1<<SPE) | (1<<MSTR) ; // SPI enable, Master mode, 1MHz Clk
;     527 	SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     528 	SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0xE,R30
;     529 	
;     530 	// DS1302 Real Time Clock initialization
;     531 	// Trickle charger: Off
;     532 	rtc_init(0,0,0); 
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
;     533 	
;     534 }  
	RET
;     535 
;     536 int SerByteAvail(void)
;     537 /********************************
;     538 Check the serial port for characters
;     539 returns a 1 if true 0 for not true
;     540 *********************************/
;     541 {   
_SerByteAvail:
;     542 	if (UCSR0A >= 0x7f)
	IN   R30,0xB
	CPI  R30,LOW(0x7F)
	BRLO _0x1A
;     543 	{
;     544 	    //printf("Character found!\n\r");
;     545 		return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
;     546 	}
;     547 	 return 0;
_0x1A:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
;     548 }      
;     549 
;     550 int ClearScreen(void)
;     551 /*********************************************
;     552 Routine to clear the terminal screen.
;     553 **********************************************/
;     554 { 
_ClearScreen:
;     555 	int i; 
;     556 	i=0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
;     557 	while (i<25)
_0x1B:
	__CPWRN 16,17,25
	BRGE _0x1D
;     558 	{
;     559 		printf("\n\r");
	CALL SUBOPT_0x3E
;     560 		i++;
	__ADDWRN 16,17,1
;     561 	} 
	RJMP _0x1B
_0x1D:
;     562 	return OK;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LD   R16,Y+
	LD   R17,Y+
	RET
;     563 }
;     564 
;     565 int Read_Max186(int channel, int mode)
;     566 /**************************************************
;     567 Routine to read external Max186 A-D Converter.
;     568 Control word sets Unipolar mode, Single-Ended Input,
;     569 External Clock.
;     570 Mode: 	0 = Bipolar (-VRef/2 to +VRef/2)
;     571  		1 = Unipolar ( 0 to VRef )		
;     572 **************************************************/
;     573 {
_Read_Max186:
;     574 	unsigned int rb1, rb2, rb3;
;     575 	int data_out;
;     576 	long din;
;     577 	
;     578 	data_out=0;
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
;     579 	rb1=rb2=rb3=0; 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R20,R30
	MOVW R18,R30
	MOVW R16,R30
;     580 	
;     581 	if (mode == 1) //DO UNIPOLAR (0 - VREF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x1E
;     582 	{
;     583 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x1F
;     584 			din=0x8F;		// 10001111
	__GETD1N 0x8F
	RJMP _0x225
;     585 		else if(channel==1)
_0x1F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x21
;     586 			din=0xCF;		// 11001111
	__GETD1N 0xCF
	RJMP _0x225
;     587 		else if(channel==2)
_0x21:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x23
;     588 			din=0x9F;		// 10011111
	__GETD1N 0x9F
	RJMP _0x225
;     589 		else if(channel==3)
_0x23:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x25
;     590 			din=0xDF;		// 11011111
	__GETD1N 0xDF
	RJMP _0x225
;     591 		else if(channel==4)
_0x25:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x27
;     592 			din=0xAF;		// 10101111
	__GETD1N 0xAF
	RJMP _0x225
;     593 		else if(channel==5)
_0x27:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x29
;     594 			din=0xEF;		// 11101111
	__GETD1N 0xEF
	RJMP _0x225
;     595 		else if(channel==6)
_0x29:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x2B
;     596 			din=0xBF;		// 10111111
	__GETD1N 0xBF
	RJMP _0x225
;     597 		else if(channel==7)
_0x2B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x2D
;     598 			din=0xFF;	 	// 11111111
	__GETD1N 0xFF
_0x225:
	__PUTD1S 6
;     599 	} 
_0x2D:
;     600 	else	//DO BIPOLAR (-VREF/2 - +VREF/2)
	RJMP _0x2E
_0x1E:
;     601 	{
;     602 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x2F
;     603 			din=0x87;		// 10000111
	__GETD1N 0x87
	RJMP _0x226
;     604 		else if(channel==1)
_0x2F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x31
;     605 			din=0xC7;		// 11000111
	__GETD1N 0xC7
	RJMP _0x226
;     606 		else if(channel==2)
_0x31:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x33
;     607 			din=0x97;		// 10010111
	__GETD1N 0x97
	RJMP _0x226
;     608 		else if(channel==3)
_0x33:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x35
;     609 			din=0xD7;		// 11010111
	__GETD1N 0xD7
	RJMP _0x226
;     610 		else if(channel==4)
_0x35:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x37
;     611 			din=0xA7;		// 10100111
	__GETD1N 0xA7
	RJMP _0x226
;     612 		else if(channel==5)
_0x37:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x39
;     613 			din=0xE7;		// 11100111
	__GETD1N 0xE7
	RJMP _0x226
;     614 		else if(channel==6)
_0x39:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x3B
;     615 			din=0xB7;		// 10110111
	__GETD1N 0xB7
	RJMP _0x226
;     616 		else if(channel==7)
_0x3B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x3D
;     617 			din=0xF7;	 	// 11110111
	__GETD1N 0xF7
_0x226:
	__PUTD1S 6
;     618 	}
_0x3D:
_0x2E:
;     619     
;     620 	// START A-D
;     621 	PORTB = 0x07;
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     622 	PORTB = 0x06; 	//Selects CS- lo 
	LDI  R30,LOW(6)
	OUT  0x18,R30
;     623 	
;     624 	// Send control byte ch7, Uni, Sgl, ext clk
;     625 	rb1 = ( spi(din) );		//Sends the coversion code from above
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _spi
	MOV  R16,R30
	CLR  R17
;     626 	// Send/Rcv HiByte
;     627 	rb2 = ( spi(0x00) );		//Receive byte 2 (MSB) 
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R18,R30
	CLR  R19
;     628 	// Send/Rcv LoByte
;     629 	rb3 = ( spi(0x00) );		//Receive byte 3 (LSB)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R20,R30
	CLR  R21
;     630 		
;     631 	PORTB = 0x07;		//Selects CS- hi
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     632     
;     633 	// Calculation to counts
;     634 	if(mode == 1) //UNIPOLAR
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x3E
;     635 	{
;     636 		rb2 = rb2 << 1;
	CALL SUBOPT_0x3F
;     637 		rb3 = rb3 >> 3;
;     638 		data_out = ( (rb2*16) + rb3 ) ;
;     639 	}
;     640 	else if(mode == 0) //BIPOLAR
	RJMP _0x3F
_0x3E:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x40
;     641 	{
;     642 		rb2 = rb2 << 1;
	CALL SUBOPT_0x3F
;     643 		rb3 = rb3 >> 3;
;     644 		data_out = ((rb2*16) + rb3);
;     645 		if(data_out >= 2048) data_out -= 4096;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0x800)
	LDI  R30,HIGH(0x800)
	CPC  R27,R30
	BRLT _0x41
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(4096)
	SBCI R31,HIGH(4096)
	STD  Y+10,R30
	STD  Y+10+1,R31
;     646 	}
_0x41:
;     647 	else {  // v15 we need this.
	RJMP _0x42
_0x40:
;     648 		data_out = 0;
	LDI  R30,0
	STD  Y+10,R30
	STD  Y+10+1,R30
;     649 	}
_0x42:
_0x3F:
;     650 			
;     651 	//printf("Data Out= %d\n\r", data_out);   
;     652 	
;     653 	
;     654 	return data_out;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;     655 }   
;     656 
;     657 
;     658 float RL10052Temp (unsigned int v2, int ref, int res)
;     659 /***********************************
;     660 Calculates Thermistor Temperature
;     661 v2 = A to D Milli Volts 0-4096
;     662 ref = reference voltage to circuit
;     663 res = reference divider resistor
;     664 ***********************************/
;     665 {
_RL10052Temp:
;     666 	float v1, r2, it, Temp, dum;
;     667 	float term1, term2, term3;
;     668 			
;     669 	v1 = (float)ref - (float)v2;
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
	CALL SUBOPT_0x36
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	CALL SUBOPT_0x14
;     670 	it = v1/(float)res;
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x36
	CALL SUBOPT_0x13
	CALL __DIVF21
	__PUTD1S 20
;     671 	r2 = (float)v2/it;		    //find resistance of thermistor
	CALL SUBOPT_0x40
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x24
	CALL __DIVF21
	__PUTD1S 24
;     672 	dum = (float)log(r2/(float)res);
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x36
	CALL SUBOPT_0x17
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x42
;     673 	
;     674 	// Diagnostic
;     675 	//printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\n\r", v2, v1, it, r2, dum);
;     676 	
;     677 	term1 = COEFFA + (COEFFB * dum);
	CALL SUBOPT_0x43
	LDS  R26,_COEFFB
	LDS  R27,_COEFFB+1
	LDS  R24,_COEFFB+2
	LDS  R25,_COEFFB+3
	CALL __MULF12
	LDS  R26,_COEFFA
	LDS  R27,_COEFFA+1
	LDS  R24,_COEFFA+2
	LDS  R25,_COEFFA+3
	CALL SUBOPT_0x44
;     678 	term2 = COEFFC * (dum*dum);
	CALL SUBOPT_0x45
	LDS  R26,_COEFFC
	LDS  R27,_COEFFC+1
	LDS  R24,_COEFFC+2
	LDS  R25,_COEFFC+3
	CALL __MULF12
	CALL SUBOPT_0x1F
;     679 	term3 = COEFFD * ((dum*dum)*dum);
	CALL SUBOPT_0x45
	CALL SUBOPT_0x46
	CALL __MULF12
	LDS  R26,_COEFFD
	LDS  R27,_COEFFD+1
	LDS  R24,_COEFFD+2
	LDS  R25,_COEFFD+3
	CALL __MULF12
	CALL SUBOPT_0x2A
;     680    	Temp = term1 + term2 + term3;
	CALL SUBOPT_0x35
	CALL SUBOPT_0x47
	CALL __ADDF12
	CALL SUBOPT_0x25
	CALL __ADDF12
	CALL SUBOPT_0x48
;     681 	//printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\n\r", term1, term2, term3, Temp);
;     682 	//Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
;     683 	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	CALL SUBOPT_0x49
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x438B0000
	CALL SUBOPT_0x41
	CALL SUBOPT_0x48
;     684 	//	printf("Temp= %f\n\r", Temp);
;     685 
;     686 return Temp;
	ADIW R28,38
	RET
;     687 } 
;     688 
;     689 void Main_Menu(void)
;     690 /*************************************************
;     691 *************************************************/
;     692 { 
_Main_Menu:
;     693 	char ch;
;     694 	int ltime;
;     695 	char msg[12];
;     696 	int i; 
;     697 	unsigned long t1, t2;  //v1.13
;     698 
;     699 			
;     700 	printf("\n\r");
	SBIW R28,20
	CALL __SAVELOCR5
;	ch -> R16
;	ltime -> R17,R18
;	msg -> Y+13
;	i -> R19,R20
;	t1 -> Y+9
;	t2 -> Y+5
	CALL SUBOPT_0x3E
;     701 	printf("\n\r RAD%02d BOARD (REV B) VERSION: %s, VERSION DATE: %s\n\r", Id_address, version, verdate);
	__POINTW1FN _0,692
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3C
;     702 	printf(" ----------EEPROM PARAMETERS----------------------------\n\r");
	__POINTW1FN _0,749
	CALL SUBOPT_0x3B
;     703 	printf("PSP Coeff= %.2E, PIR Coeff= %.2E\n\r", psp, pir);
	__POINTW1FN _0,808
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x3A
;     704 	printf("PIRadc_gain= %.1f, PIRadc_offset= %.1f\n\r", PIRadc_gain, PIRadc_offset);                   
	__POINTW1FN _0,843
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
;     705 	printf("PSPadc_gain= %.1f, PSPadc_offset= %.1f\n\r", PSPadc_gain, PSPadc_offset);
	__POINTW1FN _0,884
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x22
	CALL SUBOPT_0x3A
;     706 	printf(" ---------DATE & TIME SETTING---------------------------\n\r"); 
	__POINTW1FN _0,925
	CALL SUBOPT_0x3B
;     707     printf("'T' -->Set the date/time.\n\r");
	__POINTW1FN _0,984
	CALL SUBOPT_0x3B
;     708     printf(" ---------PSP SETTINGS----------------------------------\n\r");
	__POINTW1FN _0,1012
	CALL SUBOPT_0x3B
;     709     printf("'p' -->Set PSP coefficient. 'g' -->Set PSP amplifier gain value.\n\r"); 
	__POINTW1FN _0,1071
	CALL SUBOPT_0x3B
;     710     printf("'o' -->Set PSP amplifier output offset, mv.\n\r");  //v15
	__POINTW1FN _0,1138
	CALL SUBOPT_0x3B
;     711     printf(" ---------PIR SETTINGS----------------------------------\n\r");
	__POINTW1FN _0,1184
	CALL SUBOPT_0x3B
;     712     printf("'I' -->Set PIR coefficient. 'G' -->Set PIR amplifier gain value.\n\r");
	__POINTW1FN _0,1243
	CALL SUBOPT_0x3B
;     713     printf("'O' -->Set PIR amplifier output offset, mv.\n\r");  //v15
	__POINTW1FN _0,1310
	CALL SUBOPT_0x3B
;     714     printf("'C' -->Set Case (R8) value. 'D' -->Set Dome (R9) value.\n\r");
	__POINTW1FN _0,1356
	CALL SUBOPT_0x3B
;     715     printf("'V' -->Set Thermistor/ADC Reference Voltage (TP2) value.\n\r");
	__POINTW1FN _0,1414
	CALL SUBOPT_0x3B
;     716     printf(" ---------TIMING SETTING--------------------------------\n\r");
	__POINTW1FN _0,1473
	CALL SUBOPT_0x3B
;     717     printf("'L' -->Set Output time in seconds.\n\r");
	__POINTW1FN _0,1532
	CALL SUBOPT_0x3B
;     718     printf(" -------------------------------------------------------\n\r");
	__POINTW1FN _0,1569
	CALL SUBOPT_0x3B
;     719     printf("'S' -->Sample 12 bit A to D. 'A' -->Change Identifier String.\n\r");
	__POINTW1FN _0,1628
	CALL SUBOPT_0x3B
;     720     printf("'X' -->Exit this menu, return to operation.\n\r");
	__POINTW1FN _0,1692
	CALL SUBOPT_0x3B
;     721     printf("=========================================================\n\r");
	__POINTW1FN _0,1738
	CALL SUBOPT_0x3B
;     722     printf("Command?>");
	__POINTW1FN _0,1798
	CALL SUBOPT_0x3B
;     723 	
;     724 	// ***************************************
;     725 	// WAITING FOR A CHARACTER.  TIMEOUT.  v13
;     726 	// ***************************************
;     727 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2C
;     728 	t1 = h*3600 + m*60 + s;
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
;     729 	while (1) 
_0x43:
;     730 	{
;     731 		// CHECK INPUT BUFFER FOR A CHARACTER
;     732 		if ( SerByteAvail() )
	CALL _SerByteAvail
	SBIW R30,0
	BREQ _0x46
;     733 		{
;     734 			ch = getchar();
	RCALL _getchar
	MOV  R16,R30
;     735 			break;
	RJMP _0x45
;     736 		}
;     737 		// CHECK CURRENT TIME FOR A TIMEOUT
;     738 		rtc_get_time(&h,&m,&s);
_0x46:
	CALL SUBOPT_0x2C
;     739 		t2 = h*3600 + m*60 + s;		 
	CALL SUBOPT_0x4A
	__PUTD1S 5
;     740 		if ( abs(t2-t1) > MENU_TIMEOUT )     //v13 30 sec timeout
	CALL SUBOPT_0x4C
	__GETD1S 5
	CALL __SUBD12
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	SBIW R30,31
	BRLO _0x47
;     741 		{
;     742 			printf("\n\rTIMEOUT: Return to sampling\n\r");
	__POINTW1FN _0,1808
	CALL SUBOPT_0x3B
;     743 			return;
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;     744 		}
;     745 	}	
_0x47:
	RJMP _0x43
_0x45:
;     746 	switch (ch) 
	MOV  R30,R16
	LDI  R31,0
;     747 	{
;     748 		//*** echo characters typed.  See PRP code.
;     749 		// SET THE REAL-TIME CLOCK TIME
;     750 		case 'T':
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BREQ _0x4C
;     751 		case 't': 
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x4D
_0x4C:
;     752 		    printf("System date/time (YY/MM/DD, hh:mm:ss) is %02d/%02d/%02d, %02d:%02d:%02d\n\r", yr, mon, dt, h, m, s);
	__POINTW1FN _0,1840
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x2F
	LDI  R24,24
	CALL _printf
	ADIW R28,26
;     753 			printf("Enter new time (hhmmss):  ");
	__POINTW1FN _0,1914
	CALL SUBOPT_0x3B
;     754 			
;     755 			scanf(" %2d%2d%2d", &h, &m, &s);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x4
	CALL __PUTPARD1
	__GETD1N 0x5
	CALL __PUTPARD1
	__GETD1N 0x6
	CALL SUBOPT_0x4D
;     756 		
;     757 			if( (h >= 24) || (m >= 60) || (s >= 60) ) 
	LDI  R30,LOW(24)
	CP   R4,R30
	BRSH _0x4F
	LDI  R30,LOW(60)
	CP   R5,R30
	BRSH _0x4F
	CP   R6,R30
	BRLO _0x4E
_0x4F:
;     758 			{
;     759 				printf("\n\rIncorrect time entered, check format.\n\r");
	__POINTW1FN _0,1952
	CALL SUBOPT_0x3B
;     760 				break;
	RJMP _0x4A
;     761 			}
;     762 			else 
_0x4E:
;     763 			{
;     764 				rtc_set_time(h, m, s);
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R6
	CALL _rtc_set_time
;     765 				printf("\n\r%02d:%02d:%02d saved.\n\r", h, m, s);
	__POINTW1FN _0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x3C
;     766 			}
;     767 			printf("\n\rSet Date (DDmmYY): ");
	__POINTW1FN _0,2020
	CALL SUBOPT_0x3B
;     768 			scanf(" %2d%2d%2d", &dt, &mon, &yr);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x9
	CALL __PUTPARD1
	__GETD1N 0xA
	CALL __PUTPARD1
	__GETD1N 0xB
	CALL SUBOPT_0x4D
;     769 			
;     770 		
;     771 			if( (yr <= 7 || yr > 99) ||
;     772 				(mon <=0 || mon > 12) ||
;     773 				(dt <= 0 || dt > 31) ) 
	LDI  R30,LOW(7)
	CP   R30,R11
	BRSH _0x53
	LDI  R30,LOW(99)
	CP   R30,R11
	BRSH _0x54
_0x53:
	RJMP _0x55
_0x54:
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x56
	LDI  R30,LOW(12)
	CP   R30,R10
	BRSH _0x57
_0x56:
	RJMP _0x55
_0x57:
	LDI  R30,LOW(0)
	CP   R30,R9
	BRSH _0x58
	LDI  R30,LOW(31)
	CP   R30,R9
	BRSH _0x59
_0x58:
	RJMP _0x55
_0x59:
	RJMP _0x52
_0x55:
;     774 				{
;     775 					printf("\n\rIncorrect date entered, check format.\n\r");
	__POINTW1FN _0,2042
	CALL SUBOPT_0x3B
;     776 					break;
	RJMP _0x4A
;     777 				}
;     778 				else 
_0x52:
;     779 				{   
;     780 					rtc_set_date(dt, mon, yr);
	ST   -Y,R9
	ST   -Y,R10
	ST   -Y,R11
	CALL _rtc_set_date
;     781 					printf("\n\r\n\r%02d/%02d/%02d saved.\n\r", yr, mon, dt);
	__POINTW1FN _0,2084
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
;     782 				}
;     783 			//printf("\n\r");
;     784 			
;     785 			break;
	RJMP _0x4A
;     786 		
;     787 		// SET AVERAGING INTERVAL IN SECS
;     788 		case 'L' :
_0x4D:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BREQ _0x5D
;     789 		case 'l' : 
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x5E
_0x5D:
;     790 			printf("Change Output Interval in secs\n\r");
	__POINTW1FN _0,2112
	CALL SUBOPT_0x3B
;     791 			printf("Current Interval is: %d secs\n\r", looptime);
	__POINTW1FN _0,2145
	CALL SUBOPT_0x4E
;     792 			printf("Enter new output interval in secs: ");
	__POINTW1FN _0,2176
	CALL SUBOPT_0x3B
;     793 			for (i=0; i<5; i++)
	__GETWRN 19,20,0
_0x60:
	__CPWRN 19,20,5
	BRGE _0x61
;     794 			{
;     795 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     796 				printf("%c", msg[i]);
;     797 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x63
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x62
_0x63:
;     798 				{
;     799 					i--;
	__SUBWRN 19,20,1
;     800 					break;
	RJMP _0x61
;     801 				}
;     802 			}
_0x62:
	__ADDWRN 19,20,1
	RJMP _0x60
_0x61:
;     803 			if(atof(msg) > 3600 || atof(msg) <= 0)    //v13 increased limit to 1/2 hour //v15 increased to one hour
	CALL SUBOPT_0x52
	__GETD1N 0x45610000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x66
	CALL SUBOPT_0x52
	CALL __CPD02
	BRLT _0x65
_0x66:
;     804 			{
;     805 				printf("\n\rOut of Range.\n\r");
	__POINTW1FN _0,2215
	CALL SUBOPT_0x3B
;     806 				break;
	RJMP _0x4A
;     807 			}
;     808 			else 
_0x65:
;     809 			{
;     810 				ltime = atof(msg);
	CALL SUBOPT_0x53
	CALL __CFD1
	__PUTW1R 17,18
;     811 				looptime = ltime;
	__GETW1R 17,18
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMWRW
;     812 				printf("\n\rLooptime is now set to %d seconds.\n\r", looptime); 
	__POINTW1FN _0,2233
	CALL SUBOPT_0x4E
;     813 			}
;     814 			
;     815 			break;  
	RJMP _0x4A
;     816 		
;     817 		// PSP COEFFICIENT
;     818 		case 'p' :
_0x5E:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x69
;     819 			printf("Change PSP Coefficient\n\r");
	__POINTW1FN _0,2272
	CALL SUBOPT_0x3B
;     820 			printf("Current PSP Coefficient is: %.2E\n\r", psp);
	__POINTW1FN _0,2297
	CALL SUBOPT_0x54
;     821 			printf("Enter New PSP Coefficient: ");
	__POINTW1FN _0,2332
	CALL SUBOPT_0x3B
;     822 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x6B:
	__CPWRN 19,20,20
	BRGE _0x6C
;     823 			{
;     824 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     825 				printf("%c", msg[i]);
;     826 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x6E
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x6D
_0x6E:
;     827 				{
;     828 					i--;
	__SUBWRN 19,20,1
;     829 					break;
	RJMP _0x6C
;     830 				}
;     831 			}
_0x6D:
	__ADDWRN 19,20,1
	RJMP _0x6B
_0x6C:
;     832 			if(atof(msg) >= 20.0E-6 || atof(msg) <= 0.1E-6)  //v15  expand range
	CALL SUBOPT_0x52
	__GETD1N 0x37A7C5AC
	CALL __CMPF12
	BRSH _0x71
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
	BREQ PC+2
	BRCC PC+3
	JMP  _0x71
	RJMP _0x70
_0x71:
;     833 			{
;     834 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     835 				break;
	RJMP _0x4A
;     836 			}
;     837 			else 
_0x70:
;     838 			{
;     839 				psp = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMWRD
;     840 				printf("\n\rPSP Coefficient is now set to %.2E\n\r", psp); 
	__POINTW1FN _0,2377
	CALL SUBOPT_0x54
;     841 			}
;     842 			break;
	RJMP _0x4A
;     843 		
;     844 		case 'g' :
_0x69:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x74
;     845 			printf("Change PSP Amplifier Gain Value\n\r");
	__POINTW1FN _0,2416
	CALL SUBOPT_0x3B
;     846 			printf("Current PSP Amplifier Gain Value: %.2f\n\r", PSPadc_gain);
	__POINTW1FN _0,2450
	CALL SUBOPT_0x57
;     847 			printf("Enter New PSP Amplifier Gain Value: ");
	__POINTW1FN _0,2491
	CALL SUBOPT_0x3B
;     848 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x76:
	__CPWRN 19,20,20
	BRGE _0x77
;     849 			{
;     850 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     851 				printf("%c", msg[i] );
;     852 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x79
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x78
_0x79:
;     853 				{
;     854 					i--;
	__SUBWRN 19,20,1
;     855 					break;
	RJMP _0x77
;     856 				}
;     857 			}
_0x78:
	__ADDWRN 19,20,1
	RJMP _0x76
_0x77:
;     858 			if(atof(msg) >= 300 || atof(msg) <= 10)  //v15  expand range 
	CALL SUBOPT_0x52
	__GETD1N 0x43960000
	CALL __CMPF12
	BRSH _0x7C
	CALL SUBOPT_0x52
	CALL SUBOPT_0x58
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x7C
	RJMP _0x7B
_0x7C:
;     859 			{
;     860 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     861 				break;
	RJMP _0x4A
;     862 			}
;     863 			else 
_0x7B:
;     864 			{
;     865 				PSPadc_gain = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMWRD
;     866 				printf("\n\rPSP Amplifier Gain is now set to %.2f\n\r", PSPadc_gain); 
	__POINTW1FN _0,2528
	CALL SUBOPT_0x57
;     867 			}
;     868 			break;
	RJMP _0x4A
;     869 
;     870 		case 'o' :
_0x74:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x7F
;     871 			printf("Change PSP Amplifier Offset Value\n\r");
	__POINTW1FN _0,2570
	CALL SUBOPT_0x3B
;     872 			printf("Current PSP Amplifier Offset Value: %.2f\n\r", PSPadc_offset);
	__POINTW1FN _0,2606
	CALL SUBOPT_0x9
;     873 			printf("Enter New PSP Amplifier Offset Value: ");
	__POINTW1FN _0,2649
	CALL SUBOPT_0x3B
;     874 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x81:
	__CPWRN 19,20,20
	BRGE _0x82
;     875 			{
;     876 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     877 				printf("%c", msg[i]);
;     878 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x84
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x83
_0x84:
;     879 				{
;     880 					i--;
	__SUBWRN 19,20,1
;     881 					break;
	RJMP _0x82
;     882 				}
;     883 			}                        
_0x83:
	__ADDWRN 19,20,1
	RJMP _0x81
_0x82:
;     884 			if(atof(msg) > 500 || atof(msg) < -500)  //v15  expand range
	CALL SUBOPT_0x52
	CALL SUBOPT_0x59
	BREQ PC+4
	BRCS PC+3
	JMP  _0x87
	CALL SUBOPT_0x52
	__GETD1N 0xC3FA0000
	CALL __CMPF12
	BRSH _0x86
_0x87:
;     885 			{
;     886 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     887 				break;
	RJMP _0x4A
;     888 			}
;     889 			else 
_0x86:
;     890 			{
;     891 				PSPadc_offset = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMWRD
;     892 				printf("\n\rPSP Amplifier Offset is now set to %.2f\n\r", PSPadc_offset); 
	__POINTW1FN _0,2688
	CALL SUBOPT_0x9
;     893 			}
;     894 			break;
	RJMP _0x4A
;     895 
;     896 		case 'G' :
_0x7F:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x8A
;     897 			printf("Change PIR Amplifier Gain Value\n\r");
	__POINTW1FN _0,2732
	CALL SUBOPT_0x3B
;     898 			printf("Current PIR Amplifier Gain Value: %.2f\n\r", PIRadc_gain);
	__POINTW1FN _0,2766
	CALL SUBOPT_0x5A
;     899 			printf("Enter New PIR Amplifier Gain Value: ");
	__POINTW1FN _0,2807
	CALL SUBOPT_0x3B
;     900 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x8C:
	__CPWRN 19,20,20
	BRGE _0x8D
;     901 			{
;     902 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     903 				printf("%c", msg[i]);
;     904 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x8F
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x8E
_0x8F:
;     905 				{
;     906 					i--;
	__SUBWRN 19,20,1
;     907 					break;
	RJMP _0x8D
;     908 				}
;     909 			}                        
_0x8E:
	__ADDWRN 19,20,1
	RJMP _0x8C
_0x8D:
;     910 			if(atof(msg) > 1500 || atof(msg) < 500 )  //v15  expand range
	CALL SUBOPT_0x52
	__GETD1N 0x44BB8000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x92
	CALL SUBOPT_0x52
	CALL SUBOPT_0x59
	BRSH _0x91
_0x92:
;     911 			{
;     912 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     913 				break;
	RJMP _0x4A
;     914 			}
;     915 			else 
_0x91:
;     916 			{
;     917 				PIRadc_gain = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMWRD
;     918 				printf("\n\rPIR Amplifier Gain is now set to %.2f\n\r", PIRadc_gain); 
	__POINTW1FN _0,2844
	CALL SUBOPT_0x5A
;     919 			}
;     920 			break;
	RJMP _0x4A
;     921 
;     922 		case 'O' :
_0x8A:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x95
;     923 			printf("Change PIR Amplifier Offset Value\n\r");
	__POINTW1FN _0,2886
	CALL SUBOPT_0x3B
;     924 			printf("Current PIR Amplifier Offset Value: %.2f\n\r", PIRadc_offset);
	__POINTW1FN _0,2922
	CALL SUBOPT_0x7
;     925 			printf("Enter New PIR Amplifier Offset Value: ");
	__POINTW1FN _0,2965
	CALL SUBOPT_0x3B
;     926 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x97:
	__CPWRN 19,20,20
	BRGE _0x98
;     927 			{
;     928 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     929 				printf("%c", msg[i]);
;     930 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0x9A
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0x99
_0x9A:
;     931 				{
;     932 					i--;
	__SUBWRN 19,20,1
;     933 					break;
	RJMP _0x98
;     934 				}
;     935 			}                        
_0x99:
	__ADDWRN 19,20,1
	RJMP _0x97
_0x98:
;     936 			if(atof(msg) > 200 || atof(msg) < -200)  //v15  expand range
	CALL SUBOPT_0x52
	__GETD1N 0x43480000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x9D
	CALL SUBOPT_0x52
	__GETD1N 0xC3480000
	CALL __CMPF12
	BRSH _0x9C
_0x9D:
;     937 			{
;     938 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     939 				break;
	RJMP _0x4A
;     940 			}
;     941 			else 
_0x9C:
;     942 			{
;     943 				PIRadc_offset = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMWRD
;     944 				printf("\n\rPIR Amplifier Offset is now set to %.2f\n\r", PIRadc_offset); 
	__POINTW1FN _0,3004
	CALL SUBOPT_0x7
;     945 			}
;     946 			break;
	RJMP _0x4A
;     947 
;     948 		case 'I' :  // 'l' or 'I' This is capital Eye
_0x95:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xA0
;     949 			printf("Change PIR Coefficient\n\r");
	__POINTW1FN _0,3048
	CALL SUBOPT_0x3B
;     950 			printf("Current PIR Coefficient is: %E\n\r", pir);
	__POINTW1FN _0,3073
	CALL SUBOPT_0x5B
;     951 			printf("Enter New PIR Coefficient: ");
	__POINTW1FN _0,3106
	CALL SUBOPT_0x3B
;     952 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xA2:
	__CPWRN 19,20,20
	BRGE _0xA3
;     953 			{
;     954 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     955 				printf("%c", msg[i]);
;     956 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0xA5
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0xA4
_0xA5:
;     957 				{
;     958 					i--;
	__SUBWRN 19,20,1
;     959 					break;
	RJMP _0xA3
;     960 				}
;     961 			}                        
_0xA4:
	__ADDWRN 19,20,1
	RJMP _0xA2
_0xA3:
;     962 			if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
	CALL SUBOPT_0x52
	__GETD1N 0x3727C5AC
	CALL __CMPF12
	BRSH _0xA8
	CALL SUBOPT_0x52
	CALL SUBOPT_0x55
	BREQ PC+2
	BRCC PC+3
	JMP  _0xA8
	RJMP _0xA7
_0xA8:
;     963 			{
;     964 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     965 				break;
	RJMP _0x4A
;     966 			}
;     967 			else 
_0xA7:
;     968 			{
;     969 				pir = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMWRD
;     970 				printf("\n\rPIR Coefficient is now set to %E\n\r", pir); 
	__POINTW1FN _0,3134
	CALL SUBOPT_0x5B
;     971 			}
;     972 			break;
	RJMP _0x4A
;     973 		case 'C' :
_0xA0:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xAB
;     974 			printf("Change Case Reference Resistor (R9)\n\r");
	__POINTW1FN _0,3171
	CALL SUBOPT_0x3B
;     975 			printf("Current Case Reference Resistor is: %.1f\n\r", RrefC);
	__POINTW1FN _0,3209
	CALL SUBOPT_0x5C
;     976 			printf("Enter New Case Reference Resistance: ");
	__POINTW1FN _0,3252
	CALL SUBOPT_0x3B
;     977 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xAD:
	__CPWRN 19,20,20
	BRGE _0xAE
;     978 			{
;     979 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;     980 				printf("%c", msg[i]);
;     981 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0xB0
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0xAF
_0xB0:
;     982 				{
;     983 					i--;
	__SUBWRN 19,20,1
;     984 					break;
	RJMP _0xAE
;     985 				}
;     986 			}
_0xAF:
	__ADDWRN 19,20,1
	RJMP _0xAD
_0xAE:
;     987 			if( atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5D
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB3
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5E
	BRSH _0xB2
_0xB3:
;     988 			{
;     989 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;     990 				break;
	RJMP _0x4A
;     991 			}
;     992 			else 
_0xB2:
;     993 			{
;     994 				RrefC = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMWRD
;     995 				printf("\n\rCase Reference Resistor is now set to %.1f\n\r", RrefC); 
	__POINTW1FN _0,3290
	CALL SUBOPT_0x5C
;     996 			}
;     997 			break;
	RJMP _0x4A
;     998 		case 'D' :
_0xAB:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xB6
;     999 			printf("Change Dome Reference Resistor (R10)\n\r");
	__POINTW1FN _0,3337
	CALL SUBOPT_0x3B
;    1000 			printf("Current Dome Reference Resistor is: %.1f\n\r", RrefD);
	__POINTW1FN _0,3376
	CALL SUBOPT_0x5F
;    1001 			printf("Enter New Dome Reference Resistance: ");
	__POINTW1FN _0,3419
	CALL SUBOPT_0x3B
;    1002 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xB8:
	__CPWRN 19,20,20
	BRGE _0xB9
;    1003 			{
;    1004 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;    1005 				printf("%c", msg[i]);
;    1006 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0xBB
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0xBA
_0xBB:
;    1007 				{
;    1008 					i--;
	__SUBWRN 19,20,1
;    1009 					break;
	RJMP _0xB9
;    1010 				}
;    1011 			}                        
_0xBA:
	__ADDWRN 19,20,1
	RJMP _0xB8
_0xB9:
;    1012 			if(atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5D
	BREQ PC+4
	BRCS PC+3
	JMP  _0xBE
	CALL SUBOPT_0x52
	CALL SUBOPT_0x5E
	BRSH _0xBD
_0xBE:
;    1013 			{
;    1014 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;    1015 				break;
	RJMP _0x4A
;    1016 			}
;    1017 			else 
_0xBD:
;    1018 			{
;    1019 				RrefD = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMWRD
;    1020 				printf("\n\rDome Reference Resistor is now set to %.1f\n\r", RrefD); 
	__POINTW1FN _0,3457
	CALL SUBOPT_0x5F
;    1021 			}
;    1022 			break;
	RJMP _0x4A
;    1023 		case 'V' :
_0xB6:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xC1
;    1024 			printf("Change Thermistor Reference Voltage\n\r");
	__POINTW1FN _0,3504
	CALL SUBOPT_0x3B
;    1025 			printf("Current Thermistor Reference Voltage is: %.4f\n\r", Vtherm);
	__POINTW1FN _0,3542
	CALL SUBOPT_0x60
;    1026 			printf("Enter New Thermistor Reference Voltage: ");
	__POINTW1FN _0,3590
	CALL SUBOPT_0x3B
;    1027 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xC3:
	__CPWRN 19,20,20
	BRGE _0xC4
;    1028 			{
;    1029 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;    1030 				printf("%c", msg[i]);
;    1031 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0xC6
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0xC5
_0xC6:
;    1032 				{
;    1033 					i--;
	__SUBWRN 19,20,1
;    1034 					break;
	RJMP _0xC4
;    1035 				}
;    1036 			}                        
_0xC5:
	__ADDWRN 19,20,1
	RJMP _0xC3
_0xC4:
;    1037 			if(atof(msg) > 6.0 || atof(msg) < 2.0)  //v15  expand range
	CALL SUBOPT_0x52
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC9
	CALL SUBOPT_0x52
	__GETD1N 0x40000000
	CALL __CMPF12
	BRSH _0xC8
_0xC9:
;    1038 			{
;    1039 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;    1040 				break;
	RJMP _0x4A
;    1041 			}
;    1042 			else 
_0xC8:
;    1043 			{
;    1044 				Vtherm = atof(msg);
	CALL SUBOPT_0x53
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMWRD
;    1045 				Vadc = Vtherm;
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMWRD
;    1046 				printf("\n\rThermistor Reference Voltage is now set to %.4f\n\r", Vtherm); 
	__POINTW1FN _0,3631
	CALL SUBOPT_0x60
;    1047 			}
;    1048 			break;
	RJMP _0x4A
;    1049 		case 'A' :
_0xC1:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xCC
;    1050 			printf("Change Identifier Address\n\r");
	__POINTW1FN _0,3683
	CALL SUBOPT_0x3B
;    1051 			printf("Current Identifier Address: $RAD%02d\n\r", Id_address);
	__POINTW1FN _0,3711
	CALL SUBOPT_0x61
;    1052 			printf("Enter New Identifier Address (0-99): ");
	__POINTW1FN _0,3750
	CALL SUBOPT_0x3B
;    1053 			
;    1054 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xCE:
	__CPWRN 19,20,20
	BRGE _0xCF
;    1055 			{
;    1056 				msg[i] = getchar();
	CALL SUBOPT_0x4F
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x50
;    1057 				printf("%c", msg[i]);
;    1058 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xA)
	BREQ _0xD1
	CALL SUBOPT_0x51
	CPI  R26,LOW(0xD)
	BRNE _0xD0
_0xD1:
;    1059 				{
;    1060 					i--;
	__SUBWRN 19,20,1
;    1061 					break;
	RJMP _0xCF
;    1062 				}
;    1063 			}                        
_0xD0:
	__ADDWRN 19,20,1
	RJMP _0xCE
_0xCF:
;    1064 			if(atoi(msg) > 99 || atoi(msg) < 00)
	CALL SUBOPT_0x62
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRGE _0xD4
	CALL SUBOPT_0x62
	MOVW R26,R30
	SBIW R26,0
	BRGE _0xD3
_0xD4:
;    1065 			{
;    1066 				printf("\n\rOut of Range\n\r");
	CALL SUBOPT_0x56
;    1067 				break;
	RJMP _0x4A
;    1068 			}
;    1069 			else
_0xD3:
;    1070 			{
;    1071 				Id_address = atoi(msg);
	CALL SUBOPT_0x62
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMWRW
;    1072 				printf("\n\rIdentifier String now set to: $RAD%02d\n\r", Id_address); 
	__POINTW1FN _0,3788
	CALL SUBOPT_0x61
;    1073 			}
;    1074 			break;	                                         
	RJMP _0x4A
;    1075 		case 'X' :
_0xCC:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BREQ _0xD8
;    1076 		case 'x' :
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0xD9
_0xD8:
;    1077 			printf("\n\r Returning to operation...\n\r\n\r");
	__POINTW1FN _0,3831
	CALL SUBOPT_0x3B
;    1078 			return;  //v13 RETURN FROM THIS S/R 
	RJMP _0x223
;    1079 			break;
;    1080 		case 'S' :
_0xD9:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0xDA
;    1081 			SampleADC();
	RCALL _SampleADC
;    1082 			break;
	RJMP _0x4A
;    1083 		case 'Z' :
_0xDA:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BREQ _0xDC
;    1084 		case 'z' :
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0xDE
_0xDC:
;    1085 			printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
	CALL SUBOPT_0x0
;    1086 			printf(" Software Version %s, %s\n\r", version, verdate);
;    1087 			printf(" Current EEPROM values:\n\r");
;    1088 			printf(" Identifier Header= $RAD%02d\n\r", Id_address);
;    1089 			printf(" PSP Coeff= %.2E\n\r", psp);
;    1090 			printf(" PIR Coeff= %.2E\n\r", pir);
	CALL SUBOPT_0x1
;    1091 			printf(" Interval Time (secs)= %d\n\r", looptime);
	CALL SUBOPT_0x2
;    1092 			printf(" Cmax= %d\n\r", Cmax);
	CALL SUBOPT_0x3
;    1093 			printf(" Reference Resistor Case= %.1f\n\r", RrefC);
	CALL SUBOPT_0x4
;    1094 			printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
	CALL SUBOPT_0x5
;    1095 			printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
	CALL SUBOPT_0x6
;    1096 			printf(" PIR ADC Offset= %.2f\n\r", PIRadc_offset);
	__POINTW1FN _0,3864
	CALL SUBOPT_0x7
;    1097 			printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
	CALL SUBOPT_0x8
;    1098 			printf(" PSP ADC Offset= %.2f\n\r", PSPadc_offset);
	__POINTW1FN _0,3888
	CALL SUBOPT_0x9
;    1099 			printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
	CALL SUBOPT_0xA
;    1100 			printf("\n\r");
	CALL SUBOPT_0x3E
;    1101 			//v15 -- we need to wait here for a character press
;    1102 			break;
	RJMP _0x4A
;    1103 			
;    1104 		//v13 INVALID KEY ENTRY -- RE-CALL MENU
;    1105 		default : printf("Invalid key\n\r");
_0xDE:
	__POINTW1FN _0,3912
	CALL SUBOPT_0x3B
;    1106 			//v13 printf("\n\r Returning to operation...\n\r\n\r");
;    1107 			Main_Menu();
	CALL _Main_Menu
;    1108 	} // end switch
_0x4A:
;    1109 	
;    1110 	//v13 -- recall s/r
;    1111 	Main_Menu();
	CALL _Main_Menu
;    1112 	//printf("Returning to operation...\n\r\n\r");
;    1113 	//return;
;    1114 }	//end menu
_0x223:
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;    1115 
;    1116 void SampleADC(void)
;    1117 /********************************************************
;    1118 Test the ADC circuit
;    1119 **********************************************************/
;    1120 {
_SampleADC:
;    1121 	double ddum[8], ddumsq[8];
;    1122 	int i, npts;          
;    1123 	int missing;
;    1124 	
;    1125 	missing = -999;
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR6
;	ddum -> Y+38
;	ddumsq -> Y+6
;	i -> R16,R17
;	npts -> R18,R19
;	missing -> R20,R21
	__GETWRN 20,21,64537
;    1126 
;    1127 	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	CALL SUBOPT_0x63
	__PUTD1SX 66
	__PUTD1SX 62
	__PUTD1S 58
	__PUTD1S 54
	__PUTD1S 50
	__PUTD1S 46
	__PUTD1S 42
	__PUTD1S 38
;    1128 	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	CALL SUBOPT_0x63
	__PUTD1S 34
	__PUTD1S 30
	__PUTD1S 26
	__PUTD1S 22
	__PUTD1S 18
	__PUTD1S 14
	__PUTD1S 10
	CALL SUBOPT_0x64
;    1129 	npts=0;
	__GETWRN 18,19,0
;    1130 	printf("\n\r");
	CALL SUBOPT_0x3E
;    1131 	while( !SerByteAvail() )
_0xDF:
	CALL _SerByteAvail
	SBIW R30,0
	BREQ PC+3
	JMP _0xE1
;    1132 	{
;    1133 		ReadAnalog(ALL);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ReadAnalog
;    1134 		printf("%7d %7d %7d %7d %7d %7d %7d %7d\n\r",
;    1135 		adc[0],adc[1],adc[2],adc[3],
;    1136 		adc[4],adc[5],adc[6],adc[7]);
	__POINTW1FN _0,3926
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc
	LDS  R31,_adc+1
	CALL SUBOPT_0x30
	__GETW1MN _adc,2
	CALL SUBOPT_0x30
	__GETW1MN _adc,4
	CALL SUBOPT_0x30
	__GETW1MN _adc,6
	CALL SUBOPT_0x30
	__GETW1MN _adc,8
	CALL SUBOPT_0x30
	__GETW1MN _adc,10
	CALL SUBOPT_0x30
	__GETW1MN _adc,12
	CALL SUBOPT_0x30
	__GETW1MN _adc,14
	CALL SUBOPT_0x30
	CALL SUBOPT_0x65
;    1137 		for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xE3:
	__CPWRN 16,17,8
	BRLT PC+3
	JMP _0xE4
;    1138 		{
;    1139 			ddum[i] += (double)adc[i];
	CALL SUBOPT_0x66
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x67
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1140 			ddumsq[i] += (double)adc[i] * (double)adc[i];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x68
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x67
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x67
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
;    1141 		}
	__ADDWRN 16,17,1
	RJMP _0xE3
_0xE4:
;    1142 		npts++;
	__ADDWRN 18,19,1
;    1143 		delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x38
;    1144 		
;    1145 		Heartbeat();
	CALL _Heartbeat
;    1146 	}
	RJMP _0xDF
_0xE1:
;    1147 	printf("\n\r");
	CALL SUBOPT_0x3E
;    1148 	for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xE6:
	__CPWRN 16,17,8
	BRGE _0xE7
;    1149 		MeanStdev((ddum+i), (ddumsq+i), npts, missing);
	CALL SUBOPT_0x66
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x68
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0xE
	RCALL _MeanStdev
;    1150 
;    1151 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r",
	__ADDWRN 16,17,1
	RJMP _0xE6
_0xE7:
;    1152 		ddum[0],ddum[1],ddum[2],ddum[3],
;    1153 		ddum[4],ddum[5],ddum[6],ddum[7]);
	__POINTW1FN _0,3960
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x69
	__GETD1SX 72
	CALL __PUTPARD1
	__GETD1SX 80
	CALL __PUTPARD1
	__GETD1SX 88
	CALL __PUTPARD1
	__GETD1SX 96
	CALL __PUTPARD1
	CALL SUBOPT_0x65
;    1154 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r\n\r",
;    1155 		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
;    1156 		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
	__POINTW1FN _0,4010
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6A
	CALL __PUTPARD1
	CALL SUBOPT_0x1E
	CALL __PUTPARD1
	__GETD1S 24
	CALL __PUTPARD1
	__GETD1S 32
	CALL __PUTPARD1
	CALL SUBOPT_0x69
	CALL SUBOPT_0x65
;    1157 		
;    1158 		Heartbeat();
	CALL _Heartbeat
;    1159 	return;
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
;    1160 }
;    1161 
;    1162 void	MeanStdev(double *sum, double *sum2, int N, double missing)
;    1163 /********************************************
;    1164 Compute mean and standard deviation from the count, the sum and the sum of squares.
;    1165 991101
;    1166 Note that the mean and standard deviation are computed from the sum and the sum of 
;    1167 squared values and are returned in the same memory location.
;    1168 *********************************************/
;    1169 {
_MeanStdev:
;    1170 	if( N <= 2 )
;	*sum -> Y+8
;	*sum2 -> Y+6
;	N -> Y+4
;	missing -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRGE _0xE8
;    1171 	{
;    1172 		*sum = missing;
	CALL SUBOPT_0x6B
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x6C
;    1173 		*sum2 = missing;
	RJMP _0x227
;    1174 	}
;    1175 	else
_0xE8:
;    1176 	{
;    1177 		*sum /= (double)N;		// mean value
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x6D
	POP  R26
	POP  R27
	CALL SUBOPT_0x6E
;    1178 		*sum2 = *sum2/(double)N - (*sum * *sum); // sumsq/N - mean^2
	CALL SUBOPT_0x6D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x41
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x6E
;    1179 		*sum2 = *sum2 * (double)N / (double)(N-1); // (N/N-1) correction
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x70
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	CALL SUBOPT_0x29
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x6E
;    1180 		if( *sum2 < 0 ) *sum2 = 0;
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRGE _0xEA
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x63
	RJMP _0x228
;    1181 		else *sum2 = sqrt(*sum2);
_0xEA:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETD1P
	CALL __PUTPARD1
	CALL _sqrt
_0x227:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
_0x228:
	CALL __PUTDP1
;    1182 	}
;    1183 	return;
	RJMP _0x222
;    1184 }
;    1185 void ReadAnalog( int chan )
;    1186 /************************************************************
;    1187 Read 12 bit analog A/D Converter Max186
;    1188 ************************************************************/
;    1189 {
_ReadAnalog:
;    1190 	int i;
;    1191 	if( chan == ALL )
	ST   -Y,R17
	ST   -Y,R16
;	chan -> Y+2
;	i -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0xEC
;    1192 	{
;    1193 		for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0xEE:
	__CPWRN 16,17,8
	BRGE _0xEF
;    1194 		{	
;    1195 			adc[i] = Read_Max186(i, 0);
	MOVW R30,R16
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Read_Max186
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1196 		   //	printf("adc[i] = %d, isamp = %d, i = %d\n\r", adc[i], i);
;    1197 		}
	__ADDWRN 16,17,1
	RJMP _0xEE
_0xEF:
;    1198 	}
;    1199 	else if( chan >= 0 && chan <=7 )
	RJMP _0xF0
_0xEC:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,0
	BRLT _0xF2
	SBIW R26,8
	BRLT _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
;    1200 	{
;    1201 		adc[chan] = Read_Max186(chan, 0);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x71
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0xD
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1202 	}
;    1203     return;
_0xF1:
_0xF0:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1204 } 
;    1205     
;    1206 #include "PSP.h"
;    1207 
;    1208 /*******************************************************************************************/
;    1209 
;    1210 float PSPSW(double vp, double kp, double PSPadc_offset, double PSPadc_gain, double *sw)
;    1211 /**********************************************************
;    1212 %input
;    1213 %  vp = thermopile voltage
;    1214 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1215 %  gainPSP[2] is the offset and gain for the preamp circuit
;    1216 %     The thermopile net radiance is given by vp/kp, but
;    1217 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;    1218 %     where vp' is the actual voltage on the thermopile.
;    1219 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1220 %  e = thermopile computed flux in W/m^2 
;    1221 %    
;    1222 %  no arguments ==> test mode
;    1223 %  sw = corrected shortwave flux, W/m^2
;    1224 %  
;    1225 %000928 changes eps to 0.98 per {fairall98}
;    1226 %010323 back to 1.0 per Fairall
;    1227 /**********************************************************/
;    1228 {
_PSPSW:
;    1229 
;    1230 	double e; // w/m^2 on the thermopile 
;    1231 	
;    1232 	// THERMOPILE IRRADIANCE
;    1233 	e = ( (((vp - PSPadc_offset) / PSPadc_gain) /1000) / kp );
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
	CALL SUBOPT_0x72
	CALL SUBOPT_0x73
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 14
	CALL SUBOPT_0x74
;    1234 	//printf("PSP: e = %.4e\r\n", e);
;    1235 	
;    1236 	*sw = e;
	CALL SUBOPT_0x6B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x6C
;    1237 	
;    1238 	return e;
	ADIW R28,22
	RET
;    1239 }
;    1240 
;    1241 double ysi46041(double r, double *c)
;    1242 /************************************************************
;    1243 	Description: Best fit of Steinhart Hart equation to YSI
;    1244 	tabulated data from -10C to 60C for H mix 10k thermistors.
;    1245 	Given the thermistor temperature in Kelvin.
;    1246 
;    1247 	The lack of precision in the YSI data is evident around
;    1248 	9999/10000 Ohm transition.  Scatter approaches 10mK before,
;    1249 	much less after.  Probably some systemmatics at the 5mK level
;    1250 	as a result.  Another decimal place in the impedances would 
;    1251 	have come in very handy.  The YSI-derived coefficients read
;    1252 	10mK cold or some through the same interval.
;    1253 
;    1254 	Mandatory parameters:
;    1255 	R - Thermistor resistance(s) in Ohms
;    1256 	C - Coefficients of fit from isarconf.icf file specific
;    1257 	to each thermistor.
;    1258 ************************************************************/
;    1259 { 
;    1260 double t1, LnR;
;    1261 	if(r>0)
;	r -> Y+10
;	*c -> Y+8
;	t1 -> Y+4
;	LnR -> Y+0
;    1262 	{
;    1263 		LnR = log(r);
;    1264 		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
;    1265 	}
;    1266 	else t1 = 0;
;    1267 	
;    1268 	return t1;
;    1269 }
;    1270 
;    1271 double ysi46041CountToRes(double c)
;    1272 /**************************************************************
;    1273 	Description: Converts raw counts to resistance for the 
;    1274 	YSI46041 10K thermistors.
;    1275 **************************************************************/
;    1276 {
;    1277 	double  r=0;
;    1278 		
;    1279 		r = 10000.0 * c / (5.0 - c);
;	c -> Y+4
;	r -> Y+0
;    1280 		
;    1281 		return r;
;    1282 }
;    1283 double ysi46000(double Rt, double Pt)
;    1284 /*************************************************************/
;    1285 // Uses the Steinhart-Hart equations to compute the temperature 
;    1286 // in degC from thermistor resistance.  S-S coeficients are 
;    1287 // either computed from calibrations or tests, or are provided by 
;    1288 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1289 // the S-S coefficients.
;    1290 //                                                               
;    1291 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1292 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1293 //  Tc = Tk - 273.15;
;    1294 //
;    1295 // correction for self heating.
;    1296 // For no correction set P_t = 0;
;    1297 // deltaT = p(watts) / .004 (W/degC)
;    1298 //
;    1299 //rmr 050128
;    1300 /*************************************************************/
;    1301 {
_ysi46000:
;    1302 	double x;
;    1303 	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
;    1304 	// ysi46041, matlab steinharthart_fit(), 0--40 degC
;    1305 	x = SteinhartHart(C, Rt);
	SBIW R28,16
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xF7*2)
	LDI  R31,HIGH(_0xF7*2)
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
	RCALL _SteinhartHart
	CALL SUBOPT_0x42
;    1306 	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
;    1307 	//printf("ysi46000: Cal temp = %.5f\r\n",x);
;    1308 	
;    1309 	x = x - Pt/.004; // return temperature in degC
	__GETD2S 16
	__GETD1N 0x3B83126F
	CALL __DIVF21
	CALL SUBOPT_0x46
	CALL SUBOPT_0x41
	CALL SUBOPT_0x42
;    1310 	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
;    1311 	return x;
	CALL SUBOPT_0x43
	ADIW R28,24
	RET
;    1312 
;    1313 } 
;    1314 void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
;    1315 	double *v_t, double *R_t, double *P_t)
;    1316 /*************************************************************/
;    1317 //Compute the thermistor resistance for a resistor divider circuit //with reference voltage (V_therm), reference resistor (R_ref), //thermistor is connected to GROUND.  The ADC compares a reference //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc //count (c).  The ADC here is unipolar and referenced to ground.
;    1318 //The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
;    1319 //Input:
;    1320 //  c = ADC count.
;    1321 //  C_max = maximum count, typically 4096.
;    1322 //  R_ref = reference resistor (ohms)
;    1323 //  V_therm = thermistor circuit reference voltage 
;    1324 //  V_adc = ADC reference voltage.
;    1325 //Output:
;    1326 //  v_t = thermistor voltage (volts)
;    1327 //  R_t = thermistor resistance (ohms)
;    1328 //  P_t = power dissipated by the thermistor (watts)
;    1329 //	(for self heating correction)
;    1330 //example
;    1331 //	double cx, Cmax, Rref, Vtherm, Vadc;
;    1332 //	double vt, Rt, Pt;
;    1333 //	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
;    1334 //	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
;    1335 // vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
;    1336 /*************************************************************/
;    1337 {
_therm_circuit_ground:
;    1338 	double x;
;    1339 	
;    1340 	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
;    1341 	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
;    1342 	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
;    1343 	
;    1344 	*v_t = V_adc * (c/2) / C_max;
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
;    1345 	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	CALL SUBOPT_0x6F
	__GETD2S 14
	CALL SUBOPT_0x41
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 18
	CALL SUBOPT_0x74
;    1346 	*R_t = *v_t / x;  // v/I
	CALL SUBOPT_0x6F
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6B
	CALL __DIVF21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x6C
;    1347 	*P_t = x * x * *R_t;  // I^2 R = power
	CALL SUBOPT_0x75
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETD1P
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __PUTDP1
;    1348 	
;    1349 	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
;    1350 
;    1351 	return;
	ADIW R28,30
	RET
;    1352 }
;    1353 
;    1354 
;    1355 
;    1356 #include "PIR.h"
;    1357 
;    1358 /*******************************************************************************************/
;    1359 
;    1360 void PirTcTd2LW(double vp, double kp, double PIRadc_offset, double PIRadc_gain, double tc, double td, double k, 
;    1361 	double *lw, double *C_c, double *C_d)
;    1362 /**********************************************************
;    1363 %input
;    1364 %  vp = thermopile voltage
;    1365 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1366 %  gainPIR[2] is the offset and gain for the preamp circuit
;    1367 %     The thermopile net radiance is given by vp/kp, but
;    1368 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;    1369 %     where vp' is the actual voltage on the thermopile.
;    1370 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1371 %  e = thermopile computed flux in W/m^2 
;    1372 %  tc = case degC 
;    1373 %  td = dome degC 
;    1374 %  k = calib coef, usually = 4.
;    1375 %  no arguments ==> test mode
;    1376 %output
;    1377 %  lw = corrected longwave flux, W/m^2
;    1378 %  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
;    1379 %000928 changes eps to 0.98 per {fairall98}
;    1380 %010323 back to 1.0 per Fairall
;    1381 /**********************************************************/
;    1382 {
_PirTcTd2LW:
;    1383 	double Tc,Td;
;    1384 	double sigma=5.67e-8;
;    1385 	double eps = 1;
;    1386 	double x,y;
;    1387 	double e; // w/m^2 on the thermopile
;    1388 	
;    1389     	// THERMOPILE IRRADIANCE
;    1390 		e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
	SBIW R28,28
	LDI  R24,8
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	LDI  R30,LOW(_0xF8*2)
	LDI  R31,HIGH(_0xF8*2)
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
	CALL SUBOPT_0x73
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 54
	CALL SUBOPT_0x74
;    1391 	    //printf("Tc= %f, Td= %f\n\r", Tc, Td);
;    1392 		//printf("vp= %f\n\r");
;    1393 		//printf("PirTcTd2LW: e = %.4e\r\n", e);
;    1394 	
;    1395 	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
;    1396 	Tc = tc + Tabs;
	CALL SUBOPT_0x76
	__GETD2S 42
	CALL SUBOPT_0x18
;    1397 	Td = td + Tabs;
	CALL SUBOPT_0x76
	__GETD2S 38
	CALL __ADDF12
	__PUTD1S 20
;    1398 	x = Tc * Tc * Tc * Tc; // Tc^4
	__GETD1S 24
	CALL SUBOPT_0x77
	CALL SUBOPT_0x77
	CALL SUBOPT_0x77
	CALL SUBOPT_0x78
;    1399 	y = Td * Td * Td * Td; // Td^4
	CALL SUBOPT_0x24
	CALL SUBOPT_0x79
	CALL SUBOPT_0x79
	CALL SUBOPT_0x79
	CALL SUBOPT_0x1F
;    1400 	
;    1401 	// Corrections
;    1402 	*C_c = eps * sigma * x;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x46
	CALL __MULF12
	CALL SUBOPT_0x47
	CALL __MULF12
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __PUTDP1
;    1403 	*C_d =  - k * sigma * (y - x);
	__GETD1S 34
	CALL __ANEGF1
	__GETD2S 16
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x47
	CALL SUBOPT_0x35
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CALL __PUTDP1
;    1404 	
;    1405 	// Final computation
;    1406 	*lw = e + *C_c + *C_d;
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __GETD1P
	CALL SUBOPT_0x25
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
;    1407 
;    1408 	return;
	ADIW R28,62
	RET
;    1409 }
;    1410 double SteinhartHart(double C[], double R) 
;    1411 /*************************************************************/
;    1412 // Uses the Steinhart-Hart equations to compute the temperature 
;    1413 // in degC from thermistor resistance.  
;    1414 // See http://www.betatherm.com/stein.htm
;    1415 //The Steinhart-Hart thermistor equation is named for two oceanographers 
;    1416 //associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
;    1417 //The first publication of the equation was by I.S. Steinhart & S.R. Hart 
;    1418 //in "Deep Sea Research" vol. 15 p. 497 (1968).
;    1419 //S-S coeficients are
;    1420 // either computed from calibrations or tests, or are provided by 
;    1421 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1422 // the S-S coefficients.
;    1423 //
;    1424 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1425 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1426 //  Tc = Tk - 273.15;
;    1427 //example
;    1428 // C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
;    1429 // ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
;    1430 // ysi46041, matlab steinharthart_fit()
;    1431 // R = 25000;     Tc = 25.00C
;    1432 // rmr 050128
;    1433 /*************************************************************/
;    1434 {
_SteinhartHart:
;    1435 	double x;
;    1436 //	double Tabs = 273.15;  // defined elsewhere
;    1437 
;    1438 	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
;    1439 	
;    1440 	x = log(R);
	SBIW R28,4
;	*C -> Y+8
;	R -> Y+4
;	x -> Y+0
	CALL SUBOPT_0x35
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x2A
;    1441 	x = C[0] + x * ( C[1] + C[2] * x * x );
	CALL SUBOPT_0x6F
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
	CALL SUBOPT_0x6B
	CALL __MULF12
	CALL SUBOPT_0x75
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x75
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x26
;    1442 	x = 1/x - Tabs;
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x49
	LDS  R26,_Tabs
	LDS  R27,_Tabs+1
	LDS  R24,_Tabs+2
	LDS  R25,_Tabs+3
	CALL __SUBF12
	CALL SUBOPT_0x2A
;    1443 	
;    1444 	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
;    1445 	return x;
	CALL SUBOPT_0x6B
_0x222:
	ADIW R28,10
	RET
;    1446 }
;    1447 
;    1448 

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
__put_G5:
	LD   R26,Y
	LDD  R27,Y+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0xF9
	CALL SUBOPT_0x32
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0xFA
_0xF9:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0xFA:
	ADIW R28,3
	RET
__ftoa_G5:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x6)
	BRLO _0xFB
	LDI  R30,LOW(5)
	STD  Y+8,R30
_0xFB:
	LDD  R30,Y+8
	LDI  R31,0
	LDI  R26,LOW(__fround_G5*2)
	LDI  R27,HIGH(__fround_G5*2)
	CALL SUBOPT_0x68
	CALL __GETD1PF
	CALL SUBOPT_0x4C
	CALL __ADDF12
	CALL SUBOPT_0x4B
	LDI  R16,LOW(0)
	CALL SUBOPT_0x7A
	__PUTD1S 2
_0xFC:
	__GETD1S 2
	CALL SUBOPT_0x4C
	CALL __CMPF12
	BRLO _0xFE
	CALL SUBOPT_0x7B
	CALL __MULF12
	__PUTD1S 2
	SUBI R16,-LOW(1)
	RJMP _0xFC
_0xFE:
	CPI  R16,0
	BRNE _0xFF
	CALL SUBOPT_0x7C
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x100
_0xFF:
_0x101:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x103
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x37
	CALL SUBOPT_0x4C
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7E
	__GETD2S 2
	CALL SUBOPT_0x70
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4B
	RJMP _0x101
_0x103:
_0x100:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x104
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x221
_0x104:
	CALL SUBOPT_0x7C
	LDI  R30,LOW(46)
	ST   X,R30
_0x105:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x107
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x4B
	__GETD1S 9
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x36
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4B
	RJMP _0x105
_0x107:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x221:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G5:
	SBIW R28,4
	CALL __SAVELOCR3
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x80
	LDD  R26,Y+10
	CPI  R26,LOW(0x6)
	BRLO _0x108
	LDI  R30,LOW(5)
	STD  Y+10,R30
_0x108:
	LDD  R16,Y+10
_0x109:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x10B
	CALL SUBOPT_0x81
	CALL SUBOPT_0x80
	RJMP _0x109
_0x10B:
	__GETD1S 11
	CALL __CPD10
	BRNE _0x10C
	LDI  R18,LOW(0)
	CALL SUBOPT_0x81
	CALL SUBOPT_0x80
	RJMP _0x10D
_0x10C:
	LDD  R18,Y+10
	CALL SUBOPT_0x82
	BREQ PC+2
	BRCC PC+3
	JMP  _0x10E
	CALL SUBOPT_0x81
	CALL SUBOPT_0x80
_0x10F:
	CALL SUBOPT_0x82
	BRLO _0x111
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
	RJMP _0x10F
_0x111:
	RJMP _0x112
_0x10E:
_0x113:
	CALL SUBOPT_0x82
	BRSH _0x115
	CALL SUBOPT_0x83
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x85
	SUBI R18,LOW(1)
	RJMP _0x113
_0x115:
	CALL SUBOPT_0x81
	CALL SUBOPT_0x80
_0x112:
	__GETD1S 11
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x85
	CALL SUBOPT_0x82
	BRLO _0x116
	CALL SUBOPT_0x83
	CALL SUBOPT_0x84
_0x116:
_0x10D:
	LDI  R16,LOW(0)
_0x117:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x119
	__GETD2S 3
	CALL SUBOPT_0x58
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x80
	__GETD1S 3
	CALL SUBOPT_0x83
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x86
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 3
	CALL __MULF12
	CALL SUBOPT_0x83
	CALL SUBOPT_0x41
	CALL SUBOPT_0x85
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x117
	CALL SUBOPT_0x86
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x117
_0x119:
	CALL SUBOPT_0x87
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x11B
	CALL SUBOPT_0x86
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R18
_0x11B:
	CPI  R18,10
	BRLT _0x11C
	CALL SUBOPT_0x87
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __DIVB21
	CALL SUBOPT_0x88
_0x11C:
	CALL SUBOPT_0x87
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __MODB21
	CALL SUBOPT_0x88
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDI  R30,LOW(0)
	ST   X,R30
	CALL __LOADLOCR3
	ADIW R28,15
	RET
__print_G5:
	SBIW R28,28
	CALL __SAVELOCR6
	LDI  R16,0
_0x11D:
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	ADIW R30,1
	STD  Y+38,R30
	STD  Y+38+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x11F
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,0
	BRNE _0x123
	CPI  R19,37
	BRNE _0x124
	LDI  R16,LOW(1)
	RJMP _0x125
_0x124:
	CALL SUBOPT_0x89
_0x125:
	RJMP _0x122
_0x123:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x126
	CPI  R19,37
	BRNE _0x127
	CALL SUBOPT_0x89
	RJMP _0x229
_0x127:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x128
	LDI  R17,LOW(1)
	RJMP _0x122
_0x128:
	CPI  R19,43
	BRNE _0x129
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x122
_0x129:
	CPI  R19,32
	BRNE _0x12A
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x122
_0x12A:
	RJMP _0x12B
_0x126:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x12C
_0x12B:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x12D
	ORI  R17,LOW(128)
	RJMP _0x122
_0x12D:
	RJMP _0x12E
_0x12C:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x12F
_0x12E:
	CPI  R19,48
	BRLO _0x131
	CPI  R19,58
	BRLO _0x132
_0x131:
	RJMP _0x130
_0x132:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	CALL SUBOPT_0x8A
	ADD  R20,R30
	RJMP _0x122
_0x130:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x133
	LDI  R16,LOW(4)
	RJMP _0x122
_0x133:
	RJMP _0x134
_0x12F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x136
	CPI  R19,48
	BRLO _0x138
	CPI  R19,58
	BRLO _0x139
_0x138:
	RJMP _0x137
_0x139:
	ORI  R17,LOW(32)
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R19
	CALL SUBOPT_0x8A
	ADD  R21,R30
	RJMP _0x122
_0x137:
_0x134:
	CPI  R19,108
	BRNE _0x13A
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x122
_0x13A:
	RJMP _0x13B
_0x136:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x122
_0x13B:
	MOV  R30,R19
	CALL SUBOPT_0x8B
	BRNE _0x140
	CALL SUBOPT_0x8C
	LD   R30,X
	CALL SUBOPT_0x8D
	RJMP _0x141
_0x140:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BREQ _0x144
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x145
_0x144:
	RJMP _0x146
_0x145:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x147
_0x146:
	MOVW R30,R28
	ADIW R30,18
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x8C
	CALL __GETD1P
	CALL SUBOPT_0x64
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x148
	LDD  R26,Y+17
	CPI  R26,LOW(0x2B)
	BREQ _0x14A
	RJMP _0x14B
_0x148:
	CALL SUBOPT_0x72
	CALL __ANEGF1
	CALL SUBOPT_0x64
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x14A:
	SBRS R17,7
	RJMP _0x14C
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	RJMP _0x14D
_0x14C:
	CALL SUBOPT_0x8E
	LDD  R26,Y+17
	STD  Z+0,R26
_0x14D:
_0x14B:
	SBRS R17,5
	LDI  R21,LOW(5)
	CPI  R19,102
	BRNE _0x14F
	CALL SUBOPT_0x72
	CALL __PUTPARD1
	ST   -Y,R21
	CALL SUBOPT_0x8F
	CALL __ftoa_G5
	RJMP _0x150
_0x14F:
	CALL SUBOPT_0x72
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G5
_0x150:
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0x90
	RJMP _0x151
_0x147:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x153
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CALL SUBOPT_0x90
	RJMP _0x154
_0x153:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x156
	CALL SUBOPT_0x8C
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x154:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x158
	CP   R21,R16
	BRLO _0x159
_0x158:
	RJMP _0x157
_0x159:
	MOV  R16,R21
_0x157:
_0x151:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x15A
_0x156:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x15D
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x15E
_0x15D:
	ORI  R17,LOW(4)
	RJMP _0x15F
_0x15E:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x160
_0x15F:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x161
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x42
	LDI  R16,LOW(10)
	RJMP _0x162
_0x161:
	__GETD1N 0x2710
	CALL SUBOPT_0x42
	LDI  R16,LOW(5)
	RJMP _0x162
_0x160:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x164
	ORI  R17,LOW(8)
	RJMP _0x165
_0x164:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x1A3
_0x165:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x167
	__GETD1N 0x10000000
	CALL SUBOPT_0x42
	LDI  R16,LOW(8)
	RJMP _0x162
_0x167:
	__GETD1N 0x1000
	CALL SUBOPT_0x42
	LDI  R16,LOW(4)
_0x162:
	CPI  R21,0
	BREQ _0x168
	ANDI R17,LOW(127)
	RJMP _0x169
_0x168:
	LDI  R21,LOW(1)
_0x169:
	SBRS R17,1
	RJMP _0x16A
	CALL SUBOPT_0x8C
	CALL __GETD1P
	RJMP _0x22A
_0x16A:
	SBRS R17,2
	RJMP _0x16C
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x22A
_0x16C:
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x22A:
	__PUTD1S 6
	SBRS R17,2
	RJMP _0x16E
	CALL SUBOPT_0x91
	CALL __CPD20
	BRGE _0x16F
	CALL SUBOPT_0x72
	CALL __ANEGD1
	CALL SUBOPT_0x64
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x16F:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x170
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x171
_0x170:
	ANDI R17,LOW(251)
_0x171:
_0x16E:
	MOV  R18,R21
_0x15A:
	SBRC R17,0
	RJMP _0x172
_0x173:
	CP   R16,R20
	BRSH _0x176
	CP   R18,R20
	BRLO _0x177
_0x176:
	RJMP _0x175
_0x177:
	SBRS R17,7
	RJMP _0x178
	SBRS R17,2
	RJMP _0x179
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0x17A
_0x179:
	LDI  R19,LOW(48)
_0x17A:
	RJMP _0x17B
_0x178:
	LDI  R19,LOW(32)
_0x17B:
	CALL SUBOPT_0x89
	SUBI R20,LOW(1)
	RJMP _0x173
_0x175:
_0x172:
_0x17C:
	CP   R16,R21
	BRSH _0x17E
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x17F
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x180
	SUBI R20,LOW(1)
_0x180:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x17F:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x181
	SUBI R20,LOW(1)
_0x181:
	SUBI R21,LOW(1)
	RJMP _0x17C
_0x17E:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x182
_0x183:
	CPI  R18,0
	BREQ _0x185
	SBRS R17,3
	RJMP _0x186
	CALL SUBOPT_0x8E
	LPM  R30,Z
	RJMP _0x22B
_0x186:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x22B:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G5
	CPI  R20,0
	BREQ _0x188
	SUBI R20,LOW(1)
_0x188:
	SUBI R18,LOW(1)
	RJMP _0x183
_0x185:
	RJMP _0x189
_0x182:
_0x18B:
	CALL SUBOPT_0x43
	CALL SUBOPT_0x91
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x18D
	SBRS R17,3
	RJMP _0x18E
	SUBI R19,-LOW(55)
	RJMP _0x18F
_0x18E:
	SUBI R19,-LOW(87)
_0x18F:
	RJMP _0x190
_0x18D:
	SUBI R19,-LOW(48)
_0x190:
	SBRC R17,4
	RJMP _0x192
	CPI  R19,49
	BRSH _0x194
	CALL SUBOPT_0x46
	__CPD2N 0x1
	BRNE _0x193
_0x194:
	RJMP _0x196
_0x193:
	CP   R21,R18
	BRLO _0x197
	RJMP _0x22C
_0x197:
	CP   R20,R18
	BRLO _0x199
	SBRS R17,0
	RJMP _0x19A
_0x199:
	RJMP _0x198
_0x19A:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x19B
_0x22C:
	LDI  R19,LOW(48)
_0x196:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x19C
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x19D
	SUBI R20,LOW(1)
_0x19D:
_0x19C:
_0x19B:
_0x192:
	CALL SUBOPT_0x89
	CPI  R20,0
	BREQ _0x19E
	SUBI R20,LOW(1)
_0x19E:
_0x198:
	SUBI R18,LOW(1)
	CALL SUBOPT_0x43
	CALL SUBOPT_0x91
	CALL __MODD21U
	CALL SUBOPT_0x64
	LDD  R30,Y+16
	LDI  R31,0
	CALL SUBOPT_0x46
	CALL __CWD1
	CALL __DIVD21U
	CALL SUBOPT_0x42
	CALL SUBOPT_0x43
	CALL __CPD10
	BREQ _0x18C
	RJMP _0x18B
_0x18C:
_0x189:
	SBRS R17,0
	RJMP _0x19F
_0x1A0:
	CPI  R20,0
	BREQ _0x1A2
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x8D
	RJMP _0x1A0
_0x1A2:
_0x19F:
_0x1A3:
_0x141:
_0x229:
	LDI  R16,LOW(0)
_0x122:
	RJMP _0x11D
_0x11F:
	CALL __LOADLOCR6
	ADIW R28,40
	RET
_printf:
	PUSH R15
	CALL SUBOPT_0x92
	CALL __print_G5
	RJMP _0x21F
__get_G5:
	ST   -Y,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x1A4
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1A5
_0x1A4:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x1A6
	CALL __GETW1P
	LD   R30,Z
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x1A7
	CALL SUBOPT_0x32
_0x1A7:
	RJMP _0x1A8
_0x1A6:
	CALL _getchar
	MOV  R16,R30
_0x1A8:
_0x1A5:
	MOV  R30,R16
	LDD  R16,Y+0
	ADIW R28,5
	RET
__scanf_G5:
	SBIW R28,7
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	STD  Y+11,R30
	STD  Y+12,R30
_0x1A9:
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
	JMP _0x1AB
	CALL SUBOPT_0x93
	BREQ _0x1AC
_0x1AD:
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1B0
	CALL SUBOPT_0x93
	BRNE _0x1B1
_0x1B0:
	RJMP _0x1AF
_0x1B1:
	RJMP _0x1AD
_0x1AF:
	STD  Y+12,R18
	RJMP _0x1B2
_0x1AC:
	CPI  R18,37
	BREQ PC+3
	JMP _0x1B3
	LDI  R20,LOW(0)
_0x1B4:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
	CPI  R18,48
	BRLO _0x1B8
	CPI  R18,58
	BRLO _0x1B7
_0x1B8:
	RJMP _0x1B6
_0x1B7:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	CALL SUBOPT_0x8A
	ADD  R20,R30
	RJMP _0x1B4
_0x1B6:
	CPI  R18,0
	BRNE _0x1BA
	RJMP _0x1AB
_0x1BA:
_0x1BB:
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R19,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BRNE _0x1BB
	CPI  R19,0
	BRNE _0x1BE
	RJMP _0x1BF
_0x1BE:
	STD  Y+12,R19
	CPI  R20,0
	BRNE _0x1C0
	LDI  R20,LOW(255)
_0x1C0:
	LDI  R21,LOW(0)
	MOV  R30,R18
	CALL SUBOPT_0x8B
	BRNE _0x1C4
	CALL SUBOPT_0x95
	CALL SUBOPT_0x94
	CALL __get_G5
	MOVW R26,R16
	ST   X,R30
	RJMP _0x1C3
_0x1C4:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x1C5
	CALL SUBOPT_0x95
_0x1C6:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1C8
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1CA
	CALL SUBOPT_0x93
	BREQ _0x1C9
_0x1CA:
	RJMP _0x1C8
_0x1C9:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R18
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x1C6
_0x1C8:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1C3
_0x1C5:
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BRNE _0x1CD
	LDI  R21,LOW(1)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
_0x1CD:
	LDI  R30,LOW(1)
	STD  Y+10,R30
	MOV  R30,R18
	LDI  R31,0
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x1D2
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x1D3
_0x1D2:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	RJMP _0x1D4
_0x1D3:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x1D5
_0x1D4:
	LDI  R19,LOW(10)
	RJMP _0x1D0
_0x1D5:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x1D6
	LDI  R19,LOW(16)
	RJMP _0x1D0
_0x1D6:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x1D9
	RJMP _0x1D8
_0x1D9:
	LDD  R30,Y+11
	RJMP _0x220
_0x1D0:
	__CLRD1S 6
_0x1DA:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1DC
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,LOW(0x21)
	BRLO _0x1DE
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x1DF
	CPI  R18,45
	BRNE _0x1E0
	LDI  R30,LOW(255)
	STD  Y+10,R30
	RJMP _0x1DA
_0x1E0:
	LDI  R30,LOW(1)
	STD  Y+10,R30
_0x1DF:
	CPI  R18,48
	BRLO _0x1DE
	CPI  R18,97
	BRLO _0x1E3
	SUBI R18,LOW(87)
	RJMP _0x1E4
_0x1E3:
	CPI  R18,65
	BRLO _0x1E5
	SUBI R18,LOW(55)
	RJMP _0x1E6
_0x1E5:
	SUBI R18,LOW(48)
_0x1E6:
_0x1E4:
	CP   R18,R19
	BRLO _0x1E7
_0x1DE:
	STD  Y+12,R18
	RJMP _0x1DC
_0x1E7:
	MOV  R30,R19
	LDI  R31,0
	CALL SUBOPT_0x96
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R18
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	CALL SUBOPT_0x64
	RJMP _0x1DA
_0x1DC:
	LDD  R30,Y+10
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CALL SUBOPT_0x96
	CALL SUBOPT_0x64
	CPI  R21,0
	BREQ _0x1E8
	CALL SUBOPT_0x95
	CALL SUBOPT_0x72
	MOVW R26,R16
	CALL __PUTDP1
	RJMP _0x1E9
_0x1E8:
	CALL SUBOPT_0x95
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x1E9:
_0x1C3:
	LDD  R30,Y+11
	SUBI R30,-LOW(1)
	STD  Y+11,R30
	RJMP _0x1EA
_0x1B3:
_0x1D8:
	CALL SUBOPT_0x94
	CALL __get_G5
	LDI  R31,0
	MOV  R26,R18
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1EB
_0x1BF:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x1EC
	LDI  R30,LOW(255)
	RJMP _0x220
_0x1EC:
	RJMP _0x1AB
_0x1EB:
_0x1EA:
_0x1B2:
	RJMP _0x1A9
_0x1AB:
	LDD  R30,Y+11
_0x220:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
_scanf:
	PUSH R15
	CALL SUBOPT_0x92
	CALL __scanf_G5
_0x21F:
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
_0x1ED:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x1EF
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1ED
_0x1EF:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R20,43
	BRNE _0x1F0
	RJMP _0x22D
_0x1F0:
	CPI  R20,45
	BRNE _0x1F2
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x22D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1F2:
	LDI  R30,LOW(0)
	MOV  R21,R30
	MOV  R20,R30
	__GETWRS 16,17,16
_0x1F3:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BRNE _0x1F6
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R20,R30
	CPI  R30,0
	BREQ _0x1F5
_0x1F6:
	MOV  R30,R20
	LDI  R31,0
	OR   R21,R30
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1F3
_0x1F5:
	__GETWRS 18,19,16
	CPI  R21,0
	BREQ _0x1F8
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1F9:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x1FB
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x47
	CALL SUBOPT_0x36
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x58
	CALL __DIVF21
	CALL SUBOPT_0x78
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1F9
_0x1FB:
_0x1F8:
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x42
_0x1FC:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x1FE
	LD   R30,X
	CALL SUBOPT_0x8A
	CALL SUBOPT_0x46
	CALL SUBOPT_0x70
	CALL SUBOPT_0x47
	CALL SUBOPT_0x44
	CALL SUBOPT_0x46
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x42
	RJMP _0x1FC
_0x1FE:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R20,X
	CPI  R20,101
	BREQ _0x200
	CPI  R20,69
	BREQ _0x200
	RJMP _0x1FF
_0x200:
	LDI  R30,LOW(0)
	MOV  R21,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R20,X
	CPI  R20,43
	BRNE _0x202
	RJMP _0x22E
_0x202:
	CPI  R20,45
	BRNE _0x204
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x22E:
	__ADDWRN 18,19,1
_0x204:
_0x205:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x207
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R26,R30
	MOV  R30,R20
	LDI  R31,0
	LDI  R27,0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __SWAPW12
	SUB  R30,R26
	MOV  R21,R30
	RJMP _0x205
_0x207:
	CPI  R21,39
	BRLO _0x208
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x209
	__GETD1N 0xFF7FFFFF
	RJMP _0x21E
_0x209:
	__GETD1N 0x7F7FFFFF
	RJMP _0x21E
_0x208:
	LDI  R20,LOW(32)
	CALL SUBOPT_0x7A
	CALL SUBOPT_0x42
_0x20A:
	CPI  R20,0
	BREQ _0x20C
	CALL SUBOPT_0x45
	CALL SUBOPT_0x42
	MOV  R30,R21
	LDI  R31,0
	MOV  R26,R20
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x20D
	CALL SUBOPT_0x46
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x42
_0x20D:
	LSR  R20
	RJMP _0x20A
_0x20C:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x20E
	CALL SUBOPT_0x43
	CALL SUBOPT_0x47
	CALL __DIVF21
	RJMP _0x22F
_0x20E:
	CALL SUBOPT_0x43
	CALL SUBOPT_0x47
	CALL __MULF12
_0x22F:
	__PUTD1S 8
_0x1FF:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x210
	CALL SUBOPT_0x6A
	CALL __ANEGF1
	CALL SUBOPT_0x78
_0x210:
	CALL SUBOPT_0x6A
_0x21E:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x211:
	SBIS 0xE,7
	RJMP _0x211
	IN   R30,0xF
	ADIW R28,1
	RET
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
	RCALL SUBOPT_0x91
	CALL __CPD02
	BRLT _0x214
	__GETD1N 0xFF7FFFFF
	RJMP _0x21D
_0x214:
	RCALL SUBOPT_0x72
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
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x91
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x215
	RCALL SUBOPT_0x72
	RCALL SUBOPT_0x91
	CALL __ADDF12
	RCALL SUBOPT_0x64
	__SUBWRN 16,17,1
_0x215:
	RCALL SUBOPT_0x91
	RCALL SUBOPT_0x7A
	RCALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x72
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RCALL SUBOPT_0x64
	RCALL SUBOPT_0x72
	RCALL SUBOPT_0x91
	CALL __MULF12
	RCALL SUBOPT_0x37
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x91
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 2
	__GETD1N 0x3FD4114D
	RCALL SUBOPT_0x41
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
	RCALL SUBOPT_0x70
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x21D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
_rtc_init:
	LD   R30,Y
	ANDI R30,LOW(0x3)
	ST   Y,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x216
	LD   R30,Y
	ORI  R30,LOW(0xA0)
	ST   Y,R30
_0x216:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x217
	LD   R30,Y
	ORI  R30,4
	RJMP _0x230
_0x217:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x219
	LD   R30,Y
	ORI  R30,8
	RJMP _0x230
_0x219:
	LDI  R30,LOW(0)
_0x230:
	ST   Y,R30
	RCALL SUBOPT_0x97
	LDI  R30,LOW(144)
	ST   -Y,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x98
	RJMP _0x21B
_rtc_get_time:
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x99
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x99
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(129)
	RCALL SUBOPT_0x99
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RJMP _0x21C
_rtc_set_time:
	RCALL SUBOPT_0x97
	LDI  R30,LOW(132)
	RCALL SUBOPT_0x9A
	LDI  R30,LOW(130)
	RCALL SUBOPT_0x9B
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x9C
	RJMP _0x21B
_rtc_get_date:
	LDI  R30,LOW(135)
	RCALL SUBOPT_0x99
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(137)
	RCALL SUBOPT_0x99
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(141)
	RCALL SUBOPT_0x99
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
_0x21C:
	ADIW R28,6
	RET
_rtc_set_date:
	RCALL SUBOPT_0x97
	LDI  R30,LOW(134)
	RCALL SUBOPT_0x9A
	LDI  R30,LOW(136)
	RCALL SUBOPT_0x9B
	LDI  R30,LOW(140)
	RCALL SUBOPT_0x9C
_0x21B:
	ADIW R28,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x0:
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
SUBOPT_0x1:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	__POINTW1FN _0,178
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	__POINTW1FN _0,206
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	__POINTW1FN _0,218
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	__POINTW1FN _0,251
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6:
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
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	__POINTW1FN _0,339
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	__POINTW1FN _0,388
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rtc_get_time
	MOV  R7,R6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Read_Max186

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	MOVW R30,R20
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	CALL __PUTPARD1
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x12:
	CALL __PUTPARD1
	MOVW R30,R28
	SUBI R30,LOW(-(68))
	SBCI R31,HIGH(-(68))
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(66))
	SBCI R31,HIGH(-(66))
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	SUBI R30,LOW(-(64))
	SBCI R31,HIGH(-(64))
	ST   -Y,R31
	ST   -Y,R30
	CALL _therm_circuit_ground
	__GETD1S 44
	CALL __PUTPARD1
	__GETD1S 44
	CALL __PUTPARD1
	JMP  _ysi46000

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	__GETD2S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__PUTD1S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	CALL __GETW1P
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	__GETD2S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	CALL __ADDF12
	__PUTD1S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD1S 52
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	MOVW R16,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x25:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CALL __ADDF12
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	__GETW1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x29:
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2B:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _rtc_get_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2E:
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
SUBOPT_0x2F:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x30:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	CALL __PUTPARD1
	__GETD1SX 70
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Read_Max186

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Read_Max186

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x36:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x37:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x39:
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
SUBOPT_0x3A:
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 66 TIMES, CODE SIZE REDUCTION:257 WORDS
SUBOPT_0x3B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3C:
	LDI  R24,12
	CALL _printf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3E:
	__POINTW1FN _0,53
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3F:
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
SUBOPT_0x40:
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x41:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x43:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	CALL __ADDF12
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x45:
	RCALL SUBOPT_0x43
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x46:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x47:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	__PUTD1S 16
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	__GETD2N 0x3F800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4A:
	MOV  R30,R4
	LDI  R31,0
	LDI  R26,LOW(3600)
	LDI  R27,HIGH(3600)
	CALL __MULW12
	MOVW R22,R30
	MOV  R30,R5
	LDI  R31,0
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	CALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4C:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _scanf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4E:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x27
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4F:
	__GETW1R 19,20
	MOVW R26,R28
	ADIW R26,13
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x50:
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
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x51:
	MOVW R26,R28
	ADIW R26,13
	ADD  R26,R19
	ADC  R27,R20
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x52:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	CALL _atof
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x53:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x54:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	__GETD1N 0x33D6BF95
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x56:
	__POINTW1FN _0,2360
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x58:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	__GETD1N 0x43FA0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5D:
	__GETD1N 0x471C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	__GETD1N 0x459C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x16
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x61:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x64:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	LDI  R24,32
	CALL _printf
	ADIW R28,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x66:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,38
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x67:
	MOVW R30,R16
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x69:
	__GETD1S 40
	CALL __PUTPARD1
	__GETD1S 48
	CALL __PUTPARD1
	__GETD1S 56
	CALL __PUTPARD1
	__GETD1SX 64
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6B:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6C:
	CALL __PUTDP1
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6D:
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x70:
	RCALL SUBOPT_0x36
	CALL __MULF12
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x72:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x73:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	CALL __DIVF21
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	RCALL SUBOPT_0x25
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	LDS  R30,_Tabs
	LDS  R31,_Tabs+1
	LDS  R22,_Tabs+2
	LDS  R23,_Tabs+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x77:
	RCALL SUBOPT_0x17
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	__GETD2S 20
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7A:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	__GETD2S 2
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7D:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7E:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7F:
	RCALL SUBOPT_0x58
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x80:
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x81:
	__GETD2S 3
	RJMP SUBOPT_0x7F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x82:
	__GETD1S 3
	__GETD2S 11
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x83:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x84:
	RCALL SUBOPT_0x58
	CALL __DIVF21
	__PUTD1S 11
	SUBI R18,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x87:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x88:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x89:
	ST   -Y,R19
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	SUBI R30,LOW(48)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8B:
	LDI  R31,0
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x8C:
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	SBIW R26,4
	STD  Y+36,R26
	STD  Y+36+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x8D:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8E:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8F:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x90:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x91:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x92:
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
SUBOPT_0x93:
	ST   -Y,R18
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x94:
	MOVW R30,R28
	ADIW R30,12
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x8F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x95:
	LDD  R26,Y+15
	LDD  R27,Y+15+1
	SBIW R26,4
	STD  Y+15,R26
	STD  Y+15+1,R27
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x96:
	RCALL SUBOPT_0x91
	CALL __CWD1
	CALL __MULD12U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x97:
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x98:
	ST   -Y,R30
	CALL _ds1302_write
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x99:
	ST   -Y,R30
	CALL _ds1302_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9B:
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9C:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _bin2bcd
	RJMP SUBOPT_0x98

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

__ftrunc:
	ldd  r23,y+3
	ldd  r22,y+2
	ldd  r31,y+1
	ld   r30,y
	bst  r23,7
	lsl  r23
	sbrc r22,7
	sbr  r23,1
	mov  r25,r23
	subi r25,0x7e
	breq __ftrunc0
	brcs __ftrunc0
	cpi  r25,24
	brsh __ftrunc1
	clr  r26
	clr  r27
	clr  r24
__ftrunc2:
	sec
	ror  r24
	ror  r27
	ror  r26
	dec  r25
	brne __ftrunc2
	and  r30,r26
	and  r31,r27
	and  r22,r24
	rjmp __ftrunc1
__ftrunc0:
	clt
	clr  r23
	clr  r30
	clr  r31
	clr  r22
__ftrunc1:
	cbr  r22,0x80
	lsr  r23
	brcc __ftrunc3
	sbr  r22,0x80
__ftrunc3:
	bld  r23,7
	ld   r26,y+
	ld   r27,y+
	ld   r24,y+
	ld   r25,y+
	cp   r30,r26
	cpc  r31,r27
	cpc  r22,r24
	cpc  r23,r25
	bst  r25,7
	ret

_floor:
	rcall __ftrunc
	brne __floor1
__floor0:
	ret
__floor1:
	brtc __floor0
	ldi  r25,0xbf

__addfc:
	clr  r26
	clr  r27
	ldi  r24,0x80
	rjmp __addf12

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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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

__GETD1PF:
	LPM  R0,Z+
	LPM  R1,Z+
	LPM  R22,Z+
	LPM  R23,Z
	MOVW R30,R0
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

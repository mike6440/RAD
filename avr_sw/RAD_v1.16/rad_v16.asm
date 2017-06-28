
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

	.INCLUDE "rad_v16.vec"
	.INCLUDE "rad_v16.inc"

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
;       4 // v16 080812 :: rmr edits.  Sent to re for compile and install.
;       5 //	1. Rewrite main section with double while loops.
;       6 //	2. Change \n\r to \r\n == <cr><lf>
;       7 /*********************************************
;       8 This program was produced by the
;       9 CodeWizardAVR V1.23.8c Standard
;      10 Automatic Program Generator
;      11 © Copyright 1998-2003 HP InfoTech s.r.l.
;      12 http://www.hpinfotech.ro
;      13 e-mail:office@hpinfotech.ro
;      14 
;      15 Project : NOAA Radiometer Interface Board
;      16 Version : 
;      17 Date    : 12/20/2004
;      18 Author  : Ray Edwards                     
;      19 Company : Brookhaven National Laboratory  
;      20 Comments: Revision History
;      21 	1.0 - Start with simple timed operation 12/22/04 
;      22     1.1 - Build user menu and implement eeprom variables 03/24/05
;      23     1.13 - Bigelow mods.  see "v13" comments
;      24       * spread out the print statement a bit.
;      25       * timeout in Main_Menu
;      26       
;      27 //*** search on these comments     
;      28 /********************************************
;      29 Chip type           : ATmega64
;      30 Program type        : Application
;      31 Clock frequency     : 8.000000 MHz
;      32 Memory model        : Small
;      33 External SRAM size  : 0
;      34 Data Stack size     : 1024
;      35 *********************************************/
;      36 //*** REVISION B NOV 2007    
;      37 /********************************************
;      38 Chip type           : ATmega128
;      39 Program type        : Application
;      40 Clock frequency     : 16.000000 MHz
;      41 Memory model        : Small
;      42 External SRAM size  : 0
;      43 Data Stack size     : 1024
;      44 *********************************************/
;      45 #include <delay.h>
;      46 #include <stdio.h>
;      47 #include <stdlib.h> 
;      48 #include <spi.h> 
;      49 #include <math.h>
;      50 #include "thermistor.h"
;      51 #include "pir.h"
;      52 #include "psp.h"
;      53 #include <mega128.h>
;      54 #include <eeprom.h>
;      55 #include <ds1302.h>
;      56 
;      57 // DS1302 Real Time Clock port init
;      58 #asm
;      59    .equ __ds1302_port=0x18
   .equ __ds1302_port=0x18
;      60    .equ __ds1302_io=4
   .equ __ds1302_io=4
;      61    .equ __ds1302_sclk=5
   .equ __ds1302_sclk=5
;      62    .equ __ds1302_rst=6
   .equ __ds1302_rst=6
;      63 #endasm
;      64 
;      65 #define RXB8 	1
;      66 #define TXB8 	0
;      67 #define UPE 	2
;      68 #define OVR 	3
;      69 #define FE 	    4
;      70 #define UDRE 	5
;      71 #define RXC 	7
;      72 #define BATT	7
;      73 #define PCTEMP	6
;      74 #define VREF	5  
;      75 #define ALL	    8       
;      76 #define NSAMPS	100
;      77 #define NCHANS	8
;      78 
;      79 // watchdog WDTCR register bit positions and mask
;      80 #define WDCE   (4)  // Watchdog Turn-off Enable
;      81 #define WDE     (3)  // Watchdog Enable
;      82 #define PMASK   (7)  // prescaler mask    
;      83 #define WATCHDOG_PRESCALE (7)    
;      84 //#define XTAL	16000000
;      85 #define XTAL 3686400
;      86 #define BAUD	19200  //default terminal setting
;      87 #define OK	1
;      88 #define NOTOK	0 
;      89 #define FRAMING_ERROR (1<<FE)
;      90 #define PARITY_ERROR (1<<UPE)
;      91 #define DATA_OVERRUN (1<<OVR)
;      92 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      93 #define RX_COMPLETE (1<<RXC)
;      94 #define MENU_TIMEOUT 30
;      95 //v15 v16
;      96 //#define VERSION "1.16"
;      97 //#define VERDATE "2008/08/13"
;      98 
;      99 // Get a character from the USART1 Receiver
;     100 #pragma used+
;     101 char getchar1(void)
;     102 {

	.CSEG
;     103 char status,data;
;     104 while (1)
;	status -> R16
;	data -> R17
;     105       {
;     106       while (((status=UCSR1A) & RX_COMPLETE)==0);
;     107       data=UDR1;
;     108       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;     109          return data;
;     110       };
;     111 }
;     112 #pragma used-
;     113 
;     114 // Write a character to the USART1 Transmitter
;     115 #pragma used+
;     116 void putchar1(char c)
;     117 {
;     118 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
;     119 UDR1=c;
;     120 }
;     121 #pragma used-
;     122 
;     123 //PROTOTYPES
;     124 void ATMega128_Setup(void);
;     125 void SignOn(void);
;     126 float ReadBattVolt(void);
;     127 float ReadRefVolt(void); 
;     128 float ReadAVRTemp();
;     129 void Heartbeat(void);
;     130 int SerByteAvail(void);  
;     131 int ClearScreen(void);
;     132 int Read_Max186(int, int); 
;     133 float RL10052Temp (unsigned int v2, int ref, int res);
;     134 void Main_Menu(void);
;     135 void ReadAnalog( int chan );
;     136 void MeanStdev(double *sum, double *sum2, int N, double missing);
;     137 void SampleADC(void);
;     138 
;     139 //GLOBAL VARIABLES
;     140 //COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
;     141 float COEFFA = 	.0033540172; 

	.DSEG
_COEFFA:
	.BYTE 0x4
;     142 float COEFFB = 	.00032927261; 
_COEFFB:
	.BYTE 0x4
;     143 float COEFFC =	.0000041188325;
_COEFFC:
	.BYTE 0x4
;     144 float COEFFD = -.00000016472972;
_COEFFD:
	.BYTE 0x4
;     145 
;     146 unsigned char h, m, s;
;     147 unsigned char dt, mon, yr;
;     148 int t_now, t_end;  // v16 used for sampling loops
;     149 int state;
_state:
	.BYTE 0x2
;     150 unsigned char version[10] = "1.16";  //v15  v16
_version:
	.BYTE 0xA
;     151 unsigned char verdate[20] = "2008/08/21";  //v15 v16
_verdate:
	.BYTE 0x14
;     152 double Tabs = 273.15;
_Tabs:
	.BYTE 0x4
;     153 int adc[NCHANS];   
_adc:
	.BYTE 0x10
;     154 
;     155 //SETUP EEPROM VARIABLES AND INITIALIZE
;     156 eeprom float psp = 7.72E-6;			//PSP COEFF

	.ESEG
_psp:
	.DW  0x8526
	.DW  0x3701
;     157 eeprom float pir = 3.68E-6;			//PIR COEFF
_pir:
	.DW  0xF5EB
	.DW  0x3676
;     158 eeprom int looptime = 10;			//NMEA OUTPUT SCHEDULE
_looptime:
	.DW  0xA
;     159 eeprom int Cmax = 2048;				//A/D COUNTS MAX VALUE
_Cmax:
	.DW  0x800
;     160 eeprom float RrefC = 33042.0; 		//CASE REFERENCE RESISTOR VALUE
_RrefC:
	.DW  0x1200
	.DW  0x4701
;     161 eeprom float RrefD = 33046.0;     	//DOME REFERENCE RESISTOR VALUE
_RrefD:
	.DW  0x1600
	.DW  0x4701
;     162 eeprom float Vtherm = 4.0963;		//THERMISTOR SUPPLY VOLTAGE
_Vtherm:
	.DW  0x14E4
	.DW  0x4083
;     163 eeprom float Vadc = 4.0960;			//A/D REFERENCE VOLTAGE 
_Vadc:
	.DW  0x126F
	.DW  0x4083
;     164 // v15 -- note this offset is in mv as it is subtracted from the 
;     165 // from the ADC count.  Same for PSPadc_offset
;     166 eeprom float PIRadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PIRadc_offset:
	.DW  0x0
	.DW  0x0
;     167 eeprom float PIRadc_gain = 815.0;
_PIRadc_gain:
	.DW  0xC000
	.DW  0x444B
;     168 eeprom float PSPadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PSPadc_offset:
	.DW  0x0
	.DW  0x0
;     169 eeprom float PSPadc_gain = 125.0;
_PSPadc_gain:
	.DW  0x0
	.DW  0x42FA
;     170 eeprom int   Id_address = 00;		//$RAD** address $RAD00 is default
_Id_address:
	.DW  0x0
;     171 
;     172 
;     173 /******************************************************************************************
;     174 MAIN
;     175 ******************************************************************************************/
;     176 void main(void)
;     177 {

	.CSEG
_main:
;     178 
;     179 	double ADC0_mV, ADC1_mV, ADC2_mV, ADC3_mV, ADC4_mV, ADC5_mV, ADC6_mV, ADC7_mV;  //v16
;     180 	unsigned long nsamps;  // v16 to prevent overflow.
;     181 	double BattV, AVRTemp, RefV;
;     182 	double vt, Rt, Pt;
;     183 	double tcase, tdome;
;     184 	double sw, lw, C_c, C_d;
;     185 	
;     186 	
;     187  	
;     188 	state = 0;
	SBIW R28,63
	SBIW R28,21
;	ADC0_mV -> Y+80
;	ADC1_mV -> Y+76
;	ADC2_mV -> Y+72
;	ADC3_mV -> Y+68
;	ADC4_mV -> Y+64
;	ADC5_mV -> Y+60
;	ADC6_mV -> Y+56
;	ADC7_mV -> Y+52
;	nsamps -> Y+48
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
	LDI  R30,0
	STS  _state,R30
	STS  _state+1,R30
;     189 	Cmax = 2048;
	LDI  R30,LOW(2048)
	LDI  R31,HIGH(2048)
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMWRW
;     190 	
;     191     ATMega128_Setup();
	RCALL _ATMega128_Setup
;     192     SignOn();
	RCALL _SignOn
;     193     Heartbeat();
	RCALL _Heartbeat
;     194     
;     195 	printf("\r\n***** SMART DIGITAL INTERFACE *****\r\n");
	CALL SUBOPT_0x0
;     196 	printf(" Software Version %s, %s\r\n", version, verdate);
;     197 	printf(" Current EEPROM values:\r\n");
;     198 	printf(" Identifier Header= $WIR%02d\r\n", Id_address);
;     199 	printf(" PSP Coeff= %.2E\r\n", psp);
;     200 	printf(" PIR Coeff= %.2E\r\n", pir);
	CALL SUBOPT_0x1
;     201 	printf(" Interval Time (secs)= %d\r\n", looptime);
	CALL SUBOPT_0x2
;     202 	printf(" Cmax= %d\r\n", Cmax);
	CALL SUBOPT_0x3
;     203 	printf(" Reference Resistor Case= %.1f\r\n", RrefC);
	CALL SUBOPT_0x4
;     204 	printf(" Reference Resistor Dome= %.1f\r\n", RrefD);
	CALL SUBOPT_0x5
;     205 	printf(" Vtherm= %.4f, Vadc= %.4f\r\n", Vtherm, Vadc);
	CALL SUBOPT_0x6
;     206 	printf(" PIR ADC Offset= %.2f mv\r\n", PIRadc_offset);
	__POINTW1FN _0,312
	CALL SUBOPT_0x7
;     207 	printf(" PIR ADC Gain= %.2f\r\n", PIRadc_gain);
	CALL SUBOPT_0x8
;     208 	printf(" PSP ADC Offset= %.2f mv\r\n", PSPadc_offset);
	__POINTW1FN _0,361
	CALL SUBOPT_0x9
;     209 	printf(" PSP ADC Gain= %.2f\r\n", PSPadc_gain);
	CALL SUBOPT_0xA
;     210 	putchar('\r'); // CR
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
;     211 	putchar('\n'); // LF
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
;     212 	//*** check, do we want <cr><lf> or <lf><cr> ??
;     213 	// v15, the end of an output line will be <cr><lf>
;     214 	//v16 this was skipped in prev version
;     215 	
;     216 	//Heartbeat();
;     217 	//*** why no heartbeat? 
;     218 	
;     219 	//I added this to give a chance to set
;     220 	//menu options on boot-up if Date/Time aren't set.
;     221     Main_Menu();
	RCALL _Main_Menu
;     222 	
;     223 	//v16 -- add the additional loop to clear the sum variables.
;     224 	while (1) {
_0x12:
;     225 		ADC0_mV = ADC1_mV = ADC2_mV = ADC3_mV = ADC4_mV = ADC5_mV = ADC6_mV = ADC7_mV = 0;  
	CALL SUBOPT_0xB
	__PUTD1S 52
	__PUTD1S 56
	__PUTD1S 60
	__PUTD1SX 64
	CALL SUBOPT_0xC
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;     226 		nsamps = 0;
	__CLRD1S 48
;     227 		
;     228 		// SETUP FOR TIMED OPERATION
;     229 		// We define the loop at the top of the hour.
;     230 		// Note t_end can be = 0
;     231 		rtc_get_time(&h,&m,&s);		
	CALL SUBOPT_0x10
;     232 		t_end = ((int)m * 60 + (int)s) / looptime; //v16 integer number of loops in current hour.
	MOVW R0,R30
	CALL SUBOPT_0x11
	MOVW R26,R0
	CALL __DIVW21
	MOVW R12,R30
;     233 		t_end = ((t_end+1) * looptime) % 3600;  // hour seconds to the end of current loop. No overflow.
	CALL SUBOPT_0x11
	MOVW R26,R12
	ADIW R26,1
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(3600)
	LDI  R31,HIGH(3600)
	CALL __MODW21
	MOVW R12,R30
;     234 		
;     235 		//v16 summation loop
;     236 		while (1) {
_0x15:
;     237 			//v16 get the time at the start of the loop.
;     238 			rtc_get_time(&h,&m,&s); 
	CALL SUBOPT_0x10
;     239 			t_now = (int)m * 60 + (int)s;  //v16 seconds in this hour
	MOVW R10,R30
;     240 			
;     241 			//v16 when the time exceeds the end second, close this average.
;     242 			if( t_now == t_end) break;
	__CPWRR 12,13,10,11
	BREQ _0x17
;     243 			else {
;     244 				//PSP THERMOPILE
;     245 				ADC0_mV += Read_Max186(0,0); 	//PSP Sig 
	CALL SUBOPT_0x12
	CALL SUBOPT_0x12
	RCALL _Read_Max186
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0xF
;     246 				// PIR THERMOPILE
;     247 				ADC1_mV += Read_Max186(1,0); 	//PIR Sig
	CALL SUBOPT_0x15
	CALL SUBOPT_0x12
	RCALL _Read_Max186
	CALL SUBOPT_0x16
	CALL SUBOPT_0x14
	CALL SUBOPT_0xE
;     248 				// CASE TEMPERATURE
;     249 				ADC2_mV += Read_Max186(2,0);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x17
	RCALL _Read_Max186
	CALL SUBOPT_0x18
	CALL SUBOPT_0x14
	CALL SUBOPT_0xD
;     250 				// DOME TEMPERATURE
;     251 				ADC3_mV += Read_Max186(3,0);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x17
	RCALL _Read_Max186
	CALL SUBOPT_0x19
	CALL SUBOPT_0x14
	CALL SUBOPT_0xC
;     252 				
;     253 				//v16 we set the sample rate to 10 Hz
;     254 				delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1A
;     255 				nsamps++;
	CALL SUBOPT_0x1B
	__SUBD1N -1
	__PUTD1S 48
;     256  			}
;     257 		}  
	RJMP _0x15
_0x17:
;     258 		Heartbeat();
	RCALL _Heartbeat
;     259 		
;     260 		ADC0_mV /= nsamps;
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x13
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xF
;     261 		ADC1_mV /= nsamps;
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xE
;     262 		ADC2_mV /= nsamps;
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xD
;     263 		ADC3_mV /= nsamps;
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	CALL SUBOPT_0xC
;     264 		
;     265 		// TEMPS, VOLTAGES
;     266 		BattV = ReadBattVolt();  
	RCALL _ReadBattVolt
	__PUTD1S 44
;     267 		RefV = ReadRefVolt();
	RCALL _ReadRefVolt
	__PUTD1S 36
;     268 		AVRTemp = ReadAVRTemp();
	RCALL _ReadAVRTemp
	__PUTD1S 40
;     269 		
;     270 		// PSP COMPUTE -- sw  
;     271 		PSPSW( ADC0_mV, psp, PSPadc_offset, PSPadc_gain, &sw);
	MOVW R26,R28
	SUBI R26,LOW(-(80))
	SBCI R27,HIGH(-(80))
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	MOVW R30,R28
	ADIW R30,28
	ST   -Y,R31
	ST   -Y,R30
	CALL _PSPSW
;     272 		
;     273 		// PIR THERMOPLE == ADC1_mV
;     274 		
;     275 		// TCASE COMPUTE -- tcase
;     276 		therm_circuit_ground(ADC2_mV, Cmax, RrefC, Vadc, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(72))
	SBCI R27,HIGH(-(72))
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     277 		tcase = ysi46000(Rt,Pt);
	CALL SUBOPT_0x25
;     278 		
;     279 		// TDOME COMPUTE -- tdome
;     280 		therm_circuit_ground(ADC3_mV, Cmax, RrefD, Vadc, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(68))
	SBCI R27,HIGH(-(68))
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x26
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
;     281 		tdome = ysi46000(Rt,Pt);
	CALL SUBOPT_0x27
;     282 		
;     283 		// LW COMPUTATION -- lw
;     284 		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, tcase, tdome, 4.0, &lw, &C_c, &C_d);
	MOVW R26,R28
	SUBI R26,LOW(-(76))
	SBCI R27,HIGH(-(76))
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x28
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
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
;     285 				
;     286 		//OUTPUT STRING // v16
;     287 		rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
;     288 		rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2E
;     289 		//v13 I opened up the print statement a bit.
;     290 		//v16 Talker code = WI, So the prefix will be WIR for Weather Instrument, Radiometer
;     291 		//v16 <cr><lf> here.  Also remove \r\n at the beginning.
;     292 		printf("$WIR%02d,%02d/%02d/%02d,%02d:%02d:%02d,%4d,%6.1f,%6.2f,%6.2f,%6.2f,%7.2f,%5.1f,%5.1f\r\n", 
;     293 		   Id_address, yr, mon, dt, h, m, s, nsamps, ADC1_mV, lw, tcase, tdome, sw, AVRTemp, BattV);
	__POINTW1FN _0,410
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
	CALL SUBOPT_0x31
	__GETD1SX 78
	CALL __PUTPARD1
	__GETD1SX 110
	CALL __PUTPARD1
	__GETD1S 46
	CALL SUBOPT_0x32
	CALL SUBOPT_0x32
	CALL SUBOPT_0x32
	CALL __PUTPARD1
	__GETD1SX 94
	CALL __PUTPARD1
	__GETD1SX 102
	CALL __PUTPARD1
	LDI  R24,60
	CALL _printf
	ADIW R28,62
;     294 		
;     295 		//Check for menu call
;     296 		if( SerByteAvail() && getchar() == 'T' ) Main_Menu();	
	RCALL _SerByteAvail
	SBIW R30,0
	BREQ _0x1B
	CALL _getchar
	CPI  R30,LOW(0x54)
	BREQ _0x1C
_0x1B:
	RJMP _0x1A
_0x1C:
	RCALL _Main_Menu
;     297 	}
_0x1A:
	RJMP _0x12
;     298 } 
_0x1D:
	RJMP _0x1D
;     299 
;     300 /******************** PROGRAM FUNCTIONS ***********************************/
;     301 /**************************************************************************/
;     302 
;     303 float ReadAVRTemp(void)
;     304 /**********************************************
;     305 	Returns Temperature on Board in DegC
;     306 **********************************************/
;     307 {  
_ReadAVRTemp:
;     308 	int RefVMilliVolts, AVRVMilliVolts;
;     309 	float AVRTemp;
;     310 	
;     311     RefVMilliVolts = ( Read_Max186(VREF, 1) );
	SBIW R28,4
	CALL __SAVELOCR4
;	RefVMilliVolts -> R16,R17
;	AVRVMilliVolts -> R18,R19
;	AVRTemp -> Y+4
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
;     312 	AVRVMilliVolts = ( Read_Max186(PCTEMP, 1) );
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
	RCALL _Read_Max186
	MOVW R18,R30
;     313 	AVRTemp = RL10052Temp(AVRVMilliVolts, (RefVMilliVolts*2), 10010);
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
	CALL SUBOPT_0x35
;     314 	
;     315 	return AVRTemp;
	CALL SUBOPT_0x36
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;     316 }
;     317 
;     318 float ReadBattVolt(void)
;     319 /**********************************************
;     320 	Returns Main Power Input in Volts
;     321 **********************************************/
;     322 { 
_ReadBattVolt:
;     323 	int BattVMilliVolts;
;     324 	float BattV;
;     325 	
;     326 	BattVMilliVolts = ( Read_Max186(BATT, 1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	BattVMilliVolts -> R16,R17
;	BattV -> Y+2
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x15
	CALL SUBOPT_0x34
;     327  	BattV = ((BattVMilliVolts)/100.0) + 1.2;
	MOVW R30,R16
	CALL SUBOPT_0x37
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	CALL __DIVF21
	__GETD2N 0x3F99999A
	CALL __ADDF12
	CALL SUBOPT_0x38
;     328  	
;     329  	return BattV;
	RJMP _0x228
;     330 }
;     331 
;     332 
;     333 float ReadRefVolt(void)
;     334 /**********************************************
;     335 	Returns A/D Reference Voltage in Volts
;     336 **********************************************/
;     337 { 
_ReadRefVolt:
;     338 	int RefVMilliVolts;
;     339 	float RefV;
;     340 	
;     341 	RefVMilliVolts = ( Read_Max186(VREF,1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	RefVMilliVolts -> R16,R17
;	RefV -> Y+2
	CALL SUBOPT_0x33
	CALL SUBOPT_0x34
;     342  	RefV = ((RefVMilliVolts * 2) /1000);
	MOVW R30,R16
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
;     343  	
;     344  	return RefV;
_0x228:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     345 }
;     346 
;     347 void Heartbeat(void)
;     348 /*************************************
;     349 Heartbeat on PortE bit 2
;     350 *************************************/
;     351 {
_Heartbeat:
;     352 	
;     353 	PORTE=0X04;
	LDI  R30,LOW(4)
	OUT  0x3,R30
;     354 	delay_ms(15);
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x1A
;     355 	PORTE=0X00; 
	LDI  R30,LOW(0)
	OUT  0x3,R30
;     356 	delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x1A
;     357 }
	RET
;     358 
;     359 void SignOn(void)
;     360 /********************************************
;     361  PROGRAM START
;     362 ********************************************/
;     363 {
_SignOn:
;     364 	ClearScreen();
	RCALL _ClearScreen
;     365 	//v16 <cr><lf>  change \n\r to \r\n throughout
;     366 	printf("\r\n\r\nSIGNON RADIOMETER INTERFACE V%s, %s\r\n", version, verdate);   //v1.14
	__POINTW1FN _0,497
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
;     367 	printf("\r\nDigital Interface Board - Rev B. Nov 2007\r\n");
	__POINTW1FN _0,539
	CALL SUBOPT_0x3B
;     368 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2E
;     369 	
;     370 	printf("Program Start time is: %02d:%02d:%02d\r\n", h, m, s);
	__POINTW1FN _0,585
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x3C
;     371 	rtc_get_date(&dt, &mon, &yr);
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
;     372 	printf("Program Start date is: %02d/%02d/%02d\r\n", yr, mon, dt);
	__POINTW1FN _0,625
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
;     373 	printf("\r\nHit 'T' for Main Menu.\r\n"); 
	__POINTW1FN _0,665
	CALL SUBOPT_0x3B
;     374     printf("\r\n");
	CALL SUBOPT_0x3E
;     375 }
	RET
;     376 
;     377 void ATMega128_Setup(void)
;     378 /*************************************
;     379 Initialization for AVR ATMega128 chip
;     380 *************************************/
;     381 {   
_ATMega128_Setup:
;     382 	// Input/Output Ports initialization
;     383 	// Port A initialization
;     384 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     385 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     386 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     387 	DDRA=0x00;
	OUT  0x1A,R30
;     388 	
;     389 	// Port C initialization
;     390 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     391 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     392 	PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
;     393 	DDRC=0x03;
	OUT  0x14,R30
;     394 	
;     395 	// Port D initialization
;     396 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     397 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     398 	PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     399 	DDRD=0x00;
	OUT  0x11,R30
;     400 	
;     401 	// Port E initialization
;     402 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     403 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     404 	PORTE=0x00;
	OUT  0x3,R30
;     405 	DDRE=0x04;
	LDI  R30,LOW(4)
	OUT  0x2,R30
;     406 	
;     407 	// Port F initialization
;     408 	// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     409 	// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     410 	PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
;     411 	DDRF=0x00;
	STS  97,R30
;     412 	
;     413 	// Port G initialization
;     414 	// Func0=In Func1=In Func2=In Func3=In Func4=In 
;     415 	// State0=T State1=T State2=T State3=T State4=T 
;     416 	PORTG=0x00;
	STS  101,R30
;     417 	DDRG=0x00;
	STS  100,R30
;     418 	
;     419 	// Timer/Counter 0 initialization
;     420 	// Clock source: System Clock
;     421 	// Clock value: Timer 0 Stopped
;     422 	// Mode: Normal top=FFh
;     423 	// OC0 output: Disconnected
;     424 	ASSR=0x00;
	OUT  0x30,R30
;     425 	TCCR0=0x00;
	OUT  0x33,R30
;     426 	TCNT0=0x00;
	OUT  0x32,R30
;     427 	OCR0=0x00;
	OUT  0x31,R30
;     428 	
;     429 	// Timer/Counter 1 initialization
;     430 	// Clock source: System Clock
;     431 	// Clock value: Timer 1 Stopped
;     432 	// Mode: Normal top=FFFFh
;     433 	// OC1A output: Discon.
;     434 	// OC1B output: Discon.
;     435 	// OC1C output: Discon.
;     436 	// Noise Canceler: Off
;     437 	// Input Capture on Falling Edge
;     438 	TCCR1A=0x00;
	OUT  0x2F,R30
;     439 	TCCR1B=0x00;
	OUT  0x2E,R30
;     440 	TCNT1H=0x00;
	OUT  0x2D,R30
;     441 	TCNT1L=0x00;
	OUT  0x2C,R30
;     442 	OCR1AH=0x00;
	OUT  0x2B,R30
;     443 	OCR1AL=0x00;
	OUT  0x2A,R30
;     444 	OCR1BH=0x00;
	OUT  0x29,R30
;     445 	OCR1BL=0x00;
	OUT  0x28,R30
;     446 	OCR1CH=0x00;
	STS  121,R30
;     447 	OCR1CL=0x00;
	STS  120,R30
;     448 	
;     449 	// Timer/Counter 2 initialization
;     450 	// Clock source: System Clock
;     451 	// Clock value: Timer 2 Stopped
;     452 	// Mode: Normal top=FFh
;     453 	// OC2 output: Disconnected
;     454 	TCCR2=0x00;
	OUT  0x25,R30
;     455 	TCNT2=0x00;
	OUT  0x24,R30
;     456 	OCR2=0x00;
	OUT  0x23,R30
;     457 	
;     458 	// Timer/Counter 3 initialization
;     459 	// Clock source: System Clock
;     460 	// Clock value: Timer 3 Stopped
;     461 	// Mode: Normal top=FFFFh
;     462 	// OC3A output: Discon.
;     463 	// OC3B output: Discon.
;     464 	// OC3C output: Discon.
;     465 	TCCR3A=0x00;
	STS  139,R30
;     466 	TCCR3B=0x00;
	STS  138,R30
;     467 	TCNT3H=0x00;
	STS  137,R30
;     468 	TCNT3L=0x00;
	STS  136,R30
;     469 	OCR3AH=0x00;
	STS  135,R30
;     470 	OCR3AL=0x00;
	STS  134,R30
;     471 	OCR3BH=0x00;
	STS  133,R30
;     472 	OCR3BL=0x00;
	STS  132,R30
;     473 	OCR3CH=0x00;
	STS  131,R30
;     474 	OCR3CL=0x00;
	STS  130,R30
;     475 	
;     476 	// External Interrupt(s) initialization
;     477 	// INT0: Off
;     478 	// INT1: Off
;     479 	// INT2: Off
;     480 	// INT3: Off
;     481 	// INT4: Off
;     482 	// INT5: Off
;     483 	// INT6: Off
;     484 	// INT7: Off
;     485 	EICRA=0x00;
	STS  106,R30
;     486 	EICRB=0x00;
	OUT  0x3A,R30
;     487 	EIMSK=0x00;
	OUT  0x39,R30
;     488 	
;     489 	// Timer(s)/Counter(s) Interrupt(s) initialization
;     490 	TIMSK=0x00;
	OUT  0x37,R30
;     491 	ETIMSK=0x00;
	STS  125,R30
;     492 	
;     493 	// USART0 initialization
;     494 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     495 	// USART0 Receiver: On
;     496 	// USART0 Transmitter: On
;     497 	// USART0 Mode: Asynchronous
;     498 	// USART0 Baud rate: 19200
;     499 	UCSR0A=0x00;
	OUT  0xB,R30
;     500 	UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     501 	UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     502 	UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;     503 	UBRR0L=XTAL/16/BAUD-1;
	LDI  R30,LOW(11)
	OUT  0x9,R30
;     504 	
;     505 	// USART1 initialization
;     506 	// Communication Parameters: 8 Data, 1 Stop, No Parity
;     507 	// USART1 Receiver: On
;     508 	// USART1 Transmitter: On
;     509 	// USART1 Mode: Asynchronous
;     510 	// USART1 Baud rate: 9600
;     511 	UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;     512 	UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
;     513 	UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     514 	UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     515 	UBRR1L=0x33;
	LDI  R30,LOW(51)
	STS  153,R30
;     516 	
;     517 	// Analog Comparator initialization
;     518 	// Analog Comparator: Off
;     519 	// Analog Comparator Input Capture by Timer/Counter 1: Off
;     520 	// Analog Comparator Output: Off
;     521 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     522 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     523 	
;     524 	// Port B initialization
;     525 	PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
;     526 	DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;     527 	
;     528 	// SPI initialization
;     529 	// SPI Type: Master
;     530 	// SPI Clock Rate: 1MHz
;     531 	// SPI Clock Phase: 1
;     532 	// SPI Clock Polarity: 0
;     533 	// SPI Data Order: MSB First
;     534 	// SETUP for MAX186 on SPI
;     535 	//SPCR = (1<<SPE) | (1<<MSTR) ; // SPI enable, Master mode, 1MHz Clk
;     536 	SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     537 	SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0xE,R30
;     538 	
;     539 	// DS1302 Real Time Clock initialization
;     540 	// Trickle charger: Off
;     541 	rtc_init(0,0,0); 
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	ST   -Y,R30
	CALL _rtc_init
;     542 	
;     543 }  
	RET
;     544 
;     545 int SerByteAvail(void)
;     546 /********************************
;     547 Check the serial port for characters
;     548 returns a 1 if true 0 for not true
;     549 *********************************/
;     550 {   
_SerByteAvail:
;     551 	if (UCSR0A >= 0x7f)
	IN   R30,0xB
	CPI  R30,LOW(0x7F)
	BRLO _0x1E
;     552 	{
;     553 	    //printf("Character found!\r\n");
;     554 		return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
;     555 	}
;     556 	 return 0;
_0x1E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
;     557 }      
;     558 
;     559 int ClearScreen(void)
;     560 /*********************************************
;     561 Routine to clear the terminal screen.
;     562 **********************************************/
;     563 { 
_ClearScreen:
;     564 	int i; 
;     565 	i=0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
;     566 	while (i<25)
_0x1F:
	__CPWRN 16,17,25
	BRGE _0x21
;     567 	{
;     568 		printf("\r\n");  // v16 <cr><lf>
	CALL SUBOPT_0x3E
;     569 		i++;
	__ADDWRN 16,17,1
;     570 	} 
	RJMP _0x1F
_0x21:
;     571 	return OK;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	LD   R16,Y+
	LD   R17,Y+
	RET
;     572 }
;     573 
;     574 int Read_Max186(int channel, int mode)
;     575 /**************************************************
;     576 Routine to read external Max186 A-D Converter.
;     577 Control word sets Unipolar mode, Single-Ended Input,
;     578 External Clock.
;     579 Mode: 	0 = Bipolar (-VRef/2 to +VRef/2)
;     580  		1 = Unipolar ( 0 to VRef )		
;     581 **************************************************/
;     582 {
_Read_Max186:
;     583 	unsigned int rb1, rb2, rb3;
;     584 	int data_out;
;     585 	long din;
;     586 	
;     587 	data_out=0;
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
;     588 	rb1=rb2=rb3=0; 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R20,R30
	MOVW R18,R30
	MOVW R16,R30
;     589 	
;     590 	if (mode == 1) //DO UNIPOLAR (0 - VREF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x22
;     591 	{
;     592 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x23
;     593 			din=0x8F;		// 10001111
	__GETD1N 0x8F
	RJMP _0x229
;     594 		else if(channel==1)
_0x23:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x25
;     595 			din=0xCF;		// 11001111
	__GETD1N 0xCF
	RJMP _0x229
;     596 		else if(channel==2)
_0x25:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x27
;     597 			din=0x9F;		// 10011111
	__GETD1N 0x9F
	RJMP _0x229
;     598 		else if(channel==3)
_0x27:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x29
;     599 			din=0xDF;		// 11011111
	__GETD1N 0xDF
	RJMP _0x229
;     600 		else if(channel==4)
_0x29:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x2B
;     601 			din=0xAF;		// 10101111
	__GETD1N 0xAF
	RJMP _0x229
;     602 		else if(channel==5)
_0x2B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x2D
;     603 			din=0xEF;		// 11101111
	__GETD1N 0xEF
	RJMP _0x229
;     604 		else if(channel==6)
_0x2D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x2F
;     605 			din=0xBF;		// 10111111
	__GETD1N 0xBF
	RJMP _0x229
;     606 		else if(channel==7)
_0x2F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x31
;     607 			din=0xFF;	 	// 11111111
	__GETD1N 0xFF
_0x229:
	__PUTD1S 6
;     608 	} 
_0x31:
;     609 	else	//DO BIPOLAR (-VREF/2 - +VREF/2)
	RJMP _0x32
_0x22:
;     610 	{
;     611 		if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x33
;     612 			din=0x87;		// 10000111
	__GETD1N 0x87
	RJMP _0x22A
;     613 		else if(channel==1)
_0x33:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x35
;     614 			din=0xC7;		// 11000111
	__GETD1N 0xC7
	RJMP _0x22A
;     615 		else if(channel==2)
_0x35:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x37
;     616 			din=0x97;		// 10010111
	__GETD1N 0x97
	RJMP _0x22A
;     617 		else if(channel==3)
_0x37:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x39
;     618 			din=0xD7;		// 11010111
	__GETD1N 0xD7
	RJMP _0x22A
;     619 		else if(channel==4)
_0x39:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x3B
;     620 			din=0xA7;		// 10100111
	__GETD1N 0xA7
	RJMP _0x22A
;     621 		else if(channel==5)
_0x3B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x3D
;     622 			din=0xE7;		// 11100111
	__GETD1N 0xE7
	RJMP _0x22A
;     623 		else if(channel==6)
_0x3D:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x3F
;     624 			din=0xB7;		// 10110111
	__GETD1N 0xB7
	RJMP _0x22A
;     625 		else if(channel==7)
_0x3F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x41
;     626 			din=0xF7;	 	// 11110111
	__GETD1N 0xF7
_0x22A:
	__PUTD1S 6
;     627 	}
_0x41:
_0x32:
;     628     
;     629 	// START A-D
;     630 	PORTB = 0x07;
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     631 	PORTB = 0x06; 	//Selects CS- lo 
	LDI  R30,LOW(6)
	OUT  0x18,R30
;     632 	
;     633 	// Send control byte ch7, Uni, Sgl, ext clk
;     634 	rb1 = ( spi(din) );		//Sends the coversion code from above
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _spi
	MOV  R16,R30
	CLR  R17
;     635 	// Send/Rcv HiByte
;     636 	rb2 = ( spi(0x00) );		//Receive byte 2 (MSB) 
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R18,R30
	CLR  R19
;     637 	// Send/Rcv LoByte
;     638 	rb3 = ( spi(0x00) );		//Receive byte 3 (LSB)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R20,R30
	CLR  R21
;     639 		
;     640 	PORTB = 0x07;		//Selects CS- hi
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     641     
;     642 	// Calculation to counts
;     643 	if(mode == 1) //UNIPOLAR
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x42
;     644 	{
;     645 		rb2 = rb2 << 1;
	CALL SUBOPT_0x3F
;     646 		rb3 = rb3 >> 3;
;     647 		data_out = ( (rb2*16) + rb3 ) ;
;     648 	}
;     649 	else if(mode == 0) //BIPOLAR
	RJMP _0x43
_0x42:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x44
;     650 	{
;     651 		rb2 = rb2 << 1;
	CALL SUBOPT_0x3F
;     652 		rb3 = rb3 >> 3;
;     653 		data_out = ((rb2*16) + rb3);
;     654 		if(data_out >= 2048) data_out -= 4096;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CPI  R26,LOW(0x800)
	LDI  R30,HIGH(0x800)
	CPC  R27,R30
	BRLT _0x45
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUBI R30,LOW(4096)
	SBCI R31,HIGH(4096)
	STD  Y+10,R30
	STD  Y+10+1,R31
;     655 	}
_0x45:
;     656 	else {  // v15 we need this.
	RJMP _0x46
_0x44:
;     657 		data_out = 0;
	LDI  R30,0
	STD  Y+10,R30
	STD  Y+10+1,R30
;     658 	}
_0x46:
_0x43:
;     659 			
;     660 	//printf("Data Out= %d\r\n", data_out);   
;     661 	
;     662 	
;     663 	return data_out;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;     664 }   
;     665 
;     666 
;     667 float RL10052Temp (unsigned int v2, int ref, int res)
;     668 /***********************************
;     669 Calculates Thermistor Temperature
;     670 v2 = A to D Milli Volts 0-4096
;     671 ref = reference voltage to circuit
;     672 res = reference divider resistor
;     673 ***********************************/
;     674 {
_RL10052Temp:
;     675 	float v1, r2, it, Temp, dum;
;     676 	float term1, term2, term3;
;     677 			
;     678 	v1 = (float)ref - (float)v2;
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
	CALL SUBOPT_0x37
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x40
	CALL SUBOPT_0x41
	__PUTD1S 28
;     679 	it = v1/(float)res;
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x37
	__GETD2S 28
	CALL __DIVF21
	CALL SUBOPT_0x25
;     680 	r2 = (float)v2/it;		    //find resistance of thermistor
	CALL SUBOPT_0x40
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 20
	CALL __DIVF21
	__PUTD1S 24
;     681 	dum = (float)log(r2/(float)res);
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x37
	CALL SUBOPT_0x42
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x43
;     682 	
;     683 	// Diagnostic
;     684 	//printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\r\n", v2, v1, it, r2, dum);
;     685 	
;     686 	term1 = COEFFA + (COEFFB * dum);
	CALL SUBOPT_0x44
	LDS  R26,_COEFFB
	LDS  R27,_COEFFB+1
	LDS  R24,_COEFFB+2
	LDS  R25,_COEFFB+3
	CALL __MULF12
	LDS  R26,_COEFFA
	LDS  R27,_COEFFA+1
	LDS  R24,_COEFFA+2
	LDS  R25,_COEFFA+3
	CALL SUBOPT_0x45
;     687 	term2 = COEFFC * (dum*dum);
	CALL SUBOPT_0x46
	LDS  R26,_COEFFC
	LDS  R27,_COEFFC+1
	LDS  R24,_COEFFC+2
	LDS  R25,_COEFFC+3
	CALL __MULF12
	CALL SUBOPT_0x35
;     688 	term3 = COEFFD * ((dum*dum)*dum);
	CALL SUBOPT_0x46
	CALL SUBOPT_0x47
	CALL __MULF12
	LDS  R26,_COEFFD
	LDS  R27,_COEFFD+1
	LDS  R24,_COEFFD+2
	LDS  R25,_COEFFD+3
	CALL __MULF12
	CALL SUBOPT_0x48
;     689    	Temp = term1 + term2 + term3;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x49
	CALL SUBOPT_0x4A
	CALL __ADDF12
	CALL SUBOPT_0x4B
;     690 	//printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\r\n", term1, term2, term3, Temp);
;     691 	//Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
;     692 	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	CALL SUBOPT_0x4C
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x438B0000
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4B
;     693 	//	printf("Temp= %f\r\n", Temp);
;     694 
;     695 return Temp;
	ADIW R28,38
	RET
;     696 } 
;     697 
;     698 void Main_Menu(void)
;     699 /*************************************************
;     700 *************************************************/
;     701 { 
_Main_Menu:
;     702 	char ch;
;     703 	int ltime;
;     704 	char msg[12];
;     705 	int i; 
;     706 	unsigned long t1, t2;  //v1.13
;     707 
;     708 			
;     709 	printf("\r\n");
	SBIW R28,20
	CALL __SAVELOCR5
;	ch -> R16
;	ltime -> R17,R18
;	msg -> Y+13
;	i -> R19,R20
;	t1 -> Y+9
;	t2 -> Y+5
	CALL SUBOPT_0x3E
;     710 	printf("\r\n WIR%02d BOARD (REV B) VERSION: %s, VERSION DATE: %s\r\n", Id_address, version, verdate);
	__POINTW1FN _0,692
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3C
;     711 	printf(" ----------EEPROM PARAMETERS----------------------------\r\n");
	__POINTW1FN _0,749
	CALL SUBOPT_0x3B
;     712 	printf("PSP Coeff= %.2E, PIR Coeff= %.2E\r\n", psp, pir);
	__POINTW1FN _0,808
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x28
	CALL SUBOPT_0x3A
;     713 	printf("PIRadc_gain= %.1f, PIRadc_offset= %.1f\r\n", PIRadc_gain, PIRadc_offset);                   
	__POINTW1FN _0,843
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
	CALL SUBOPT_0x3A
;     714 	printf("PSPadc_gain= %.1f, PSPadc_offset= %.1f\r\n", PSPadc_gain, PSPadc_offset);
	__POINTW1FN _0,884
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x3A
;     715 	printf(" ---------DATE & TIME SETTING---------------------------\r\n"); 
	__POINTW1FN _0,925
	CALL SUBOPT_0x3B
;     716     printf("'T' -->Set the date/time.\r\n");
	__POINTW1FN _0,984
	CALL SUBOPT_0x3B
;     717     printf(" ---------PSP SETTINGS----------------------------------\r\n");
	__POINTW1FN _0,1012
	CALL SUBOPT_0x3B
;     718     printf("'p' -->Set PSP coefficient. 'g' -->Set PSP amplifier gain value.\r\n"); 
	__POINTW1FN _0,1071
	CALL SUBOPT_0x3B
;     719     printf("'o' -->Set PSP amplifier output offset, mv.\r\n");  //v15
	__POINTW1FN _0,1138
	CALL SUBOPT_0x3B
;     720     printf(" ---------PIR SETTINGS----------------------------------\r\n");
	__POINTW1FN _0,1184
	CALL SUBOPT_0x3B
;     721     printf("'I' -->Set PIR coefficient. 'G' -->Set PIR amplifier gain value.\r\n");
	__POINTW1FN _0,1243
	CALL SUBOPT_0x3B
;     722     printf("'O' -->Set PIR amplifier output offset, mv.\r\n");  //v15
	__POINTW1FN _0,1310
	CALL SUBOPT_0x3B
;     723     printf("'C' -->Set Case (R8) value. 'D' -->Set Dome (R9) value.\r\n");
	__POINTW1FN _0,1356
	CALL SUBOPT_0x3B
;     724     printf("'V' -->Set Thermistor/ADC Reference Voltage (TP2) value.\r\n");
	__POINTW1FN _0,1414
	CALL SUBOPT_0x3B
;     725     printf(" ---------TIMING SETTING--------------------------------\r\n");
	__POINTW1FN _0,1473
	CALL SUBOPT_0x3B
;     726     printf("'L' -->Set Output time in seconds.\r\n");
	__POINTW1FN _0,1532
	CALL SUBOPT_0x3B
;     727     printf(" -------------------------------------------------------\r\n");
	__POINTW1FN _0,1569
	CALL SUBOPT_0x3B
;     728     printf("'S' -->Sample 12 bit A to D. 'A' -->Change Identifier String.\r\n");
	__POINTW1FN _0,1628
	CALL SUBOPT_0x3B
;     729     printf("'X' -->Exit this menu, return to operation.\r\n");
	__POINTW1FN _0,1692
	CALL SUBOPT_0x3B
;     730     printf("=========================================================\r\n");
	__POINTW1FN _0,1738
	CALL SUBOPT_0x3B
;     731     printf("Command?>");
	__POINTW1FN _0,1798
	CALL SUBOPT_0x3B
;     732 	
;     733 	// ***************************************
;     734 	// WAITING FOR A CHARACTER.  TIMEOUT.  v13
;     735 	// ***************************************
;     736 	rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x2E
;     737 	t1 = h*3600 + m*60 + s;
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4E
;     738 	while (1) 
_0x47:
;     739 	{
;     740 		// CHECK INPUT BUFFER FOR A CHARACTER
;     741 		if ( SerByteAvail() )
	CALL _SerByteAvail
	SBIW R30,0
	BREQ _0x4A
;     742 		{
;     743 			ch = getchar();
	RCALL _getchar
	MOV  R16,R30
;     744 			break;
	RJMP _0x49
;     745 		}
;     746 		// CHECK CURRENT TIME FOR A TIMEOUT
;     747 		rtc_get_time(&h,&m,&s);
_0x4A:
	CALL SUBOPT_0x2E
;     748 		t2 = h*3600 + m*60 + s;		 
	CALL SUBOPT_0x4D
	__PUTD1S 5
;     749 		if ( abs(t2-t1) > MENU_TIMEOUT )     //v13 30 sec timeout
	CALL SUBOPT_0x4F
	__GETD1S 5
	CALL __SUBD12
	ST   -Y,R31
	ST   -Y,R30
	CALL _abs
	SBIW R30,31
	BRLO _0x4B
;     750 		{
;     751 			printf("\r\nTIMEOUT: Return to sampling\r\n");
	__POINTW1FN _0,1808
	CALL SUBOPT_0x3B
;     752 			return;
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;     753 		}
;     754 	}	
_0x4B:
	RJMP _0x47
_0x49:
;     755 	switch (ch) 
	MOV  R30,R16
;     756 	{
;     757 		//*** echo characters typed.  See PRP code.
;     758 		// SET THE REAL-TIME CLOCK TIME
;     759 		case 'T':
	CPI  R30,LOW(0x54)
	BREQ _0x50
;     760 		case 't': 
	CPI  R30,LOW(0x74)
	BREQ PC+3
	JMP _0x51
_0x50:
;     761 		    printf("System date/time (YY/MM/DD, hh:mm:ss) is %02d/%02d/%02d, %02d:%02d:%02d\r\n", yr, mon, dt, h, m, s);
	__POINTW1FN _0,1840
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x31
	LDI  R24,24
	CALL _printf
	ADIW R28,26
;     762 			printf("Enter new time (hhmmss):  ");
	__POINTW1FN _0,1914
	CALL SUBOPT_0x3B
;     763 			
;     764 			scanf(" %2d%2d%2d", &h, &m, &s);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x4
	CALL __PUTPARD1
	__GETD1N 0x5
	CALL __PUTPARD1
	__GETD1N 0x6
	CALL SUBOPT_0x50
;     765 		
;     766 			if( (h >= 24) || (m >= 60) || (s >= 60) ) 
	LDI  R30,LOW(24)
	CP   R4,R30
	BRSH _0x53
	LDI  R30,LOW(60)
	CP   R5,R30
	BRSH _0x53
	CP   R6,R30
	BRLO _0x52
_0x53:
;     767 			{
;     768 				printf("\r\nIncorrect time entered, check format.\r\n");
	__POINTW1FN _0,1952
	CALL SUBOPT_0x3B
;     769 				break;
	RJMP _0x4E
;     770 			}
;     771 			else 
_0x52:
;     772 			{
;     773 				rtc_set_time(h, m, s);
	ST   -Y,R4
	ST   -Y,R5
	ST   -Y,R6
	CALL _rtc_set_time
;     774 				printf("\r\n%02d:%02d:%02d saved.\r\n", h, m, s);
	__POINTW1FN _0,1994
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x31
	CALL SUBOPT_0x3C
;     775 			}
;     776 			printf("\r\nSet Date (DDmmYY): ");
	__POINTW1FN _0,2020
	CALL SUBOPT_0x3B
;     777 			scanf(" %2d%2d%2d", &dt, &mon, &yr);
	__POINTW1FN _0,1941
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x7
	CALL __PUTPARD1
	__GETD1N 0x8
	CALL __PUTPARD1
	__GETD1N 0x9
	CALL SUBOPT_0x50
;     778 			
;     779 		
;     780 			if( (yr <= 7 || yr > 99) ||
;     781 				(mon <=0 || mon > 12) ||
;     782 				(dt <= 0 || dt > 31) ) 
	LDI  R30,LOW(7)
	CP   R30,R9
	BRSH _0x57
	LDI  R30,LOW(99)
	CP   R30,R9
	BRSH _0x58
_0x57:
	RJMP _0x59
_0x58:
	LDI  R30,LOW(0)
	CP   R30,R8
	BRSH _0x5A
	LDI  R30,LOW(12)
	CP   R30,R8
	BRSH _0x5B
_0x5A:
	RJMP _0x59
_0x5B:
	LDI  R30,LOW(0)
	CP   R30,R7
	BRSH _0x5C
	LDI  R30,LOW(31)
	CP   R30,R7
	BRSH _0x5D
_0x5C:
	RJMP _0x59
_0x5D:
	RJMP _0x56
_0x59:
;     783 				{
;     784 					printf("\r\nIncorrect date entered, check format.\r\n");
	__POINTW1FN _0,2042
	CALL SUBOPT_0x3B
;     785 					break;
	RJMP _0x4E
;     786 				}
;     787 				else 
_0x56:
;     788 				{   
;     789 					rtc_set_date(dt, mon, yr);
	ST   -Y,R7
	ST   -Y,R8
	ST   -Y,R9
	CALL _rtc_set_date
;     790 					printf("\r\n\r\n%02d/%02d/%02d saved.\r\n", yr, mon, dt);
	__POINTW1FN _0,2084
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3C
;     791 				}
;     792 			//printf("\r\n");
;     793 			
;     794 			break;
	RJMP _0x4E
;     795 		
;     796 		// SET AVERAGING INTERVAL IN SECS
;     797 		case 'L' :
_0x51:
	CPI  R30,LOW(0x4C)
	BREQ _0x61
;     798 		case 'l' : 
	CPI  R30,LOW(0x6C)
	BREQ PC+3
	JMP _0x62
_0x61:
;     799 			printf("Change Output Interval in secs\r\n");
	__POINTW1FN _0,2112
	CALL SUBOPT_0x3B
;     800 			printf("Current Interval is: %d secs\r\n", looptime);
	__POINTW1FN _0,2145
	CALL SUBOPT_0x51
;     801 			printf("Enter new output interval in secs: ");
	__POINTW1FN _0,2176
	CALL SUBOPT_0x3B
;     802 			for (i=0; i<5; i++)
	__GETWRN 19,20,0
_0x64:
	__CPWRN 19,20,5
	BRGE _0x65
;     803 			{
;     804 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     805 				printf("%c", msg[i]);
;     806 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x67
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x66
_0x67:
;     807 				{
;     808 					i--;
	__SUBWRN 19,20,1
;     809 					break;
	RJMP _0x65
;     810 				}
;     811 			}
_0x66:
	__ADDWRN 19,20,1
	RJMP _0x64
_0x65:
;     812 			if(atof(msg) > 3600 || atof(msg) <= 0)    //v13 increased limit to 1/2 hour //v15 increased to one hour
	CALL SUBOPT_0x55
	__GETD1N 0x45610000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x6A
	CALL SUBOPT_0x55
	CALL __CPD02
	BRLT _0x69
_0x6A:
;     813 			{
;     814 				printf("\r\nOut of Range.\r\n");
	__POINTW1FN _0,2215
	CALL SUBOPT_0x3B
;     815 				break;
	RJMP _0x4E
;     816 			}
;     817 			else 
_0x69:
;     818 			{
;     819 				ltime = atof(msg);
	CALL SUBOPT_0x56
	CALL __CFD1
	__PUTW1R 17,18
;     820 				looptime = ltime;
	__GETW1R 17,18
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMWRW
;     821 				printf("\r\nLooptime is now set to %d seconds.\r\n", looptime); 
	__POINTW1FN _0,2233
	CALL SUBOPT_0x51
;     822 			}
;     823 			
;     824 			break;  
	RJMP _0x4E
;     825 		
;     826 		// PSP COEFFICIENT
;     827 		case 'p' :
_0x62:
	CPI  R30,LOW(0x70)
	BREQ PC+3
	JMP _0x6D
;     828 			printf("Change PSP Coefficient\r\n");
	__POINTW1FN _0,2272
	CALL SUBOPT_0x3B
;     829 			printf("Current PSP Coefficient is: %.2E\r\n", psp);
	__POINTW1FN _0,2297
	CALL SUBOPT_0x57
;     830 			printf("Enter New PSP Coefficient: ");
	__POINTW1FN _0,2332
	CALL SUBOPT_0x3B
;     831 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x6F:
	__CPWRN 19,20,20
	BRGE _0x70
;     832 			{
;     833 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     834 				printf("%c", msg[i]);
;     835 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x72
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x71
_0x72:
;     836 				{
;     837 					i--;
	__SUBWRN 19,20,1
;     838 					break;
	RJMP _0x70
;     839 				}
;     840 			}
_0x71:
	__ADDWRN 19,20,1
	RJMP _0x6F
_0x70:
;     841 			if(atof(msg) >= 20.0E-6 || atof(msg) <= 0.1E-6)  //v15  expand range
	CALL SUBOPT_0x55
	__GETD1N 0x37A7C5AC
	CALL __CMPF12
	BRSH _0x75
	CALL SUBOPT_0x55
	CALL SUBOPT_0x58
	BREQ PC+2
	BRCC PC+3
	JMP  _0x75
	RJMP _0x74
_0x75:
;     842 			{
;     843 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     844 				break;
	RJMP _0x4E
;     845 			}
;     846 			else 
_0x74:
;     847 			{
;     848 				psp = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMWRD
;     849 				printf("\r\nPSP Coefficient is now set to %.2E\r\n", psp); 
	__POINTW1FN _0,2377
	CALL SUBOPT_0x57
;     850 			}
;     851 			break;
	RJMP _0x4E
;     852 		
;     853 		case 'g' :
_0x6D:
	CPI  R30,LOW(0x67)
	BREQ PC+3
	JMP _0x78
;     854 			printf("Change PSP Amplifier Gain Value\r\n");
	__POINTW1FN _0,2416
	CALL SUBOPT_0x3B
;     855 			printf("Current PSP Amplifier Gain Value: %.2f\r\n", PSPadc_gain);
	__POINTW1FN _0,2450
	CALL SUBOPT_0x5A
;     856 			printf("Enter New PSP Amplifier Gain Value: ");
	__POINTW1FN _0,2491
	CALL SUBOPT_0x3B
;     857 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x7A:
	__CPWRN 19,20,20
	BRGE _0x7B
;     858 			{
;     859 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     860 				printf("%c", msg[i] );
;     861 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x7D
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x7C
_0x7D:
;     862 				{
;     863 					i--;
	__SUBWRN 19,20,1
;     864 					break;
	RJMP _0x7B
;     865 				}
;     866 			}
_0x7C:
	__ADDWRN 19,20,1
	RJMP _0x7A
_0x7B:
;     867 			if(atof(msg) >= 300 || atof(msg) <= 10)  //v15  expand range 
	CALL SUBOPT_0x55
	__GETD1N 0x43960000
	CALL __CMPF12
	BRSH _0x80
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5B
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x80
	RJMP _0x7F
_0x80:
;     868 			{
;     869 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     870 				break;
	RJMP _0x4E
;     871 			}
;     872 			else 
_0x7F:
;     873 			{
;     874 				PSPadc_gain = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMWRD
;     875 				printf("\r\nPSP Amplifier Gain is now set to %.2f\r\n", PSPadc_gain); 
	__POINTW1FN _0,2528
	CALL SUBOPT_0x5A
;     876 			}
;     877 			break;
	RJMP _0x4E
;     878 
;     879 		case 'o' :
_0x78:
	CPI  R30,LOW(0x6F)
	BREQ PC+3
	JMP _0x83
;     880 			printf("Change PSP Amplifier Offset Value\r\n");
	__POINTW1FN _0,2570
	CALL SUBOPT_0x3B
;     881 			printf("Current PSP Amplifier Offset Value: %.2f\r\n", PSPadc_offset);
	__POINTW1FN _0,2606
	CALL SUBOPT_0x9
;     882 			printf("Enter New PSP Amplifier Offset Value: ");
	__POINTW1FN _0,2649
	CALL SUBOPT_0x3B
;     883 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x85:
	__CPWRN 19,20,20
	BRGE _0x86
;     884 			{
;     885 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     886 				printf("%c", msg[i]);
;     887 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x88
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x87
_0x88:
;     888 				{
;     889 					i--;
	__SUBWRN 19,20,1
;     890 					break;
	RJMP _0x86
;     891 				}
;     892 			}                        
_0x87:
	__ADDWRN 19,20,1
	RJMP _0x85
_0x86:
;     893 			if(atof(msg) > 500 || atof(msg) < -500)  //v15  expand range
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5C
	BREQ PC+4
	BRCS PC+3
	JMP  _0x8B
	CALL SUBOPT_0x55
	__GETD1N 0xC3FA0000
	CALL __CMPF12
	BRSH _0x8A
_0x8B:
;     894 			{
;     895 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     896 				break;
	RJMP _0x4E
;     897 			}
;     898 			else 
_0x8A:
;     899 			{
;     900 				PSPadc_offset = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMWRD
;     901 				printf("\r\nPSP Amplifier Offset is now set to %.2f\r\n", PSPadc_offset); 
	__POINTW1FN _0,2688
	CALL SUBOPT_0x9
;     902 			}
;     903 			break;
	RJMP _0x4E
;     904 
;     905 		case 'G' :
_0x83:
	CPI  R30,LOW(0x47)
	BREQ PC+3
	JMP _0x8E
;     906 			printf("Change PIR Amplifier Gain Value\r\n");
	__POINTW1FN _0,2732
	CALL SUBOPT_0x3B
;     907 			printf("Current PIR Amplifier Gain Value: %.2f\r\n", PIRadc_gain);
	__POINTW1FN _0,2766
	CALL SUBOPT_0x5D
;     908 			printf("Enter New PIR Amplifier Gain Value: ");
	__POINTW1FN _0,2807
	CALL SUBOPT_0x3B
;     909 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x90:
	__CPWRN 19,20,20
	BRGE _0x91
;     910 			{
;     911 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     912 				printf("%c", msg[i]);
;     913 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x93
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x92
_0x93:
;     914 				{
;     915 					i--;
	__SUBWRN 19,20,1
;     916 					break;
	RJMP _0x91
;     917 				}
;     918 			}                        
_0x92:
	__ADDWRN 19,20,1
	RJMP _0x90
_0x91:
;     919 			if(atof(msg) > 1500 || atof(msg) < 500 )  //v15  expand range
	CALL SUBOPT_0x55
	__GETD1N 0x44BB8000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x96
	CALL SUBOPT_0x55
	CALL SUBOPT_0x5C
	BRSH _0x95
_0x96:
;     920 			{
;     921 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     922 				break;
	RJMP _0x4E
;     923 			}
;     924 			else 
_0x95:
;     925 			{
;     926 				PIRadc_gain = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMWRD
;     927 				printf("\r\nPIR Amplifier Gain is now set to %.2f\r\n", PIRadc_gain); 
	__POINTW1FN _0,2844
	CALL SUBOPT_0x5D
;     928 			}
;     929 			break;
	RJMP _0x4E
;     930 
;     931 		case 'O' :
_0x8E:
	CPI  R30,LOW(0x4F)
	BREQ PC+3
	JMP _0x99
;     932 			printf("Change PIR Amplifier Offset Value\r\n");
	__POINTW1FN _0,2886
	CALL SUBOPT_0x3B
;     933 			printf("Current PIR Amplifier Offset Value: %.2f\r\n", PIRadc_offset);
	__POINTW1FN _0,2922
	CALL SUBOPT_0x7
;     934 			printf("Enter New PIR Amplifier Offset Value: ");
	__POINTW1FN _0,2965
	CALL SUBOPT_0x3B
;     935 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0x9B:
	__CPWRN 19,20,20
	BRGE _0x9C
;     936 			{
;     937 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     938 				printf("%c", msg[i]);
;     939 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0x9E
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0x9D
_0x9E:
;     940 				{
;     941 					i--;
	__SUBWRN 19,20,1
;     942 					break;
	RJMP _0x9C
;     943 				}
;     944 			}                        
_0x9D:
	__ADDWRN 19,20,1
	RJMP _0x9B
_0x9C:
;     945 			if(atof(msg) > 200 || atof(msg) < -200)  //v15  expand range
	CALL SUBOPT_0x55
	__GETD1N 0x43480000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xA1
	CALL SUBOPT_0x55
	__GETD1N 0xC3480000
	CALL __CMPF12
	BRSH _0xA0
_0xA1:
;     946 			{
;     947 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     948 				break;
	RJMP _0x4E
;     949 			}
;     950 			else 
_0xA0:
;     951 			{
;     952 				PIRadc_offset = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMWRD
;     953 				printf("\r\nPIR Amplifier Offset is now set to %.2f\r\n", PIRadc_offset); 
	__POINTW1FN _0,3004
	CALL SUBOPT_0x7
;     954 			}
;     955 			break;
	RJMP _0x4E
;     956 
;     957 		case 'I' :  // 'l' or 'I' This is capital Eye
_0x99:
	CPI  R30,LOW(0x49)
	BREQ PC+3
	JMP _0xA4
;     958 			printf("Change PIR Coefficient\r\n");
	__POINTW1FN _0,3048
	CALL SUBOPT_0x3B
;     959 			printf("Current PIR Coefficient is: %E\r\n", pir);
	__POINTW1FN _0,3073
	CALL SUBOPT_0x5E
;     960 			printf("Enter New PIR Coefficient: ");
	__POINTW1FN _0,3106
	CALL SUBOPT_0x3B
;     961 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xA6:
	__CPWRN 19,20,20
	BRGE _0xA7
;     962 			{
;     963 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     964 				printf("%c", msg[i]);
;     965 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0xA9
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0xA8
_0xA9:
;     966 				{
;     967 					i--;
	__SUBWRN 19,20,1
;     968 					break;
	RJMP _0xA7
;     969 				}
;     970 			}                        
_0xA8:
	__ADDWRN 19,20,1
	RJMP _0xA6
_0xA7:
;     971 			if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
	CALL SUBOPT_0x55
	__GETD1N 0x3727C5AC
	CALL __CMPF12
	BRSH _0xAC
	CALL SUBOPT_0x55
	CALL SUBOPT_0x58
	BREQ PC+2
	BRCC PC+3
	JMP  _0xAC
	RJMP _0xAB
_0xAC:
;     972 			{
;     973 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     974 				break;
	RJMP _0x4E
;     975 			}
;     976 			else 
_0xAB:
;     977 			{
;     978 				pir = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMWRD
;     979 				printf("\r\nPIR Coefficient is now set to %E\r\n", pir); 
	__POINTW1FN _0,3134
	CALL SUBOPT_0x5E
;     980 			}
;     981 			break;
	RJMP _0x4E
;     982 		case 'C' :
_0xA4:
	CPI  R30,LOW(0x43)
	BREQ PC+3
	JMP _0xAF
;     983 			printf("Change Case Reference Resistor (R8)\r\n");
	__POINTW1FN _0,3171
	CALL SUBOPT_0x3B
;     984 			printf("Current Case Reference Resistor is: %.1f\r\n", RrefC);
	__POINTW1FN _0,3209
	CALL SUBOPT_0x5F
;     985 			printf("Enter New Case Reference Resistance: ");
	__POINTW1FN _0,3252
	CALL SUBOPT_0x3B
;     986 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xB1:
	__CPWRN 19,20,20
	BRGE _0xB2
;     987 			{
;     988 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;     989 				printf("%c", msg[i]);
;     990 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0xB4
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0xB3
_0xB4:
;     991 				{
;     992 					i--;
	__SUBWRN 19,20,1
;     993 					break;
	RJMP _0xB2
;     994 				}
;     995 			}
_0xB3:
	__ADDWRN 19,20,1
	RJMP _0xB1
_0xB2:
;     996 			if( atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x55
	CALL SUBOPT_0x60
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB7
	CALL SUBOPT_0x55
	CALL SUBOPT_0x61
	BRSH _0xB6
_0xB7:
;     997 			{
;     998 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;     999 				break;
	RJMP _0x4E
;    1000 			}
;    1001 			else 
_0xB6:
;    1002 			{
;    1003 				RrefC = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMWRD
;    1004 				printf("\r\nCase Reference Resistor is now set to %.1f\r\n", RrefC); 
	__POINTW1FN _0,3290
	CALL SUBOPT_0x5F
;    1005 			}
;    1006 			break;
	RJMP _0x4E
;    1007 		case 'D' :
_0xAF:
	CPI  R30,LOW(0x44)
	BREQ PC+3
	JMP _0xBA
;    1008 			printf("Change Dome Reference Resistor (R9)\r\n");
	__POINTW1FN _0,3337
	CALL SUBOPT_0x3B
;    1009 			printf("Current Dome Reference Resistor is: %.1f\r\n", RrefD);
	__POINTW1FN _0,3375
	CALL SUBOPT_0x62
;    1010 			printf("Enter New Dome Reference Resistance: ");
	__POINTW1FN _0,3418
	CALL SUBOPT_0x3B
;    1011 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xBC:
	__CPWRN 19,20,20
	BRGE _0xBD
;    1012 			{
;    1013 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;    1014 				printf("%c", msg[i]);
;    1015 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0xBF
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0xBE
_0xBF:
;    1016 				{
;    1017 					i--;
	__SUBWRN 19,20,1
;    1018 					break;
	RJMP _0xBD
;    1019 				}
;    1020 			}                        
_0xBE:
	__ADDWRN 19,20,1
	RJMP _0xBC
_0xBD:
;    1021 			if(atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x55
	CALL SUBOPT_0x60
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC2
	CALL SUBOPT_0x55
	CALL SUBOPT_0x61
	BRSH _0xC1
_0xC2:
;    1022 			{
;    1023 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;    1024 				break;
	RJMP _0x4E
;    1025 			}
;    1026 			else 
_0xC1:
;    1027 			{
;    1028 				RrefD = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMWRD
;    1029 				printf("\r\nDome Reference Resistor is now set to %.1f\r\n", RrefD); 
	__POINTW1FN _0,3456
	CALL SUBOPT_0x62
;    1030 			}
;    1031 			break;
	RJMP _0x4E
;    1032 		case 'V' :
_0xBA:
	CPI  R30,LOW(0x56)
	BREQ PC+3
	JMP _0xC5
;    1033 			printf("Change Thermistor Reference Voltage\r\n");
	__POINTW1FN _0,3503
	CALL SUBOPT_0x3B
;    1034 			printf("Current Thermistor Reference Voltage is: %.4f\r\n", Vtherm);
	__POINTW1FN _0,3541
	CALL SUBOPT_0x63
;    1035 			printf("Enter New Thermistor Reference Voltage: ");
	__POINTW1FN _0,3589
	CALL SUBOPT_0x3B
;    1036 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xC7:
	__CPWRN 19,20,20
	BRGE _0xC8
;    1037 			{
;    1038 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;    1039 				printf("%c", msg[i]);
;    1040 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0xCA
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0xC9
_0xCA:
;    1041 				{
;    1042 					i--;
	__SUBWRN 19,20,1
;    1043 					break;
	RJMP _0xC8
;    1044 				}
;    1045 			}                        
_0xC9:
	__ADDWRN 19,20,1
	RJMP _0xC7
_0xC8:
;    1046 			if(atof(msg) > 6.0 || atof(msg) < 2.0)  //v15  expand range
	CALL SUBOPT_0x55
	__GETD1N 0x40C00000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xCD
	CALL SUBOPT_0x55
	__GETD1N 0x40000000
	CALL __CMPF12
	BRSH _0xCC
_0xCD:
;    1047 			{
;    1048 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;    1049 				break;
	RJMP _0x4E
;    1050 			}
;    1051 			else 
_0xCC:
;    1052 			{
;    1053 				Vtherm = atof(msg);
	CALL SUBOPT_0x56
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMWRD
;    1054 				Vadc = Vtherm;
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMWRD
;    1055 				printf("\r\nThermistor Reference Voltage is now set to %.4f\r\n", Vtherm); 
	__POINTW1FN _0,3630
	CALL SUBOPT_0x63
;    1056 			}
;    1057 			break;
	RJMP _0x4E
;    1058 		case 'A' :
_0xC5:
	CPI  R30,LOW(0x41)
	BREQ PC+3
	JMP _0xD0
;    1059 			printf("Change Identifier Address\r\n");
	__POINTW1FN _0,3682
	CALL SUBOPT_0x3B
;    1060 			printf("Current Identifier Address: $WIR%02d\r\n", Id_address);
	__POINTW1FN _0,3710
	CALL SUBOPT_0x64
;    1061 			printf("Enter New Identifier Address (0-99): ");
	__POINTW1FN _0,3749
	CALL SUBOPT_0x3B
;    1062 			
;    1063 			for (i=0; i<20; i++)
	__GETWRN 19,20,0
_0xD2:
	__CPWRN 19,20,20
	BRGE _0xD3
;    1064 			{
;    1065 				msg[i] = getchar();
	CALL SUBOPT_0x52
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x53
;    1066 				printf("%c", msg[i]);
;    1067 				if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xA)
	BREQ _0xD5
	CALL SUBOPT_0x54
	CPI  R26,LOW(0xD)
	BRNE _0xD4
_0xD5:
;    1068 				{
;    1069 					i--;
	__SUBWRN 19,20,1
;    1070 					break;
	RJMP _0xD3
;    1071 				}
;    1072 			}                        
_0xD4:
	__ADDWRN 19,20,1
	RJMP _0xD2
_0xD3:
;    1073 			if(atoi(msg) > 99 || atoi(msg) < 00)
	CALL SUBOPT_0x65
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRGE _0xD8
	CALL SUBOPT_0x65
	MOVW R26,R30
	SBIW R26,0
	BRGE _0xD7
_0xD8:
;    1074 			{
;    1075 				printf("\r\nOut of Range\r\n");
	CALL SUBOPT_0x59
;    1076 				break;
	RJMP _0x4E
;    1077 			}
;    1078 			else
_0xD7:
;    1079 			{
;    1080 				Id_address = atoi(msg);
	CALL SUBOPT_0x65
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMWRW
;    1081 				printf("\r\nIdentifier String now set to: $WIR%02d\r\n", Id_address); 
	__POINTW1FN _0,3787
	CALL SUBOPT_0x64
;    1082 			}
;    1083 			break;	                                         
	RJMP _0x4E
;    1084 		case 'X' :
_0xD0:
	CPI  R30,LOW(0x58)
	BREQ _0xDC
;    1085 		case 'x' :
	CPI  R30,LOW(0x78)
	BRNE _0xDD
_0xDC:
;    1086 			printf("\r\n Returning to operation...\r\n\r\n");
	__POINTW1FN _0,3830
	CALL SUBOPT_0x3B
;    1087 			return;  //v13 RETURN FROM THIS S/R 
	RJMP _0x227
;    1088 			break;
;    1089 		case 'S' :
_0xDD:
	CPI  R30,LOW(0x53)
	BRNE _0xDE
;    1090 			SampleADC();
	RCALL _SampleADC
;    1091 			break;
	RJMP _0x4E
;    1092 		case 'Z' :
_0xDE:
	CPI  R30,LOW(0x5A)
	BREQ _0xE0
;    1093 		case 'z' :
	CPI  R30,LOW(0x7A)
	BRNE _0xE2
_0xE0:
;    1094 			printf("\r\n***** SMART DIGITAL INTERFACE *****\r\n");
	CALL SUBOPT_0x0
;    1095 			printf(" Software Version %s, %s\r\n", version, verdate);
;    1096 			printf(" Current EEPROM values:\r\n");
;    1097 			printf(" Identifier Header= $WIR%02d\r\n", Id_address);
;    1098 			printf(" PSP Coeff= %.2E\r\n", psp);
;    1099 			printf(" PIR Coeff= %.2E\r\n", pir);
	CALL SUBOPT_0x1
;    1100 			printf(" Interval Time (secs)= %d\r\n", looptime);
	CALL SUBOPT_0x2
;    1101 			printf(" Cmax= %d\r\n", Cmax);
	CALL SUBOPT_0x3
;    1102 			printf(" Reference Resistor Case= %.1f\r\n", RrefC);
	CALL SUBOPT_0x4
;    1103 			printf(" Reference Resistor Dome= %.1f\r\n", RrefD);
	CALL SUBOPT_0x5
;    1104 			printf(" Vtherm= %.4f, Vadc= %.4f\r\n", Vtherm, Vadc);
	CALL SUBOPT_0x6
;    1105 			printf(" PIR ADC Offset= %.2f\r\n", PIRadc_offset);
	__POINTW1FN _0,3863
	CALL SUBOPT_0x7
;    1106 			printf(" PIR ADC Gain= %.2f\r\n", PIRadc_gain);
	CALL SUBOPT_0x8
;    1107 			printf(" PSP ADC Offset= %.2f\r\n", PSPadc_offset);
	__POINTW1FN _0,3887
	CALL SUBOPT_0x9
;    1108 			printf(" PSP ADC Gain= %.2f\r\n", PSPadc_gain);
	CALL SUBOPT_0xA
;    1109 			printf("\r\n");
	CALL SUBOPT_0x3E
;    1110 			//v15 -- we need to wait here for a character press
;    1111 			break;
	RJMP _0x4E
;    1112 			
;    1113 		//v13 INVALID KEY ENTRY -- RE-CALL MENU
;    1114 		default : printf("Invalid key\r\n");
_0xE2:
	__POINTW1FN _0,3911
	CALL SUBOPT_0x3B
;    1115 			//v13 printf("\r\n Returning to operation...\r\n\r\n");
;    1116 			Main_Menu();
	CALL _Main_Menu
;    1117 	} // end switch
_0x4E:
;    1118 	
;    1119 	//v13 -- recall s/r
;    1120 	Main_Menu();
	CALL _Main_Menu
;    1121 	//printf("Returning to operation...\r\n\r\n");
;    1122 	//return;
;    1123 }	//end menu
_0x227:
	CALL __LOADLOCR5
	ADIW R28,25
	RET
;    1124 
;    1125 void SampleADC(void)
;    1126 /********************************************************
;    1127 Test the ADC circuit
;    1128 **********************************************************/
;    1129 {
_SampleADC:
;    1130 	double ddum[8], ddumsq[8];
;    1131 	int i, npts;          
;    1132 	int missing;
;    1133 	
;    1134 	missing = -999;
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR6
;	ddum -> Y+38
;	ddumsq -> Y+6
;	i -> R16,R17
;	npts -> R18,R19
;	missing -> R20,R21
	__GETWRN 20,21,64537
;    1135 
;    1136 	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	CALL SUBOPT_0xB
	__PUTD1SX 66
	__PUTD1SX 62
	__PUTD1S 58
	__PUTD1S 54
	__PUTD1S 50
	__PUTD1S 46
	__PUTD1S 42
	__PUTD1S 38
;    1137 	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	CALL SUBOPT_0xB
	__PUTD1S 34
	__PUTD1S 30
	__PUTD1S 26
	__PUTD1S 22
	__PUTD1S 18
	__PUTD1S 14
	__PUTD1S 10
	CALL SUBOPT_0x66
;    1138 	npts=0;
	__GETWRN 18,19,0
;    1139 	printf("\r\n");
	CALL SUBOPT_0x3E
;    1140 	while( !SerByteAvail() )
_0xE3:
	CALL _SerByteAvail
	SBIW R30,0
	BREQ PC+3
	JMP _0xE5
;    1141 	{
;    1142 		ReadAnalog(ALL);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ReadAnalog
;    1143 		printf("%7d %7d %7d %7d %7d %7d %7d %7d\r\n",
;    1144 		adc[0],adc[1],adc[2],adc[3],
;    1145 		adc[4],adc[5],adc[6],adc[7]);
	__POINTW1FN _0,3925
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc
	LDS  R31,_adc+1
	CALL SUBOPT_0x67
	__GETW1MN _adc,2
	CALL SUBOPT_0x67
	__GETW1MN _adc,4
	CALL SUBOPT_0x67
	__GETW1MN _adc,6
	CALL SUBOPT_0x67
	__GETW1MN _adc,8
	CALL SUBOPT_0x67
	__GETW1MN _adc,10
	CALL SUBOPT_0x67
	__GETW1MN _adc,12
	CALL SUBOPT_0x67
	__GETW1MN _adc,14
	CALL SUBOPT_0x67
	CALL SUBOPT_0x68
;    1146 		for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xE7:
	__CPWRN 16,17,8
	BRLT PC+3
	JMP _0xE8
;    1147 		{
;    1148 			ddum[i] += (double)adc[i];
	CALL SUBOPT_0x69
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1149 			ddumsq[i] += (double)adc[i] * (double)adc[i];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x6B
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6A
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
;    1150 		}
	__ADDWRN 16,17,1
	RJMP _0xE7
_0xE8:
;    1151 		npts++;
	__ADDWRN 18,19,1
;    1152 		delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x1A
;    1153 		
;    1154 		Heartbeat();
	CALL _Heartbeat
;    1155 	}
	RJMP _0xE3
_0xE5:
;    1156 	printf("\r\n");
	CALL SUBOPT_0x3E
;    1157 	for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xEA:
	__CPWRN 16,17,8
	BRGE _0xEB
;    1158 		MeanStdev((ddum+i), (ddumsq+i), npts, missing);
	CALL SUBOPT_0x69
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x6B
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R20
	CALL SUBOPT_0x37
	CALL __PUTPARD1
	RCALL _MeanStdev
;    1159 
;    1160 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n",
	__ADDWRN 16,17,1
	RJMP _0xEA
_0xEB:
;    1161 		ddum[0],ddum[1],ddum[2],ddum[3],
;    1162 		ddum[4],ddum[5],ddum[6],ddum[7]);
	__POINTW1FN _0,3959
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6C
	__GETD1SX 72
	CALL __PUTPARD1
	__GETD1SX 80
	CALL __PUTPARD1
	__GETD1SX 88
	CALL __PUTPARD1
	__GETD1SX 96
	CALL __PUTPARD1
	CALL SUBOPT_0x68
;    1163 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\r\n\r\n",
;    1164 		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
;    1165 		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
	__POINTW1FN _0,4009
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6D
	CALL __PUTPARD1
	__GETD1S 16
	CALL __PUTPARD1
	__GETD1S 24
	CALL __PUTPARD1
	__GETD1S 32
	CALL __PUTPARD1
	CALL SUBOPT_0x6C
	CALL SUBOPT_0x68
;    1166 		
;    1167 		Heartbeat();
	CALL _Heartbeat
;    1168 	return;
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
;    1169 }
;    1170 
;    1171 void	MeanStdev(double *sum, double *sum2, int N, double missing)
;    1172 /********************************************
;    1173 Compute mean and standard deviation from the count, the sum and the sum of squares.
;    1174 991101
;    1175 Note that the mean and standard deviation are computed from the sum and the sum of 
;    1176 squared values and are returned in the same memory location.
;    1177 *********************************************/
;    1178 {
_MeanStdev:
;    1179 	if( N <= 2 )
;	*sum -> Y+8
;	*sum2 -> Y+6
;	N -> Y+4
;	missing -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRGE _0xEC
;    1180 	{
;    1181 		*sum = missing;
	CALL SUBOPT_0x6E
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x6F
;    1182 		*sum2 = missing;
	RJMP _0x22B
;    1183 	}
;    1184 	else
_0xEC:
;    1185 	{
;    1186 		*sum /= (double)N;		// mean value
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x70
	POP  R26
	POP  R27
	CALL SUBOPT_0x71
;    1187 		*sum2 = *sum2/(double)N - (*sum * *sum); // sumsq/N - mean^2
	CALL SUBOPT_0x70
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x72
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
	CALL SUBOPT_0x71
;    1188 		*sum2 = *sum2 * (double)N / (double)(N-1); // (N/N-1) correction
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x37
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	CALL SUBOPT_0x37
	CALL __DIVF21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x71
;    1189 		if( *sum2 < 0 ) *sum2 = 0;
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRGE _0xEE
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0xB
	RJMP _0x22C
;    1190 		else *sum2 = sqrt(*sum2);
_0xEE:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x1D
	CALL _sqrt
_0x22B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
_0x22C:
	CALL __PUTDP1
;    1191 	}
;    1192 	return;
	RJMP _0x226
;    1193 }
;    1194 void ReadAnalog( int chan )
;    1195 /************************************************************
;    1196 Read 12 bit analog A/D Converter Max186
;    1197 ************************************************************/
;    1198 {
_ReadAnalog:
;    1199 	int i;
;    1200 	if( chan == ALL )
	ST   -Y,R17
	ST   -Y,R16
;	chan -> Y+2
;	i -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0xF0
;    1201 	{
;    1202 		for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0xF2:
	__CPWRN 16,17,8
	BRGE _0xF3
;    1203 		{	
;    1204 			adc[i] = Read_Max186(i, 0);
	MOVW R30,R16
	CALL SUBOPT_0x73
	PUSH R31
	PUSH R30
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x12
	CALL _Read_Max186
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1205 		}
	__ADDWRN 16,17,1
	RJMP _0xF2
_0xF3:
;    1206 	}
;    1207 	else if( chan >= 0 && chan <=7 )
	RJMP _0xF4
_0xF0:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,0
	BRLT _0xF6
	SBIW R26,8
	BRLT _0xF7
_0xF6:
	RJMP _0xF5
_0xF7:
;    1208 	{
;    1209 		adc[chan] = Read_Max186(chan, 0);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x73
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x17
	CALL _Read_Max186
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1210 	}
;    1211     return;
_0xF5:
_0xF4:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1212 } 
;    1213     
;    1214 //v13 This is the beginning of config control for the RAD converter.
;    1215 
;    1216 #include <math.h> 
;    1217 #include <pir.h>
;    1218 
;    1219 double ysi46041(double r, double *c)
;    1220 /************************************************************
;    1221 	Description: Best fit of Steinhart Hart equation to YSI
;    1222 	tabulated data from -10C to 60C for H mix 10k thermistors.
;    1223 	Given the thermistor temperature in Kelvin.
;    1224 
;    1225 	The lack of precision in the YSI data is evident around
;    1226 	9999/10000 Ohm transition.  Scatter approaches 10mK before,
;    1227 	much less after.  Probably some systemmatics at the 5mK level
;    1228 	as a result.  Another decimal place in the impedances would 
;    1229 	have come in very handy.  The YSI-derived coefficients read
;    1230 	10mK cold or some through the same interval.
;    1231 
;    1232 	Mandatory parameters:
;    1233 	R - Thermistor resistance(s) in Ohms
;    1234 	C - Coefficients of fit from isarconf.icf file specific
;    1235 	to each thermistor.
;    1236 ************************************************************/
;    1237 { 
;    1238 double t1, LnR;
;    1239 	if(r>0)
;	r -> Y+10
;	*c -> Y+8
;	t1 -> Y+4
;	LnR -> Y+0
;    1240 	{
;    1241 		LnR = log(r);
;    1242 		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
;    1243 	}
;    1244 	else t1 = 0;
;    1245 	
;    1246 	return t1;
;    1247 }
;    1248 
;    1249 double ysi46041CountToRes(double c)
;    1250 /**************************************************************
;    1251 	Description: Converts raw counts to resistance for the 
;    1252 	YSI46041 10K thermistors.
;    1253 **************************************************************/
;    1254 {
;    1255 	double  r=0;
;    1256 		
;    1257 		r = 10000.0 * c / (5.0 - c);
;	c -> Y+4
;	r -> Y+0
;    1258 		
;    1259 		return r;
;    1260 }
;    1261 double ysi46000(double Rt, double Pt)
;    1262 /*************************************************************/
;    1263 // Uses the Steinhart-Hart equations to compute the temperature 
;    1264 // in degC from thermistor resistance.  S-S coeficients are 
;    1265 // either computed from calibrations or tests, or are provided by 
;    1266 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1267 // the S-S coefficients.
;    1268 //                                                               
;    1269 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1270 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1271 //  Tc = Tk - 273.15;
;    1272 //
;    1273 // correction for self heating.
;    1274 // For no correction set P_t = 0;
;    1275 // deltaT = p(watts) / .004 (W/degC)
;    1276 //
;    1277 //rmr 050128
;    1278 /*************************************************************/
;    1279 {
_ysi46000:
;    1280 	double x;
;    1281 	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
;    1282 	// ysi46041, matlab steinharthart_fit(), 0--40 degC
;    1283 	x = SteinhartHart(C, Rt);
	SBIW R28,16
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xFB*2)
	LDI  R31,HIGH(_0xFB*2)
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
	CALL SUBOPT_0x43
;    1284 	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
;    1285 	//printf("ysi46000: Cal temp = %.5f\r\n",x);
;    1286 	
;    1287 	x = x - Pt/.004; // return temperature in degC
	__GETD2S 16
	__GETD1N 0x3B83126F
	CALL __DIVF21
	CALL SUBOPT_0x47
	CALL SUBOPT_0x41
	CALL SUBOPT_0x43
;    1288 	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
;    1289 	return x;
	CALL SUBOPT_0x44
	ADIW R28,24
	RET
;    1290 
;    1291 } 
;    1292 void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
;    1293 	double *v_t, double *R_t, double *P_t)
;    1294 /*************************************************************/
;    1295 //Compute the thermistor resistance for a resistor divider circuit 
;    1296 //with reference voltage (V_therm), reference resistor (R_ref), 
;    1297 //thermistor is connected to GROUND.  The ADC compares a reference 
;    1298 //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc 
;    1299 //count (c).  The ADC here is unipolar and referenced to ground.
;    1300 //The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
;    1301 //Input:
;    1302 //  c = ADC count.
;    1303 //  C_max = maximum count, typically 4096.
;    1304 //  R_ref = reference resistor (ohms)
;    1305 //  V_therm = thermistor circuit reference voltage 
;    1306 //  V_adc = ADC reference voltage.
;    1307 //Output:
;    1308 //  v_t = thermistor voltage (volts)
;    1309 //  R_t = thermistor resistance (ohms)
;    1310 //  P_t = power dissipated by the thermistor (watts)
;    1311 //	(for self heating correction)
;    1312 //example
;    1313 //	double cx, Cmax, Rref, Vtherm, Vadc;
;    1314 //	double vt, Rt, Pt;
;    1315 //	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
;    1316 //	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
;    1317 // vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
;    1318 /*************************************************************/
;    1319 {
_therm_circuit_ground:
;    1320 	double x;
;    1321 	
;    1322 	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
;    1323 	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
;    1324 	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
;    1325 	
;    1326 	*v_t = V_adc * (c/2) / C_max;
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
;    1327 	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	CALL SUBOPT_0x72
	__GETD2S 14
	CALL SUBOPT_0x41
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 18
	CALL SUBOPT_0x74
;    1328 	*R_t = *v_t / x;  // v/I
	CALL SUBOPT_0x72
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6E
	CALL __DIVF21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x6F
;    1329 	*P_t = x * x * *R_t;  // I^2 R = power
	CALL SUBOPT_0x75
	CALL __MULF12
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
;    1330 	
;    1331 	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
;    1332 
;    1333 	return;
	ADIW R28,30
	RET
;    1334 }
;    1335 
;    1336 
;    1337 
;    1338 #include "PSP.h"
;    1339 
;    1340 /*******************************************************************************************/
;    1341 
;    1342 float PSPSW(double vp, double kp, double PSPadc_offset, double PSPadc_gain, double *sw)
;    1343 /**********************************************************
;    1344 %input
;    1345 %  vp = thermopile voltage
;    1346 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1347 %  gainPSP[2] is the offset and gain for the preamp circuit
;    1348 %     The thermopile net radiance is given by vp/kp, but
;    1349 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;    1350 %     where vp' is the actual voltage on the thermopile.
;    1351 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1352 %  e = thermopile computed flux in W/m^2 
;    1353 %    
;    1354 %  no arguments ==> test mode
;    1355 %  sw = corrected shortwave flux, W/m^2
;    1356 %  
;    1357 %000928 changes eps to 0.98 per {fairall98}
;    1358 %010323 back to 1.0 per Fairall
;    1359 % v14 080603 rmr -- 
;    1360 /**********************************************************/
;    1361 {
_PSPSW:
;    1362 
;    1363 	double e; // w/m^2 on the thermopile
;    1364 	  
;    1365 	//diagnostic printout
;    1366 	//printf("vp= %.2f, kp= %.2e, Offset= %.2f, Gain= %.2f\n\r", vp, kp, PSPadc_offset, PSPadc_gain);
;    1367 	
;    1368 	// THERMOPILE IRRADIANCE
;    1369 	e = ( ( ( ( vp - PSPadc_offset) / PSPadc_gain ) / 1000 ) / kp );
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
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 14
	CALL SUBOPT_0x74
;    1370 	
;    1371 	//diagnostic printout
;    1372 	//printf("PSP: e = %.4e\r\n", e);
;    1373 	
;    1374 	*sw = e;
	CALL SUBOPT_0x6E
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x6F
;    1375 	
;    1376 	return e;
	ADIW R28,22
	RET
;    1377 }
;    1378 #include "PIR.h"
;    1379 
;    1380 /*******************************************************************************************/
;    1381 
;    1382 void PirTcTd2LW(double vp, double kp, double PIRadc_offset, double PIRadc_gain, double tc, double td, double k, 
;    1383 	double *lw, double *C_c, double *C_d)
;    1384 /**********************************************************
;    1385 %input  // v15 -- enhanced comments
;    1386 %  vp = output in counts of thew ADC circuit.  In ADC counts.
;    1387 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1388 %  PIRadc_offset = the constant (B) in a straight line fit of 
;    1389 %     vp = M * v_pir + B
;    1390 %  PIRadc_gain = M, the gain term.
;    1391 %     The thermopile net radiance is given by (v_pir / kp), but
;    1392 %     if a preamp is used, then the measured voltage vp = B + M * vp'
;    1393 %     where vp' is the actual voltage on the thermopile.
;    1394 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1395 %  e = thermopile computed flux in W/m^2 
;    1396 %  tc = case degC 
;    1397 %  td = dome degC 
;    1398 %  k = calib coef, usually = 4.
;    1399 %  no arguments ==> test mode
;    1400 %output
;    1401 %  lw = corrected longwave flux, W/m^2
;    1402 %  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
;    1403 %000928 changes eps to 0.98 per {fairall98}
;    1404 %010323 back to 1.0 per Fairall
;    1405 % v15 -- tweak the code for the RAD operation
;    1406 /**********************************************************/
;    1407 {
_PirTcTd2LW:
;    1408 	double Tc,Td;
;    1409 	double sigma=5.67e-8;
;    1410 	double eps = 1;
;    1411 	double x,y;
;    1412 	double e; // w/m^2 on the thermopile
;    1413 	
;    1414 	// THERMOPILE IRRADIANCE
;    1415 	e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
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
	CALL SUBOPT_0x77
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 54
	CALL SUBOPT_0x74
;    1416 	//printf("PirTcTd2LW: e = %.4e\r\n", e);
;    1417 	
;    1418 	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
;    1419 	Tc = tc + Tabs;
	CALL SUBOPT_0x78
	__GETD2S 42
	CALL __ADDF12
	__PUTD1S 24
;    1420 	Td = td + Tabs;
	CALL SUBOPT_0x78
	__GETD2S 38
	CALL __ADDF12
	CALL SUBOPT_0x25
;    1421 	x = Tc * Tc * Tc * Tc; // Tc^4
	__GETD1S 24
	CALL SUBOPT_0x79
	CALL SUBOPT_0x79
	CALL SUBOPT_0x79
	CALL SUBOPT_0x7A
;    1422 	y = Td * Td * Td * Td; // Td^4
	__GETD1S 20
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x7B
	CALL SUBOPT_0x35
;    1423 	
;    1424 	// Corrections
;    1425 	*C_c = eps * sigma * x;
	__GETD1S 16
	CALL SUBOPT_0x47
	CALL __MULF12
	CALL SUBOPT_0x49
	CALL __MULF12
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __PUTDP1
;    1426 	*C_d =  - k * sigma * (y - x);
	__GETD1S 34
	CALL __ANEGF1
	__GETD2S 16
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x49
	CALL SUBOPT_0x36
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CALL __PUTDP1
;    1427 	
;    1428 	// Final computation
;    1429 	*lw = e + *C_c + *C_d;
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __GETD1P
	CALL SUBOPT_0x75
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
;    1430 	
;    1431 	return;
	ADIW R28,62
	RET
;    1432 }
;    1433 double SteinhartHart(double C[], double R) 
;    1434 /*************************************************************/
;    1435 // Uses the Steinhart-Hart equations to compute the temperature 
;    1436 // in degC from thermistor resistance.  
;    1437 // See http://www.betatherm.com/stein.htm
;    1438 //The Steinhart-Hart thermistor equation is named for two oceanographers 
;    1439 //associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
;    1440 //The first publication of the equation was by I.S. Steinhart & S.R. Hart 
;    1441 //in "Deep Sea Research" vol. 15 p. 497 (1968).
;    1442 //S-S coeficients are
;    1443 // either computed from calibrations or tests, or are provided by 
;    1444 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1445 // the S-S coefficients.
;    1446 //
;    1447 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1448 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1449 //  Tc = Tk - 273.15;
;    1450 //example
;    1451 // C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
;    1452 // ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
;    1453 // ysi46041, matlab steinharthart_fit()
;    1454 // R = 25000;     Tc = 25.00C
;    1455 // rmr 050128
;    1456 /*************************************************************/
;    1457 {
_SteinhartHart:
;    1458 	double x;
;    1459 //	double Tabs = 273.15;  // defined elsewhere
;    1460 
;    1461 	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
;    1462 	
;    1463 	x = log(R);
	SBIW R28,4
;	*C -> Y+8
;	R -> Y+4
;	x -> Y+0
	CALL SUBOPT_0x36
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x48
;    1464 	x = C[0] + x * ( C[1] + C[2] * x * x );
	CALL SUBOPT_0x72
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
	CALL SUBOPT_0x6E
	CALL __MULF12
	CALL SUBOPT_0x75
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x4A
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x48
;    1465 	x = 1/x - Tabs;
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x4C
	LDS  R26,_Tabs
	LDS  R27,_Tabs+1
	LDS  R24,_Tabs+2
	LDS  R25,_Tabs+3
	CALL __SUBF12
	CALL SUBOPT_0x48
;    1466 	
;    1467 	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
;    1468 	return x;
	CALL SUBOPT_0x6E
_0x226:
	ADIW R28,10
	RET
;    1469 }
;    1470 
;    1471 

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
	BREQ _0xFD
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0xFE
_0xFD:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0xFE:
	ADIW R28,3
	RET
__ftoa_G5:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x6)
	BRLO _0xFF
	LDI  R30,LOW(5)
	STD  Y+8,R30
_0xFF:
	LDD  R30,Y+8
	LDI  R26,LOW(__fround_G5*2)
	LDI  R27,HIGH(__fround_G5*2)
	LDI  R31,0
	CALL SUBOPT_0x6B
	CALL __GETD1PF
	CALL SUBOPT_0x4F
	CALL __ADDF12
	CALL SUBOPT_0x4E
	LDI  R16,LOW(0)
	CALL SUBOPT_0x7C
	__PUTD1S 2
_0x100:
	__GETD1S 2
	CALL SUBOPT_0x4F
	CALL __CMPF12
	BRLO _0x102
	CALL SUBOPT_0x7D
	CALL __MULF12
	__PUTD1S 2
	SUBI R16,-LOW(1)
	RJMP _0x100
_0x102:
	CPI  R16,0
	BRNE _0x103
	CALL SUBOPT_0x7E
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x104
_0x103:
_0x105:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x107
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x38
	CALL SUBOPT_0x4F
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x80
	__GETD2S 2
	CALL SUBOPT_0x81
	CALL __MULF12
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4E
	RJMP _0x105
_0x107:
_0x104:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x108
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x225
_0x108:
	CALL SUBOPT_0x7E
	LDI  R30,LOW(46)
	ST   X,R30
_0x109:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x10B
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x82
	CALL SUBOPT_0x4E
	__GETD1S 9
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x7E
	CALL SUBOPT_0x80
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x81
	CALL SUBOPT_0x41
	CALL SUBOPT_0x4E
	RJMP _0x109
_0x10B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x225:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G5:
	SBIW R28,4
	CALL __SAVELOCR3
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x83
	LDD  R26,Y+10
	CPI  R26,LOW(0x6)
	BRLO _0x10C
	LDI  R30,LOW(5)
	STD  Y+10,R30
_0x10C:
	LDD  R16,Y+10
_0x10D:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x10F
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
	RJMP _0x10D
_0x10F:
	__GETD1S 11
	CALL __CPD10
	BRNE _0x110
	LDI  R18,LOW(0)
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
	RJMP _0x111
_0x110:
	LDD  R18,Y+10
	CALL SUBOPT_0x85
	BREQ PC+2
	BRCC PC+3
	JMP  _0x112
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
_0x113:
	CALL SUBOPT_0x85
	BRLO _0x115
	CALL SUBOPT_0x86
	CALL SUBOPT_0x87
	RJMP _0x113
_0x115:
	RJMP _0x116
_0x112:
_0x117:
	CALL SUBOPT_0x85
	BRSH _0x119
	CALL SUBOPT_0x86
	CALL SUBOPT_0x82
	CALL SUBOPT_0x88
	SUBI R18,LOW(1)
	RJMP _0x117
_0x119:
	CALL SUBOPT_0x84
	CALL SUBOPT_0x83
_0x116:
	__GETD1S 11
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x88
	CALL SUBOPT_0x85
	BRLO _0x11A
	CALL SUBOPT_0x86
	CALL SUBOPT_0x87
_0x11A:
_0x111:
	LDI  R16,LOW(0)
_0x11B:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x11D
	__GETD2S 3
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x7F
	CALL SUBOPT_0x83
	__GETD1S 3
	CALL SUBOPT_0x86
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x89
	CALL SUBOPT_0x80
	CALL SUBOPT_0x81
	__GETD2S 3
	CALL __MULF12
	CALL SUBOPT_0x86
	CALL SUBOPT_0x41
	CALL SUBOPT_0x88
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x11B
	CALL SUBOPT_0x89
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x11B
_0x11D:
	CALL SUBOPT_0x8A
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x11F
	CALL SUBOPT_0x89
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R18
_0x11F:
	CPI  R18,10
	BRLT _0x120
	CALL SUBOPT_0x8A
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
_0x120:
	CALL SUBOPT_0x8A
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
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
_0x121:
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
	JMP _0x123
	MOV  R30,R16
	CPI  R30,0
	BRNE _0x127
	CPI  R19,37
	BRNE _0x128
	LDI  R16,LOW(1)
	RJMP _0x129
_0x128:
	CALL SUBOPT_0x8B
_0x129:
	RJMP _0x126
_0x127:
	CPI  R30,LOW(0x1)
	BRNE _0x12A
	CPI  R19,37
	BRNE _0x12B
	CALL SUBOPT_0x8B
	RJMP _0x22D
_0x12B:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x12C
	LDI  R17,LOW(1)
	RJMP _0x126
_0x12C:
	CPI  R19,43
	BRNE _0x12D
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x126
_0x12D:
	CPI  R19,32
	BRNE _0x12E
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x126
_0x12E:
	RJMP _0x12F
_0x12A:
	CPI  R30,LOW(0x2)
	BRNE _0x130
_0x12F:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x131
	ORI  R17,LOW(128)
	RJMP _0x126
_0x131:
	RJMP _0x132
_0x130:
	CPI  R30,LOW(0x3)
	BRNE _0x133
_0x132:
	CPI  R19,48
	BRLO _0x135
	CPI  R19,58
	BRLO _0x136
_0x135:
	RJMP _0x134
_0x136:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x126
_0x134:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x137
	LDI  R16,LOW(4)
	RJMP _0x126
_0x137:
	RJMP _0x138
_0x133:
	CPI  R30,LOW(0x4)
	BRNE _0x13A
	CPI  R19,48
	BRLO _0x13C
	CPI  R19,58
	BRLO _0x13D
_0x13C:
	RJMP _0x13B
_0x13D:
	ORI  R17,LOW(32)
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x126
_0x13B:
_0x138:
	CPI  R19,108
	BRNE _0x13E
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x126
_0x13E:
	RJMP _0x13F
_0x13A:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x126
_0x13F:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x144
	CALL SUBOPT_0x8C
	LD   R30,X
	CALL SUBOPT_0x8D
	RJMP _0x145
_0x144:
	CPI  R30,LOW(0x45)
	BREQ _0x148
	CPI  R30,LOW(0x65)
	BRNE _0x149
_0x148:
	RJMP _0x14A
_0x149:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x14B
_0x14A:
	MOVW R30,R28
	ADIW R30,18
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x8C
	CALL __GETD1P
	CALL SUBOPT_0x66
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x14C
	LDD  R26,Y+17
	CPI  R26,LOW(0x2B)
	BREQ _0x14E
	RJMP _0x14F
_0x14C:
	CALL SUBOPT_0x76
	CALL __ANEGF1
	CALL SUBOPT_0x66
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x14E:
	SBRS R17,7
	RJMP _0x150
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	RJMP _0x151
_0x150:
	CALL SUBOPT_0x8E
	LDD  R26,Y+17
	STD  Z+0,R26
_0x151:
_0x14F:
	SBRS R17,5
	LDI  R21,LOW(5)
	CPI  R19,102
	BRNE _0x153
	CALL SUBOPT_0x76
	CALL __PUTPARD1
	ST   -Y,R21
	CALL SUBOPT_0x8F
	CALL __ftoa_G5
	RJMP _0x154
_0x153:
	CALL SUBOPT_0x76
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G5
_0x154:
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0x90
	RJMP _0x155
_0x14B:
	CPI  R30,LOW(0x73)
	BRNE _0x157
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CALL SUBOPT_0x90
	RJMP _0x158
_0x157:
	CPI  R30,LOW(0x70)
	BRNE _0x15A
	CALL SUBOPT_0x8C
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x158:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x15C
	CP   R21,R16
	BRLO _0x15D
_0x15C:
	RJMP _0x15B
_0x15D:
	MOV  R16,R21
_0x15B:
_0x155:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x15E
_0x15A:
	CPI  R30,LOW(0x64)
	BREQ _0x161
	CPI  R30,LOW(0x69)
	BRNE _0x162
_0x161:
	ORI  R17,LOW(4)
	RJMP _0x163
_0x162:
	CPI  R30,LOW(0x75)
	BRNE _0x164
_0x163:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x165
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x43
	LDI  R16,LOW(10)
	RJMP _0x166
_0x165:
	__GETD1N 0x2710
	CALL SUBOPT_0x43
	LDI  R16,LOW(5)
	RJMP _0x166
_0x164:
	CPI  R30,LOW(0x58)
	BRNE _0x168
	ORI  R17,LOW(8)
	RJMP _0x169
_0x168:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x1A7
_0x169:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x16B
	__GETD1N 0x10000000
	CALL SUBOPT_0x43
	LDI  R16,LOW(8)
	RJMP _0x166
_0x16B:
	__GETD1N 0x1000
	CALL SUBOPT_0x43
	LDI  R16,LOW(4)
_0x166:
	CPI  R21,0
	BREQ _0x16C
	ANDI R17,LOW(127)
	RJMP _0x16D
_0x16C:
	LDI  R21,LOW(1)
_0x16D:
	SBRS R17,1
	RJMP _0x16E
	CALL SUBOPT_0x8C
	CALL __GETD1P
	RJMP _0x22E
_0x16E:
	SBRS R17,2
	RJMP _0x170
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x22E
_0x170:
	CALL SUBOPT_0x8C
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x22E:
	__PUTD1S 6
	SBRS R17,2
	RJMP _0x172
	CALL SUBOPT_0x91
	CALL __CPD20
	BRGE _0x173
	CALL SUBOPT_0x76
	CALL __ANEGD1
	CALL SUBOPT_0x66
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x173:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x174
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x175
_0x174:
	ANDI R17,LOW(251)
_0x175:
_0x172:
	MOV  R18,R21
_0x15E:
	SBRC R17,0
	RJMP _0x176
_0x177:
	CP   R16,R20
	BRSH _0x17A
	CP   R18,R20
	BRLO _0x17B
_0x17A:
	RJMP _0x179
_0x17B:
	SBRS R17,7
	RJMP _0x17C
	SBRS R17,2
	RJMP _0x17D
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0x17E
_0x17D:
	LDI  R19,LOW(48)
_0x17E:
	RJMP _0x17F
_0x17C:
	LDI  R19,LOW(32)
_0x17F:
	CALL SUBOPT_0x8B
	SUBI R20,LOW(1)
	RJMP _0x177
_0x179:
_0x176:
_0x180:
	CP   R16,R21
	BRSH _0x182
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x183
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x184
	SUBI R20,LOW(1)
_0x184:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x183:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x185
	SUBI R20,LOW(1)
_0x185:
	SUBI R21,LOW(1)
	RJMP _0x180
_0x182:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x186
_0x187:
	CPI  R18,0
	BREQ _0x189
	SBRS R17,3
	RJMP _0x18A
	CALL SUBOPT_0x8E
	LPM  R30,Z
	RJMP _0x22F
_0x18A:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x22F:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G5
	CPI  R20,0
	BREQ _0x18C
	SUBI R20,LOW(1)
_0x18C:
	SUBI R18,LOW(1)
	RJMP _0x187
_0x189:
	RJMP _0x18D
_0x186:
_0x18F:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x91
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x191
	SBRS R17,3
	RJMP _0x192
	SUBI R19,-LOW(55)
	RJMP _0x193
_0x192:
	SUBI R19,-LOW(87)
_0x193:
	RJMP _0x194
_0x191:
	SUBI R19,-LOW(48)
_0x194:
	SBRC R17,4
	RJMP _0x196
	CPI  R19,49
	BRSH _0x198
	CALL SUBOPT_0x47
	__CPD2N 0x1
	BRNE _0x197
_0x198:
	RJMP _0x19A
_0x197:
	CP   R21,R18
	BRLO _0x19B
	RJMP _0x230
_0x19B:
	CP   R20,R18
	BRLO _0x19D
	SBRS R17,0
	RJMP _0x19E
_0x19D:
	RJMP _0x19C
_0x19E:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x19F
_0x230:
	LDI  R19,LOW(48)
_0x19A:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x1A0
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x8D
	CPI  R20,0
	BREQ _0x1A1
	SUBI R20,LOW(1)
_0x1A1:
_0x1A0:
_0x19F:
_0x196:
	CALL SUBOPT_0x8B
	CPI  R20,0
	BREQ _0x1A2
	SUBI R20,LOW(1)
_0x1A2:
_0x19C:
	SUBI R18,LOW(1)
	CALL SUBOPT_0x44
	CALL SUBOPT_0x91
	CALL __MODD21U
	CALL SUBOPT_0x66
	LDD  R30,Y+16
	CALL SUBOPT_0x47
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
	CALL __CPD10
	BREQ _0x190
	RJMP _0x18F
_0x190:
_0x18D:
	SBRS R17,0
	RJMP _0x1A3
_0x1A4:
	CPI  R20,0
	BREQ _0x1A6
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x8D
	RJMP _0x1A4
_0x1A6:
_0x1A3:
_0x1A7:
_0x145:
_0x22D:
	LDI  R16,LOW(0)
_0x126:
	RJMP _0x121
_0x123:
	CALL __LOADLOCR6
	ADIW R28,40
	RET
_printf:
	PUSH R15
	CALL SUBOPT_0x92
	CALL __print_G5
	RJMP _0x223
__get_G5:
	ST   -Y,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x1A8
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1A9
_0x1A8:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x1AA
	CALL __GETW1P
	LD   R30,Z
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x1AB
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x1AB:
	RJMP _0x1AC
_0x1AA:
	CALL _getchar
	MOV  R16,R30
_0x1AC:
_0x1A9:
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
_0x1AD:
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
	JMP _0x1AF
	CALL SUBOPT_0x93
	BREQ _0x1B0
_0x1B1:
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1B4
	CALL SUBOPT_0x93
	BRNE _0x1B5
_0x1B4:
	RJMP _0x1B3
_0x1B5:
	RJMP _0x1B1
_0x1B3:
	STD  Y+12,R18
	RJMP _0x1B6
_0x1B0:
	CPI  R18,37
	BREQ PC+3
	JMP _0x1B7
	LDI  R20,LOW(0)
_0x1B8:
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
	CPI  R18,48
	BRLO _0x1BC
	CPI  R18,58
	BRLO _0x1BB
_0x1BC:
	RJMP _0x1BA
_0x1BB:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x1B8
_0x1BA:
	CPI  R18,0
	BRNE _0x1BE
	RJMP _0x1AF
_0x1BE:
_0x1BF:
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R19,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BRNE _0x1BF
	CPI  R19,0
	BRNE _0x1C2
	RJMP _0x1C3
_0x1C2:
	STD  Y+12,R19
	CPI  R20,0
	BRNE _0x1C4
	LDI  R20,LOW(255)
_0x1C4:
	LDI  R21,LOW(0)
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x1C8
	CALL SUBOPT_0x95
	CALL SUBOPT_0x94
	CALL __get_G5
	MOVW R26,R16
	ST   X,R30
	RJMP _0x1C7
_0x1C8:
	CPI  R30,LOW(0x73)
	BRNE _0x1C9
	CALL SUBOPT_0x95
_0x1CA:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1CC
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1CE
	CALL SUBOPT_0x93
	BREQ _0x1CD
_0x1CE:
	RJMP _0x1CC
_0x1CD:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R18
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x1CA
_0x1CC:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1C7
_0x1C9:
	CPI  R30,LOW(0x6C)
	BRNE _0x1D1
	LDI  R21,LOW(1)
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	LPM  R18,Z+
	STD  Y+17,R30
	STD  Y+17+1,R31
_0x1D1:
	LDI  R30,LOW(1)
	STD  Y+10,R30
	MOV  R30,R18
	CPI  R30,LOW(0x64)
	BREQ _0x1D6
	CPI  R30,LOW(0x69)
	BRNE _0x1D7
_0x1D6:
	LDI  R30,LOW(0)
	STD  Y+10,R30
	RJMP _0x1D8
_0x1D7:
	CPI  R30,LOW(0x75)
	BRNE _0x1D9
_0x1D8:
	LDI  R19,LOW(10)
	RJMP _0x1D4
_0x1D9:
	CPI  R30,LOW(0x78)
	BRNE _0x1DA
	LDI  R19,LOW(16)
	RJMP _0x1D4
_0x1DA:
	CPI  R30,LOW(0x25)
	BRNE _0x1DD
	RJMP _0x1DC
_0x1DD:
	LDD  R30,Y+11
	RJMP _0x224
_0x1D4:
	__CLRD1S 6
_0x1DE:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1E0
	CALL SUBOPT_0x94
	CALL __get_G5
	MOV  R18,R30
	CPI  R30,LOW(0x21)
	BRLO _0x1E2
	LDD  R30,Y+10
	CPI  R30,0
	BRNE _0x1E3
	CPI  R18,45
	BRNE _0x1E4
	LDI  R30,LOW(255)
	STD  Y+10,R30
	RJMP _0x1DE
_0x1E4:
	LDI  R30,LOW(1)
	STD  Y+10,R30
_0x1E3:
	CPI  R18,48
	BRLO _0x1E2
	CPI  R18,97
	BRLO _0x1E7
	SUBI R18,LOW(87)
	RJMP _0x1E8
_0x1E7:
	CPI  R18,65
	BRLO _0x1E9
	SUBI R18,LOW(55)
	RJMP _0x1EA
_0x1E9:
	SUBI R18,LOW(48)
_0x1EA:
_0x1E8:
	CP   R18,R19
	BRLO _0x1EB
_0x1E2:
	STD  Y+12,R18
	RJMP _0x1E0
_0x1EB:
	MOV  R30,R19
	CALL SUBOPT_0x91
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
	CALL SUBOPT_0x66
	RJMP _0x1DE
_0x1E0:
	LDD  R30,Y+10
	CALL SUBOPT_0x91
	CALL __CBD1
	CALL __MULD12U
	CALL SUBOPT_0x66
	CPI  R21,0
	BREQ _0x1EC
	CALL SUBOPT_0x95
	CALL SUBOPT_0x76
	MOVW R26,R16
	CALL __PUTDP1
	RJMP _0x1ED
_0x1EC:
	CALL SUBOPT_0x95
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x1ED:
_0x1C7:
	LDD  R30,Y+11
	SUBI R30,-LOW(1)
	STD  Y+11,R30
	RJMP _0x1EE
_0x1B7:
_0x1DC:
	CALL SUBOPT_0x94
	CALL __get_G5
	CP   R30,R18
	BREQ _0x1EF
_0x1C3:
	LDD  R30,Y+11
	CPI  R30,0
	BRNE _0x1F0
	LDI  R30,LOW(255)
	RJMP _0x224
_0x1F0:
	RJMP _0x1AF
_0x1EF:
_0x1EE:
_0x1B6:
	RJMP _0x1AD
_0x1AF:
	LDD  R30,Y+11
_0x224:
	CALL __LOADLOCR6
	ADIW R28,19
	RET
_scanf:
	PUSH R15
	CALL SUBOPT_0x92
	CALL __scanf_G5
_0x223:
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
_0x1F1:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x1F3
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1F1
_0x1F3:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R20,43
	BRNE _0x1F4
	RJMP _0x231
_0x1F4:
	CPI  R20,45
	BRNE _0x1F6
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x231:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1F6:
	LDI  R30,LOW(0)
	MOV  R21,R30
	MOV  R20,R30
	__GETWRS 16,17,16
_0x1F7:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BRNE _0x1FA
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R20,R30
	CPI  R30,0
	BREQ _0x1F9
_0x1FA:
	OR   R21,R20
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1F7
_0x1F9:
	__GETWRS 18,19,16
	CPI  R21,0
	BREQ _0x1FC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1FD:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x1FF
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	SUBI R30,LOW(48)
	CALL SUBOPT_0x49
	CALL SUBOPT_0x81
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x5B
	CALL __DIVF21
	CALL SUBOPT_0x7A
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1FD
_0x1FF:
_0x1FC:
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x43
_0x200:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x202
	LD   R30,X
	SUBI R30,LOW(48)
	CALL SUBOPT_0x47
	CALL SUBOPT_0x81
	CALL __MULF12
	CALL SUBOPT_0x49
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	CALL SUBOPT_0x82
	CALL SUBOPT_0x43
	RJMP _0x200
_0x202:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R20,X
	CPI  R20,101
	BREQ _0x204
	CPI  R20,69
	BREQ _0x204
	RJMP _0x203
_0x204:
	LDI  R30,LOW(0)
	MOV  R21,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R20,X
	CPI  R20,43
	BRNE _0x206
	RJMP _0x232
_0x206:
	CPI  R20,45
	BRNE _0x208
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x232:
	__ADDWRN 18,19,1
_0x208:
_0x209:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x20B
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	ADD  R30,R20
	SUBI R30,LOW(48)
	MOV  R21,R30
	RJMP _0x209
_0x20B:
	CPI  R21,39
	BRLO _0x20C
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x20D
	__GETD1N 0xFF7FFFFF
	RJMP _0x222
_0x20D:
	__GETD1N 0x7F7FFFFF
	RJMP _0x222
_0x20C:
	LDI  R20,LOW(32)
	CALL SUBOPT_0x7C
	CALL SUBOPT_0x43
_0x20E:
	CPI  R20,0
	BREQ _0x210
	CALL SUBOPT_0x46
	CALL SUBOPT_0x43
	MOV  R30,R21
	AND  R30,R20
	BREQ _0x211
	CALL SUBOPT_0x47
	CALL SUBOPT_0x82
	CALL SUBOPT_0x43
_0x211:
	LSR  R20
	RJMP _0x20E
_0x210:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x212
	CALL SUBOPT_0x44
	CALL SUBOPT_0x49
	CALL __DIVF21
	RJMP _0x233
_0x212:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x49
	CALL __MULF12
_0x233:
	__PUTD1S 8
_0x203:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x214
	CALL SUBOPT_0x6D
	CALL __ANEGF1
	CALL SUBOPT_0x7A
_0x214:
	CALL SUBOPT_0x6D
_0x222:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x215:
	SBIS 0xE,7
	RJMP _0x215
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
	BRLT _0x218
	__GETD1N 0xFF7FFFFF
	RJMP _0x221
_0x218:
	RCALL SUBOPT_0x76
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
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x91
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x219
	RCALL SUBOPT_0x76
	RCALL SUBOPT_0x91
	CALL __ADDF12
	RCALL SUBOPT_0x66
	__SUBWRN 16,17,1
_0x219:
	RCALL SUBOPT_0x91
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x41
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x76
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x76
	RCALL SUBOPT_0x91
	CALL __MULF12
	RCALL SUBOPT_0x38
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
	RCALL SUBOPT_0x37
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x221:
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
	BREQ _0x21A
	LD   R30,Y
	ORI  R30,LOW(0xA0)
	ST   Y,R30
_0x21A:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x21B
	LD   R30,Y
	ORI  R30,4
	RJMP _0x234
_0x21B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x21D
	LD   R30,Y
	ORI  R30,8
	RJMP _0x234
_0x21D:
	LDI  R30,LOW(0)
_0x234:
	ST   Y,R30
	RCALL SUBOPT_0x96
	LDI  R30,LOW(144)
	ST   -Y,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x97
	RJMP _0x21F
_rtc_get_time:
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x98
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x98
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(129)
	RCALL SUBOPT_0x98
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RJMP _0x220
_rtc_set_time:
	RCALL SUBOPT_0x96
	LDI  R30,LOW(132)
	RCALL SUBOPT_0x99
	LDI  R30,LOW(130)
	RCALL SUBOPT_0x9A
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x9B
	RJMP _0x21F
_rtc_get_date:
	LDI  R30,LOW(135)
	RCALL SUBOPT_0x98
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(137)
	RCALL SUBOPT_0x98
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(141)
	RCALL SUBOPT_0x98
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
_0x220:
	ADIW R28,6
	RET
_rtc_set_date:
	RCALL SUBOPT_0x96
	LDI  R30,LOW(134)
	RCALL SUBOPT_0x99
	LDI  R30,LOW(136)
	RCALL SUBOPT_0x9A
	LDI  R30,LOW(140)
	RCALL SUBOPT_0x9B
_0x21F:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	__PUTD1SX 68
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	__PUTD1SX 72
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	__PUTD1SX 76
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	__PUTD1SX 80
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x10:
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
	MOV  R30,R5
	LDI  R31,0
	LDI  R26,LOW(60)
	LDI  R27,HIGH(60)
	CALL __MULW12
	MOVW R26,R30
	MOV  R30,R6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	__GETD2SX 80
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	CALL __CWD1
	CALL __CDF1
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	__GETD2SX 76
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	__GETD2SX 72
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	__GETD2SX 68
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1B:
	__GETD1S 48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	CALL __CDF1U
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	CALL __GETD1P
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	CALL __PUTPARD1
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
	__PUTD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	__GETD1S 36
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _rtc_get_date

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2E:
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
SUBOPT_0x2F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x30:
	MOV  R30,R9
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	MOV  R30,R7
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x31:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x32:
	CALL __PUTPARD1
	__GETD1SX 62
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL _Read_Max186
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x37:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x38:
	__PUTD1S 2
	RET

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
	RJMP SUBOPT_0x30

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x42:
	__GETD2S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x43:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x44:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	CALL __ADDF12
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x44
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x47:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x48:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x49:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	CALL __ADDF12
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	RCALL SUBOPT_0x27
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__GETD2N 0x3F800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4D:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4F:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _scanf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x51:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x11
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x52:
	__GETW1R 19,20
	MOVW R26,R28
	ADIW R26,13
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:127 WORDS
SUBOPT_0x53:
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
SUBOPT_0x54:
	MOVW R26,R28
	ADIW R26,13
	ADD  R26,R19
	ADC  R27,R20
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x55:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	CALL _atof
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x56:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	__GETD1N 0x33D6BF95
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x59:
	__POINTW1FN _0,2360
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5B:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	__GETD1N 0x43FA0000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5E:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x22
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x60:
	__GETD1N 0x471C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	__GETD1N 0x459C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x26
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x65:
	MOVW R30,R28
	ADIW R30,13
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x66:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x67:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	LDI  R24,32
	CALL _printf
	ADIW R28,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x69:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,38
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6A:
	MOVW R30,R16
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RJMP SUBOPT_0x37

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6C:
	__GETD1S 40
	CALL __PUTPARD1
	RCALL SUBOPT_0x1B
	CALL __PUTPARD1
	__GETD1S 56
	CALL __PUTPARD1
	__GETD1SX 64
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6E:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
	CALL __PUTDP1
	RJMP SUBOPT_0x6E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x70:
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x37
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x72:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	CALL __DIVF21
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x75:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x76:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x77:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x78:
	LDS  R30,_Tabs
	LDS  R31,_Tabs+1
	LDS  R22,_Tabs+2
	LDS  R23,_Tabs+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	RCALL SUBOPT_0x42
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7B:
	__GETD2S 20
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7C:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7D:
	__GETD2S 2
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7E:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7F:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x80:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x81:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x82:
	RCALL SUBOPT_0x5B
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x83:
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x84:
	__GETD2S 3
	RJMP SUBOPT_0x82

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x85:
	__GETD1S 3
	__GETD2S 11
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x86:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x87:
	RCALL SUBOPT_0x5B
	CALL __DIVF21
	__PUTD1S 11
	SUBI R18,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x88:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x89:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8A:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x8B:
	ST   -Y,R19
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G5

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x96:
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x97:
	ST   -Y,R30
	CALL _ds1302_write
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x98:
	ST   -Y,R30
	CALL _ds1302_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x99:
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9A:
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9B:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _bin2bcd
	RJMP SUBOPT_0x97

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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

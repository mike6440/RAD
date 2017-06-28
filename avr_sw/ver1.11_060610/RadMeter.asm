
;CodeVisionAVR C Compiler V1.25.0a Standard
;(C) Copyright 1998-2006 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega64
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega64
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
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

	.INCLUDE "RadMeter.vec"
	.INCLUDE "RadMeter.inc"

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
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x500
;       1 /*********************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.23.8c Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2003 HP InfoTech s.r.l.
;       6 http://www.hpinfotech.ro
;       7 e-mail:office@hpinfotech.ro
;       8 
;       9 Project : NOAA Radiometer Interface Board
;      10 Version : 
;      11 Date    : 12/20/2004
;      12 Author  : Ray Edwards                     
;      13 Company : Brookhaven National Laboratory  
;      14 Comments: Revision History
;      15 			1.0 - Start with simple timed operation 12/22/04 
;      16             1.1 - Build user menu and implement eeprom variables 03/24/05
;      17             
;      18 ********************************************
;      19 Chip type           : ATmega64
;      20 Program type        : Application
;      21 Clock frequency     : 8.000000 MHz
;      22 Memory model        : Small
;      23 External SRAM size  : 0
;      24 Data Stack size     : 1024
;      25 *********************************************/
;      26 
;      27 #include <delay.h>
;      28 #include <stdio.h>
;      29 #include <stdlib.h> 
;      30 #include <spi.h> 
;      31 #include <math.h>
;      32 #include "thermistor.h"
;      33 #include "pir.h"
;      34 #include "psp.h"
;      35 #include <mega64.h>
;      36 #include <eeprom.h>
;      37 
;      38 
;      39 
;      40 // DS1302 Real Time Clock functions
;      41 #asm
;      42    .equ __ds1302_port=0x18
   .equ __ds1302_port=0x18
;      43    .equ __ds1302_io=4
   .equ __ds1302_io=4
;      44    .equ __ds1302_sclk=5
   .equ __ds1302_sclk=5
;      45    .equ __ds1302_rst=6
   .equ __ds1302_rst=6
;      46 #endasm
;      47 #include <ds1302.h> 
;      48 
;      49 #define VERSION "1.11"
;      50 #define VERDATE "2006/10/08"
;      51 #define RXB8 	1
;      52 #define TXB8 	0
;      53 #define UPE 	2
;      54 #define OVR 	3
;      55 #define FE 	4
;      56 #define UDRE 	5
;      57 #define RXC 	7
;      58 #define BATT	7
;      59 #define PCTEMP	6
;      60 #define VREF	5  
;      61 #define ALL	8       
;      62 #define NSAMPS	100
;      63 #define NCHANS	8
;      64 
;      65 // watchdog WDTCR register bit positions and mask
;      66 #define WDCE   (4)  // Watchdog Turn-off Enable
;      67 #define WDE     (3)  // Watchdog Enable
;      68 #define PMASK   (7)  // prescaler mask    
;      69 #define WATCHDOG_PRESCALE (7)    
;      70 #define XTAL	8000000
;      71 #define BAUD	19200  //default terminal setting
;      72 #define OK	1
;      73 #define NOTOK	0 
;      74 
;      75 #define FRAMING_ERROR (1<<FE)
;      76 #define PARITY_ERROR (1<<UPE)
;      77 #define DATA_OVERRUN (1<<OVR)
;      78 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      79 #define RX_COMPLETE (1<<RXC)
;      80 
;      81 // Get a character from the USART1 Receiver
;      82 #pragma used+
;      83 char getchar1(void)
;      84 {

	.CSEG
;      85 char status,data;
;      86 while (1)
;	status -> R16
;	data -> R17
;      87       {
;      88       while (((status=UCSR1A) & RX_COMPLETE)==0);
;      89       data=UDR1;
;      90       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;      91          return data;
;      92       };
;      93 }
;      94 #pragma used-
;      95 
;      96 // Write a character to the USART1 Transmitter
;      97 #pragma used+
;      98 void putchar1(char c)
;      99 {
;     100 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
;     101 UDR1=c;
;     102 }
;     103 #pragma used-
;     104 
;     105 // Declare your global variables here
;     106 
;     107 //PROTOTYPES
;     108 void ATMega64_Setup(void);
;     109 void SignOn(void);
;     110 float ReadBattVolt(void);
;     111 float ReadRefVolt(void); 
;     112 float ReadAVRTemp();
;     113 void Heartbeat(void);
;     114 int SerByteAvail(void);  
;     115 int ClearScreen(void);
;     116 int Read_Max186(int, int); 
;     117 float RL10052Temp (unsigned int v2, int ref, int res);
;     118 void Main_Menu(void);
;     119 void ReadAnalog( int chan );
;     120 void MeanStdev(double *sum, double *sum2, int N, double missing);
;     121 void SampleADC(void);
;     122 
;     123 //GLOBAL VARIABLES
;     124 //COEFFICIENTS FOR THERMOMETRICS RL1005 Thermistor
;     125 float COEFFA = 	.0033540172; 

	.DSEG
_COEFFA:
	.BYTE 0x4
;     126 float COEFFB = 	.00032927261; 
_COEFFB:
	.BYTE 0x4
;     127 float COEFFC =	.0000041188325;
_COEFFC:
	.BYTE 0x4
;     128 float COEFFD = -.00000016472972;
_COEFFD:
	.BYTE 0x4
;     129 
;     130 unsigned char h, m, s, now, then;
;     131 unsigned char date, mon, yr;
;     132 int state; 
;     133 double Tabs = 273.15;
_Tabs:
	.BYTE 0x4
;     134 int adc[NCHANS];   
_adc:
	.BYTE 0x10
;     135 
;     136 //SETUP EEPROM VARIABLES AND INITIALIZE
;     137 eeprom float psp = 7.72E-6;       //PSP COEFF

	.ESEG
_psp:
	.DW  0x8526
	.DW  0x3701
;     138 eeprom float pir = 3.68E-6;       //PIR COEFF
_pir:
	.DW  0xF5EB
	.DW  0x3676
;     139 eeprom int looptime = 10;	//NMEA OUTPUT SCHEDULE
_looptime:
	.DW  0xA
;     140 eeprom int Cmax = 2048;  	//A/D COUNTS MAX VALUE
_Cmax:
	.DW  0x800
;     141 eeprom float RrefC = 33042.0; 	//CASE REFERENCE RESISTOR VALUE
_RrefC:
	.DW  0x1200
	.DW  0x4701
;     142 eeprom float RrefD = 33046.0;     //DOME REFERENCE RESISTOR VALUE
_RrefD:
	.DW  0x1600
	.DW  0x4701
;     143 eeprom float Vtherm = 4.0963;    //THERMISTOR SUPPLY VOLTAGE
_Vtherm:
	.DW  0x14E4
	.DW  0x4083
;     144 eeprom float Vadc = 4.0960;	//A/D REFERENCE VOLTAGE 
_Vadc:
	.DW  0x126F
	.DW  0x4083
;     145 eeprom float PIRadc_offset = 0.0;     //AMPLIFIER GAIN & OFFSET
_PIRadc_offset:
	.DW  0x0
	.DW  0x0
;     146 eeprom float PIRadc_gain = 815.0;
_PIRadc_gain:
	.DW  0xC000
	.DW  0x444B
;     147 eeprom float PSPadc_offset = 0.0;	//AMPLIFIER GAIN & OFFSET
_PSPadc_offset:
	.DW  0x0
	.DW  0x0
;     148 eeprom float PSPadc_gain = 125.0;
_PSPadc_gain:
	.DW  0x0
	.DW  0x42FA
;     149 eeprom int   Id_address = 00; 	//$RAD** address $RAD00 is default
_Id_address:
	.DW  0x0
;     150 
;     151 /******************************************************************************************
;     152 MAIN
;     153 ******************************************************************************************/
;     154 void main(void)
;     155 {

	.CSEG
_main:
;     156 int ADC0_mV, ADC1_mV, cx1, cx2;  
;     157 int nsamps;             
;     158 double BattV, AVRTemp, RefV;
;     159 double vt, Rt, Pt;
;     160 double Tc, Td;
;     161 double tcase, tdome;
;     162 double sw, lw, C_c, C_d;
;     163 double pir_cum, psp_cum;
;     164 
;     165 state = 0;
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
;     166 
;     167 
;     168     ATMega64_Setup();
	RCALL _ATMega64_Setup
;     169     SignOn();
	RCALL _SignOn
;     170     //Heartbeat();
;     171         printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
	CALL SUBOPT_0x0
;     172         printf(" Software Version 1.11, 2006/10/08\n\r");
;     173     	printf(" Current EEPROM values:\n\r");
;     174     	printf(" Identifier Header= $RAD%02d\n\r", Id_address);
;     175     	printf(" PSP Coeff= %.2E\n\r", psp);
;     176     	printf(" PIR Coeff= %.2E\n\r", pir);
;     177     	printf(" Interval Time (secs)= %d\n\r", looptime);
	CALL SUBOPT_0x1
;     178     	printf(" Cmax= %d\n\r", Cmax);
;     179     	printf(" Reference Resistor Case= %.1f\n\r", RrefC);
;     180     	printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
;     181     	printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
;     182     	printf(" PIR ADC Offset= %.2f\n\r", PIRadc_offset);
	CALL SUBOPT_0x2
;     183     	printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
;     184     	printf(" PSP ADC Offset= %.2f\n\r", PSPadc_offset);
;     185     	printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
;     186 		putchar('\n');
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
;     187 		putchar('\r');
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL _putchar
;     188 		
;     189 	//Heartbeat();
;     190     
;     191     // SETUP FOR TIMED OPERATION
;     192     rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x3
;     193     now = s;       
;     194     nsamps = 1;
	CALL SUBOPT_0x4
;     195     psp_cum = 0;
	__CLRD1S 0
;     196     	
;     197         while (1)
_0x12:
;     198         {
;     199          
;     200 
;     201       	// TEMPS, VOLTAGES
;     202         BattV = ReadBattVolt();
	RCALL _ReadBattVolt
	__PUTD1S 60
;     203       	RefV = ReadRefVolt();
	RCALL _ReadRefVolt
	__PUTD1S 52
;     204       	AVRTemp = ReadAVRTemp();
	RCALL _ReadAVRTemp
	__PUTD1S 56
;     205       
;     206         	
;     207       		// CALCULATE CASE TEMPERATURE
;     208      		cx1 = ( Read_Max186(2,0) );
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x5
	MOVW R20,R30
;     209       		therm_circuit_ground(cx1, Cmax, RrefC, Vtherm, Vadc, &vt, &Rt, &Pt);
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
;     210       		Tc = ysi46000(Rt,Pt);
	__PUTD1S 36
;     211       		tcase += Tc;
	CALL SUBOPT_0xA
	CALL __ADDF12
	CALL SUBOPT_0xB
;     212       	
;     213       		// CALCULATE DOME TEMPERATURE
;     214       		cx2 = ( Read_Max186(3,0) );
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x5
	__PUTW1SX 66
;     215       		therm_circuit_ground(cx2, Cmax, RrefD, Vtherm, Vadc, &vt, &Rt, &Pt);
	MOVW R26,R28
	SUBI R26,LOW(-(66))
	SBCI R27,HIGH(-(66))
	CALL SUBOPT_0xC
	CALL __PUTPARD1
	CALL SUBOPT_0x7
	CALL SUBOPT_0xD
	CALL SUBOPT_0x9
;     216       		Td = ysi46000(Rt,Pt);
	__PUTD1S 32
;     217       		tdome += Td;
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
;     218       		
;     219       		//CALCULATE LW (PIR)
;     220       		ADC1_mV = ( Read_Max186(1,0) ); 	//PIR Sig
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x5
	MOVW R18,R30
;     221       		PirTcTd2LW( ADC1_mV, pir, PIRadc_offset, PIRadc_gain, Tc, Td, 4.0, &lw, &C_c, &C_d);
	MOVW R30,R18
	CALL SUBOPT_0x10
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	CALL SUBOPT_0x14
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
;     222 			pir_cum += lw;
	CALL SUBOPT_0x15
	__GETD2S 4
	CALL __ADDF12
	CALL SUBOPT_0x16
;     223 			      	    
;     224 			//CALCULATE SW (PSP)
;     225       		ADC0_mV = ( Read_Max186(0,0) ); 	//PSP Sig 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x5
	CALL SUBOPT_0x17
;     226       		PSPSW( ADC0_mV, psp, PSPadc_offset, PSPadc_gain, &sw);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	MOVW R30,R28
	ADIW R30,36
	ST   -Y,R31
	ST   -Y,R30
	CALL _PSPSW
;     227       		psp_cum += sw; 
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
;     228             	
;     229             	//Diagnostic Printout
;     230 //            	printf("PIRmV= %d, CasemV= %d, DomemV= %d, PSPmV= %d\n\r",
;     231 //           			ADC1_mV, cx1, cx2, ADC0_mV);
;     232 //              printf("then= %d, now= %d\n\r", then, now);
;     233             			
;     234       		rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x3
;     235       		now = s;
;     236       		//if(now == 0) then=now; 
;     237          	if( abs((int)now - (int)then) >= looptime ) 
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
	CALL SUBOPT_0x1E
	CP   R0,R30
	CPC  R1,R31
	BRSH PC+3
	JMP _0x15
;     238          	{   
;     239        		        //OUTPUT STRING
;     240        		        pir_cum = pir_cum/nsamps;     //avg pir sig
	CALL SUBOPT_0x1F
	__GETD2S 4
	CALL SUBOPT_0x20
	CALL SUBOPT_0x16
;     241        		        tcase = tcase/nsamps;         //avg case temp pir
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xA
	CALL SUBOPT_0x20
	CALL SUBOPT_0xB
;     242        		        tdome = tdome/nsamps;         //avg dome temp pir
	CALL SUBOPT_0x1F
	CALL SUBOPT_0xE
	CALL SUBOPT_0x20
	__PUTD1S 24
;     243        		        psp_cum = psp_cum/nsamps;     //avg psp sig
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
;     244        		        rtc_get_date(&date, &mon, &yr);
	CALL SUBOPT_0x22
;     245        		        rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x23
;     246 			        if(h > 12) h = h - 12;
	LDI  R30,LOW(12)
	CP   R30,R4
	BRSH _0x16
	SUB  R4,R30
;     247 			
;     248        		        printf("$RAD%02d,%02d/%02d/%02d,%02d:%02d:%02d,%d,%d,%.2f,%.2f,%.2f,%.2f,%.1f,%.1f\n\r", 
_0x16:
;     249        			       Id_address, yr, mon, date, h, m, s, nsamps, ADC1_mV, pir_cum, tcase, tdome, psp_cum, AVRTemp, BattV);
	__POINTW1FN _0,398
	CALL SUBOPT_0x24
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	__GETW1SX 94
	CALL SUBOPT_0x27
	MOVW R30,R18
	CALL SUBOPT_0x27
	__GETD1S 42
	CALL SUBOPT_0x28
	CALL SUBOPT_0x28
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
;     250        		       
;     251                         rtc_get_time(&h,&m,&s); 
	CALL SUBOPT_0x23
;     252         	        then = s;
	MOV  R8,R6
;     253         	        nsamps = 1;
	CALL SUBOPT_0x4
;     254         	        Heartbeat();  
	RCALL _Heartbeat
;     255   	   	}                
;     256   	   		nsamps++;
_0x15:
	MOVW R26,R28
	SUBI R26,LOW(-(64))
	SBCI R27,HIGH(-(64))
	CALL SUBOPT_0x29
;     257   	       if( SerByteAvail() ) Main_Menu();
	RCALL _SerByteAvail
	SBIW R30,0
	BREQ _0x17
	RCALL _Main_Menu
;     258       }; // while loop
_0x17:
	RJMP _0x12
;     259       
;     260       
;     261 } // end main()
_0x18:
	RJMP _0x18
;     262  
;     263 float ReadAVRTemp(void)
;     264 /**********************************************
;     265 	Returns Temperature on Board in DegC
;     266 **********************************************/
;     267 {  
_ReadAVRTemp:
;     268 int RefVMilliVolts, AVRVMilliVolts;
;     269 float AVRTemp;
;     270 
;     271     RefVMilliVolts = ( Read_Max186(VREF, 1) );
	SBIW R28,4
	CALL __SAVELOCR4
;	RefVMilliVolts -> R16,R17
;	AVRVMilliVolts -> R18,R19
;	AVRTemp -> Y+4
	CALL SUBOPT_0x2A
	MOVW R16,R30
;     272 	AVRVMilliVolts = ( Read_Max186(PCTEMP, 1) );
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x2B
	MOVW R18,R30
;     273 	AVRTemp = RL10052Temp(AVRVMilliVolts, (RefVMilliVolts*2), 10010);
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
	CALL SUBOPT_0x16
;     274 	
;     275 	return AVRTemp;
	CALL SUBOPT_0x2C
	CALL __LOADLOCR4
	ADIW R28,8
	RET
;     276 }
;     277 
;     278 float ReadBattVolt(void)
;     279 /**********************************************
;     280 	Returns Main Power Input in Volts
;     281 **********************************************/
;     282 { 
_ReadBattVolt:
;     283 int BattVMilliVolts;
;     284 float BattV;
;     285 
;     286 	BattVMilliVolts = ( Read_Max186(BATT, 1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	BattVMilliVolts -> R16,R17
;	BattV -> Y+2
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x17
;     287  	BattV = ((BattVMilliVolts)/100.0) + 1.2;
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL __DIVF21
	__GETD2N 0x3F99999A
	CALL __ADDF12
	CALL SUBOPT_0x2F
;     288  	
;     289  	return BattV;
	RJMP _0x21B
;     290 }  
;     291 float ReadRefVolt(void)
;     292 /**********************************************
;     293 	Returns A/D Reference Voltage in Volts
;     294 **********************************************/
;     295 { 
_ReadRefVolt:
;     296 int RefVMilliVolts;
;     297 float RefV;
;     298 
;     299 	RefVMilliVolts = ( Read_Max186(VREF,1) );
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
;	RefVMilliVolts -> R16,R17
;	RefV -> Y+2
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x17
;     300  	RefV = ((RefVMilliVolts * 2) /1000);
	LSL  R30
	ROL  R31
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2F
;     301  	
;     302  	return RefV;
_0x21B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,6
	RET
;     303 }
;     304 
;     305 void Heartbeat(void)
;     306 /*************************************
;     307 Heartbeat on PortC pin 1
;     308 *************************************/
;     309 {
_Heartbeat:
;     310       PORTC=0x01;
	LDI  R30,LOW(1)
	CALL SUBOPT_0x30
;     311       delay_ms(50);
;     312       PORTC=0x03; 
	LDI  R30,LOW(3)
	CALL SUBOPT_0x30
;     313       delay_ms(50);
;     314 }
	RET
;     315 
;     316 void SignOn(void)
;     317 /********************************************
;     318  PROGRAM START
;     319 ********************************************/
;     320 {
_SignOn:
;     321 ClearScreen();
	RCALL _ClearScreen
;     322 	
;     323 	printf("\n\r\n\rNOAA RADIOMETER INTERFACE V1.11, 2006/10/08\n\r");
	__POINTW1FN _0,475
	CALL SUBOPT_0x31
;     324 		rtc_get_time(&h,&m,&s);
	CALL SUBOPT_0x23
;     325 		if(h > 12) h = h - 12;
	LDI  R30,LOW(12)
	CP   R30,R4
	BRSH _0x19
	SUB  R4,R30
;     326 	printf("Program Start time is: %02d:%02d:%02d\n\r", h, m, s);
_0x19:
	__POINTW1FN _0,525
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x26
	LDI  R24,12
	CALL _printf
	ADIW R28,14
;     327 		rtc_get_date(&date, &mon, &yr);
	CALL SUBOPT_0x22
;     328 	printf("Program Start date is: %02d/%02d/%02d\n\r", yr, mon, date);
	__POINTW1FN _0,565
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x25
	LDI  R24,12
	CALL _printf
	ADIW R28,14
;     329 	printf("\n\rHit any key for Main Menu.\n\r"); 
	__POINTW1FN _0,605
	CALL SUBOPT_0x31
;     330     printf("\n\r");
	CALL SUBOPT_0x32
;     331 }
	RET
;     332 
;     333 void ATMega64_Setup(void)
;     334 /*************************************
;     335 Initialization for AVR ATMega64 chip
;     336 *************************************/
;     337 {   
_ATMega64_Setup:
;     338 // Input/Output Ports initialization
;     339 // Port A initialization
;     340 // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     341 // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     342 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     343 DDRA=0x00;
	OUT  0x1A,R30
;     344 
;     345 // Port C initialization
;     346 // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     347 // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     348 PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
;     349 DDRC=0x03;
	OUT  0x14,R30
;     350 
;     351 // Port D initialization
;     352 // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     353 // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     354 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
;     355 DDRD=0x00;
	OUT  0x11,R30
;     356 
;     357 // Port E initialization
;     358 // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     359 // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     360 PORTE=0x00;
	OUT  0x3,R30
;     361 DDRE=0x00;
	OUT  0x2,R30
;     362 
;     363 // Port F initialization
;     364 // Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
;     365 // State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
;     366 PORTF=0x00;
	STS  98,R30
;     367 DDRF=0x00;
	STS  97,R30
;     368 
;     369 // Port G initialization
;     370 // Func0=In Func1=In Func2=In Func3=In Func4=In 
;     371 // State0=T State1=T State2=T State3=T State4=T 
;     372 PORTG=0x00;
	STS  101,R30
;     373 DDRG=0x00;
	STS  100,R30
;     374 
;     375 // Timer/Counter 0 initialization
;     376 // Clock source: System Clock
;     377 // Clock value: Timer 0 Stopped
;     378 // Mode: Normal top=FFh
;     379 // OC0 output: Disconnected
;     380 ASSR=0x00;
	OUT  0x30,R30
;     381 TCCR0=0x00;
	OUT  0x33,R30
;     382 TCNT0=0x00;
	OUT  0x32,R30
;     383 OCR0=0x00;
	OUT  0x31,R30
;     384 
;     385 // Timer/Counter 1 initialization
;     386 // Clock source: System Clock
;     387 // Clock value: Timer 1 Stopped
;     388 // Mode: Normal top=FFFFh
;     389 // OC1A output: Discon.
;     390 // OC1B output: Discon.
;     391 // OC1C output: Discon.
;     392 // Noise Canceler: Off
;     393 // Input Capture on Falling Edge
;     394 TCCR1A=0x00;
	OUT  0x2F,R30
;     395 TCCR1B=0x00;
	OUT  0x2E,R30
;     396 TCNT1H=0x00;
	OUT  0x2D,R30
;     397 TCNT1L=0x00;
	OUT  0x2C,R30
;     398 OCR1AH=0x00;
	OUT  0x2B,R30
;     399 OCR1AL=0x00;
	OUT  0x2A,R30
;     400 OCR1BH=0x00;
	OUT  0x29,R30
;     401 OCR1BL=0x00;
	OUT  0x28,R30
;     402 OCR1CH=0x00;
	STS  121,R30
;     403 OCR1CL=0x00;
	STS  120,R30
;     404 
;     405 // Timer/Counter 2 initialization
;     406 // Clock source: System Clock
;     407 // Clock value: Timer 2 Stopped
;     408 // Mode: Normal top=FFh
;     409 // OC2 output: Disconnected
;     410 TCCR2=0x00;
	OUT  0x25,R30
;     411 TCNT2=0x00;
	OUT  0x24,R30
;     412 OCR2=0x00;
	OUT  0x23,R30
;     413 
;     414 // Timer/Counter 3 initialization
;     415 // Clock source: System Clock
;     416 // Clock value: Timer 3 Stopped
;     417 // Mode: Normal top=FFFFh
;     418 // OC3A output: Discon.
;     419 // OC3B output: Discon.
;     420 // OC3C output: Discon.
;     421 TCCR3A=0x00;
	STS  139,R30
;     422 TCCR3B=0x00;
	STS  138,R30
;     423 TCNT3H=0x00;
	STS  137,R30
;     424 TCNT3L=0x00;
	STS  136,R30
;     425 OCR3AH=0x00;
	STS  135,R30
;     426 OCR3AL=0x00;
	STS  134,R30
;     427 OCR3BH=0x00;
	STS  133,R30
;     428 OCR3BL=0x00;
	STS  132,R30
;     429 OCR3CH=0x00;
	STS  131,R30
;     430 OCR3CL=0x00;
	STS  130,R30
;     431 
;     432 // External Interrupt(s) initialization
;     433 // INT0: Off
;     434 // INT1: Off
;     435 // INT2: Off
;     436 // INT3: Off
;     437 // INT4: Off
;     438 // INT5: Off
;     439 // INT6: Off
;     440 // INT7: Off
;     441 EICRA=0x00;
	STS  106,R30
;     442 EICRB=0x00;
	OUT  0x3A,R30
;     443 EIMSK=0x00;
	OUT  0x39,R30
;     444 
;     445 // Timer(s)/Counter(s) Interrupt(s) initialization
;     446 TIMSK=0x00;
	OUT  0x37,R30
;     447 ETIMSK=0x00;
	STS  125,R30
;     448 
;     449 // USART0 initialization
;     450 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     451 // USART0 Receiver: On
;     452 // USART0 Transmitter: On
;     453 // USART0 Mode: Asynchronous
;     454 // USART0 Baud rate: 19200
;     455 UCSR0A=0x00;
	OUT  0xB,R30
;     456 UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
;     457 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
;     458 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
;     459 UBRR0L=XTAL/16/BAUD-1;
	LDI  R30,LOW(25)
	OUT  0x9,R30
;     460 
;     461 // USART1 initialization
;     462 // Communication Parameters: 8 Data, 1 Stop, No Parity
;     463 // USART1 Receiver: On
;     464 // USART1 Transmitter: On
;     465 // USART1 Mode: Asynchronous
;     466 // USART1 Baud rate: 9600
;     467 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
;     468 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
;     469 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
;     470 UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
;     471 UBRR1L=0x33;
	LDI  R30,LOW(51)
	STS  153,R30
;     472 
;     473 // Analog Comparator initialization
;     474 // Analog Comparator: Off
;     475 // Analog Comparator Input Capture by Timer/Counter 1: Off
;     476 // Analog Comparator Output: Off
;     477 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     478 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     479 
;     480 // Port B initialization
;     481 PORTB=0x01;
	LDI  R30,LOW(1)
	OUT  0x18,R30
;     482 DDRB=0x07;
	LDI  R30,LOW(7)
	OUT  0x17,R30
;     483 
;     484 // SPI initialization
;     485 // SPI Type: Master
;     486 // SPI Clock Rate: 1MHz
;     487 // SPI Clock Phase: 1
;     488 // SPI Clock Polarity: 0
;     489 // SPI Data Order: MSB First
;     490 // SETUP for MAX186 on SPI
;     491 //SPCR = (1<<SPE) | (1<<MSTR) ; // SPI enable, Master mode, 1MHz Clk
;     492 SPCR = 0x51;
	LDI  R30,LOW(81)
	OUT  0xD,R30
;     493 SPSR=0x01;
	LDI  R30,LOW(1)
	OUT  0xE,R30
;     494 
;     495 // DS1302 Real Time Clock initialization
;     496 // Trickle charger: Off
;     497 rtc_init(1,1,3); 
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _rtc_init
;     498 
;     499 }  
	RET
;     500 
;     501 int SerByteAvail(void)
;     502 /********************************
;     503 Check the serial port for characters
;     504 returns a 1 if true 0 for not true
;     505 *********************************/
;     506 {   
_SerByteAvail:
;     507 int dum;
;     508 	if (UCSR0A >= 0x7f)
	ST   -Y,R17
	ST   -Y,R16
;	dum -> R16,R17
	IN   R30,0xB
	CPI  R30,LOW(0x7F)
	BRLO _0x1A
;     509 		{
;     510 		//printf("Character found!\n\r");
;     511 		dum = UDR0; 
	IN   R16,12
	CLR  R17
;     512 		return 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x21A
;     513 		}
;     514      dum = UDR0;
_0x1A:
	IN   R16,12
	CLR  R17
;     515 	 return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x21A
;     516 }      
;     517 
;     518 int ClearScreen(void)
;     519 /*********************************************
;     520 Routine to clear the terminal screen.
;     521 **********************************************/
;     522 { 
_ClearScreen:
;     523 int i; 
;     524 i=0;
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
;     525 	while (i<25)
_0x1B:
	__CPWRN 16,17,25
	BRGE _0x1D
;     526 	{
;     527 		printf("\n\r");
	CALL SUBOPT_0x32
;     528 		i++;
	__ADDWRN 16,17,1
;     529 	} 
	RJMP _0x1B
_0x1D:
;     530 	return OK;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x21A:
	LD   R16,Y+
	LD   R17,Y+
	RET
;     531 }  
;     532 
;     533 int Read_Max186(int channel, int mode)
;     534 /**************************************************
;     535 Routine to read external Max186 A-D Converter.
;     536 Control word sets Unipolar mode, Single-Ended Input,
;     537 External Clock.
;     538 Mode: 	0 = Bipolar (-VRef/2 to +VRef/2)
;     539  		1 = Unipolar ( 0 to VRef )		
;     540 **************************************************/
;     541 {
_Read_Max186:
;     542 unsigned int rb1, rb2, rb3;
;     543 int data_out;
;     544 long din;
;     545 
;     546 data_out=0;
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
;     547 rb1=rb2=rb3=0; 
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	MOVW R20,R30
	MOVW R18,R30
	MOVW R16,R30
;     548 
;     549 	if (mode == 1) //DO UNIPOLAR (0 - VREF)
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BREQ PC+3
	JMP _0x1E
;     550 	{
;     551 	if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x1F
;     552 		din=0x8F;		// 10001111
	__GETD1N 0x8F
	RJMP _0x21C
;     553 	else if(channel==1)
_0x1F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x21
;     554 		din=0xCF;		// 11001111
	__GETD1N 0xCF
	RJMP _0x21C
;     555 	else if(channel==2)
_0x21:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x23
;     556 		din=0x9F;		// 10011111
	__GETD1N 0x9F
	RJMP _0x21C
;     557 	else if(channel==3)
_0x23:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x25
;     558 		din=0xDF;		// 11011111
	__GETD1N 0xDF
	RJMP _0x21C
;     559 	else if(channel==4)
_0x25:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x27
;     560 		din=0xAF;		// 10101111
	__GETD1N 0xAF
	RJMP _0x21C
;     561 	else if(channel==5)
_0x27:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x29
;     562 		din=0xEF;		// 11101111
	__GETD1N 0xEF
	RJMP _0x21C
;     563 	else if(channel==6)
_0x29:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x2B
;     564 		din=0xBF;		// 10111111
	__GETD1N 0xBF
	RJMP _0x21C
;     565 	else if(channel==7)
_0x2B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x2D
;     566 		din=0xFF;	 	// 11111111
	__GETD1N 0xFF
_0x21C:
	__PUTD1S 6
;     567 	} 
_0x2D:
;     568 	else	//DO BIPOLAR (-VREF/2 - +VREF/2)
	RJMP _0x2E
_0x1E:
;     569 	{
;     570 	if(channel==0)		/*Set din to correct A/D channel*/
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,0
	BRNE _0x2F
;     571 		din=0x87;		// 10000111
	__GETD1N 0x87
	RJMP _0x21D
;     572 	else if(channel==1)
_0x2F:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,1
	BRNE _0x31
;     573 		din=0xC7;		// 11000111
	__GETD1N 0xC7
	RJMP _0x21D
;     574 	else if(channel==2)
_0x31:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,2
	BRNE _0x33
;     575 		din=0x97;		// 10010111
	__GETD1N 0x97
	RJMP _0x21D
;     576 	else if(channel==3)
_0x33:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,3
	BRNE _0x35
;     577 		din=0xD7;		// 11010111
	__GETD1N 0xD7
	RJMP _0x21D
;     578 	else if(channel==4)
_0x35:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,4
	BRNE _0x37
;     579 		din=0xA7;		// 10100111
	__GETD1N 0xA7
	RJMP _0x21D
;     580 	else if(channel==5)
_0x37:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,5
	BRNE _0x39
;     581 		din=0xE7;		// 11100111
	__GETD1N 0xE7
	RJMP _0x21D
;     582 	else if(channel==6)
_0x39:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,6
	BRNE _0x3B
;     583 		din=0xB7;		// 10110111
	__GETD1N 0xB7
	RJMP _0x21D
;     584 	else if(channel==7)
_0x3B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	SBIW R26,7
	BRNE _0x3D
;     585 		din=0xF7;	 	// 11110111
	__GETD1N 0xF7
_0x21D:
	__PUTD1S 6
;     586 	}
_0x3D:
_0x2E:
;     587     
;     588 	// START A-D
;     589 	PORTB = 0x07;
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     590 	PORTB = 0x06; 	//Selects CS- lo 
	LDI  R30,LOW(6)
	OUT  0x18,R30
;     591 	   
;     592 		// Send control byte ch7, Uni, Sgl, ext clk
;     593 		rb1 = ( spi(din) );		//Sends the coversion code from above
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _spi
	MOV  R16,R30
	CLR  R17
;     594 		// Send/Rcv HiByte
;     595 		rb2 = ( spi(0x00) );		//Receive byte 2 (MSB) 
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R18,R30
	CLR  R19
;     596 		// Send/Rcv LoByte
;     597 		rb3 = ( spi(0x00) );		//Receive byte 3 (LSB)
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _spi
	MOV  R20,R30
	CLR  R21
;     598 			
;     599 	PORTB = 0x07;		//Selects CS- hi
	LDI  R30,LOW(7)
	OUT  0x18,R30
;     600     
;     601 	// Calculation to counts
;     602 	if(mode == 1) //UNIPOLAR
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,1
	BRNE _0x3E
;     603 	{
;     604 		rb2 = rb2 << 1;
	CALL SUBOPT_0x33
;     605 		rb3 = rb3 >> 3;
;     606 		data_out = ( (rb2*16) + rb3 ) ;
	RJMP _0x21E
;     607 	}
;     608 	else if(mode == 0) //BIPOLAR
_0x3E:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x40
;     609 	{
;     610 		rb2 = rb2 << 1;
	CALL SUBOPT_0x33
;     611 		rb3 = rb3 >> 3;
;     612 		data_out = ((rb2*16) + rb3);
	STD  Y+10,R30
	STD  Y+10+1,R31
;     613 		if(data_out >= 2048) data_out -= 4096;
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
_0x21E:
	STD  Y+10,R30
	STD  Y+10+1,R31
;     614 	}
_0x41:
;     615 		
;     616 	
;     617    //	printf("Data Out= %d\n\r", data_out);   
;     618 	
;     619 	
;     620 	return data_out;
_0x40:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __LOADLOCR6
	ADIW R28,16
	RET
;     621 		
;     622 }   
;     623 
;     624 float RL10052Temp (unsigned int v2, int ref, int res)
;     625 /***********************************
;     626 Calculates Thermistor Temperature
;     627 v2 = A to D Milli Volts 0-4096
;     628 ref = reference voltage to circuit
;     629 res = reference divider resistor
;     630 ***********************************/
;     631 {
_RL10052Temp:
;     632 
;     633 
;     634 float v1, r2, it, Temp, dum;
;     635 float term1, term2, term3;
;     636 			
;     637 	v1 = (float)ref - (float)v2;
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
	CALL SUBOPT_0x2D
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CALL SUBOPT_0xB
;     638 	it = v1/(float)res;
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x2D
	CALL SUBOPT_0xA
	CALL __DIVF21
	__PUTD1S 20
;     639 	r2 = (float)v2/it;		    //find resistance of thermistor
	CALL SUBOPT_0x34
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x1B
	CALL __DIVF21
	__PUTD1S 24
;     640 	dum = (float)log(r2/(float)res);
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	CALL SUBOPT_0x2D
	CALL SUBOPT_0xE
	CALL __DIVF21
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x36
;     641 
;     642 // Diagnostic
;     643 //printf("v2=%d, v1=%f, it=%f, r2=%f, dum=%f\n\r", v2, v1, it, r2, dum);
;     644 
;     645 	term1 = COEFFA + (COEFFB * dum);
	CALL SUBOPT_0x37
	LDS  R26,_COEFFB
	LDS  R27,_COEFFB+1
	LDS  R24,_COEFFB+2
	LDS  R25,_COEFFB+3
	CALL __MULF12
	LDS  R26,_COEFFA
	LDS  R27,_COEFFA+1
	LDS  R24,_COEFFA+2
	LDS  R25,_COEFFA+3
	CALL SUBOPT_0x38
;     646 	term2 = COEFFC * (dum*dum);
	CALL SUBOPT_0x39
	LDS  R26,_COEFFC
	LDS  R27,_COEFFC+1
	LDS  R24,_COEFFC+2
	LDS  R25,_COEFFC+3
	CALL __MULF12
	CALL SUBOPT_0x16
;     647 	term3 = COEFFD * ((dum*dum)*dum);
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	LDS  R26,_COEFFD
	LDS  R27,_COEFFD+1
	LDS  R24,_COEFFD+2
	LDS  R25,_COEFFD+3
	CALL __MULF12
	CALL SUBOPT_0x21
;     648    	Temp = term1 + term2 + term3;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x3B
	CALL __ADDF12
	CALL SUBOPT_0x1C
	CALL __ADDF12
	CALL SUBOPT_0x3C
;     649 //printf("Term1= %.8f, Term2= %.8f, Term3= %.8f, Temp= %.8f\n\r", term1, term2, term3, Temp);
;     650 //Temp = (float)(A + (float)(B * dum) + (float)(C * (dum*dum)) + (float)(D * ((dum*dum)*dum)) );
;     651 	Temp = (float)(1/Temp) - 278.0;	// Rough conversion from Kelvin to Centigrade  
	CALL SUBOPT_0x3D
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x438B0000
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3C
;     652 //	printf("Temp= %f\n\r", Temp);
;     653 
;     654 return Temp;
	ADIW R28,38
	RET
;     655 } 
;     656 
;     657 void Main_Menu(void)
;     658 /*************************************************
;     659 *************************************************/
;     660 { 
_Main_Menu:
;     661 
;     662 char ch;
;     663 unsigned char h, date;
;     664 unsigned char dum1;
;     665 int ltime;
;     666 char msg[12];
;     667 int i;
;     668         
;     669 	printf("\n\r");
	SBIW R28,14
	CALL __SAVELOCR6
;	ch -> R16
;	h -> R17
;	date -> R18
;	dum1 -> R19
;	ltime -> R20,R21
;	msg -> Y+8
;	i -> Y+6
	CALL SUBOPT_0x32
;     670 	printf("\n\r NOAA RADIOMETER INTERFACE BOARD VERSION: 1.11, VERSION DATE: 2006/06/01\n\r");
	__POINTW1FN _0,636
	CALL SUBOPT_0x31
;     671 	printf(" ----------EEPROM PARAMETERS----------------------------\n\r");
	__POINTW1FN _0,713
	CALL SUBOPT_0x31
;     672 	printf("PSP Coeff= %.2E, PIR Coeff= %.2E\n\r", psp, pir);
	__POINTW1FN _0,772
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x11
	CALL SUBOPT_0x3F
;     673 	printf("PIRadc_gain= %.1f, PIRadc_offset= %.1f\n\r", PIRadc_gain, PIRadc_offset);                   
	__POINTW1FN _0,807
	CALL SUBOPT_0x40
	CALL SUBOPT_0x12
	CALL SUBOPT_0x3F
;     674 	printf("PSPadc_gain= %.1f, PSPadc_offset= %.1f\n\r", PSPadc_gain, PSPadc_offset);
	__POINTW1FN _0,848
	CALL SUBOPT_0x41
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3F
;     675 	printf(" ---------DATE & TIME SETTING---------------------------\n\r"); 
	__POINTW1FN _0,889
	CALL SUBOPT_0x31
;     676         printf("'T' -->Set the date/time.\n\r");
	__POINTW1FN _0,948
	CALL SUBOPT_0x31
;     677         printf(" ---------PSP SETTINGS----------------------------------\n\r");
	__POINTW1FN _0,976
	CALL SUBOPT_0x31
;     678         printf("'p' -->Set PSP coefficient.\n\r"); 
	__POINTW1FN _0,1035
	CALL SUBOPT_0x31
;     679         printf("'g' -->Set PSP amplifier gain value.\n\r");
	__POINTW1FN _0,1065
	CALL SUBOPT_0x31
;     680         printf("'o' -->Set PSP amplifier offset value.\n\r");
	__POINTW1FN _0,1104
	CALL SUBOPT_0x31
;     681         printf(" ---------PIR SETTINGS----------------------------------\n\r");
	__POINTW1FN _0,1145
	CALL SUBOPT_0x31
;     682         printf("'I' -->Set PIR coefficient.\n\r");
	__POINTW1FN _0,1204
	CALL SUBOPT_0x31
;     683         printf("'G' -->Set PIR amplifier gain value.\n\r");
	__POINTW1FN _0,1234
	CALL SUBOPT_0x31
;     684         printf("'O' -->Set PIR amplifier offset value.\n\r");
	__POINTW1FN _0,1273
	CALL SUBOPT_0x31
;     685         printf("'C' -->Set Case Reference Resistor (R9) value.\n\r");
	__POINTW1FN _0,1314
	CALL SUBOPT_0x31
;     686         printf("'D' -->Set Dome Reference Resistor (R10) value.\n\r");
	__POINTW1FN _0,1363
	CALL SUBOPT_0x31
;     687         printf("'V' -->Set Thermistor/ADC Reference Voltage (TP3) value.\n\r");
	__POINTW1FN _0,1413
	CALL SUBOPT_0x31
;     688         printf(" ---------TIMING SETTING--------------------------------\n\r");
	__POINTW1FN _0,1472
	CALL SUBOPT_0x31
;     689         printf("'L' -->Set Output time in seconds.\n\r");
	__POINTW1FN _0,1531
	CALL SUBOPT_0x31
;     690         printf(" -------------------------------------------------------\n\r");
	__POINTW1FN _0,1568
	CALL SUBOPT_0x31
;     691         printf("'S' -->Sample 12 bit A to D.\n\r");
	__POINTW1FN _0,1627
	CALL SUBOPT_0x31
;     692         printf("'A' -->Change Identifier String.\n\r");
	__POINTW1FN _0,1658
	CALL SUBOPT_0x31
;     693         printf("'X' -->Exit this menu, return to operation.\n\r");
	__POINTW1FN _0,1693
	CALL SUBOPT_0x31
;     694         printf("=========================================================\n\r");
	__POINTW1FN _0,1739
	CALL SUBOPT_0x31
;     695         printf("Command?>");
	__POINTW1FN _0,1799
	CALL SUBOPT_0x31
;     696         
;     697         
;     698         
;     699         	scanf(" %c", &ch);
	__POINTW1FN _0,1809
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	CALL __PUTPARD1L
	PUSH R16
	LDI  R24,4
	CALL _scanf
	ADIW R28,6
	POP  R16
;     700    			switch (ch) 
	MOV  R30,R16
	LDI  R31,0
;     701    			{
;     702 	   		case 'T':
	CPI  R30,LOW(0x54)
	LDI  R26,HIGH(0x54)
	CPC  R31,R26
	BREQ _0x46
;     703 	   		case 't':
	CPI  R30,LOW(0x74)
	LDI  R26,HIGH(0x74)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x47
_0x46:
;     704 	   			printf("\n\rSet Time (hhmmss): ");
	__POINTW1FN _0,1813
	CALL SUBOPT_0x31
;     705 				scanf(" %2d%2d%2d", &h, &m, &s);
	__POINTW1FN _0,1835
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	CALL __PUTPARD1L
	PUSH R17
	__GETD1N 0x5
	CALL __PUTPARD1
	__GETD1N 0x6
	CALL SUBOPT_0x42
	POP  R17
;     706 				
;     707 				    if( (h >= 24) || (m >= 60) || (s >= 60) ) 
	CPI  R17,24
	BRSH _0x49
	LDI  R30,LOW(60)
	CP   R5,R30
	BRSH _0x49
	CP   R6,R30
	BRLO _0x48
_0x49:
;     708 				    {
;     709 				    printf("\n\rIncorrect time entered, try again.\n\r");
	__POINTW1FN _0,1846
	RJMP _0x21F
;     710 				    break;
;     711 				    }
;     712 				else 
_0x48:
;     713 				{
;     714 				    rtc_set_time(h, m, s);
	ST   -Y,R17
	ST   -Y,R5
	ST   -Y,R6
	CALL _rtc_set_time
;     715 				    printf("Time Set!\n\r");
	__POINTW1FN _0,1885
	CALL SUBOPT_0x31
;     716 				}
;     717 				printf("\n\rSet Date (YYMMDD): ");
	__POINTW1FN _0,1897
	CALL SUBOPT_0x31
;     718 				scanf(" %2d%2d%2d", &date, &mon, &yr);
	__POINTW1FN _0,1835
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	CALL __PUTPARD1L
	PUSH R18
	__GETD1N 0xA
	CALL __PUTPARD1
	__GETD1N 0xB
	CALL SUBOPT_0x42
	POP  R18
;     719 				
;     720 				    if( (date <= 0 || date > 31) ||
;     721 				        (mon <=0 || mon > 12) ||
;     722 				        (yr < 06 || yr > 99) ) 
	CPI  R18,1
	BRLO _0x4D
	CPI  R18,32
	BRLO _0x4E
_0x4D:
	RJMP _0x4F
_0x4E:
	LDI  R30,LOW(0)
	CP   R30,R10
	BRSH _0x50
	LDI  R30,LOW(12)
	CP   R30,R10
	BRSH _0x51
_0x50:
	RJMP _0x4F
_0x51:
	LDI  R30,LOW(6)
	CP   R11,R30
	BRLO _0x52
	LDI  R30,LOW(99)
	CP   R30,R11
	BRSH _0x53
_0x52:
	RJMP _0x4F
_0x53:
	RJMP _0x4C
_0x4F:
;     723 				        {
;     724 				            printf("\n\rIncorrect date entered, try again\n\r");
	__POINTW1FN _0,1919
	RJMP _0x21F
;     725 				            break;
;     726 				        }
;     727 				        else 
_0x4C:
;     728 				        {   
;     729 				            rtc_set_date(date, mon, yr);
	ST   -Y,R18
	ST   -Y,R10
	ST   -Y,R11
	CALL _rtc_set_date
;     730 				            printf("Date Set!\n\r");
	__POINTW1FN _0,1957
	CALL SUBOPT_0x31
;     731 				        }
;     732 				//printf("\n\r");
;     733 				break;
	RJMP _0x44
;     734 				 
;     735 			case 'L' :
_0x47:
	CPI  R30,LOW(0x4C)
	LDI  R26,HIGH(0x4C)
	CPC  R31,R26
	BREQ _0x57
;     736 			case 'l' : 
	CPI  R30,LOW(0x6C)
	LDI  R26,HIGH(0x6C)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x58
_0x57:
;     737 				printf("Change Output Interval in secs\n\r");
	__POINTW1FN _0,1969
	CALL SUBOPT_0x31
;     738 				printf("Current Interval is: %d secs\n\r", looptime);
	__POINTW1FN _0,2002
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
;     739 				printf("Enter new output interval in secs: ");
	__POINTW1FN _0,2033
	CALL SUBOPT_0x31
;     740 				for (i=0; i<5; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x5A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BRGE _0x5B
;     741 				{
;     742 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     743 					printf("%c", msg[i]);
;     744 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x5D
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x5C
_0x5D:
;     745 					{
;     746 						i--;
	CALL SUBOPT_0x49
;     747 						break;
	RJMP _0x5B
;     748 					}
;     749 				}
_0x5C:
	CALL SUBOPT_0x4A
	RJMP _0x5A
_0x5B:
;     750 				if(atof(msg) >= 600 || atof(msg) <= 0)
	CALL SUBOPT_0x4B
	__GETD1N 0x44160000
	CALL __CMPF12
	BRSH _0x60
	CALL SUBOPT_0x4B
	CALL __CPD02
	BRLT _0x5F
_0x60:
;     751 				{
;     752 					printf("\n\rOut of Range.\n\r");
	__POINTW1FN _0,2069
	RJMP _0x21F
;     753 					break;
;     754 				}
;     755 				else 
_0x5F:
;     756 				{
;     757 					ltime = atof(msg);
	CALL SUBOPT_0x4C
	CALL __CFD1
	MOVW R20,R30
;     758 					looptime = ltime;
	MOVW R30,R20
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMWRW
;     759 					printf("\n\rLooptime is now set to %d seconds.\n\r", looptime); 
	__POINTW1FN _0,2087
	CALL SUBOPT_0x43
	CALL SUBOPT_0x44
;     760 				}
;     761 				
;     762 				break;  
	RJMP _0x44
;     763 			case 'p' :
_0x58:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x63
;     764 				printf("Change PSP Coefficient\n\r");
	__POINTW1FN _0,2126
	CALL SUBOPT_0x31
;     765 				printf("Current PSP Coefficient is: %.2E\n\r", psp);
	__POINTW1FN _0,2151
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x44
;     766 				printf("Enter New PSP Coefficient: ");
	__POINTW1FN _0,2186
	CALL SUBOPT_0x31
;     767 				for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x65:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x66
;     768 				{
;     769 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     770 					printf("%c", msg[i]);
;     771 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x68
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x67
_0x68:
;     772 					{
;     773 						i--;
	CALL SUBOPT_0x49
;     774 						break;
	RJMP _0x66
;     775 					}
;     776 				}
_0x67:
	CALL SUBOPT_0x4A
	RJMP _0x65
_0x66:
;     777 				if(atof(msg) >= 10.0E-6 || atof(msg) <= 0.1E-6)
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4D
	BRSH _0x6B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4E
	BREQ PC+2
	BRCC PC+3
	JMP  _0x6B
	RJMP _0x6A
_0x6B:
;     778 				{
;     779 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     780 					break;
;     781 				}
;     782 				else 
_0x6A:
;     783 				{
;     784 					psp = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMWRD
;     785 					printf("\n\rPSP Coefficient is now set to %.2E\n\r", psp); 
	__POINTW1FN _0,2229
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x44
;     786 				}
;     787 				break;
	RJMP _0x44
;     788 			 case 'g' :
_0x63:
	CPI  R30,LOW(0x67)
	LDI  R26,HIGH(0x67)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x6E
;     789 				printf("Change PSP Amplifier Gain Value\n\r");
	__POINTW1FN _0,2268
	CALL SUBOPT_0x31
;     790 				printf("Current PSP Amplifier Gain Value: %.2f\n\r", PSPadc_gain);
	__POINTW1FN _0,2302
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
;     791 				printf("Enter New PSP Amplifier Gain Value: ");
	__POINTW1FN _0,2343
	CALL SUBOPT_0x31
;     792 				for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x70:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x71
;     793 				{
;     794 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     795 					printf("%c", msg[i] );
;     796 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x73
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x72
_0x73:
;     797 					{
;     798 						i--;
	CALL SUBOPT_0x49
;     799 						break;
	RJMP _0x71
;     800 					}
;     801 				}
_0x72:
	CALL SUBOPT_0x4A
	RJMP _0x70
_0x71:
;     802 				if(atof(msg) >= 150 || atof(msg) <= 100) 
	CALL SUBOPT_0x4B
	__GETD1N 0x43160000
	CALL __CMPF12
	BRSH _0x76
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x2E
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x76
	RJMP _0x75
_0x76:
;     803 				{
;     804 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     805 					break;
;     806 				}
;     807 				else 
_0x75:
;     808 				{
;     809 					PSPadc_gain = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMWRD
;     810 					printf("\n\rPSP Amplifier Gain is now set to %.2f\n\r", PSPadc_gain); 
	__POINTW1FN _0,2380
	CALL SUBOPT_0x41
	CALL SUBOPT_0x44
;     811 				}
;     812 				break;
	RJMP _0x44
;     813 			case 'o' :
_0x6E:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x79
;     814 				printf("Change PSP Amplifier Offset Value\n\r");
	__POINTW1FN _0,2422
	CALL SUBOPT_0x31
;     815 				printf("Current PSP Amplifier Offset Value: %.2f\n\r", PSPadc_offset);
	__POINTW1FN _0,2458
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x44
;     816 				printf("Enter New PSP Amplifier Offset Value: ");
	__POINTW1FN _0,2501
	CALL SUBOPT_0x31
;     817 				for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x7B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x7C
;     818 				{
;     819 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     820 					printf("%c", msg[i]);
;     821 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x7E
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x7D
_0x7E:
;     822 					{
;     823 						i--;
	CALL SUBOPT_0x49
;     824 						break;
	RJMP _0x7C
;     825 					}
;     826 				}                        
_0x7D:
	CALL SUBOPT_0x4A
	RJMP _0x7B
_0x7C:
;     827 				if(atof(msg) > 50 || atof(msg) < -50)
	CALL SUBOPT_0x4B
	__GETD1N 0x42480000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x81
	CALL SUBOPT_0x4B
	__GETD1N 0xC2480000
	CALL __CMPF12
	BRSH _0x80
_0x81:
;     828 				{
;     829 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     830 					break;
;     831 				}
;     832 				else 
_0x80:
;     833 				{
;     834 					PSPadc_offset = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMWRD
;     835 					printf("\n\rPSP Amplifier Offset is now set to %.2f\n\r", PSPadc_offset); 
	__POINTW1FN _0,2540
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x19
	CALL SUBOPT_0x44
;     836 				}
;     837 				break;
	RJMP _0x44
;     838 			case 'G' :
_0x79:
	CPI  R30,LOW(0x47)
	LDI  R26,HIGH(0x47)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x84
;     839 				printf("Change PIR Amplifier Gain Value\n\r");
	__POINTW1FN _0,2584
	CALL SUBOPT_0x31
;     840 				printf("Current PIR Amplifier Gain Value: %.2f\n\r", PIRadc_gain);
	__POINTW1FN _0,2618
	CALL SUBOPT_0x40
	CALL SUBOPT_0x44
;     841 				printf("Enter New PIR Amplifier Gain Value: ");
	__POINTW1FN _0,2659
	CALL SUBOPT_0x31
;     842 				for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x86:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x87
;     843 				{
;     844 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     845 					printf("%c", msg[i]);
;     846 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x89
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x88
_0x89:
;     847 					{
;     848 						i--;
	CALL SUBOPT_0x49
;     849 						break;
	RJMP _0x87
;     850 					}
;     851 				}                        
_0x88:
	CALL SUBOPT_0x4A
	RJMP _0x86
_0x87:
;     852 				if(atof(msg) > 900 || atof(msg) < 800 )
	CALL SUBOPT_0x4B
	__GETD1N 0x44610000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x8C
	CALL SUBOPT_0x4B
	__GETD1N 0x44480000
	CALL __CMPF12
	BRSH _0x8B
_0x8C:
;     853 				{
;     854 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     855 					break;
;     856 				}
;     857 				else 
_0x8B:
;     858 				{
;     859 					PIRadc_gain = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMWRD
;     860 					printf("\n\rPIR Amplifier Gain is now set to %.2f\n\r", PIRadc_gain); 
	__POINTW1FN _0,2696
	CALL SUBOPT_0x40
	CALL SUBOPT_0x44
;     861 				}
;     862 				break;
	RJMP _0x44
;     863 			case 'O' :
_0x84:
	CPI  R30,LOW(0x4F)
	LDI  R26,HIGH(0x4F)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x8F
;     864 				printf("Change PIR Amplifier Offset Value\n\r");
	__POINTW1FN _0,2738
	CALL SUBOPT_0x31
;     865 				printf("Current PIR Amplifier Offset Value: %.2f\n\r", PIRadc_offset);
	__POINTW1FN _0,2774
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x44
;     866 				printf("Enter New PIR Amplifier Offset Value: ");
	__POINTW1FN _0,2817
	CALL SUBOPT_0x31
;     867 				for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x91:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x92
;     868 				{
;     869 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     870 					printf("%c", msg[i]);
;     871 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x94
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x93
_0x94:
;     872 					{
;     873 						i--;
	CALL SUBOPT_0x49
;     874 						break;
	RJMP _0x92
;     875 					}
;     876 				}                        
_0x93:
	CALL SUBOPT_0x4A
	RJMP _0x91
_0x92:
;     877 				if(atof(msg) > 25 || atof(msg) < -25)
	CALL SUBOPT_0x4B
	__GETD1N 0x41C80000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0x97
	CALL SUBOPT_0x4B
	__GETD1N 0xC1C80000
	CALL __CMPF12
	BRSH _0x96
_0x97:
;     878 				{
;     879 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     880 					break;
;     881 				}
;     882 				else 
_0x96:
;     883 				{
;     884 					PIRadc_offset = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMWRD
;     885 					printf("\n\rPIR Amplifier Offset is now set to %.2f\n\r", PIRadc_offset); 
	__POINTW1FN _0,2856
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x12
	CALL SUBOPT_0x44
;     886 				}
;     887 				break;
	RJMP _0x44
;     888 			case 'I' :
_0x8F:
	CPI  R30,LOW(0x49)
	LDI  R26,HIGH(0x49)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x9A
;     889 				printf("Change PIR Coefficient\n\r");
	__POINTW1FN _0,2900
	CALL SUBOPT_0x31
;     890 				printf("Current PIR Coefficient is: %E\n\r", pir);
	__POINTW1FN _0,2925
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x44
;     891 				printf("Enter New PIR Coefficient: ");
	__POINTW1FN _0,2958
	CALL SUBOPT_0x31
;     892 			    for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x9C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0x9D
;     893 				{
;     894 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     895 					printf("%c", msg[i]);
;     896 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0x9F
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0x9E
_0x9F:
;     897 					{
;     898 						i--;
	CALL SUBOPT_0x49
;     899 						break;
	RJMP _0x9D
;     900 					}
;     901 				}                        
_0x9E:
	CALL SUBOPT_0x4A
	RJMP _0x9C
_0x9D:
;     902 				if(atof(msg) >=10.0E-6 || atof(msg) <= 0.1E-6)
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4D
	BRSH _0xA2
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4E
	BREQ PC+2
	BRCC PC+3
	JMP  _0xA2
	RJMP _0xA1
_0xA2:
;     903 				{
;     904 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     905 					break;
;     906 				}
;     907 				else 
_0xA1:
;     908 				{
;     909 					pir = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMWRD
;     910 					printf("\n\rPIR Coefficient is now set to %E\n\r", pir); 
	__POINTW1FN _0,2986
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x44
;     911 				}
;     912 				break;
	RJMP _0x44
;     913 		 	case 'C' :
_0x9A:
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xA5
;     914 				printf("Change Case Reference Resistor (R9)\n\r");
	__POINTW1FN _0,3023
	CALL SUBOPT_0x31
;     915 				printf("Current Case Reference Resistor is: %.1f\n\r", RrefC);
	__POINTW1FN _0,3061
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x44
;     916 				printf("Enter New Case Reference Resistance: ");
	__POINTW1FN _0,3104
	CALL SUBOPT_0x31
;     917 			    for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xA7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0xA8
;     918 				{
;     919 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     920 					printf("%c", msg[i]);
;     921 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0xAA
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0xA9
_0xAA:
;     922 					{
;     923 						i--;
	CALL SUBOPT_0x49
;     924 						break;
	RJMP _0xA8
;     925 					}
;     926 				}
_0xA9:
	CALL SUBOPT_0x4A
	RJMP _0xA7
_0xA8:
;     927 				if( atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4F
	BREQ PC+4
	BRCS PC+3
	JMP  _0xAD
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x50
	BRSH _0xAC
_0xAD:
;     928 				{
;     929 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     930 					break;
;     931 				}
;     932 				else 
_0xAC:
;     933 				{
;     934 					RrefC = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMWRD
;     935 					printf("\n\rCase Reference Resistor is now set to %.1f\n\r", RrefC); 
	__POINTW1FN _0,3142
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x8
	CALL SUBOPT_0x44
;     936 				}
;     937 				break;
	RJMP _0x44
;     938 			case 'D' :
_0xA5:
	CPI  R30,LOW(0x44)
	LDI  R26,HIGH(0x44)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xB0
;     939 				printf("Change Dome Reference Resistor (R10)\n\r");
	__POINTW1FN _0,3189
	CALL SUBOPT_0x31
;     940 				printf("Current Dome Reference Resistor is: %.1f\n\r", RrefD);
	__POINTW1FN _0,3228
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x44
;     941 				printf("Enter New Dome Reference Resistance: ");
	__POINTW1FN _0,3271
	CALL SUBOPT_0x31
;     942 			    for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xB2:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0xB3
;     943 				{
;     944 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     945 					printf("%c", msg[i]);
;     946 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0xB5
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0xB4
_0xB5:
;     947 					{
;     948 						i--;
	CALL SUBOPT_0x49
;     949 						break;
	RJMP _0xB3
;     950 					}
;     951 				}                        
_0xB4:
	CALL SUBOPT_0x4A
	RJMP _0xB2
_0xB3:
;     952 				if(atof(msg) > 40000 || atof(msg) < 5000)
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4F
	BREQ PC+4
	BRCS PC+3
	JMP  _0xB8
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x50
	BRSH _0xB7
_0xB8:
;     953 				{
;     954 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     955 					break;
;     956 				}
;     957 				else 
_0xB7:
;     958 				{
;     959 					RrefD = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMWRD
;     960 					printf("\n\rDome Reference Resistor is now set to %.1f\n\r", RrefD); 
	__POINTW1FN _0,3309
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL SUBOPT_0x44
;     961 				}
;     962 				break;
	RJMP _0x44
;     963 			case 'V' :
_0xB0:
	CPI  R30,LOW(0x56)
	LDI  R26,HIGH(0x56)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xBB
;     964 				printf("Change Thermistor Reference Voltage\n\r");
	__POINTW1FN _0,3356
	CALL SUBOPT_0x31
;     965 				printf("Current Thermistor Reference Voltage is: %.4f\n\r", Vtherm);
	__POINTW1FN _0,3394
	CALL SUBOPT_0x51
;     966 				printf("Enter New Thermistor Reference Voltage: ");
	__POINTW1FN _0,3442
	CALL SUBOPT_0x31
;     967 			    for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xBD:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0xBE
;     968 				{
;     969 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     970 					printf("%c", msg[i]);
;     971 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0xC0
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0xBF
_0xC0:
;     972 					{
;     973 						i--;
	CALL SUBOPT_0x49
;     974 						break;
	RJMP _0xBE
;     975 					}
;     976 				}                        
_0xBF:
	CALL SUBOPT_0x4A
	RJMP _0xBD
_0xBE:
;     977 				if(atof(msg) > 4.5 || atof(msg) < 4.0)
	CALL SUBOPT_0x4B
	__GETD1N 0x40900000
	CALL __CMPF12
	BREQ PC+4
	BRCS PC+3
	JMP  _0xC3
	CALL SUBOPT_0x4B
	__GETD1N 0x40800000
	CALL __CMPF12
	BRSH _0xC2
_0xC3:
;     978 				{
;     979 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;     980 					break;
;     981 				}
;     982 				else 
_0xC2:
;     983 				{
;     984 					Vtherm = atof(msg);
	CALL SUBOPT_0x4C
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMWRD
;     985 					Vadc = Vtherm;
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMWRD
;     986 					printf("\n\rThermistor Reference Voltage is now set to %.4f\n\r", Vtherm); 
	__POINTW1FN _0,3483
	CALL SUBOPT_0x51
;     987 				}
;     988 				break;
	RJMP _0x44
;     989 				case 'A' :
_0xBB:
	CPI  R30,LOW(0x41)
	LDI  R26,HIGH(0x41)
	CPC  R31,R26
	BREQ PC+3
	JMP _0xC6
;     990 				printf("Change Identifier Address\n\r");
	__POINTW1FN _0,3535
	CALL SUBOPT_0x31
;     991 				printf("Current Identifier Address: $RAD%02d\n\r", Id_address);
	__POINTW1FN _0,3563
	CALL SUBOPT_0x24
	CALL SUBOPT_0x44
;     992 				printf("Enter New Identifier Address (0-99): ");
	__POINTW1FN _0,3602
	CALL SUBOPT_0x31
;     993 			    for (i=0; i<20; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0xC8:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,20
	BRGE _0xC9
;     994 				{
;     995 					msg[i] = getchar();
	CALL SUBOPT_0x45
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	CALL SUBOPT_0x46
;     996 					printf("%c", msg[i]);
;     997 					if (msg[i] == '\n' || msg[i] == '\r')
	CALL SUBOPT_0x45
	CALL SUBOPT_0x47
	BREQ _0xCB
	CALL SUBOPT_0x45
	CALL SUBOPT_0x48
	BRNE _0xCA
_0xCB:
;     998 					{
;     999 						i--;
	CALL SUBOPT_0x49
;    1000 						break;
	RJMP _0xC9
;    1001 					}
;    1002 				}                        
_0xCA:
	CALL SUBOPT_0x4A
	RJMP _0xC8
_0xC9:
;    1003 				if(atoi(msg) > 99 || atoi(msg) < 00)
	CALL SUBOPT_0x52
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRGE _0xCE
	CALL SUBOPT_0x52
	MOVW R26,R30
	SBIW R26,0
	BRGE _0xCD
_0xCE:
;    1004 				{
;    1005 					printf("Out of Range\n\r");
	__POINTW1FN _0,2214
	RJMP _0x21F
;    1006 					break;
;    1007 				}
;    1008 				else
_0xCD:
;    1009 				{
;    1010 					Id_address = atoi(msg);
	CALL SUBOPT_0x52
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMWRW
;    1011 					printf("\n\rIdentifier String now set to: $RAD%02d\n\r", Id_address); 
	__POINTW1FN _0,3640
	CALL SUBOPT_0x24
	CALL SUBOPT_0x44
;    1012 				}
;    1013 				break;	                                         
	RJMP _0x44
;    1014 			case 'X' :
_0xC6:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BREQ _0xD2
;    1015 			case 'x' :
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0xD3
_0xD2:
;    1016 				printf("\n\r Returning to operation...\n\r\n\r");
	RJMP _0x220
;    1017 				break;
;    1018 			case 'S' :
_0xD3:
	CPI  R30,LOW(0x53)
	LDI  R26,HIGH(0x53)
	CPC  R31,R26
	BRNE _0xD4
;    1019 				SampleADC();
	RCALL _SampleADC
;    1020 				break;
	RJMP _0x44
;    1021 			case 'Z' :
_0xD4:
	CPI  R30,LOW(0x5A)
	LDI  R26,HIGH(0x5A)
	CPC  R31,R26
	BREQ _0xD6
;    1022 			case 'z' :
	CPI  R30,LOW(0x7A)
	LDI  R26,HIGH(0x7A)
	CPC  R31,R26
	BRNE _0xD8
_0xD6:
;    1023 			        printf("\n\r***** SMART DIGITAL INTERFACE *****\n\r");
	CALL SUBOPT_0x0
;    1024 			        printf(" Software Version 1.11, 2006/10/08\n\r");
;    1025 			        printf(" Current EEPROM values:\n\r");
;    1026     	            printf(" Identifier Header= $RAD%02d\n\r", Id_address);
;    1027     	            printf(" PSP Coeff= %.2E\n\r", psp);
;    1028     	            printf(" PIR Coeff= %.2E\n\r", pir);
;    1029     	            printf(" Interval Time (secs)= %d\n\r", looptime);
	CALL SUBOPT_0x1
;    1030     	            printf(" Cmax= %d\n\r", Cmax);
;    1031     	            printf(" Reference Resistor Case= %.1f\n\r", RrefC);
;    1032     	            printf(" Reference Resistor Dome= %.1f\n\r", RrefD);
;    1033     	            printf(" Vtherm= %.4f, Vadc= %.4f\n\r", Vtherm, Vadc);
;    1034     	            printf(" PIR ADC Offset= %.2f\n\r", PIRadc_offset);
	CALL SUBOPT_0x2
;    1035     	            printf(" PIR ADC Gain= %.2f\n\r", PIRadc_gain);
;    1036     	            printf(" PSP ADC Offset= %.2f\n\r", PSPadc_offset);
;    1037     	            printf(" PSP ADC Gain= %.2f\n\r", PSPadc_gain);
;    1038 		                printf("\n\r");
	__POINTW1FN _0,37
	RJMP _0x21F
;    1039 		                break;
;    1040 				
;    1041 			default : printf("Invalid key\n\r");
_0xD8:
	__POINTW1FN _0,3716
	CALL SUBOPT_0x31
;    1042 			          printf("\n\r Returning to operation...\n\r\n\r");
_0x220:
	__POINTW1FN _0,3683
_0x21F:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
;    1043 				        break;                             
;    1044 			
;    1045 			} // end switch
_0x44:
;    1046 	
;    1047 }
	CALL __LOADLOCR6
	ADIW R28,20
	RET
;    1048  
;    1049 void SampleADC(void)
;    1050 /********************************************************
;    1051 Test the ADC circuit
;    1052 **********************************************************/
;    1053 {
_SampleADC:
;    1054 	double ddum[8], ddumsq[8];
;    1055 	int i, npts;          
;    1056 	int missing;
;    1057 	
;    1058 	missing = -999;
	SBIW R28,63
	SBIW R28,1
	CALL __SAVELOCR6
;	ddum -> Y+38
;	ddumsq -> Y+6
;	i -> R16,R17
;	npts -> R18,R19
;	missing -> R20,R21
	__GETWRN 20,21,64537
;    1059 
;    1060 	ddum[0]=ddum[1]=ddum[2]=ddum[3]=ddum[4]=ddum[5]=ddum[6]=ddum[7]=0;
	CALL SUBOPT_0x53
	__PUTD1SX 66
	__PUTD1SX 62
	__PUTD1S 58
	__PUTD1S 54
	__PUTD1S 50
	__PUTD1S 46
	__PUTD1S 42
	__PUTD1S 38
;    1061 	ddumsq[0]=ddumsq[1]=ddumsq[2]=ddumsq[3]=ddumsq[4]=ddumsq[5]=ddumsq[6]=ddumsq[7]=0;
	CALL SUBOPT_0x53
	__PUTD1S 34
	__PUTD1S 30
	__PUTD1S 26
	__PUTD1S 22
	__PUTD1S 18
	__PUTD1S 14
	__PUTD1S 10
	CALL SUBOPT_0x54
;    1062 	npts=0;
	__GETWRN 18,19,0
;    1063 	printf("\n\r");
	CALL SUBOPT_0x32
;    1064 	while( !SerByteAvail() )
_0xD9:
	CALL _SerByteAvail
	SBIW R30,0
	BREQ PC+3
	JMP _0xDB
;    1065 	{
;    1066 		ReadAnalog(ALL);
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ReadAnalog
;    1067 		printf("%7d %7d %7d %7d %7d %7d %7d %7d\n\r",
;    1068 		adc[0],adc[1],adc[2],adc[3],
;    1069 		adc[4],adc[5],adc[6],adc[7]);
	__POINTW1FN _0,3730
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc
	LDS  R31,_adc+1
	CALL SUBOPT_0x27
	__GETW1MN _adc,2
	CALL SUBOPT_0x27
	__GETW1MN _adc,4
	CALL SUBOPT_0x27
	__GETW1MN _adc,6
	CALL SUBOPT_0x27
	__GETW1MN _adc,8
	CALL SUBOPT_0x27
	__GETW1MN _adc,10
	CALL SUBOPT_0x27
	__GETW1MN _adc,12
	CALL SUBOPT_0x27
	__GETW1MN _adc,14
	CALL SUBOPT_0x27
	CALL SUBOPT_0x55
;    1070 		for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xDD:
	__CPWRN 16,17,8
	BRLT PC+3
	JMP _0xDE
;    1071 		{
;    1072 			ddum[i] += (double)adc[i];
	CALL SUBOPT_0x56
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x57
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	POP  R26
	POP  R27
	CALL __PUTDP1
;    1073 			ddumsq[i] += (double)adc[i] * (double)adc[i];
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	CALL SUBOPT_0x58
	PUSH R31
	PUSH R30
	MOVW R26,R30
	CALL __GETD1P
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x57
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x57
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
;    1074 		}
	__ADDWRN 16,17,1
	RJMP _0xDD
_0xDE:
;    1075 		npts++;
	__ADDWRN 18,19,1
;    1076 		delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
;    1077 	}
	RJMP _0xD9
_0xDB:
;    1078 	printf("\n\r");
	CALL SUBOPT_0x32
;    1079 	for(i=0; i<8; i++)
	__GETWRN 16,17,0
_0xE0:
	__CPWRN 16,17,8
	BRGE _0xE1
;    1080 		MeanStdev((ddum+i), (ddumsq+i), npts, missing);
	CALL SUBOPT_0x56
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x58
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x6
	RCALL _MeanStdev
;    1081 
;    1082 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r",
	__ADDWRN 16,17,1
	RJMP _0xE0
_0xE1:
;    1083 		ddum[0],ddum[1],ddum[2],ddum[3],
;    1084 		ddum[4],ddum[5],ddum[6],ddum[7]);
	__POINTW1FN _0,3764
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x59
	__GETD1SX 72
	CALL __PUTPARD1
	__GETD1SX 80
	CALL __PUTPARD1
	__GETD1SX 88
	CALL __PUTPARD1
	__GETD1SX 96
	CALL __PUTPARD1
	CALL SUBOPT_0x55
;    1085 	printf("%7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f %7.2f\n\r\n\r",
;    1086 		ddumsq[0],ddumsq[1],ddumsq[2],ddumsq[3],
;    1087 		ddumsq[4],ddumsq[5],ddumsq[6],ddumsq[7]);
	__POINTW1FN _0,3814
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5A
	CALL __PUTPARD1
	CALL SUBOPT_0x15
	CALL __PUTPARD1
	__GETD1S 24
	CALL __PUTPARD1
	__GETD1S 32
	CALL __PUTPARD1
	CALL SUBOPT_0x59
	CALL SUBOPT_0x55
;    1088 	return;
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,7
	RET
;    1089 }
;    1090 
;    1091 void	MeanStdev(double *sum, double *sum2, int N, double missing)
;    1092 /********************************************
;    1093 Compute mean and standard deviation from the count, the sum and the sum of squares.
;    1094 991101
;    1095 Note that the mean and standard deviation are computed from the sum and the sum of 
;    1096 squared values and are returned in the same memory location.
;    1097 *********************************************/
;    1098 {
_MeanStdev:
;    1099 	if( N <= 2 )
;	*sum -> Y+8
;	*sum2 -> Y+6
;	N -> Y+4
;	missing -> Y+0
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,3
	BRGE _0xE2
;    1100 	{
;    1101 		*sum = missing;
	CALL SUBOPT_0x5B
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL SUBOPT_0x5C
;    1102 		*sum2 = missing;
	RJMP _0x221
;    1103 	}
;    1104 	else
_0xE2:
;    1105 	{
;    1106 		*sum /= (double)N;		// mean value
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	PUSH R27
	PUSH R26
	CALL SUBOPT_0x5D
	POP  R26
	POP  R27
	CALL SUBOPT_0x5E
;    1107 		*sum2 = *sum2/(double)N - (*sum * *sum); // sumsq/N - mean^2
	CALL SUBOPT_0x5D
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5F
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x5F
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x35
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x5E
;    1108 		*sum2 = *sum2 * (double)N / (double)(N-1); // (N/N-1) correction
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x60
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,1
	CALL SUBOPT_0x20
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x5E
;    1109 		if( *sum2 < 0 ) *sum2 = 0;
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRGE _0xE4
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x53
	RJMP _0x222
;    1110 		else *sum2 = sqrt(*sum2);
_0xE4:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETD1P
	CALL __PUTPARD1
	CALL _sqrt
_0x221:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
_0x222:
	CALL __PUTDP1
;    1111 	}
;    1112 	return;
	RJMP _0x219
;    1113 }
;    1114 void ReadAnalog( int chan )
;    1115 /************************************************************
;    1116 Read 12 bit analog A/D Converter Max186
;    1117 ************************************************************/
;    1118 {
_ReadAnalog:
;    1119 	int i;
;    1120 	if( chan == ALL )
	ST   -Y,R17
	ST   -Y,R16
;	chan -> Y+2
;	i -> R16,R17
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,8
	BRNE _0xE6
;    1121 	{
;    1122 		for(i=0;i<8;i++)
	__GETWRN 16,17,0
_0xE8:
	__CPWRN 16,17,8
	BRGE _0xE9
;    1123 		{	
;    1124 			adc[i] = Read_Max186(i, 0);
	MOVW R30,R16
	CALL SUBOPT_0x61
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
;    1125 		   //	printf("adc[i] = %d, isamp = %d, i = %d\n\r", adc[i], i);
;    1126 		}
	__ADDWRN 16,17,1
	RJMP _0xE8
_0xE9:
;    1127 	}
;    1128 	else if( chan >= 0 && chan <=7 )
	RJMP _0xEA
_0xE6:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	SBIW R26,0
	BRLT _0xEC
	CPI  R26,LOW(0x8)
	LDI  R30,HIGH(0x8)
	CPC  R27,R30
	BRLT _0xED
_0xEC:
	RJMP _0xEB
_0xED:
;    1129 	{
;    1130 		adc[chan] = Read_Max186(chan, 0);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x61
	PUSH R31
	PUSH R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x5
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
;    1131 	}
;    1132     return;
_0xEB:
_0xEA:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
;    1133 }
;    1134 #include "PIR.h"
;    1135 
;    1136 /*******************************************************************************************/
;    1137 
;    1138 void PirTcTd2LW(double vp, double kp, double PIRadc_offset, double PIRadc_gain, double tc, double td, double k, 
;    1139 	double *lw, double *C_c, double *C_d)
;    1140 /**********************************************************
;    1141 %input
;    1142 %  vp = thermopile voltage
;    1143 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1144 %  gainPIR[2] is the offset and gain for the preamp circuit
;    1145 %     The thermopile net radiance is given by vp/kp, but
;    1146 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;    1147 %     where vp' is the actual voltage on the thermopile.
;    1148 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1149 %  e = thermopile computed flux in W/m^2 
;    1150 %  tc = case degC 
;    1151 %  td = dome degC 
;    1152 %  k = calib coef, usually = 4.
;    1153 %  no arguments ==> test mode
;    1154 %output
;    1155 %  lw = corrected longwave flux, W/m^2
;    1156 %  C_c C_d = corrections for case and dome, w/m^2 // Matlab rmrtools edits
;    1157 %000928 changes eps to 0.98 per {fairall98}
;    1158 %010323 back to 1.0 per Fairall
;    1159 /**********************************************************/
;    1160 {
_PirTcTd2LW:
;    1161 	double Tc,Td;
;    1162 	double sigma=5.67e-8;
;    1163 	double eps = 1;
;    1164 	double x,y;
;    1165 	double e; // w/m^2 on the thermopile
;    1166 	
;    1167     	// THERMOPILE IRRADIANCE
;    1168 		e = ( ( (( vp - PIRadc_offset ) / PIRadc_gain) /1000) / kp ) ;
	SBIW R28,28
	LDI  R24,8
	LDI  R26,LOW(12)
	LDI  R27,HIGH(12)
	LDI  R30,LOW(_0xEE*2)
	LDI  R31,HIGH(_0xEE*2)
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
	CALL SUBOPT_0x62
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 54
	CALL SUBOPT_0x63
;    1169 		//printf("PirTcTd2LW: e = %.4e\r\n", e);
;    1170 	
;    1171 	// THE CORRECTION IS BASED ON THE TEMPERATURES ONLY
;    1172 	Tc = tc + Tabs;
	CALL SUBOPT_0x64
	__GETD2S 42
	CALL SUBOPT_0xF
;    1173 	Td = td + Tabs;
	CALL SUBOPT_0x64
	__GETD2S 38
	CALL __ADDF12
	__PUTD1S 20
;    1174 	x = Tc * Tc * Tc * Tc; // Tc^4
	__GETD1S 24
	CALL SUBOPT_0x65
	CALL SUBOPT_0x65
	CALL SUBOPT_0x65
	CALL SUBOPT_0x66
;    1175 	y = Td * Td * Td * Td; // Td^4
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x67
	CALL SUBOPT_0x67
	CALL SUBOPT_0x67
	CALL SUBOPT_0x16
;    1176 	
;    1177 	// Corrections
;    1178 	*C_c = eps * sigma * x;
	CALL SUBOPT_0x15
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	CALL __MULF12
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __PUTDP1
;    1179 	*C_d =  - k * sigma * (y - x);
	__GETD1S 34
	CALL __ANEGF1
	__GETD2S 16
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x2C
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __MULF12
	LDD  R26,Y+28
	LDD  R27,Y+28+1
	CALL __PUTDP1
;    1180 	
;    1181 	// Final computation
;    1182 	*lw = e + *C_c + *C_d;
	LDD  R26,Y+30
	LDD  R27,Y+30+1
	CALL __GETD1P
	CALL SUBOPT_0x1C
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
;    1183 
;    1184 	return;
	ADIW R28,62
	RET
;    1185 }
;    1186 double SteinhartHart(double C[], double R) 
;    1187 /*************************************************************/
;    1188 // Uses the Steinhart-Hart equations to compute the temperature 
;    1189 // in degC from thermistor resistance.  
;    1190 // See http://www.betatherm.com/stein.htm
;    1191 //The Steinhart-Hart thermistor equation is named for two oceanographers 
;    1192 //associated with Woods Hole Oceanographic Institute on Cape Cod, Massachusetts. 
;    1193 //The first publication of the equation was by I.S. Steinhart & S.R. Hart 
;    1194 //in "Deep Sea Research" vol. 15 p. 497 (1968).
;    1195 //S-S coeficients are
;    1196 // either computed from calibrations or tests, or are provided by 
;    1197 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1198 // the S-S coefficients.
;    1199 //
;    1200 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1201 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1202 //  Tc = Tk - 273.15;
;    1203 //example
;    1204 // C = 1.0271173e-3,  2.3947051e-4,  1.5532990e-7  
;    1205 // ysi46041, donlon // C = 1.025579e-03,  2.397338e-04,  1.542038e-07  
;    1206 // ysi46041, matlab steinharthart_fit()
;    1207 // R = 25000;     Tc = 25.00C
;    1208 // rmr 050128
;    1209 /*************************************************************/
;    1210 {
_SteinhartHart:
;    1211 	double x;
;    1212 //	double Tabs = 273.15;  // defined elsewhere
;    1213 
;    1214 	//printf( "SteinhartHart: %.5e, %.5e, %.5e\r\n",C[0], C[1], C[2]);
;    1215 	
;    1216 	x = log(R);
	SBIW R28,4
;	*C -> Y+8
;	R -> Y+4
;	x -> Y+0
	CALL SUBOPT_0x2C
	CALL __PUTPARD1
	CALL _log
	CALL SUBOPT_0x21
;    1217 	x = C[0] + x * ( C[1] + C[2] * x * x );
	CALL SUBOPT_0x5F
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
	CALL SUBOPT_0x5B
	CALL __MULF12
	CALL SUBOPT_0x68
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	CALL SUBOPT_0x68
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x1D
;    1218 	x = 1/x - Tabs;
	CALL SUBOPT_0x5B
	CALL SUBOPT_0x3D
	LDS  R26,_Tabs
	LDS  R27,_Tabs+1
	LDS  R24,_Tabs+2
	LDS  R25,_Tabs+3
	CALL __SUBF12
	CALL SUBOPT_0x21
;    1219 	
;    1220 	//printf("SteinhartHart: R = %.2f,      Tc = %.4f\r\n",R,x);
;    1221 	return x;
	CALL SUBOPT_0x5B
_0x219:
	ADIW R28,10
	RET
;    1222 }
;    1223 
;    1224 
;    1225 
;    1226 double ysi46041(double r, double *c)
;    1227 /************************************************************
;    1228 	Description: Best fit of Steinhart Hart equation to YSI
;    1229 	tabulated data from -10C to 60C for H mix 10k thermistors.
;    1230 	Given the thermistor temperature in Kelvin.
;    1231 
;    1232 	The lack of precision in the YSI data is evident around
;    1233 	9999/10000 Ohm transition.  Scatter approaches 10mK before,
;    1234 	much less after.  Probably some systemmatics at the 5mK level
;    1235 	as a result.  Another decimal place in the impedances would 
;    1236 	have come in very handy.  The YSI-derived coefficients read
;    1237 	10mK cold or some through the same interval.
;    1238 
;    1239 	Mandatory parameters:
;    1240 	R - Thermistor resistance(s) in Ohms
;    1241 	C - Coefficients of fit from isarconf.icf file specific
;    1242 	to each thermistor.
;    1243 ************************************************************/
;    1244 { 
;    1245 double t1, LnR;
;    1246 	if(r>0)
;	r -> Y+10
;	*c -> Y+8
;	t1 -> Y+4
;	LnR -> Y+0
;    1247 	{
;    1248 		LnR = log(r);
;    1249 		t1 = 1 / (c[0] + LnR * (c[1] + LnR*LnR * c[2]) );
;    1250 	}
;    1251 	else t1 = 0;
;    1252 	
;    1253 	return t1;
;    1254 }
;    1255 
;    1256 double ysi46041CountToRes(double c)
;    1257 /**************************************************************
;    1258 	Description: Converts raw counts to resistance for the 
;    1259 	YSI46041 10K thermistors.
;    1260 **************************************************************/
;    1261 {
;    1262 	double  r=0;
;    1263 		
;    1264 		r = 10000.0 * c / (5.0 - c);
;	c -> Y+4
;	r -> Y+0
;    1265 		
;    1266 		return r;
;    1267 }
;    1268 double ysi46000(double Rt, double Pt)
;    1269 /*************************************************************/
;    1270 // Uses the Steinhart-Hart equations to compute the temperature 
;    1271 // in degC from thermistor resistance.  S-S coeficients are 
;    1272 // either computed from calibrations or tests, or are provided by 
;    1273 // the manufacturer.  Reynolds has Matlab routines for computing 
;    1274 // the S-S coefficients.
;    1275 //                                                               
;    1276 //	xr = ln(Rt);   where Rt is the thermistor resistance in ohms.
;    1277 //	1/Tk = C(0) + C(1) * xr + C(2) * xr * xr * xr;
;    1278 //  Tc = Tk - 273.15;
;    1279 //
;    1280 // correction for self heating.
;    1281 // For no correction set P_t = 0;
;    1282 // deltaT = p(watts) / .004 (W/degC)
;    1283 //
;    1284 //rmr 050128
;    1285 /*************************************************************/
;    1286 {
_ysi46000:
;    1287 	double x;
;    1288 	double C[3] = {1.025579e-03,  2.397338e-04,  1.542038e-07};  
;    1289 	// ysi46041, matlab steinharthart_fit(), 0--40 degC
;    1290 	x = SteinhartHart(C, Rt);
	SBIW R28,16
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0xF2*2)
	LDI  R31,HIGH(_0xF2*2)
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
	CALL SUBOPT_0x36
;    1291 	//printf("ysi46000: R_t = %.2f,  P_t = %.4e\r\n",Rt, Pt);
;    1292 	//printf("ysi46000: Cal temp = %.5f\r\n",x);
;    1293 	
;    1294 	x = x - Pt/.004; // return temperature in degC
	__GETD2S 16
	__GETD1N 0x3B83126F
	CALL __DIVF21
	CALL SUBOPT_0x69
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
;    1295 	//printf("Temp correction = %.3e,  final temp = %.5f\r\n", Pt/.004, x);
;    1296 	return x;
	CALL SUBOPT_0x37
	ADIW R28,24
	RET
;    1297 
;    1298 } 
;    1299 void therm_circuit_ground(double c, double C_max, double R_ref, double V_therm, double V_adc,
;    1300 	double *v_t, double *R_t, double *P_t)
;    1301 /*************************************************************/
;    1302 //Compute the thermistor resistance for a resistor divider circuit //with reference voltage (V_therm), reference resistor (R_ref), //thermistor is connected to GROUND.  The ADC compares a reference //voltage (V_adc) with the thermistor voltage (v_t) and gives an adc //count (c).  The ADC here is unipolar and referenced to ground.
;    1303 //The ADC range is 0--C_max and is linear with input voltage 0--V_adc.
;    1304 //Input:
;    1305 //  c = ADC count.
;    1306 //  C_max = maximum count, typically 4096.
;    1307 //  R_ref = reference resistor (ohms)
;    1308 //  V_therm = thermistor circuit reference voltage 
;    1309 //  V_adc = ADC reference voltage.
;    1310 //Output:
;    1311 //  v_t = thermistor voltage (volts)
;    1312 //  R_t = thermistor resistance (ohms)
;    1313 //  P_t = power dissipated by the thermistor (watts)
;    1314 //	(for self heating correction)
;    1315 //example
;    1316 //	double cx, Cmax, Rref, Vtherm, Vadc;
;    1317 //	double vt, Rt, Pt;
;    1318 //	cx = 2036;  Cmax = 4095; Rref = 10021; Vtherm = 5.0123;  Vadc = 4.087;
;    1319 //	ysi46006_circuit(c, Cmax, Rref, Vtherm, Vadc, &vt, &Rt, &Pt);
;    1320 // vt= 2.0320 volts,  Rt = 6832.48 ohms,  Pt = 6.04323e-4 Watts 
;    1321 /*************************************************************/
;    1322 {
_therm_circuit_ground:
;    1323 	double x;
;    1324 	
;    1325 	//printf("therm_circuit_ground: c = %.1f,              C_max = %.1f,\r\n",c, C_max);
;    1326 	//printf("therm_circuit_ground: V_therm = %.3f         V_adc = %.3f\r\n", V_therm, V_adc);
;    1327 	//printf("therm_circuit_ground: R_ref = %.1f\r\n", R_ref);
;    1328 	
;    1329 	*v_t = V_adc * (c/2) / C_max;
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
;    1330 	x = (V_therm - *v_t) / R_ref;  // circuit current, I
	CALL SUBOPT_0x5F
	__GETD2S 14
	CALL SUBOPT_0x35
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 18
	CALL SUBOPT_0x63
;    1331 	*R_t = *v_t / x;  // v/I
	CALL SUBOPT_0x5F
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x5B
	CALL __DIVF21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x5C
;    1332 	*P_t = x * x * *R_t;  // I^2 R = power
	CALL SUBOPT_0x68
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
;    1333 	
;    1334 	//printf("therm_circuit_ground: v_t = %.4f,       R_t = %.2f,          P_t = %.4e\r\n", *v_t, *R_t, *P_t);
;    1335 
;    1336 	return;
	ADIW R28,30
	RET
;    1337 }
;    1338 
;    1339 
;    1340 
;    1341 #include "PSP.h"
;    1342 
;    1343 /*******************************************************************************************/
;    1344 
;    1345 float PSPSW(double vp, double kp, double PSPadc_offset, double PSPadc_gain, double *sw)
;    1346 /**********************************************************
;    1347 %input
;    1348 %  vp = thermopile voltage
;    1349 %  kp = thermopile calibration factor in volts/ W m^-2.
;    1350 %  gainPSP[2] is the offset and gain for the preamp circuit
;    1351 %     The thermopile net radiance is given by vp/kp, but
;    1352 %     if a preamp is used, then the measured voltage vp = c0 + c1 * vp'
;    1353 %     where vp' is the actual voltage on the thermopile.
;    1354 %	Then vp' = (vp - c0) / c1;  And e = vp'/kp;
;    1355 %  e = thermopile computed flux in W/m^2 
;    1356 %    
;    1357 %  no arguments ==> test mode
;    1358 %  sw = corrected shortwave flux, W/m^2
;    1359 %  
;    1360 %000928 changes eps to 0.98 per {fairall98}
;    1361 %010323 back to 1.0 per Fairall
;    1362 /**********************************************************/
;    1363 {
_PSPSW:
;    1364 
;    1365 	double e; // w/m^2 on the thermopile 
;    1366 	
;    1367 	// THERMOPILE IRRADIANCE
;    1368 	e = ( (((vp - PSPadc_offset) / PSPadc_gain) /1000) / kp );
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
	CALL SUBOPT_0x6A
	CALL SUBOPT_0x62
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 14
	CALL SUBOPT_0x63
;    1369 	//printf("PSP: e = %.4e\r\n", e);
;    1370 	
;    1371 	*sw = e;
	CALL SUBOPT_0x5B
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x5C
;    1372 	
;    1373 	return e;
	ADIW R28,22
	RET
;    1374 }

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
	BREQ _0xF3
	CALL SUBOPT_0x29
	SBIW R30,1
	LDD  R26,Y+2
	STD  Z+0,R26
	RJMP _0xF4
_0xF3:
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _putchar
_0xF4:
	ADIW R28,3
	RET
__ftoa_G5:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+8
	CPI  R26,LOW(0x6)
	BRLO _0xF5
	LDI  R30,LOW(5)
	STD  Y+8,R30
_0xF5:
	LDD  R30,Y+8
	LDI  R31,0
	LDI  R26,LOW(__fround_G5*2)
	LDI  R27,HIGH(__fround_G5*2)
	CALL SUBOPT_0x58
	CALL __GETD1PF
	CALL SUBOPT_0x6B
	CALL __ADDF12
	CALL SUBOPT_0x6C
	LDI  R16,LOW(0)
	CALL SUBOPT_0x6D
	__PUTD1S 2
_0xF6:
	__GETD1S 2
	CALL SUBOPT_0x6B
	CALL __CMPF12
	BRLO _0xF8
	CALL SUBOPT_0x6E
	CALL __MULF12
	__PUTD1S 2
	SUBI R16,-LOW(1)
	RJMP _0xF6
_0xF8:
	CPI  R16,0
	BRNE _0xF9
	CALL SUBOPT_0x6F
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0xFA
_0xF9:
_0xFB:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0xFD
	CALL SUBOPT_0x6E
	CALL SUBOPT_0x70
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x6B
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x71
	__GETD2S 2
	CALL SUBOPT_0x60
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x35
	CALL SUBOPT_0x6C
	RJMP _0xFB
_0xFD:
_0xFA:
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0xFE
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x218
_0xFE:
	CALL SUBOPT_0x6F
	LDI  R30,LOW(46)
	ST   X,R30
_0xFF:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x101
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x72
	CALL SUBOPT_0x6C
	__GETD1S 9
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x6F
	CALL SUBOPT_0x71
	CALL SUBOPT_0x6B
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x35
	CALL SUBOPT_0x6C
	RJMP _0xFF
_0x101:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x218:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
__ftoe_G5:
	SBIW R28,4
	CALL __SAVELOCR3
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x73
	LDD  R26,Y+10
	CPI  R26,LOW(0x6)
	BRLO _0x102
	LDI  R30,LOW(5)
	STD  Y+10,R30
_0x102:
	LDD  R16,Y+10
_0x103:
	MOV  R30,R16
	SUBI R16,1
	CPI  R30,0
	BREQ _0x105
	CALL SUBOPT_0x74
	CALL SUBOPT_0x73
	RJMP _0x103
_0x105:
	__GETD1S 11
	CALL __CPD10
	BRNE _0x106
	LDI  R18,LOW(0)
	CALL SUBOPT_0x74
	CALL SUBOPT_0x73
	RJMP _0x107
_0x106:
	LDD  R18,Y+10
	CALL SUBOPT_0x75
	BREQ PC+2
	BRCC PC+3
	JMP  _0x108
	CALL SUBOPT_0x74
	CALL SUBOPT_0x73
_0x109:
	CALL SUBOPT_0x75
	BRLO _0x10B
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
	RJMP _0x109
_0x10B:
	RJMP _0x10C
_0x108:
_0x10D:
	CALL SUBOPT_0x75
	BRSH _0x10F
	CALL SUBOPT_0x76
	CALL SUBOPT_0x72
	CALL SUBOPT_0x78
	SUBI R18,LOW(1)
	RJMP _0x10D
_0x10F:
	CALL SUBOPT_0x74
	CALL SUBOPT_0x73
_0x10C:
	__GETD1S 11
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL SUBOPT_0x78
	CALL SUBOPT_0x75
	BRLO _0x110
	CALL SUBOPT_0x76
	CALL SUBOPT_0x77
_0x110:
_0x107:
	LDI  R16,LOW(0)
_0x111:
	LDD  R30,Y+10
	CP   R30,R16
	BRLO _0x113
	__GETD2S 3
	__GETD1N 0x41200000
	CALL SUBOPT_0x70
	CALL SUBOPT_0x73
	__GETD1S 3
	CALL SUBOPT_0x76
	CALL __DIVF21
	CALL __CFD1
	MOV  R17,R30
	CALL SUBOPT_0x79
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
	CALL SUBOPT_0x76
	CALL SUBOPT_0x35
	CALL SUBOPT_0x78
	MOV  R30,R16
	SUBI R16,-1
	CPI  R30,0
	BRNE _0x111
	CALL SUBOPT_0x79
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x111
_0x113:
	CALL SUBOPT_0x7A
	LDD  R26,Y+9
	STD  Z+0,R26
	CPI  R18,0
	BRGE _0x115
	CALL SUBOPT_0x79
	LDI  R30,LOW(45)
	ST   X,R30
	NEG  R18
_0x115:
	CPI  R18,10
	BRLT _0x116
	CALL SUBOPT_0x7A
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __DIVB21
	CALL SUBOPT_0x7B
_0x116:
	CALL SUBOPT_0x7A
	MOVW R22,R30
	MOV  R26,R18
	LDI  R30,LOW(10)
	CALL __MODB21
	CALL SUBOPT_0x7B
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
_0x117:
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
	JMP _0x119
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,0
	BRNE _0x11D
	CPI  R19,37
	BRNE _0x11E
	LDI  R16,LOW(1)
	RJMP _0x11F
_0x11E:
	CALL SUBOPT_0x7C
_0x11F:
	RJMP _0x11C
_0x11D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x120
	CPI  R19,37
	BRNE _0x121
	CALL SUBOPT_0x7C
	RJMP _0x223
_0x121:
	LDI  R16,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R17,LOW(0)
	CPI  R19,45
	BRNE _0x122
	LDI  R17,LOW(1)
	RJMP _0x11C
_0x122:
	CPI  R19,43
	BRNE _0x123
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x11C
_0x123:
	CPI  R19,32
	BRNE _0x124
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x11C
_0x124:
	RJMP _0x125
_0x120:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x126
_0x125:
	LDI  R20,LOW(0)
	LDI  R16,LOW(3)
	CPI  R19,48
	BRNE _0x127
	ORI  R17,LOW(128)
	RJMP _0x11C
_0x127:
	RJMP _0x128
_0x126:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x129
_0x128:
	CPI  R19,48
	BRLO _0x12B
	CPI  R19,58
	BRLO _0x12C
_0x12B:
	RJMP _0x12A
_0x12C:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R19
	CALL SUBOPT_0x7D
	ADD  R20,R30
	RJMP _0x11C
_0x12A:
	LDI  R21,LOW(0)
	CPI  R19,46
	BRNE _0x12D
	LDI  R16,LOW(4)
	RJMP _0x11C
_0x12D:
	RJMP _0x12E
_0x129:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x130
	CPI  R19,48
	BRLO _0x132
	CPI  R19,58
	BRLO _0x133
_0x132:
	RJMP _0x131
_0x133:
	ORI  R17,LOW(32)
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R19
	CALL SUBOPT_0x7D
	ADD  R21,R30
	RJMP _0x11C
_0x131:
_0x12E:
	CPI  R19,108
	BRNE _0x134
	ORI  R17,LOW(2)
	LDI  R16,LOW(5)
	RJMP _0x11C
_0x134:
	RJMP _0x135
_0x130:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x11C
_0x135:
	MOV  R30,R19
	CALL SUBOPT_0x7E
	BRNE _0x13A
	CALL SUBOPT_0x7F
	LD   R30,X
	CALL SUBOPT_0x80
	RJMP _0x13B
_0x13A:
	CPI  R30,LOW(0x45)
	LDI  R26,HIGH(0x45)
	CPC  R31,R26
	BREQ _0x13E
	CPI  R30,LOW(0x65)
	LDI  R26,HIGH(0x65)
	CPC  R31,R26
	BRNE _0x13F
_0x13E:
	RJMP _0x140
_0x13F:
	CPI  R30,LOW(0x66)
	LDI  R26,HIGH(0x66)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x141
_0x140:
	MOVW R30,R28
	ADIW R30,18
	STD  Y+10,R30
	STD  Y+10+1,R31
	CALL SUBOPT_0x7F
	CALL __GETD1P
	CALL SUBOPT_0x54
	MOVW R26,R30
	MOVW R24,R22
	CALL __CPD20
	BRLT _0x142
	LDD  R26,Y+17
	CPI  R26,LOW(0x2B)
	BREQ _0x144
	RJMP _0x145
_0x142:
	CALL SUBOPT_0x6A
	CALL __ANEGF1
	CALL SUBOPT_0x54
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x144:
	SBRS R17,7
	RJMP _0x146
	LDD  R30,Y+17
	CALL SUBOPT_0x80
	RJMP _0x147
_0x146:
	CALL SUBOPT_0x81
	LDD  R26,Y+17
	STD  Z+0,R26
_0x147:
_0x145:
	SBRS R17,5
	LDI  R21,LOW(5)
	CPI  R19,102
	BRNE _0x149
	CALL SUBOPT_0x6A
	CALL __PUTPARD1
	ST   -Y,R21
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoa_G5
	RJMP _0x14A
_0x149:
	CALL SUBOPT_0x6A
	CALL __PUTPARD1
	ST   -Y,R21
	ST   -Y,R19
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __ftoe_G5
_0x14A:
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0x82
	RJMP _0x14B
_0x141:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x14D
	CALL SUBOPT_0x7F
	CALL __GETW1P
	CALL SUBOPT_0x82
	RJMP _0x14E
_0x14D:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x150
	CALL SUBOPT_0x7F
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R16,R30
	ORI  R17,LOW(8)
_0x14E:
	ANDI R17,LOW(127)
	CPI  R21,0
	BREQ _0x152
	CP   R21,R16
	BRLO _0x153
_0x152:
	RJMP _0x151
_0x153:
	MOV  R16,R21
_0x151:
_0x14B:
	LDI  R21,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R18,LOW(0)
	RJMP _0x154
_0x150:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x157
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x158
_0x157:
	ORI  R17,LOW(4)
	RJMP _0x159
_0x158:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x15A
_0x159:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x15B
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x36
	LDI  R16,LOW(10)
	RJMP _0x15C
_0x15B:
	__GETD1N 0x2710
	CALL SUBOPT_0x36
	LDI  R16,LOW(5)
	RJMP _0x15C
_0x15A:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x15E
	ORI  R17,LOW(8)
	RJMP _0x15F
_0x15E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x19D
_0x15F:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R17,1
	RJMP _0x161
	__GETD1N 0x10000000
	CALL SUBOPT_0x36
	LDI  R16,LOW(8)
	RJMP _0x15C
_0x161:
	__GETD1N 0x1000
	CALL SUBOPT_0x36
	LDI  R16,LOW(4)
_0x15C:
	CPI  R21,0
	BREQ _0x162
	ANDI R17,LOW(127)
	RJMP _0x163
_0x162:
	LDI  R21,LOW(1)
_0x163:
	SBRS R17,1
	RJMP _0x164
	CALL SUBOPT_0x7F
	CALL __GETD1P
	RJMP _0x224
_0x164:
	SBRS R17,2
	RJMP _0x166
	CALL SUBOPT_0x7F
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x224
_0x166:
	CALL SUBOPT_0x7F
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x224:
	__PUTD1S 6
	SBRS R17,2
	RJMP _0x168
	CALL SUBOPT_0x83
	CALL __CPD20
	BRGE _0x169
	CALL SUBOPT_0x6A
	CALL __ANEGD1
	CALL SUBOPT_0x54
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x169:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x16A
	SUBI R16,-LOW(1)
	SUBI R21,-LOW(1)
	RJMP _0x16B
_0x16A:
	ANDI R17,LOW(251)
_0x16B:
_0x168:
	MOV  R18,R21
_0x154:
	SBRC R17,0
	RJMP _0x16C
_0x16D:
	CP   R16,R20
	BRSH _0x170
	CP   R18,R20
	BRLO _0x171
_0x170:
	RJMP _0x16F
_0x171:
	SBRS R17,7
	RJMP _0x172
	SBRS R17,2
	RJMP _0x173
	ANDI R17,LOW(251)
	LDD  R19,Y+17
	SUBI R16,LOW(1)
	RJMP _0x174
_0x173:
	LDI  R19,LOW(48)
_0x174:
	RJMP _0x175
_0x172:
	LDI  R19,LOW(32)
_0x175:
	CALL SUBOPT_0x7C
	SUBI R20,LOW(1)
	RJMP _0x16D
_0x16F:
_0x16C:
_0x176:
	CP   R16,R21
	BRSH _0x178
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x179
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x80
	CPI  R20,0
	BREQ _0x17A
	SUBI R20,LOW(1)
_0x17A:
	SUBI R16,LOW(1)
	SUBI R21,LOW(1)
_0x179:
	LDI  R30,LOW(48)
	CALL SUBOPT_0x80
	CPI  R20,0
	BREQ _0x17B
	SUBI R20,LOW(1)
_0x17B:
	SUBI R21,LOW(1)
	RJMP _0x176
_0x178:
	MOV  R18,R16
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x17C
_0x17D:
	CPI  R18,0
	BREQ _0x17F
	SBRS R17,3
	RJMP _0x180
	CALL SUBOPT_0x81
	LPM  R30,Z
	RJMP _0x225
_0x180:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R30,X+
	STD  Y+10,R26
	STD  Y+10+1,R27
_0x225:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	CALL __put_G5
	CPI  R20,0
	BREQ _0x182
	SUBI R20,LOW(1)
_0x182:
	SUBI R18,LOW(1)
	RJMP _0x17D
_0x17F:
	RJMP _0x183
_0x17C:
_0x185:
	CALL SUBOPT_0x37
	CALL SUBOPT_0x83
	CALL __DIVD21U
	MOV  R19,R30
	CPI  R19,10
	BRLO _0x187
	SBRS R17,3
	RJMP _0x188
	SUBI R19,-LOW(55)
	RJMP _0x189
_0x188:
	SUBI R19,-LOW(87)
_0x189:
	RJMP _0x18A
_0x187:
	SUBI R19,-LOW(48)
_0x18A:
	SBRC R17,4
	RJMP _0x18C
	CPI  R19,49
	BRSH _0x18E
	CALL SUBOPT_0x69
	__CPD2N 0x1
	BRNE _0x18D
_0x18E:
	RJMP _0x190
_0x18D:
	CP   R21,R18
	BRLO _0x191
	RJMP _0x226
_0x191:
	CP   R20,R18
	BRLO _0x193
	SBRS R17,0
	RJMP _0x194
_0x193:
	RJMP _0x192
_0x194:
	LDI  R19,LOW(32)
	SBRS R17,7
	RJMP _0x195
_0x226:
	LDI  R19,LOW(48)
_0x190:
	ORI  R17,LOW(16)
	SBRS R17,2
	RJMP _0x196
	ANDI R17,LOW(251)
	LDD  R30,Y+17
	CALL SUBOPT_0x80
	CPI  R20,0
	BREQ _0x197
	SUBI R20,LOW(1)
_0x197:
_0x196:
_0x195:
_0x18C:
	CALL SUBOPT_0x7C
	CPI  R20,0
	BREQ _0x198
	SUBI R20,LOW(1)
_0x198:
_0x192:
	SUBI R18,LOW(1)
	CALL SUBOPT_0x37
	CALL SUBOPT_0x83
	CALL __MODD21U
	CALL SUBOPT_0x54
	LDD  R30,Y+16
	LDI  R31,0
	CALL SUBOPT_0x69
	CALL __CWD1
	CALL __DIVD21U
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL __CPD10
	BREQ _0x186
	RJMP _0x185
_0x186:
_0x183:
	SBRS R17,0
	RJMP _0x199
_0x19A:
	CPI  R20,0
	BREQ _0x19C
	SUBI R20,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x80
	RJMP _0x19A
_0x19C:
_0x199:
_0x19D:
_0x13B:
_0x223:
	LDI  R16,LOW(0)
_0x11C:
	RJMP _0x117
_0x119:
	CALL __LOADLOCR6
	ADIW R28,40
	RET
_printf:
	PUSH R15
	CALL SUBOPT_0x84
	CALL __print_G5
	RJMP _0x216
__get_G5:
	ST   -Y,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x19E
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x19F
_0x19E:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x1A0
	CALL __GETW1P
	LD   R30,Z
	MOV  R16,R30
	CPI  R30,0
	BREQ _0x1A1
	CALL SUBOPT_0x29
_0x1A1:
	RJMP _0x1A2
_0x1A0:
	CALL _getchar
	MOV  R16,R30
_0x1A2:
_0x19F:
	MOV  R30,R16
	LDD  R16,Y+0
	ADIW R28,5
	RET
__scanf_G5:
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	STD  Y+9,R30
	MOV  R21,R30
_0x1A3:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x1A5
	CALL SUBOPT_0x85
	BREQ _0x1A6
_0x1A7:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1AA
	CALL SUBOPT_0x85
	BRNE _0x1AB
_0x1AA:
	RJMP _0x1A9
_0x1AB:
	RJMP _0x1A7
_0x1A9:
	MOV  R21,R18
	RJMP _0x1AC
_0x1A6:
	CPI  R18,37
	BREQ PC+3
	JMP _0x1AD
	LDI  R20,LOW(0)
_0x1AE:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	CPI  R18,48
	BRLO _0x1B2
	CPI  R18,58
	BRLO _0x1B1
_0x1B2:
	RJMP _0x1B0
_0x1B1:
	MOV  R26,R20
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R20,R30
	MOV  R30,R18
	CALL SUBOPT_0x7D
	ADD  R20,R30
	RJMP _0x1AE
_0x1B0:
	CPI  R18,0
	BRNE _0x1B4
	RJMP _0x1A5
_0x1B4:
_0x1B5:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	MOV  R19,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BRNE _0x1B5
	CPI  R19,0
	BRNE _0x1B8
	RJMP _0x1B9
_0x1B8:
	MOV  R21,R19
	CPI  R20,0
	BRNE _0x1BA
	LDI  R20,LOW(255)
_0x1BA:
	MOV  R30,R18
	CALL SUBOPT_0x7E
	BRNE _0x1BE
	CALL SUBOPT_0x87
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	MOVW R26,R16
	ST   X,R30
	RJMP _0x1BD
_0x1BE:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x1C6
	CALL SUBOPT_0x87
_0x1C0:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1C2
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	MOV  R18,R30
	CPI  R30,0
	BREQ _0x1C4
	CALL SUBOPT_0x85
	BREQ _0x1C3
_0x1C4:
	RJMP _0x1C2
_0x1C3:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R18
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x1C0
_0x1C2:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x1BD
_0x1C6:
	LDI  R30,LOW(1)
	STD  Y+8,R30
	MOV  R30,R18
	LDI  R31,0
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x1CB
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x1CC
_0x1CB:
	LDI  R30,LOW(0)
	STD  Y+8,R30
	RJMP _0x1CD
_0x1CC:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x1CE
_0x1CD:
	LDI  R19,LOW(10)
	RJMP _0x1C9
_0x1CE:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BRNE _0x1CF
	LDI  R19,LOW(16)
	RJMP _0x1C9
_0x1CF:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x1D2
	RJMP _0x1D1
_0x1D2:
	LDD  R30,Y+9
	RJMP _0x217
_0x1C9:
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x1D3:
	MOV  R30,R20
	SUBI R20,1
	CPI  R30,0
	BREQ _0x1D5
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	MOV  R18,R30
	CPI  R30,LOW(0x21)
	BRLO _0x1D7
	LDD  R30,Y+8
	CPI  R30,0
	BRNE _0x1D8
	CPI  R18,45
	BRNE _0x1D9
	LDI  R30,LOW(255)
	STD  Y+8,R30
	RJMP _0x1D3
_0x1D9:
	LDI  R30,LOW(1)
	STD  Y+8,R30
_0x1D8:
	CPI  R18,48
	BRLO _0x1D7
	CPI  R18,97
	BRLO _0x1DC
	SUBI R18,LOW(87)
	RJMP _0x1DD
_0x1DC:
	CPI  R18,65
	BRLO _0x1DE
	SUBI R18,LOW(55)
	RJMP _0x1DF
_0x1DE:
	SUBI R18,LOW(48)
_0x1DF:
_0x1DD:
	CP   R18,R19
	BRLO _0x1E0
_0x1D7:
	MOV  R21,R18
	RJMP _0x1D5
_0x1E0:
	MOV  R30,R19
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x1D3
_0x1D5:
	CALL SUBOPT_0x87
	LDD  R30,Y+8
	LDI  R31,0
	SBRC R30,7
	SER  R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __MULW12U
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x1BD:
	LDD  R30,Y+9
	SUBI R30,-LOW(1)
	STD  Y+9,R30
	RJMP _0x1E1
_0x1AD:
_0x1D1:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R21
	CALL SUBOPT_0x86
	POP  R21
	LDI  R31,0
	MOV  R26,R18
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1E2
_0x1B9:
	LDD  R30,Y+9
	CPI  R30,0
	BRNE _0x1E3
	LDI  R30,LOW(255)
	RJMP _0x217
_0x1E3:
	RJMP _0x1A5
_0x1E2:
_0x1E1:
_0x1AC:
	RJMP _0x1A3
_0x1A5:
	LDD  R30,Y+9
_0x217:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
_scanf:
	PUSH R15
	CALL SUBOPT_0x84
	CALL __scanf_G5
_0x216:
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
_0x1E4:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x1E6
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1E4
_0x1E6:
	LDI  R30,LOW(0)
	STD  Y+7,R30
	CPI  R20,43
	BRNE _0x1E7
	RJMP _0x227
_0x1E7:
	CPI  R20,45
	BRNE _0x1E9
	LDI  R30,LOW(1)
	STD  Y+7,R30
_0x227:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1E9:
	LDI  R30,LOW(0)
	MOV  R21,R30
	MOV  R20,R30
	__GETWRS 16,17,16
_0x1EA:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BRNE _0x1ED
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	LDI  R30,LOW(46)
	CALL __EQB12
	MOV  R20,R30
	CPI  R30,0
	BREQ _0x1EC
_0x1ED:
	MOV  R30,R20
	LDI  R31,0
	OR   R21,R30
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1EA
_0x1EC:
	__GETWRS 18,19,16
	CPI  R21,0
	BREQ _0x1EF
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
_0x1F0:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R26,X
	CPI  R26,LOW(0x2E)
	BREQ _0x1F2
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	LD   R30,X
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x2D
	CALL __ADDF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	CALL SUBOPT_0x66
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RJMP _0x1F0
_0x1F2:
_0x1EF:
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x36
_0x1F3:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,1
	STD  Y+16,R26
	STD  Y+16+1,R27
	CP   R26,R16
	CPC  R27,R17
	BRLO _0x1F5
	LD   R30,X
	CALL SUBOPT_0x7D
	CALL SUBOPT_0x69
	CALL SUBOPT_0x60
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x38
	CALL SUBOPT_0x69
	CALL SUBOPT_0x72
	CALL SUBOPT_0x36
	RJMP _0x1F3
_0x1F5:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R20,X
	CPI  R20,101
	BREQ _0x1F7
	CPI  R20,69
	BREQ _0x1F7
	RJMP _0x1F6
_0x1F7:
	LDI  R30,LOW(0)
	MOV  R21,R30
	STD  Y+6,R30
	MOVW R26,R18
	LD   R20,X
	CPI  R20,43
	BRNE _0x1F9
	RJMP _0x228
_0x1F9:
	CPI  R20,45
	BRNE _0x1FB
	LDI  R30,LOW(1)
	STD  Y+6,R30
_0x228:
	__ADDWRN 18,19,1
_0x1FB:
_0x1FC:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R20,R30
	ST   -Y,R30
	CALL _isdigit
	CPI  R30,0
	BREQ _0x1FE
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
	RJMP _0x1FC
_0x1FE:
	CPI  R21,39
	BRLO _0x1FF
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x200
	__GETD1N 0xFF7FFFFF
	RJMP _0x215
_0x200:
	__GETD1N 0x7F7FFFFF
	RJMP _0x215
_0x1FF:
	LDI  R20,LOW(32)
	CALL SUBOPT_0x6D
	CALL SUBOPT_0x36
_0x201:
	CPI  R20,0
	BREQ _0x203
	CALL SUBOPT_0x39
	CALL SUBOPT_0x36
	MOV  R30,R21
	LDI  R31,0
	MOV  R26,R20
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x204
	CALL SUBOPT_0x69
	CALL SUBOPT_0x72
	CALL SUBOPT_0x36
_0x204:
	LSR  R20
	RJMP _0x201
_0x203:
	LDD  R30,Y+6
	CPI  R30,0
	BREQ _0x205
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3B
	CALL __DIVF21
	RJMP _0x229
_0x205:
	CALL SUBOPT_0x37
	CALL SUBOPT_0x3B
	CALL __MULF12
_0x229:
	__PUTD1S 8
_0x1F6:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x207
	CALL SUBOPT_0x5A
	CALL __ANEGF1
	CALL SUBOPT_0x66
_0x207:
	CALL SUBOPT_0x5A
_0x215:
	CALL __LOADLOCR6
	ADIW R28,18
	RET
_spi:
	LD   R30,Y
	OUT  0xF,R30
_0x208:
	SBIS 0xE,7
	RJMP _0x208
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
	RCALL SUBOPT_0x83
	CALL __CPD02
	BRLT _0x20B
	__GETD1N 0xFF7FFFFF
	RJMP _0x214
_0x20B:
	RCALL SUBOPT_0x6A
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
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x83
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x20C
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x83
	CALL __ADDF12
	RCALL SUBOPT_0x54
	__SUBWRN 16,17,1
_0x20C:
	RCALL SUBOPT_0x83
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x35
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6A
	__GETD2N 0x3F800000
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0x83
	CALL __MULF12
	RCALL SUBOPT_0x2F
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x83
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD2S 2
	__GETD1N 0x3FD4114D
	RCALL SUBOPT_0x35
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
	RCALL SUBOPT_0x60
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x214:
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
	BREQ _0x20D
	LD   R30,Y
	ORI  R30,LOW(0xA0)
	ST   Y,R30
_0x20D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x20E
	LD   R30,Y
	ORI  R30,4
	RJMP _0x22A
_0x20E:
	LDD  R26,Y+1
	CPI  R26,LOW(0x2)
	BRNE _0x210
	LD   R30,Y
	ORI  R30,8
	RJMP _0x22A
_0x210:
	LDI  R30,LOW(0)
_0x22A:
	ST   Y,R30
	RCALL SUBOPT_0x88
	LDI  R30,LOW(144)
	ST   -Y,R30
	LDD  R30,Y+1
	RCALL SUBOPT_0x89
	RJMP _0x212
_rtc_get_time:
	LDI  R30,LOW(133)
	RCALL SUBOPT_0x8A
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(131)
	RCALL SUBOPT_0x8A
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(129)
	RCALL SUBOPT_0x8A
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
	RJMP _0x213
_rtc_set_time:
	RCALL SUBOPT_0x88
	LDI  R30,LOW(132)
	RCALL SUBOPT_0x8B
	LDI  R30,LOW(130)
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(128)
	RCALL SUBOPT_0x8D
	RJMP _0x212
_rtc_get_date:
	LDI  R30,LOW(135)
	RCALL SUBOPT_0x8A
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
	LDI  R30,LOW(137)
	RCALL SUBOPT_0x8A
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R30,LOW(141)
	RCALL SUBOPT_0x8A
	LD   R26,Y
	LDD  R27,Y+1
	ST   X,R30
_0x213:
	ADIW R28,6
	RET
_rtc_set_date:
	RCALL SUBOPT_0x88
	LDI  R30,LOW(134)
	RCALL SUBOPT_0x8B
	LDI  R30,LOW(136)
	RCALL SUBOPT_0x8C
	LDI  R30,LOW(140)
	RCALL SUBOPT_0x8D
_0x212:
	ADIW R28,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x0:
	__POINTW1FN _0,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0,40
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0,77
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	__POINTW1FN _0,103
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
	__POINTW1FN _0,134
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,153
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x1:
	__POINTW1FN _0,172
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,200
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,212
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,245
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,278
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x2:
	__POINTW1FN _0,306
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,330
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,352
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	__POINTW1FN _0,376
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
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
SUBOPT_0x4:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__PUTW1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Read_Max186

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	MOVW R30,R20
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_Cmax)
	LDI  R27,HIGH(_Cmax)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_RrefC)
	LDI  R27,HIGH(_RrefC)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:38 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	LDI  R26,LOW(_Vadc)
	LDI  R27,HIGH(_Vadc)
	CALL __EEPROMRDD
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
SUBOPT_0xA:
	__GETD2S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	__PUTD1S 28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	CALL __GETW1P
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_RrefD)
	LDI  R27,HIGH(_RrefD)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	__GETD2S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CALL __ADDF12
	__PUTD1S 24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_pir)
	LDI  R27,HIGH(_pir)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	LDI  R26,LOW(_PIRadc_offset)
	LDI  R27,HIGH(_PIRadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_PIRadc_gain)
	LDI  R27,HIGH(_PIRadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__GETD1S 52
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__GETD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	MOVW R16,R30
	MOVW R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_psp)
	LDI  R27,HIGH(_psp)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_PSPadc_offset)
	LDI  R27,HIGH(_PSPadc_offset)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_PSPadc_gain)
	LDI  R27,HIGH(_PSPadc_gain)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	__GETD1S 20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	__GETD2S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __ADDF12
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_looptime)
	LDI  R27,HIGH(_looptime)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	__GETW1SX 64
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x20:
	CALL __CWD1
	CALL __CDF1
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x21:
	__PUTD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x23:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x24:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Id_address)
	LDI  R27,HIGH(_Id_address)
	CALL __EEPROMRDW
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x27:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x28:
	CALL __PUTPARD1
	__GETD1SX 70
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _Read_Max186

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2D:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42C80000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x2F:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x30:
	OUT  0x15,R30
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 57 TIMES, CODE SIZE REDUCTION:221 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__POINTW1FN _0,37
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R30,Y+36
	LDD  R31,Y+36+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x35:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x36:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x37:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	CALL __ADDF12
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x37
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	__GETD2S 12
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3B:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__PUTD1S 16
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__GETD2N 0x3F800000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R24,8
	CALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL __PUTPARD1
	LDI  R24,12
	CALL _scanf
	ADIW R28,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x1E
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x44:
	LDI  R24,4
	CALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x45:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R28
	ADIW R26,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:167 WORDS
SUBOPT_0x46:
	ST   X,R30
	__POINTW1FN _0,1810
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	MOVW R26,R28
	ADIW R26,10
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x47:
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0xA)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x48:
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0xD)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x49:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4A:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x4B:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	CALL _atof
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4C:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atof

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	__GETD1N 0x3727C5AC
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD1N 0x33D6BF95
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	__GETD1N 0x471C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x50:
	__GETD1N 0x459C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Vtherm)
	LDI  R27,HIGH(_Vtherm)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x54:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	LDI  R24,32
	CALL _printf
	ADIW R28,34
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,38
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x57:
	MOVW R30,R16
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	CALL __LSLW2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x59:
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
SUBOPT_0x5A:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5B:
	__GETD1S 0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	CALL __PUTDP1
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5D:
	CALL __GETD1P
	MOVW R26,R30
	MOVW R24,R22
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5E:
	CALL __PUTDP1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL __GETD1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	RCALL SUBOPT_0x2D
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	LDI  R26,LOW(_adc)
	LDI  R27,HIGH(_adc)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x62:
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	CALL __DIVF21
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x64:
	LDS  R30,_Tabs
	LDS  R31,_Tabs+1
	LDS  R22,_Tabs+2
	LDS  R23,_Tabs+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	RCALL SUBOPT_0xE
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x66:
	__PUTD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x67:
	__GETD2S 20
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x1C
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x69:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6A:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6B:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6D:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	__GETD2S 2
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x70:
	CALL __DIVF21
	__GETD2N 0x3F000000
	CALL __ADDF12
	CALL __PUTPARD1
	JMP  _floor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x71:
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x72:
	__GETD1N 0x41200000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x73:
	__PUTD1S 3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x74:
	__GETD2S 3
	RJMP SUBOPT_0x72

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x75:
	__GETD1S 3
	__GETD2S 11
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x76:
	__GETD2S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x77:
	__GETD1N 0x41200000
	CALL __DIVF21
	__PUTD1S 11
	SUBI R18,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x78:
	__PUTD1S 11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	ADIW R26,1
	STD  Y+7,R26
	STD  Y+7+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7A:
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7B:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADIW R30,48
	MOVW R26,R22
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7C:
	ST   -Y,R19
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7D:
	SUBI R30,LOW(48)
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7E:
	LDI  R31,0
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7F:
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	SBIW R26,4
	STD  Y+36,R26
	STD  Y+36+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x80:
	ST   -Y,R30
	LDD  R30,Y+35
	LDD  R31,Y+35+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ADIW R30,1
	STD  Y+10,R30
	STD  Y+10+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x82:
	STD  Y+10,R30
	STD  Y+10+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x83:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x84:
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
SUBOPT_0x85:
	ST   -Y,R18
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x86:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	JMP  __get_G5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x87:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	SBIW R26,4
	STD  Y+12,R26
	STD  Y+12+1,R27
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x88:
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x89:
	ST   -Y,R30
	CALL _ds1302_write
	LDI  R30,LOW(142)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x8A:
	ST   -Y,R30
	CALL _ds1302_read
	ST   -Y,R30
	JMP  _bcd2bin

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8B:
	ST   -Y,R30
	LDD  R30,Y+3
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8C:
	ST   -Y,R30
	LDD  R30,Y+2
	ST   -Y,R30
	CALL _bin2bcd
	ST   -Y,R30
	JMP  _ds1302_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8D:
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _bin2bcd
	RJMP SUBOPT_0x89

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
	__DELAY_USW 0x7D0
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
	__DELAY_USB 0x5
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x5
	dec  r26
	brne __ds1302_read0
__ds1302_rst0:
	cbi  __ds1302_port,__ds1302_rst
	__DELAY_USB 0xD
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
	__DELAY_USB 0xD
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
	__DELAY_USB 0x5
	cbi  __ds1302_port,__ds1302_sclk
	__DELAY_USB 0x5
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

__PUTPARD1L:
	LDI  R22,0
	LDI  R23,0
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

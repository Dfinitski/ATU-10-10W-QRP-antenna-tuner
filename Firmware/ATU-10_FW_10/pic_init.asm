
_pic_init:

;pic_init.c,5 :: 		void pic_init (void) {
;pic_init.c,7 :: 		ANSELA = 0;         // all as digital
	CLRF       ANSELA+0
;pic_init.c,8 :: 		ANSELB = 0;         // all as digital
	CLRF       ANSELB+0
;pic_init.c,9 :: 		ANSB0_bit = 1;      // analog input
	BSF        ANSB0_bit+0, BitPos(ANSB0_bit+0)
;pic_init.c,10 :: 		ANSB1_bit = 1;      // analog input
	BSF        ANSB1_bit+0, BitPos(ANSB1_bit+0)
;pic_init.c,11 :: 		ANSB2_bit = 1;      // analog input
	BSF        ANSB2_bit+0, BitPos(ANSB2_bit+0)
;pic_init.c,12 :: 		ANSELC = 0;         // all as digital
	CLRF       ANSELC+0
;pic_init.c,13 :: 		ANSELE = 0;         // all as digital
	CLRF       ANSELE+0
;pic_init.c,14 :: 		ANSELD = 0;         // all as digital
	CLRF       ANSELD+0
;pic_init.c,16 :: 		C1ON_bit = 0;      // Disable comparators
	BCF        C1ON_bit+0, BitPos(C1ON_bit+0)
;pic_init.c,17 :: 		C2ON_bit = 0;
	BCF        C2ON_bit+0, BitPos(C2ON_bit+0)
;pic_init.c,19 :: 		PORTA = 0;
	CLRF       PORTA+0
;pic_init.c,20 :: 		PORTB = 0;
	CLRF       PORTB+0
;pic_init.c,21 :: 		PORTC = 0;
	CLRF       PORTC+0
;pic_init.c,22 :: 		PORTD = 0;
	CLRF       PORTD+0
;pic_init.c,23 :: 		PORTE = 0;
	CLRF       PORTE+0
;pic_init.c,24 :: 		LATA = 0b00000000;
	CLRF       LATA+0
;pic_init.c,25 :: 		LATB = 0b00000000;
	CLRF       LATB+0
;pic_init.c,26 :: 		LATC = 0b00010000;
	MOVLW      16
	MOVWF      LATC+0
;pic_init.c,27 :: 		LATD = 0b00000110;
	MOVLW      6
	MOVWF      LATD+0
;pic_init.c,28 :: 		LATE = 0b00000000;
	CLRF       LATE+0
;pic_init.c,29 :: 		TRISA = 0b00000000;
	CLRF       TRISA+0
;pic_init.c,30 :: 		TRISB = 0b00100111;
	MOVLW      39
	MOVWF      TRISB+0
;pic_init.c,31 :: 		TRISC = 0b00000000;
	CLRF       TRISC+0
;pic_init.c,32 :: 		TRISD = 0b00000000;
	CLRF       TRISD+0
;pic_init.c,33 :: 		TRISE = 0b00000000;
	CLRF       TRISE+0
;pic_init.c,36 :: 		ODCA2_bit = 1;
	BSF        ODCA2_bit+0, BitPos(ODCA2_bit+0)
;pic_init.c,37 :: 		ODCA3_bit = 1;
	BSF        ODCA3_bit+0, BitPos(ODCA3_bit+0)
;pic_init.c,38 :: 		ODCD1_bit = 1;
	BSF        ODCD1_bit+0, BitPos(ODCD1_bit+0)
;pic_init.c,39 :: 		ODCD2_bit = 1;
	BSF        ODCD2_bit+0, BitPos(ODCD2_bit+0)
;pic_init.c,42 :: 		T0CS0_bit = 0; // Fosc/4
	BCF        T0CS0_bit+0, BitPos(T0CS0_bit+0)
;pic_init.c,43 :: 		T0CS1_bit = 1;
	BSF        T0CS1_bit+0, BitPos(T0CS1_bit+0)
;pic_init.c,44 :: 		T0CS2_bit = 0;
	BCF        T0CS2_bit+0, BitPos(T0CS2_bit+0)
;pic_init.c,45 :: 		T016BIT_bit = 1;
	BSF        T016BIT_bit+0, BitPos(T016BIT_bit+0)
;pic_init.c,46 :: 		TMR0L = 0xC0;   // 80_000 cycles to OF
	MOVLW      192
	MOVWF      TMR0L+0
;pic_init.c,47 :: 		TMR0H = 0xE0;
	MOVLW      224
	MOVWF      TMR0H+0
;pic_init.c,48 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;pic_init.c,49 :: 		T0EN_bit = 1;
	BSF        T0EN_bit+0, BitPos(T0EN_bit+0)
;pic_init.c,50 :: 		TMR0IE_bit = 1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;pic_init.c,53 :: 		PMD0 = 0b00011110; //
	MOVLW      30
	MOVWF      PMD0+0
;pic_init.c,54 :: 		PMD1 = 0b11111110;
	MOVLW      254
	MOVWF      PMD1+0
;pic_init.c,55 :: 		PMD2 = 0b01000111;
	MOVLW      71
	MOVWF      PMD2+0
;pic_init.c,56 :: 		PMD3 = 0b01111111;
	MOVLW      127
	MOVWF      PMD3+0
;pic_init.c,57 :: 		PMD4 = 0b1110111;
	MOVLW      119
	MOVWF      PMD4+0
;pic_init.c,58 :: 		PMD5 = 0b11011111;
	MOVLW      223
	MOVWF      PMD5+0
;pic_init.c,60 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;pic_init.c,61 :: 		IOCIE_bit = 1;
	BSF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;pic_init.c,62 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;pic_init.c,63 :: 		IOCBN5_bit = 1;
	BSF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;pic_init.c,65 :: 		Delay_ms (100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_pic_init0:
	DECFSZ     R13, 1
	GOTO       L_pic_init0
	DECFSZ     R12, 1
	GOTO       L_pic_init0
	DECFSZ     R11, 1
	GOTO       L_pic_init0
;pic_init.c,66 :: 		return;
;pic_init.c,67 :: 		}
L_end_pic_init:
	RETURN
; end of _pic_init


_Soft_I2C_Init:

;Soft_I2C.c,12 :: 		void Soft_I2C_Init(void) {
;Soft_I2C.c,13 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;Soft_I2C.c,14 :: 		return;
;Soft_I2C.c,15 :: 		}
L_end_Soft_I2C_Init:
	RETURN
; end of _Soft_I2C_Init

_Soft_I2C_Start:

;Soft_I2C.c,17 :: 		void Soft_I2C_Start() {
;Soft_I2C.c,18 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,19 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Start0:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Start0
	NOP
;Soft_I2C.c,20 :: 		Soft_I2C_Sda = 1;
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,21 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Start1:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Start1
	NOP
;Soft_I2C.c,22 :: 		Soft_I2C_Sda = 0;
	BCF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,23 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Start2:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Start2
	NOP
;Soft_I2C.c,24 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,25 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Start3:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Start3
	NOP
;Soft_I2C.c,26 :: 		return;
;Soft_I2C.c,27 :: 		}
L_end_Soft_I2C_Start:
	RETURN
; end of _Soft_I2C_Start

_Soft_I2C_Write:

;Soft_I2C.c,29 :: 		char Soft_I2C_Write(char d) {
;Soft_I2C.c,31 :: 		for(i=0; i<8; i++) {
	CLRF       R1+0
L_Soft_I2C_Write4:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Soft_I2C_Write5
;Soft_I2C.c,32 :: 		Soft_I2C_Sda = d.B7;
	BTFSC      FARG_Soft_I2C_Write_d+0, 7
	GOTO       L__Soft_I2C_Write29
	BCF        LATA2_bit+0, BitPos(LATA2_bit+0)
	GOTO       L__Soft_I2C_Write30
L__Soft_I2C_Write29:
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
L__Soft_I2C_Write30:
;Soft_I2C.c,33 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Write7:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Write7
	NOP
;Soft_I2C.c,34 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,35 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Write8:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Write8
	NOP
;Soft_I2C.c,36 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,37 :: 		d = d << 1;
	LSLF       FARG_Soft_I2C_Write_d+0, 1
;Soft_I2C.c,31 :: 		for(i=0; i<8; i++) {
	INCF       R1+0, 1
;Soft_I2C.c,38 :: 		}
	GOTO       L_Soft_I2C_Write4
L_Soft_I2C_Write5:
;Soft_I2C.c,40 :: 		Soft_I2C_Sda = 1; //ACK
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,41 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Write9:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Write9
	NOP
;Soft_I2C.c,42 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,43 :: 		ack = Soft_I2C_Sda_in;
	MOVLW      0
	BTFSC      PORTA+0, 2
	MOVLW      1
	MOVWF      R2+0
;Soft_I2C.c,44 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Write10:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Write10
	NOP
;Soft_I2C.c,45 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,46 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Write11:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Write11
	NOP
;Soft_I2C.c,47 :: 		return ack;
	MOVF       R2+0, 0
	MOVWF      R0
;Soft_I2C.c,48 :: 		}
L_end_Soft_I2C_Write:
	RETURN
; end of _Soft_I2C_Write

_Soft_I2C_Read:

;Soft_I2C.c,50 :: 		char Soft_I2C_Read(void){
;Soft_I2C.c,51 :: 		char i, d = 0;
	CLRF       Soft_I2C_Read_d_L0+0
;Soft_I2C.c,52 :: 		for(i=0; i<8; i++){
	CLRF       R1+0
L_Soft_I2C_Read12:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_Soft_I2C_Read13
;Soft_I2C.c,53 :: 		d = d << 1;
	LSLF       Soft_I2C_Read_d_L0+0, 1
;Soft_I2C.c,54 :: 		d = d + Soft_I2C_Sda_in;
	CLRF       R0
	BTFSC      PORTA+0, 2
	INCF       R0, 1
	MOVF       R0, 0
	ADDWF      Soft_I2C_Read_d_L0+0, 1
;Soft_I2C.c,55 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,56 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Read15:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Read15
	NOP
;Soft_I2C.c,57 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,58 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Read16:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Read16
	NOP
;Soft_I2C.c,52 :: 		for(i=0; i<8; i++){
	INCF       R1+0, 1
;Soft_I2C.c,59 :: 		}
	GOTO       L_Soft_I2C_Read12
L_Soft_I2C_Read13:
;Soft_I2C.c,60 :: 		return d;
	MOVF       Soft_I2C_Read_d_L0+0, 0
	MOVWF      R0
;Soft_I2C.c,61 :: 		}
L_end_Soft_I2C_Read:
	RETURN
; end of _Soft_I2C_Read

_Soft_I2C_ACK:

;Soft_I2C.c,63 :: 		void Soft_I2C_ACK(void){
;Soft_I2C.c,64 :: 		Soft_I2C_Sda = 0;
	BCF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,65 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_ACK17:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_ACK17
	NOP
;Soft_I2C.c,66 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,67 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_ACK18:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_ACK18
	NOP
;Soft_I2C.c,68 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,69 :: 		Soft_I2C_Sda = 1;
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,70 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_ACK19:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_ACK19
	NOP
;Soft_I2C.c,71 :: 		return;
;Soft_I2C.c,72 :: 		}
L_end_Soft_I2C_ACK:
	RETURN
; end of _Soft_I2C_ACK

_Soft_I2C_NACK:

;Soft_I2C.c,74 :: 		void Soft_I2C_NACK(void){
;Soft_I2C.c,75 :: 		Soft_I2C_Sda = 1;
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,76 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_NACK20:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_NACK20
	NOP
;Soft_I2C.c,77 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,78 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_NACK21:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_NACK21
	NOP
;Soft_I2C.c,79 :: 		Soft_I2C_Scl = 0;
	BCF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,80 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_NACK22:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_NACK22
	NOP
;Soft_I2C.c,81 :: 		return;
;Soft_I2C.c,82 :: 		}
L_end_Soft_I2C_NACK:
	RETURN
; end of _Soft_I2C_NACK

_Soft_I2C_Stop:

;Soft_I2C.c,84 :: 		void Soft_I2C_Stop() {
;Soft_I2C.c,85 :: 		Soft_I2C_Sda = 0;
	BCF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,86 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Stop23:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Stop23
	NOP
;Soft_I2C.c,87 :: 		Soft_I2C_Scl = 1;
	BSF        LATA3_bit+0, BitPos(LATA3_bit+0)
;Soft_I2C.c,88 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Stop24:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Stop24
	NOP
;Soft_I2C.c,89 :: 		Soft_I2C_Sda = 1;
	BSF        LATA2_bit+0, BitPos(LATA2_bit+0)
;Soft_I2C.c,90 :: 		Delay_I2C;
	MOVLW      66
	MOVWF      R13
L_Soft_I2C_Stop25:
	DECFSZ     R13, 1
	GOTO       L_Soft_I2C_Stop25
	NOP
;Soft_I2C.c,91 :: 		return;
;Soft_I2C.c,92 :: 		}
L_end_Soft_I2C_Stop:
	RETURN
; end of _Soft_I2C_Stop

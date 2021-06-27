
_interupt:

;main.c,30 :: 		void interupt() iv 0x0004  {
;main.c,32 :: 		if(TMR0IF_bit) {   // Timer0
	BTFSS      TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
	GOTO       L_interupt0
;main.c,33 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;main.c,34 :: 		Tick++;
	MOVLW      1
	ADDWF      _Tick+0, 1
	MOVLW      0
	ADDWFC     _Tick+1, 1
	ADDWFC     _Tick+2, 1
	ADDWFC     _Tick+3, 1
;main.c,35 :: 		TMR0L = 0xC0;   // 80_000 cycles to OF
	MOVLW      192
	MOVWF      TMR0L+0
;main.c,36 :: 		TMR0H = 0xE0;
	MOVLW      224
	MOVWF      TMR0H+0
;main.c,37 :: 		}
L_interupt0:
;main.c,38 :: 		if(IOCBF5_bit){
	BTFSS      IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
	GOTO       L_interupt1
;main.c,39 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,40 :: 		sleep_cnt = Tick + Sleep_time*1000;
	MOVF       _Sleep_time+0, 0
	MOVWF      R0
	MOVF       _Sleep_time+1, 0
	MOVWF      R1
	MOVF       _Sleep_time+2, 0
	MOVWF      R2
	MOVF       _Sleep_time+3, 0
	MOVWF      R3
	MOVLW      232
	MOVWF      R4
	MOVLW      3
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	CALL       _Mul_32x32_U+0
	MOVF       R0, 0
	ADDWF      _Tick+0, 0
	MOVWF      _sleep_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _sleep_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _sleep_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _sleep_cnt+3
;main.c,41 :: 		}
L_interupt1:
;main.c,42 :: 		if(Tick>=btn_cnt){  // every 10ms
	MOVF       _btn_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt207
	MOVF       _btn_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt207
	MOVF       _btn_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt207
	MOVF       _btn_cnt+0, 0
	SUBWF      _Tick+0, 0
L__interupt207:
	BTFSS      STATUS+0, 0
	GOTO       L_interupt2
;main.c,43 :: 		btn_cnt += 10;
	MOVLW      10
	ADDWF      _btn_cnt+0, 1
	MOVLW      0
	ADDWFC     _btn_cnt+1, 1
	ADDWFC     _btn_cnt+2, 1
	ADDWFC     _btn_cnt+3, 1
;main.c,45 :: 		if(GetButton){  //
	BTFSC      PORTB+0, 5
	GOTO       L__interupt208
	BSF        3, 0
	GOTO       L__interupt209
L__interupt208:
	BCF        3, 0
L__interupt209:
	BTFSS      3, 0
	GOTO       L_interupt3
;main.c,46 :: 		if(btn_1_cnt<255) btn_1_cnt ++;
	MOVLW      255
	SUBWF      _btn_1_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interupt4
	INCF       _btn_1_cnt+0, 1
L_interupt4:
;main.c,47 :: 		if(btn_1_cnt==255) B_xlong = 1;  //  Xtra long pressing detected
	MOVF       _btn_1_cnt+0, 0
	XORLW      255
	BTFSS      STATUS+0, 2
	GOTO       L_interupt5
	BSF        _B_xlong+0, BitPos(_B_xlong+0)
L_interupt5:
;main.c,48 :: 		}
	GOTO       L_interupt6
L_interupt3:
;main.c,49 :: 		else if(btn_1_cnt>=35 & btn_1_cnt<255){
	MOVLW      35
	SUBWF      _btn_1_cnt+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      255
	SUBWF      _btn_1_cnt+0, 0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt7
;main.c,50 :: 		B_long = 1;
	BSF        _B_long+0, BitPos(_B_long+0)
;main.c,51 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,52 :: 		}
	GOTO       L_interupt8
L_interupt7:
;main.c,53 :: 		else if(btn_1_cnt>10 & btn_1_cnt<35){
	MOVF       _btn_1_cnt+0, 0
	SUBLW      10
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      35
	SUBWF      _btn_1_cnt+0, 0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt9
;main.c,54 :: 		B_short = 1; // short pressing detected
	BSF        _B_short+0, BitPos(_B_short+0)
;main.c,55 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,56 :: 		}
	GOTO       L_interupt10
L_interupt9:
;main.c,58 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
L_interupt10:
L_interupt8:
L_interupt6:
;main.c,59 :: 		}
L_interupt2:
;main.c,60 :: 		return;
;main.c,61 :: 		}
L_end_interupt:
L__interupt206:
	RETFIE     %s
; end of _interupt

_main:

;main.c,64 :: 		void main() {
;main.c,65 :: 		pic_init();
	CALL       _pic_init+0
;main.c,66 :: 		oled_start();
	CALL       _oled_start+0
;main.c,68 :: 		ADC_Init();
	CALL       _ADC_Init+0
;main.c,69 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,70 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,71 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,72 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,74 :: 		sleep_cnt = Tick + Sleep_time*1000;
	MOVF       _Sleep_time+0, 0
	MOVWF      R0
	MOVF       _Sleep_time+1, 0
	MOVWF      R1
	MOVF       _Sleep_time+2, 0
	MOVWF      R2
	MOVF       _Sleep_time+3, 0
	MOVWF      R3
	MOVLW      232
	MOVWF      R4
	MOVLW      3
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	CALL       _Mul_32x32_U+0
	MOVF       R0, 0
	ADDWF      _Tick+0, 0
	MOVWF      _sleep_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _sleep_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _sleep_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _sleep_cnt+3
;main.c,75 :: 		Sleep = 0;
	BCF        _Sleep+0, BitPos(_Sleep+0)
;main.c,76 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,77 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,81 :: 		while(1) {
L_main11:
;main.c,82 :: 		if(Tick>=volt_cnt & Sleep==0){   // every 3 second
	MOVF       _volt_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main211
	MOVF       _volt_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main211
	MOVF       _volt_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main211
	MOVF       _volt_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main211:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	BTFSC      _Sleep+0, BitPos(_Sleep+0)
	GOTO       L__main212
	BSF        3, 0
	GOTO       L__main213
L__main212:
	BCF        3, 0
L__main213:
	CLRF       R0
	BTFSC      3, 0
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main13
;main.c,83 :: 		volt_cnt += 3000;
	MOVLW      184
	ADDWF      _volt_cnt+0, 1
	MOVLW      11
	ADDWFC     _volt_cnt+1, 1
	MOVLW      0
	ADDWFC     _volt_cnt+2, 1
	ADDWFC     _volt_cnt+3, 1
;main.c,84 :: 		Voltage_show();
	CALL       _Voltage_show+0
;main.c,85 :: 		}
L_main13:
;main.c,87 :: 		if(Tick>=watch_cnt & Sleep==0){   // every 300 ms
	MOVF       _watch_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main214
	MOVF       _watch_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main214
	MOVF       _watch_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main214
	MOVF       _watch_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main214:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	BTFSC      _Sleep+0, BitPos(_Sleep+0)
	GOTO       L__main215
	BSF        3, 0
	GOTO       L__main216
L__main215:
	BCF        3, 0
L__main216:
	CLRF       R0
	BTFSC      3, 0
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main14
;main.c,88 :: 		watch_cnt += 300;
	MOVLW      44
	ADDWF      _watch_cnt+0, 1
	MOVLW      1
	ADDWFC     _watch_cnt+1, 1
	MOVLW      0
	ADDWFC     _watch_cnt+2, 1
	ADDWFC     _watch_cnt+3, 1
;main.c,89 :: 		watch_swr();
	CALL       _watch_swr+0
;main.c,90 :: 		if(B_short) Btn_short();
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_main15
	CALL       _Btn_short+0
L_main15:
;main.c,91 :: 		if(B_long) Btn_long();
	BTFSS      _B_long+0, BitPos(_B_long+0)
	GOTO       L_main16
	CALL       _Btn_long+0
L_main16:
;main.c,92 :: 		if(B_xlong) Btn_xlong();
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_main17
	CALL       _Btn_xlong+0
L_main17:
;main.c,93 :: 		}
L_main14:
;main.c,95 :: 		if(Tick>=sleep_cnt & Sleep==0){  // Go to sleep
	MOVF       _sleep_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main217
	MOVF       _sleep_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main217
	MOVF       _sleep_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main217
	MOVF       _sleep_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main217:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	BTFSC      _Sleep+0, BitPos(_Sleep+0)
	GOTO       L__main218
	BSF        3, 0
	GOTO       L__main219
L__main218:
	BCF        3, 0
L__main219:
	CLRF       R0
	BTFSC      3, 0
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main18
;main.c,96 :: 		Sleep = 1;
	BSF        _Sleep+0, BitPos(_Sleep+0)
;main.c,97 :: 		sleep_mode();
	CALL       _Sleep_mode+0
;main.c,98 :: 		}
L_main18:
;main.c,100 :: 		if(Sleep & GetButton){
	BTFSC      PORTB+0, 5
	GOTO       L__main220
	BSF        3, 0
	GOTO       L__main221
L__main220:
	BCF        3, 0
L__main221:
	BTFSS      _Sleep+0, BitPos(_Sleep+0)
	GOTO       L__main222
	BTFSS      3, 0
	GOTO       L__main222
	BSF        R4, 0
	GOTO       L__main223
L__main222:
	BCF        R4, 0
L__main223:
	BTFSS      R4, 0
	GOTO       L_main19
;main.c,101 :: 		Sleep = 0;
	BCF        _Sleep+0, BitPos(_Sleep+0)
;main.c,102 :: 		Sleep_mode();
	CALL       _Sleep_mode+0
;main.c,103 :: 		}
L_main19:
;main.c,105 :: 		if(Tick>=off_cnt & Sleep){    // one hour after sleep
	MOVF       _off_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main224
	MOVF       _off_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main224
	MOVF       _off_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main224
	MOVF       _off_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main224:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	CLRF       R0
	BTFSC      _Sleep+0, BitPos(_Sleep+0)
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_main20
;main.c,106 :: 		power_off();
	CALL       _power_off+0
;main.c,107 :: 		}
L_main20:
;main.c,111 :: 		} // while(1)
	GOTO       L_main11
;main.c,112 :: 		} // main
L_end_main:
	GOTO       $+0
; end of _main

_Sleep_mode:

;main.c,115 :: 		void Sleep_mode(){
;main.c,116 :: 		if(Sleep){    // go to sleep
	BTFSS      _Sleep+0, BitPos(_Sleep+0)
	GOTO       L_Sleep_mode21
;main.c,117 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,118 :: 		OSCFRQ = 0b00000000; // 1MHz
	CLRF       OSCFRQ+0
;main.c,119 :: 		OSCCON1 = 0b01100101; // /32
	MOVLW      101
	MOVWF      OSCCON1+0
;main.c,120 :: 		off_cnt = Tick + Off_time;
	MOVF       _Off_time+0, 0
	ADDWF      _Tick+0, 0
	MOVWF      _off_cnt+0
	MOVF       _Off_time+1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       _Off_time+2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       _Off_time+3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,121 :: 		ADON_bit = 0;
	BCF        ADON_bit+0, BitPos(ADON_bit+0)
;main.c,122 :: 		FVREN_bit = 0;
	BCF        FVREN_bit+0, BitPos(FVREN_bit+0)
;main.c,123 :: 		FVRMD_bit = 1; // Disable FVR
	BSF        FVRMD_bit+0, BitPos(FVRMD_bit+0)
;main.c,124 :: 		ADCMD_bit = 1; // Disable ADC
	BSF        ADCMD_bit+0, BitPos(ADCMD_bit+0)
;main.c,125 :: 		}
	GOTO       L_Sleep_mode22
L_Sleep_mode21:
;main.c,127 :: 		FVRMD_bit = 0; // Enable FVR
	BCF        FVRMD_bit+0, BitPos(FVRMD_bit+0)
;main.c,128 :: 		ADCMD_bit = 0; // Enable ADC
	BCF        ADCMD_bit+0, BitPos(ADCMD_bit+0)
;main.c,129 :: 		ADON_bit = 1;
	BSF        ADON_bit+0, BitPos(ADON_bit+0)
;main.c,130 :: 		FVREN_bit = 1;
	BSF        FVREN_bit+0, BitPos(FVREN_bit+0)
;main.c,131 :: 		OSCFRQ = 0b00000110; // 32MHz
	MOVLW      6
	MOVWF      OSCFRQ+0
;main.c,132 :: 		OSCCON1 = 0b01100000; // /1
	MOVLW      96
	MOVWF      OSCCON1+0
;main.c,133 :: 		oled_start();
	CALL       _oled_start+0
;main.c,134 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,135 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,136 :: 		Sleep_cnt = Tick + Sleep_time*1000;
	MOVF       _Sleep_time+0, 0
	MOVWF      R0
	MOVF       _Sleep_time+1, 0
	MOVWF      R1
	MOVF       _Sleep_time+2, 0
	MOVWF      R2
	MOVF       _Sleep_time+3, 0
	MOVWF      R3
	MOVLW      232
	MOVWF      R4
	MOVLW      3
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	CALL       _Mul_32x32_U+0
	MOVF       R0, 0
	ADDWF      _Tick+0, 0
	MOVWF      _sleep_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _sleep_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _sleep_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _sleep_cnt+3
;main.c,137 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,138 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,139 :: 		}
L_Sleep_mode22:
;main.c,140 :: 		return;
;main.c,141 :: 		}
L_end_Sleep_mode:
	RETURN
; end of _Sleep_mode

_oled_start:

;main.c,143 :: 		void oled_start(){
;main.c,144 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,145 :: 		Delay_ms(200);
	MOVLW      9
	MOVWF      R11
	MOVLW      30
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_oled_start23:
	DECFSZ     R13, 1
	GOTO       L_oled_start23
	DECFSZ     R12, 1
	GOTO       L_oled_start23
	DECFSZ     R11, 1
	GOTO       L_oled_start23
	NOP
;main.c,146 :: 		Soft_I2C_init();
	CALL       _Soft_I2C_Init+0
;main.c,147 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_oled_start24:
	DECFSZ     R13, 1
	GOTO       L_oled_start24
	DECFSZ     R12, 1
	GOTO       L_oled_start24
	NOP
;main.c,148 :: 		oled_init();
	CALL       _oled_init+0
;main.c,150 :: 		oled_wr_str(0, 0, "PWR     W", 9);
	CLRF       FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr1_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,151 :: 		oled_bat();
	CALL       _oled_bat+0
;main.c,152 :: 		oled_wr_str(2, 0, "SWR      ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr2_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr2_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,153 :: 		oled_wr_str(0, 42, "=", 1);
	CLRF       FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr3_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr3_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,154 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr4_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr4_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,155 :: 		Voltage = 9999;
	MOVLW      15
	MOVWF      _Voltage+0
	MOVLW      39
	MOVWF      _Voltage+1
;main.c,156 :: 		SWR_fixed_old = 9999;
	MOVLW      15
	MOVWF      _SWR_fixed_old+0
	MOVLW      39
	MOVWF      _SWR_fixed_old+1
;main.c,157 :: 		PWR_fixed_old = 9999;
	MOVLW      15
	MOVWF      _PWR_fixed_old+0
	MOVLW      39
	MOVWF      _PWR_fixed_old+1
;main.c,158 :: 		return;
;main.c,159 :: 		}
L_end_oled_start:
	RETURN
; end of _oled_start

_watch_swr:

;main.c,162 :: 		void watch_swr(void){
;main.c,164 :: 		int delta = Auto_delta - 100;
	MOVLW      100
	SUBWF      _Auto_delta+0, 0
	MOVWF      watch_swr_delta_L0+0
	MOVLW      0
	SUBWFB     _Auto_delta+1, 0
	MOVWF      watch_swr_delta_L0+1
;main.c,167 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_watch_swr25:
	DECFSZ     R13, 1
	GOTO       L_watch_swr25
	DECFSZ     R12, 1
	GOTO       L_watch_swr25
	DECFSZ     R11, 1
	GOTO       L_watch_swr25
;main.c,169 :: 		cnt = 100;
	MOVLW      100
	MOVWF      watch_swr_cnt_L0+0
;main.c,170 :: 		PWR_fixed = 0;
	CLRF       watch_swr_PWR_fixed_L0+0
	CLRF       watch_swr_PWR_fixed_L0+1
;main.c,171 :: 		SWR_fixed = 999;
	MOVLW      231
	MOVWF      watch_swr_SWR_fixed_L0+0
	MOVLW      3
	MOVWF      watch_swr_SWR_fixed_L0+1
;main.c,172 :: 		for(peak_cnt = 0; peak_cnt < cnt; peak_cnt++){
	CLRF       watch_swr_peak_cnt_L0+0
L_watch_swr26:
	MOVF       watch_swr_cnt_L0+0, 0
	SUBWF      watch_swr_peak_cnt_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr27
;main.c,173 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,174 :: 		if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr228
	MOVF       _PWR+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr228:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr29
	MOVF       _PWR+0, 0
	MOVWF      watch_swr_PWR_fixed_L0+0
	MOVF       _PWR+1, 0
	MOVWF      watch_swr_PWR_fixed_L0+1
	MOVF       _SWR+0, 0
	MOVWF      watch_swr_SWR_fixed_L0+0
	MOVF       _SWR+1, 0
	MOVWF      watch_swr_SWR_fixed_L0+1
L_watch_swr29:
;main.c,175 :: 		Delay_ms(1);
	MOVLW      11
	MOVWF      R12
	MOVLW      98
	MOVWF      R13
L_watch_swr30:
	DECFSZ     R13, 1
	GOTO       L_watch_swr30
	DECFSZ     R12, 1
	GOTO       L_watch_swr30
	NOP
;main.c,172 :: 		for(peak_cnt = 0; peak_cnt < cnt; peak_cnt++){
	INCF       watch_swr_peak_cnt_L0+0, 1
;main.c,176 :: 		}
	GOTO       L_watch_swr26
L_watch_swr27:
;main.c,178 :: 		if(PWR_fixed!=PWR_fixed_old){
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	XORWF      _PWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr229
	MOVF       _PWR_fixed_old+0, 0
	XORWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr229:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr31
;main.c,179 :: 		if(Overflow)
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr32
;main.c,180 :: 		oled_wr_str(0, 42, ">", 1);
	CLRF       FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr5_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr5_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
	GOTO       L_watch_swr33
L_watch_swr32:
;main.c,182 :: 		oled_wr_str(0, 42, "=", 1);
	CLRF       FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr6_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr6_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
L_watch_swr33:
;main.c,183 :: 		PWR_fixed_old = PWR_fixed;
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      _PWR_fixed_old+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      _PWR_fixed_old+1
;main.c,184 :: 		draw_power(PWR_fixed);
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      FARG_draw_power+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      FARG_draw_power+1
	CALL       _draw_power+0
;main.c,185 :: 		}
L_watch_swr31:
;main.c,186 :: 		if(PWR_fixed<10)
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr230
	MOVLW      10
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr230:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr34
;main.c,187 :: 		SWR_fixed = 0;
	CLRF       watch_swr_SWR_fixed_L0+0
	CLRF       watch_swr_SWR_fixed_L0+1
L_watch_swr34:
;main.c,188 :: 		if(Overflow){
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr35
;main.c,189 :: 		for(cnt=3; cnt!=0; cnt--){
	MOVLW      3
	MOVWF      watch_swr_cnt_L0+0
L_watch_swr36:
	MOVF       watch_swr_cnt_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr37
;main.c,190 :: 		oled_wr_str(2, 6, "OVERLOAD ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      6
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr7_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr7_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,191 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr39:
	DECFSZ     R13, 1
	GOTO       L_watch_swr39
	DECFSZ     R12, 1
	GOTO       L_watch_swr39
	DECFSZ     R11, 1
	GOTO       L_watch_swr39
	NOP
;main.c,192 :: 		oled_wr_str(2, 0, "         ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr8_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr8_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,193 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr40:
	DECFSZ     R13, 1
	GOTO       L_watch_swr40
	DECFSZ     R12, 1
	GOTO       L_watch_swr40
	DECFSZ     R11, 1
	GOTO       L_watch_swr40
	NOP
;main.c,189 :: 		for(cnt=3; cnt!=0; cnt--){
	DECF       watch_swr_cnt_L0+0, 1
;main.c,194 :: 		}
	GOTO       L_watch_swr36
L_watch_swr37:
;main.c,195 :: 		oled_wr_str(2, 0, "SWR      ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr9_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr9_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,196 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr10_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr10_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,197 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,198 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr41:
	DECFSZ     R13, 1
	GOTO       L_watch_swr41
	DECFSZ     R12, 1
	GOTO       L_watch_swr41
	DECFSZ     R11, 1
	GOTO       L_watch_swr41
	NOP
;main.c,199 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,200 :: 		}
	GOTO       L_watch_swr42
L_watch_swr35:
;main.c,201 :: 		else if(SWR_fixed!=SWR_fixed_old){
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	XORWF      _SWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr231
	MOVF       _SWR_fixed_old+0, 0
	XORWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr231:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr43
;main.c,202 :: 		SWR_fixed_old = SWR_fixed;
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      _SWR_fixed_old+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      _SWR_fixed_old+1
;main.c,203 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,204 :: 		}
L_watch_swr43:
L_watch_swr42:
;main.c,207 :: 		if(PWR_fixed<min_for_start | PWR_fixed>max_for_start) return;
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr232
	MOVF       _min_for_start+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr232:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      128
	XORWF      _max_for_start+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr233
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBWF      _max_for_start+0, 0
L__watch_swr233:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr44
	GOTO       L_end_watch_swr
L_watch_swr44:
;main.c,209 :: 		if(SWR_fixed>=Auto_delta & ((SWR_fixed>SWR_fixed_old & (SWR_fixed-SWR_fixed_old)>delta) | (SWR_fixed<SWR_fixed_old & (SWR_fixed_old-SWR_fixed)>delta) | SWR_fixed_old==999))
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R5
	MOVLW      128
	XORWF      _Auto_delta+1, 0
	SUBWF      R5, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr234
	MOVF       _Auto_delta+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr234:
	MOVLW      1
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R5
	MOVLW      128
	XORWF      _SWR_fixed_old+1, 0
	MOVWF      R3
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	SUBWF      R3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr235
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBWF      _SWR_fixed_old+0, 0
L__watch_swr235:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R3
	MOVF       _SWR_fixed_old+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
	MOVWF      R1
	MOVF       _SWR_fixed_old+1, 0
	SUBWFB     watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R2
	MOVLW      128
	XORWF      watch_swr_delta_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr236
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr236:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	ANDWF      R3, 0
	MOVWF      R4
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R3
	MOVLW      128
	XORWF      _SWR_fixed_old+1, 0
	SUBWF      R3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr237
	MOVF       _SWR_fixed_old+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr237:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R3
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBWF      _SWR_fixed_old+0, 0
	MOVWF      R1
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	SUBWFB     _SWR_fixed_old+1, 0
	MOVWF      R2
	MOVLW      128
	XORWF      watch_swr_delta_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr238
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr238:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R3, 0
	ANDWF      R0, 1
	MOVF       R0, 0
	IORWF       R4, 0
	MOVWF      R1
	MOVF       _SWR_fixed_old+1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr239
	MOVLW      231
	XORWF      _SWR_fixed_old+0, 0
L__watch_swr239:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	MOVF       R5, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr45
;main.c,210 :: 		{ Tune(); Voltage_old = 9999; volt_cnt = Tick; watch_cnt = Tick; }
	CALL       _tune+0
	MOVLW      15
	MOVWF      _Voltage_old+0
	MOVLW      39
	MOVWF      _Voltage_old+1
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
L_watch_swr45:
;main.c,213 :: 		return;
;main.c,214 :: 		}
L_end_watch_swr:
	RETURN
; end of _watch_swr

_draw_swr:

;main.c,216 :: 		void draw_swr(int s){
;main.c,217 :: 		if(s==0)
	MOVLW      0
	XORWF      FARG_draw_swr_s+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_swr241
	MOVLW      0
	XORWF      FARG_draw_swr_s+0, 0
L__draw_swr241:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_swr46
;main.c,218 :: 		oled_wr_str(2, 60, "0.00", 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr11_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr11_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
	GOTO       L_draw_swr47
L_draw_swr46:
;main.c,220 :: 		IntToStr(s, txt_2);
	MOVF       FARG_draw_swr_s+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_swr_s+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,221 :: 		txt[0] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+0
;main.c,222 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,223 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,224 :: 		txt[3] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+3
;main.c,226 :: 		oled_wr_str(2, 60, txt, 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      _txt+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(_txt+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,227 :: 		}
L_draw_swr47:
;main.c,228 :: 		return;
;main.c,229 :: 		}
L_end_draw_swr:
	RETURN
; end of _draw_swr

_draw_power:

;main.c,231 :: 		void draw_power(int p){
;main.c,233 :: 		if(p==0){
	MOVLW      0
	XORWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power243
	MOVLW      0
	XORWF      FARG_draw_power_p+0, 0
L__draw_power243:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_power48
;main.c,234 :: 		oled_wr_str(0, 60, "0.0", 3);
	CLRF       FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr12_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr12_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      3
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,235 :: 		return;
	GOTO       L_end_draw_power
;main.c,236 :: 		}
L_draw_power48:
;main.c,237 :: 		else if(p<10){  // <1 W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power244
	MOVLW      10
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power244:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power50
;main.c,238 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,239 :: 		txt[0] = '0';
	MOVLW      48
	MOVWF      _txt+0
;main.c,240 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,241 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,242 :: 		}
	GOTO       L_draw_power51
L_draw_power50:
;main.c,243 :: 		else if(p<100){ // <10W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power245
	MOVLW      100
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power245:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power52
;main.c,244 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,245 :: 		txt[0] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+0
;main.c,246 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,247 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,248 :: 		}
	GOTO       L_draw_power53
L_draw_power52:
;main.c,250 :: 		p += 5;
	MOVLW      5
	ADDWF      FARG_draw_power_p+0, 0
	MOVWF      R0
	MOVLW      0
	ADDWFC     FARG_draw_power_p+1, 0
	MOVWF      R1
	MOVF       R0, 0
	MOVWF      FARG_draw_power_p+0
	MOVF       R1, 0
	MOVWF      FARG_draw_power_p+1
;main.c,251 :: 		IntToStr(p, txt_2);
	MOVF       R0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,252 :: 		txt[0] = ' ';
	MOVLW      32
	MOVWF      _txt+0
;main.c,253 :: 		txt[1] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+1
;main.c,254 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,255 :: 		}
L_draw_power53:
L_draw_power51:
;main.c,256 :: 		oled_wr_str(0, 60, txt, 3);
	CLRF       FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      _txt+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(_txt+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      3
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,257 :: 		return;
;main.c,258 :: 		}
L_end_draw_power:
	RETURN
; end of _draw_power

_Voltage_show:

;main.c,260 :: 		void Voltage_show(){
;main.c,261 :: 		get_batt();
	CALL       _get_batt+0
;main.c,262 :: 		if(Voltage != Voltage_old) { Voltage_old = Voltage; oled_voltage(Voltage); }
	MOVF       _Voltage+1, 0
	XORWF      _Voltage_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show247
	MOVF       _Voltage_old+0, 0
	XORWF      _Voltage+0, 0
L__Voltage_show247:
	BTFSC      STATUS+0, 2
	GOTO       L_Voltage_show54
	MOVF       _Voltage+0, 0
	MOVWF      _Voltage_old+0
	MOVF       _Voltage+1, 0
	MOVWF      _Voltage_old+1
	MOVF       _Voltage+0, 0
	MOVWF      FARG_oled_voltage+0
	MOVF       _Voltage+1, 0
	MOVWF      FARG_oled_voltage+1
	CALL       _oled_voltage+0
L_Voltage_show54:
;main.c,264 :: 		if(Voltage>3700){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show248
	MOVF       _Voltage+0, 0
	SUBLW      116
L__Voltage_show248:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show55
;main.c,265 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,266 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,267 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show56:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show56
	DECFSZ     R12, 1
	GOTO       L_Voltage_show56
	DECFSZ     R11, 1
	GOTO       L_Voltage_show56
;main.c,268 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,269 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,270 :: 		}
	GOTO       L_Voltage_show57
L_Voltage_show55:
;main.c,271 :: 		else if(Voltage>3590){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show249
	MOVF       _Voltage+0, 0
	SUBLW      6
L__Voltage_show249:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show58
;main.c,272 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,273 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,274 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show59:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show59
	DECFSZ     R12, 1
	GOTO       L_Voltage_show59
	DECFSZ     R11, 1
	GOTO       L_Voltage_show59
;main.c,275 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,276 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,277 :: 		}
	GOTO       L_Voltage_show60
L_Voltage_show58:
;main.c,279 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,280 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,281 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show61:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show61
	DECFSZ     R12, 1
	GOTO       L_Voltage_show61
	DECFSZ     R11, 1
	GOTO       L_Voltage_show61
;main.c,282 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,283 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,284 :: 		}
L_Voltage_show60:
L_Voltage_show57:
;main.c,286 :: 		if(Voltage<3400){
	MOVLW      128
	XORWF      _Voltage+1, 0
	MOVWF      R0
	MOVLW      128
	XORLW      13
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show250
	MOVLW      72
	SUBWF      _Voltage+0, 0
L__Voltage_show250:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show62
;main.c,287 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,288 :: 		oled_wr_str(1, 0, "  LOW BATT ", 11);
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr13_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr13_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      11
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,289 :: 		Delay_ms(3000);
	MOVLW      122
	MOVWF      R11
	MOVLW      193
	MOVWF      R12
	MOVLW      129
	MOVWF      R13
L_Voltage_show63:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show63
	DECFSZ     R12, 1
	GOTO       L_Voltage_show63
	DECFSZ     R11, 1
	GOTO       L_Voltage_show63
	NOP
	NOP
;main.c,290 :: 		Sleep = 1;
	BSF        _Sleep+0, BitPos(_Sleep+0)
;main.c,291 :: 		Sleep_mode();
	CALL       _Sleep_mode+0
;main.c,292 :: 		off_cnt = Tick; // go to power off  immediatelly after sleep
	MOVF       _Tick+0, 0
	MOVWF      _off_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,293 :: 		}
L_Voltage_show62:
;main.c,294 :: 		return;
;main.c,295 :: 		}
L_end_Voltage_show:
	RETURN
; end of _Voltage_show

_Btn_long:

;main.c,299 :: 		void Btn_long(){
;main.c,300 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,301 :: 		oled_wr_str(2, 0, "TUNE     ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr14_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr14_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,302 :: 		tune();
	CALL       _tune+0
;main.c,303 :: 		oled_wr_str(2, 0, "SWR ", 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr15_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr15_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,304 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr16_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr16_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,305 :: 		draw_swr(SWR);
	MOVF       _SWR+0, 0
	MOVWF      FARG_draw_swr_s+0
	MOVF       _SWR+1, 0
	MOVWF      FARG_draw_swr_s+1
	CALL       _draw_swr+0
;main.c,306 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,307 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,308 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,309 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,310 :: 		return;
;main.c,311 :: 		}
L_end_Btn_long:
	RETURN
; end of _Btn_long

_Btn_short:

;main.c,313 :: 		void Btn_short(){
;main.c,314 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,315 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,316 :: 		oled_wr_str(2, 0, "RESET    ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr17_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr17_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,317 :: 		Delay_ms(600);
	MOVLW      25
	MOVWF      R11
	MOVLW      90
	MOVWF      R12
	MOVLW      177
	MOVWF      R13
L_Btn_short64:
	DECFSZ     R13, 1
	GOTO       L_Btn_short64
	DECFSZ     R12, 1
	GOTO       L_Btn_short64
	DECFSZ     R11, 1
	GOTO       L_Btn_short64
	NOP
	NOP
;main.c,318 :: 		oled_wr_str(2, 0, "SWR  ", 5);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr18_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr18_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      5
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,319 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr19_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr19_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,320 :: 		oled_wr_str(2, 60, "0.00", 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr20_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr20_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,321 :: 		Delay_ms(300);
	MOVLW      13
	MOVWF      R11
	MOVLW      45
	MOVWF      R12
	MOVLW      215
	MOVWF      R13
L_Btn_short65:
	DECFSZ     R13, 1
	GOTO       L_Btn_short65
	DECFSZ     R12, 1
	GOTO       L_Btn_short65
	DECFSZ     R11, 1
	GOTO       L_Btn_short65
	NOP
	NOP
;main.c,322 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,323 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,324 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,325 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,326 :: 		return;
;main.c,327 :: 		}
L_end_Btn_short:
	RETURN
; end of _Btn_short

_Btn_xlong:

;main.c,329 :: 		void Btn_xlong(){
;main.c,330 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,331 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,332 :: 		oled_wr_str_s(0, 0, " DESIGNED BY N7DDC", 18);
	CLRF       FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr21_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr21_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      18
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,333 :: 		oled_wr_str_s(2, 0, " FW VERSION ", 12);
	MOVLW      2
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr22_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr22_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,334 :: 		oled_wr_str_s(2, 12*7, FW_VER, 3);
	MOVLW      2
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      84
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      ?lstr23_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr23_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      3
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,335 :: 		Delay_ms(5000);
	MOVLW      203
	MOVWF      R11
	MOVLW      236
	MOVWF      R12
	MOVLW      132
	MOVWF      R13
L_Btn_xlong66:
	DECFSZ     R13, 1
	GOTO       L_Btn_xlong66
	DECFSZ     R12, 1
	GOTO       L_Btn_xlong66
	DECFSZ     R11, 1
	GOTO       L_Btn_xlong66
	NOP
;main.c,336 :: 		while(GetButton){}
L_Btn_xlong67:
	BTFSC      PORTB+0, 5
	GOTO       L__Btn_xlong254
	BSF        3, 0
	GOTO       L__Btn_xlong255
L__Btn_xlong254:
	BCF        3, 0
L__Btn_xlong255:
	BTFSS      3, 0
	GOTO       L_Btn_xlong68
	GOTO       L_Btn_xlong67
L_Btn_xlong68:
;main.c,337 :: 		oled_start();
	CALL       _oled_start+0
;main.c,338 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,339 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,340 :: 		Voltage_old = 9999;
	MOVLW      15
	MOVWF      _Voltage_old+0
	MOVLW      39
	MOVWF      _Voltage_old+1
;main.c,341 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,342 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,343 :: 		Sleep_cnt = Tick + Sleep_time*1000;
	MOVF       _Sleep_time+0, 0
	MOVWF      R0
	MOVF       _Sleep_time+1, 0
	MOVWF      R1
	MOVF       _Sleep_time+2, 0
	MOVWF      R2
	MOVF       _Sleep_time+3, 0
	MOVWF      R3
	MOVLW      232
	MOVWF      R4
	MOVLW      3
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	CALL       _Mul_32x32_U+0
	MOVF       R0, 0
	ADDWF      _Tick+0, 0
	MOVWF      _sleep_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _sleep_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _sleep_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _sleep_cnt+3
;main.c,344 :: 		return;
;main.c,345 :: 		}
L_end_Btn_xlong:
	RETURN
; end of _Btn_xlong

_atu_reset:

;main.c,347 :: 		void atu_reset(){
;main.c,348 :: 		ind = 0;
	CLRF       _ind+0
;main.c,349 :: 		cap = 0;
	CLRF       _cap+0
;main.c,350 :: 		SW = 0;
	CLRF       _SW+0
;main.c,351 :: 		Relay_set(ind, cap, SW);
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CALL       _Relay_set+0
;main.c,352 :: 		return;
;main.c,353 :: 		}
L_end_atu_reset:
	RETURN
; end of _atu_reset

_Relay_set:

;main.c,355 :: 		void Relay_set(char L, char C, char I){
;main.c,356 :: 		L_010 = ~L.B0;
	BTFSC      FARG_Relay_set_L+0, 0
	GOTO       L__Relay_set258
	BSF        LATD7_bit+0, BitPos(LATD7_bit+0)
	GOTO       L__Relay_set259
L__Relay_set258:
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
L__Relay_set259:
;main.c,357 :: 		L_022 = ~L.B1;
	BTFSC      FARG_Relay_set_L+0, 1
	GOTO       L__Relay_set260
	BSF        LATD6_bit+0, BitPos(LATD6_bit+0)
	GOTO       L__Relay_set261
L__Relay_set260:
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
L__Relay_set261:
;main.c,358 :: 		L_045 = ~L.B2;
	BTFSC      FARG_Relay_set_L+0, 2
	GOTO       L__Relay_set262
	BSF        LATD5_bit+0, BitPos(LATD5_bit+0)
	GOTO       L__Relay_set263
L__Relay_set262:
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
L__Relay_set263:
;main.c,359 :: 		L_100 = ~L.B3;
	BTFSC      FARG_Relay_set_L+0, 3
	GOTO       L__Relay_set264
	BSF        LATD4_bit+0, BitPos(LATD4_bit+0)
	GOTO       L__Relay_set265
L__Relay_set264:
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
L__Relay_set265:
;main.c,360 :: 		L_220 = ~L.B4;
	BTFSC      FARG_Relay_set_L+0, 4
	GOTO       L__Relay_set266
	BSF        LATC7_bit+0, BitPos(LATC7_bit+0)
	GOTO       L__Relay_set267
L__Relay_set266:
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
L__Relay_set267:
;main.c,361 :: 		L_450 = ~L.B5;
	BTFSC      FARG_Relay_set_L+0, 5
	GOTO       L__Relay_set268
	BSF        LATC6_bit+0, BitPos(LATC6_bit+0)
	GOTO       L__Relay_set269
L__Relay_set268:
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
L__Relay_set269:
;main.c,362 :: 		L_1000 = ~L.B6;
	BTFSC      FARG_Relay_set_L+0, 6
	GOTO       L__Relay_set270
	BSF        LATC5_bit+0, BitPos(LATC5_bit+0)
	GOTO       L__Relay_set271
L__Relay_set270:
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
L__Relay_set271:
;main.c,364 :: 		C_22 = ~C.B0;
	BTFSC      FARG_Relay_set_C+0, 0
	GOTO       L__Relay_set272
	BSF        LATA5_bit+0, BitPos(LATA5_bit+0)
	GOTO       L__Relay_set273
L__Relay_set272:
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
L__Relay_set273:
;main.c,365 :: 		C_47 = ~C.B1;
	BTFSC      FARG_Relay_set_C+0, 1
	GOTO       L__Relay_set274
	BSF        LATE1_bit+0, BitPos(LATE1_bit+0)
	GOTO       L__Relay_set275
L__Relay_set274:
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
L__Relay_set275:
;main.c,366 :: 		C_100 = ~C.B2;
	BTFSC      FARG_Relay_set_C+0, 2
	GOTO       L__Relay_set276
	BSF        LATA7_bit+0, BitPos(LATA7_bit+0)
	GOTO       L__Relay_set277
L__Relay_set276:
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
L__Relay_set277:
;main.c,367 :: 		C_220 = ~C.B3;
	BTFSC      FARG_Relay_set_C+0, 3
	GOTO       L__Relay_set278
	BSF        LATA6_bit+0, BitPos(LATA6_bit+0)
	GOTO       L__Relay_set279
L__Relay_set278:
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
L__Relay_set279:
;main.c,368 :: 		C_470 = ~C.B4;
	BTFSC      FARG_Relay_set_C+0, 4
	GOTO       L__Relay_set280
	BSF        LATC0_bit+0, BitPos(LATC0_bit+0)
	GOTO       L__Relay_set281
L__Relay_set280:
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
L__Relay_set281:
;main.c,369 :: 		C_1000 = ~C.B5;
	BTFSC      FARG_Relay_set_C+0, 5
	GOTO       L__Relay_set282
	BSF        LATC1_bit+0, BitPos(LATC1_bit+0)
	GOTO       L__Relay_set283
L__Relay_set282:
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
L__Relay_set283:
;main.c,370 :: 		C_2200 = ~C.B6;
	BTFSC      FARG_Relay_set_C+0, 6
	GOTO       L__Relay_set284
	BSF        LATC2_bit+0, BitPos(LATC2_bit+0)
	GOTO       L__Relay_set285
L__Relay_set284:
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
L__Relay_set285:
;main.c,372 :: 		C_sw = I;
	BTFSC      FARG_Relay_set_I+0, 0
	GOTO       L__Relay_set286
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
	GOTO       L__Relay_set287
L__Relay_set286:
	BSF        LATE0_bit+0, BitPos(LATE0_bit+0)
L__Relay_set287:
;main.c,374 :: 		Rel_to_gnd = 1;
	BSF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,375 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,376 :: 		Rel_to_gnd = 0;
	BCF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,377 :: 		Delay_us(10);
	MOVLW      26
	MOVWF      R13
L_Relay_set69:
	DECFSZ     R13, 1
	GOTO       L_Relay_set69
	NOP
;main.c,378 :: 		Rel_to_plus_N = 0;
	BCF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,379 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,380 :: 		Rel_to_plus_N = 1;
	BSF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,381 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,383 :: 		return;
;main.c,384 :: 		}
L_end_Relay_set:
	RETURN
; end of _Relay_set

_power_off:

;main.c,386 :: 		void power_off(void){
;main.c,389 :: 		GIE_bit = 0;
	BCF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,390 :: 		T0EN_bit = 0;
	BCF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,391 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;main.c,393 :: 		L_010 = 0;
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
;main.c,394 :: 		L_022 = 0;
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
;main.c,395 :: 		L_045 = 0;
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
;main.c,396 :: 		L_100 = 0;
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
;main.c,397 :: 		L_220 = 0;
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
;main.c,398 :: 		L_450 = 0;
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
;main.c,399 :: 		L_1000 = 0;
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
;main.c,401 :: 		C_22 = 0;
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
;main.c,402 :: 		C_47 = 0;
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
;main.c,403 :: 		C_100 = 0;
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
;main.c,404 :: 		C_220 = 0;
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
;main.c,405 :: 		C_470 = 0;
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
;main.c,406 :: 		C_1000 = 0;
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
;main.c,407 :: 		C_2200 = 0;
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
;main.c,409 :: 		C_sw = 0;
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
;main.c,410 :: 		SYSCMD_bit = 1;
	BSF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,412 :: 		btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
;main.c,413 :: 		while(1){
L_power_off70:
;main.c,414 :: 		if(btn_cnt==0) { Delay_us(100); IOCBF5_bit = 0; asm sleep; }
	MOVF       power_off_btn_cnt_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_power_off72
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_power_off73:
	DECFSZ     R13, 1
	GOTO       L_power_off73
	DECFSZ     R12, 1
	GOTO       L_power_off73
	NOP
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
	SLEEP
L_power_off72:
;main.c,415 :: 		asm NOP;
	NOP
;main.c,416 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_power_off74:
	DECFSZ     R13, 1
	GOTO       L_power_off74
	DECFSZ     R12, 1
	GOTO       L_power_off74
	NOP
;main.c,417 :: 		if(GetButton) btn_cnt++;
	BTFSC      PORTB+0, 5
	GOTO       L__power_off289
	BSF        3, 0
	GOTO       L__power_off290
L__power_off289:
	BCF        3, 0
L__power_off290:
	BTFSS      3, 0
	GOTO       L_power_off75
	INCF       power_off_btn_cnt_L0+0, 1
	GOTO       L_power_off76
L_power_off75:
;main.c,418 :: 		else btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
L_power_off76:
;main.c,419 :: 		if(btn_cnt>13) break;
	MOVF       power_off_btn_cnt_L0+0, 0
	SUBLW      13
	BTFSC      STATUS+0, 0
	GOTO       L_power_off77
	GOTO       L_power_off71
L_power_off77:
;main.c,420 :: 		}
	GOTO       L_power_off70
L_power_off71:
;main.c,422 :: 		SYSCMD_bit = 0;
	BCF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,424 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,425 :: 		T0EN_bit = 1;
	BSF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,426 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,428 :: 		Sleep = 0;
	BCF        _Sleep+0, BitPos(_Sleep+0)
;main.c,429 :: 		Sleep_mode();
	CALL       _Sleep_mode+0
;main.c,430 :: 		while(GetButton){asm NOP;}
L_power_off78:
	BTFSC      PORTB+0, 5
	GOTO       L__power_off291
	BSF        3, 0
	GOTO       L__power_off292
L__power_off291:
	BCF        3, 0
L__power_off292:
	BTFSS      3, 0
	GOTO       L_power_off79
	NOP
	GOTO       L_power_off78
L_power_off79:
;main.c,431 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,432 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,433 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,434 :: 		return;
;main.c,435 :: 		}
L_end_power_off:
	RETURN
; end of _power_off

_check_reset_flags:

;main.c,438 :: 		void check_reset_flags(void){
;main.c,439 :: 		char i = 0;
	CLRF       check_reset_flags_i_L0+0
;main.c,440 :: 		if(STKOVF_bit){oled_wr_str_s(0,  0, "Stack overflow",  14); i = 1;}
	BTFSS      STKOVF_bit+0, BitPos(STKOVF_bit+0)
	GOTO       L_check_reset_flags80
	CLRF       FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr24_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr24_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      14
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags80:
;main.c,441 :: 		if(STKUNF_bit){oled_wr_str_s(1,  0, "Stack underflow", 15); i = 1;}
	BTFSS      STKUNF_bit+0, BitPos(STKUNF_bit+0)
	GOTO       L_check_reset_flags81
	MOVLW      1
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr25_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr25_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      15
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags81:
;main.c,442 :: 		if(!nRWDT_bit){oled_wr_str_s(2,  0, "WDT overflow",    12); i = 1;}
	BTFSC      nRWDT_bit+0, BitPos(nRWDT_bit+0)
	GOTO       L_check_reset_flags82
	MOVLW      2
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr26_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr26_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags82:
;main.c,443 :: 		if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ",    12); i = 1;}
	BTFSC      nRMCLR_bit+0, BitPos(nRMCLR_bit+0)
	GOTO       L_check_reset_flags83
	MOVLW      3
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr27_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr27_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags83:
;main.c,444 :: 		if(!nBOR_bit){oled_wr_str_s(4,   0, "BOR reset  ",     12); i = 1;}
	BTFSC      nBOR_bit+0, BitPos(nBOR_bit+0)
	GOTO       L_check_reset_flags84
	MOVLW      4
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr28_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr28_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags84:
;main.c,445 :: 		if(i){
	MOVF       check_reset_flags_i_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_check_reset_flags85
;main.c,446 :: 		Delay_ms(5000);
	MOVLW      203
	MOVWF      R11
	MOVLW      236
	MOVWF      R12
	MOVLW      132
	MOVWF      R13
L_check_reset_flags86:
	DECFSZ     R13, 1
	GOTO       L_check_reset_flags86
	DECFSZ     R12, 1
	GOTO       L_check_reset_flags86
	DECFSZ     R11, 1
	GOTO       L_check_reset_flags86
	NOP
;main.c,447 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,448 :: 		}
L_check_reset_flags85:
;main.c,449 :: 		return;
;main.c,450 :: 		}
L_end_check_reset_flags:
	RETURN
; end of _check_reset_flags

_correction:

;main.c,452 :: 		int correction(int input) {
;main.c,453 :: 		input *= 2;
	MOVF       FARG_correction_input+0, 0
	MOVWF      R1
	MOVF       FARG_correction_input+1, 0
	MOVWF      R2
	LSLF       R1, 1
	RLF        R2, 1
	MOVF       R1, 0
	MOVWF      FARG_correction_input+0
	MOVF       R2, 0
	MOVWF      FARG_correction_input+1
;main.c,455 :: 		if(input <= 588) input += 376;
	MOVLW      128
	XORLW      2
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction295
	MOVF       R1, 0
	SUBLW      76
L__correction295:
	BTFSS      STATUS+0, 0
	GOTO       L_correction87
	MOVLW      120
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction88
L_correction87:
;main.c,456 :: 		else if(input <= 882) input += 400;
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction296
	MOVF       FARG_correction_input+0, 0
	SUBLW      114
L__correction296:
	BTFSS      STATUS+0, 0
	GOTO       L_correction89
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction90
L_correction89:
;main.c,457 :: 		else if(input <= 1313) input += 476;
	MOVLW      128
	XORLW      5
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction297
	MOVF       FARG_correction_input+0, 0
	SUBLW      33
L__correction297:
	BTFSS      STATUS+0, 0
	GOTO       L_correction91
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction92
L_correction91:
;main.c,458 :: 		else if(input <= 1900) input += 514;
	MOVLW      128
	XORLW      7
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction298
	MOVF       FARG_correction_input+0, 0
	SUBLW      108
L__correction298:
	BTFSS      STATUS+0, 0
	GOTO       L_correction93
	MOVLW      2
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction94
L_correction93:
;main.c,459 :: 		else if(input <= 2414) input += 568;
	MOVLW      128
	XORLW      9
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction299
	MOVF       FARG_correction_input+0, 0
	SUBLW      110
L__correction299:
	BTFSS      STATUS+0, 0
	GOTO       L_correction95
	MOVLW      56
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction96
L_correction95:
;main.c,460 :: 		else if(input <= 2632) input += 644;
	MOVLW      128
	XORLW      10
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction300
	MOVF       FARG_correction_input+0, 0
	SUBLW      72
L__correction300:
	BTFSS      STATUS+0, 0
	GOTO       L_correction97
	MOVLW      132
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction98
L_correction97:
;main.c,461 :: 		else if(input <= 2942) input += 732;
	MOVLW      128
	XORLW      11
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction301
	MOVF       FARG_correction_input+0, 0
	SUBLW      126
L__correction301:
	BTFSS      STATUS+0, 0
	GOTO       L_correction99
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction100
L_correction99:
;main.c,462 :: 		else if(input <= 3232) input += 784;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction302
	MOVF       FARG_correction_input+0, 0
	SUBLW      160
L__correction302:
	BTFSS      STATUS+0, 0
	GOTO       L_correction101
	MOVLW      16
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction102
L_correction101:
;main.c,463 :: 		else if(input <= 3324) input += 992;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction303
	MOVF       FARG_correction_input+0, 0
	SUBLW      252
L__correction303:
	BTFSS      STATUS+0, 0
	GOTO       L_correction103
	MOVLW      224
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction104
L_correction103:
;main.c,464 :: 		else if(input <= 3720) input += 1000;
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction304
	MOVF       FARG_correction_input+0, 0
	SUBLW      136
L__correction304:
	BTFSS      STATUS+0, 0
	GOTO       L_correction105
	MOVLW      232
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction106
L_correction105:
;main.c,465 :: 		else if(input <= 4340) input += 1160;
	MOVLW      128
	XORLW      16
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction305
	MOVF       FARG_correction_input+0, 0
	SUBLW      244
L__correction305:
	BTFSS      STATUS+0, 0
	GOTO       L_correction107
	MOVLW      136
	ADDWF      FARG_correction_input+0, 1
	MOVLW      4
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction108
L_correction107:
;main.c,466 :: 		else if(input <= 4808) input += 1360;
	MOVLW      128
	XORLW      18
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction306
	MOVF       FARG_correction_input+0, 0
	SUBLW      200
L__correction306:
	BTFSS      STATUS+0, 0
	GOTO       L_correction109
	MOVLW      80
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction110
L_correction109:
;main.c,467 :: 		else if(input <= 5272) input += 1424;
	MOVLW      128
	XORLW      20
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction307
	MOVF       FARG_correction_input+0, 0
	SUBLW      152
L__correction307:
	BTFSS      STATUS+0, 0
	GOTO       L_correction111
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction112
L_correction111:
;main.c,468 :: 		else  input += 1432;
	MOVLW      152
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
L_correction112:
L_correction110:
L_correction108:
L_correction106:
L_correction104:
L_correction102:
L_correction100:
L_correction98:
L_correction96:
L_correction94:
L_correction92:
L_correction90:
L_correction88:
;main.c,470 :: 		return input;
	MOVF       FARG_correction_input+0, 0
	MOVWF      R0
	MOVF       FARG_correction_input+1, 0
	MOVWF      R1
;main.c,471 :: 		}
L_end_correction:
	RETURN
; end of _correction

_get_reverse:

;main.c,473 :: 		int get_reverse(void){
;main.c,476 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,477 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse113:
	DECFSZ     R13, 1
	GOTO       L_get_reverse113
	DECFSZ     R12, 1
	GOTO       L_get_reverse113
	NOP
;main.c,478 :: 		v = ADC_Get_Sample(REV_input);
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,479 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse309
	MOVLW      255
	XORWF      R0, 0
L__get_reverse309:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse114
;main.c,480 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,481 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse115:
	DECFSZ     R13, 1
	GOTO       L_get_reverse115
	DECFSZ     R12, 1
	GOTO       L_get_reverse115
	NOP
;main.c,482 :: 		v = ADC_Get_Sample(REV_input) * 2;
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
	LSLF       get_reverse_v_L0+0, 1
	RLF        get_reverse_v_L0+1, 1
;main.c,483 :: 		}
L_get_reverse114:
;main.c,484 :: 		if(v==1023*2){
	MOVF       get_reverse_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse310
	MOVLW      254
	XORWF      get_reverse_v_L0+0, 0
L__get_reverse310:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse116
;main.c,485 :: 		get_batt();
	CALL       _get_batt+0
;main.c,486 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,487 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse117:
	DECFSZ     R13, 1
	GOTO       L_get_reverse117
	DECFSZ     R12, 1
	GOTO       L_get_reverse117
	NOP
;main.c,488 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      FLOC__get_reverse+4
	MOVF       R1, 0
	MOVWF      FLOC__get_reverse+5
	MOVF       FLOC__get_reverse+4, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       FLOC__get_reverse+5, 0
	MOVWF      get_reverse_v_L0+1
;main.c,489 :: 		f = Voltage / 1024;
	MOVLW      0
	MOVWF      R4
	MOVLW      4
	MOVWF      R5
	MOVF       _Voltage+0, 0
	MOVWF      R0
	MOVF       _Voltage+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	CALL       _int2double+0
	MOVF       R0, 0
	MOVWF      FLOC__get_reverse+0
	MOVF       R1, 0
	MOVWF      FLOC__get_reverse+1
	MOVF       R2, 0
	MOVWF      FLOC__get_reverse+2
	MOVF       R3, 0
	MOVWF      FLOC__get_reverse+3
	MOVF       FLOC__get_reverse+4, 0
	MOVWF      R0
	MOVF       FLOC__get_reverse+5, 0
	MOVWF      R1
	CALL       _int2double+0
;main.c,490 :: 		v = v * f;
	MOVF       FLOC__get_reverse+0, 0
	MOVWF      R4
	MOVF       FLOC__get_reverse+1, 0
	MOVWF      R5
	MOVF       FLOC__get_reverse+2, 0
	MOVWF      R6
	MOVF       FLOC__get_reverse+3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,491 :: 		}
L_get_reverse116:
;main.c,492 :: 		return v;
	MOVF       get_reverse_v_L0+0, 0
	MOVWF      R0
	MOVF       get_reverse_v_L0+1, 0
	MOVWF      R1
;main.c,493 :: 		}
L_end_get_reverse:
	RETURN
; end of _get_reverse

_get_forward:

;main.c,495 :: 		int get_forward(void){
;main.c,498 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,499 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward118:
	DECFSZ     R13, 1
	GOTO       L_get_forward118
	DECFSZ     R12, 1
	GOTO       L_get_forward118
	NOP
;main.c,500 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,501 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward312
	MOVLW      255
	XORWF      R0, 0
L__get_forward312:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward119
;main.c,502 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,503 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward120:
	DECFSZ     R13, 1
	GOTO       L_get_forward120
	DECFSZ     R12, 1
	GOTO       L_get_forward120
	NOP
;main.c,504 :: 		v = ADC_Get_Sample(FWD_input) * 2;
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
	LSLF       get_forward_v_L0+0, 1
	RLF        get_forward_v_L0+1, 1
;main.c,505 :: 		}
L_get_forward119:
;main.c,506 :: 		if(v==1023*2){
	MOVF       get_forward_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward313
	MOVLW      254
	XORWF      get_forward_v_L0+0, 0
L__get_forward313:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward121
;main.c,507 :: 		get_batt();
	CALL       _get_batt+0
;main.c,508 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,509 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward122:
	DECFSZ     R13, 1
	GOTO       L_get_forward122
	DECFSZ     R12, 1
	GOTO       L_get_forward122
	NOP
;main.c,510 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,511 :: 		if(v==1023) Overflow = 1;
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward314
	MOVLW      255
	XORWF      R0, 0
L__get_forward314:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward123
	BSF        _Overflow+0, BitPos(_Overflow+0)
L_get_forward123:
;main.c,512 :: 		f = Voltage / 1024;
	MOVLW      0
	MOVWF      R4
	MOVLW      4
	MOVWF      R5
	MOVF       _Voltage+0, 0
	MOVWF      R0
	MOVF       _Voltage+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	CALL       _int2double+0
	MOVF       R0, 0
	MOVWF      FLOC__get_forward+0
	MOVF       R1, 0
	MOVWF      FLOC__get_forward+1
	MOVF       R2, 0
	MOVWF      FLOC__get_forward+2
	MOVF       R3, 0
	MOVWF      FLOC__get_forward+3
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R0
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R1
	CALL       _int2double+0
;main.c,513 :: 		v = v * f;
	MOVF       FLOC__get_forward+0, 0
	MOVWF      R4
	MOVF       FLOC__get_forward+1, 0
	MOVWF      R5
	MOVF       FLOC__get_forward+2, 0
	MOVWF      R6
	MOVF       FLOC__get_forward+3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,514 :: 		}
L_get_forward121:
;main.c,515 :: 		return v;
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R0
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R1
;main.c,516 :: 		}
L_end_get_forward:
	RETURN
; end of _get_forward

_get_pwr:

;main.c,519 :: 		void get_pwr(){
;main.c,523 :: 		Forward = get_forward();
	CALL       _get_forward+0
	MOVF       R0, 0
	MOVWF      get_pwr_Forward_L0+0
	MOVF       R1, 0
	MOVWF      get_pwr_Forward_L0+1
	MOVLW      0
	BTFSC      get_pwr_Forward_L0+1, 7
	MOVLW      255
	MOVWF      get_pwr_Forward_L0+2
	MOVWF      get_pwr_Forward_L0+3
;main.c,524 :: 		Reverse = get_reverse();
	CALL       _get_reverse+0
	MOVF       R0, 0
	MOVWF      get_pwr_Reverse_L0+0
	MOVF       R1, 0
	MOVWF      get_pwr_Reverse_L0+1
	MOVLW      0
	BTFSC      get_pwr_Reverse_L0+1, 7
	MOVLW      255
	MOVWF      get_pwr_Reverse_L0+2
	MOVWF      get_pwr_Reverse_L0+3
;main.c,526 :: 		p = correction(Forward);
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      FARG_correction_input+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      FARG_correction_input+1
	CALL       _correction+0
	CALL       _int2double+0
;main.c,527 :: 		P = p * 5 / 1000;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      32
	MOVWF      R6
	MOVLW      129
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      122
	MOVWF      R6
	MOVLW      136
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,528 :: 		p = p / 1.414;
	MOVLW      244
	MOVWF      R4
	MOVLW      253
	MOVWF      R5
	MOVLW      52
	MOVWF      R6
	MOVLW      127
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,529 :: 		p = p * p;
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
;main.c,530 :: 		p = p / 5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      32
	MOVWF      R6
	MOVLW      129
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,531 :: 		p += 0.5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      126
	MOVWF      R7
	CALL       _Add_32x32_FP+0
;main.c,532 :: 		PWR = p;
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      _PWR+0
	MOVF       R1, 0
	MOVWF      _PWR+1
;main.c,534 :: 		if(Reverse >= Forward)
	MOVLW      128
	XORWF      get_pwr_Reverse_L0+3, 0
	MOVWF      R0
	MOVLW      128
	XORWF      get_pwr_Forward_L0+3, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr316
	MOVF       get_pwr_Forward_L0+2, 0
	SUBWF      get_pwr_Reverse_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr316
	MOVF       get_pwr_Forward_L0+1, 0
	SUBWF      get_pwr_Reverse_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr316
	MOVF       get_pwr_Forward_L0+0, 0
	SUBWF      get_pwr_Reverse_L0+0, 0
L__get_pwr316:
	BTFSS      STATUS+0, 0
	GOTO       L_get_pwr124
;main.c,535 :: 		Forward = 999;
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
	GOTO       L_get_pwr125
L_get_pwr124:
;main.c,537 :: 		Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
	MOVF       get_pwr_Reverse_L0+0, 0
	ADDWF      get_pwr_Forward_L0+0, 0
	MOVWF      R0
	MOVF       get_pwr_Reverse_L0+1, 0
	ADDWFC     get_pwr_Forward_L0+1, 0
	MOVWF      R1
	MOVF       get_pwr_Reverse_L0+2, 0
	ADDWFC     get_pwr_Forward_L0+2, 0
	MOVWF      R2
	MOVF       get_pwr_Reverse_L0+3, 0
	ADDWFC     get_pwr_Forward_L0+3, 0
	MOVWF      R3
	MOVLW      100
	MOVWF      R4
	CLRF       R5
	CLRF       R6
	CLRF       R7
	CALL       _Mul_32x32_U+0
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      R4
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      R5
	MOVF       get_pwr_Forward_L0+2, 0
	MOVWF      R6
	MOVF       get_pwr_Forward_L0+3, 0
	MOVWF      R7
	MOVF       get_pwr_Reverse_L0+0, 0
	SUBWF      R4, 1
	MOVF       get_pwr_Reverse_L0+1, 0
	SUBWFB     R5, 1
	MOVF       get_pwr_Reverse_L0+2, 0
	SUBWFB     R6, 1
	MOVF       get_pwr_Reverse_L0+3, 0
	SUBWFB     R7, 1
	CALL       _Div_32x32_S+0
	MOVF       R0, 0
	MOVWF      get_pwr_Forward_L0+0
	MOVF       R1, 0
	MOVWF      get_pwr_Forward_L0+1
	MOVF       R2, 0
	MOVWF      get_pwr_Forward_L0+2
	MOVF       R3, 0
	MOVWF      get_pwr_Forward_L0+3
;main.c,538 :: 		if(Forward>999) Forward = 999;
	MOVLW      128
	MOVWF      R4
	MOVLW      128
	XORWF      R3, 0
	SUBWF      R4, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr317
	MOVF       R2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr317
	MOVF       R1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr317
	MOVF       R0, 0
	SUBLW      231
L__get_pwr317:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr126
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
L_get_pwr126:
;main.c,539 :: 		}
L_get_pwr125:
;main.c,541 :: 		SWR = Forward;
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      _SWR+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      _SWR+1
;main.c,542 :: 		return;
;main.c,543 :: 		}
L_end_get_pwr:
	RETURN
; end of _get_pwr

_get_swr:

;main.c,545 :: 		void get_swr(){
;main.c,546 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,547 :: 		tune_cnt = 1000;
	MOVLW      232
	MOVWF      _tune_cnt+0
	MOVLW      3
	MOVWF      _tune_cnt+1
	CLRF       _tune_cnt+2
	CLRF       _tune_cnt+3
;main.c,548 :: 		while(PWR<min_for_start | PWR>max_for_start){   // waiting for good power
L_get_swr127:
	MOVLW      128
	XORWF      _PWR+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr319
	MOVF       _min_for_start+0, 0
	SUBWF      _PWR+0, 0
L__get_swr319:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      128
	XORWF      _max_for_start+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr320
	MOVF       _PWR+0, 0
	SUBWF      _max_for_start+0, 0
L__get_swr320:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_get_swr128
;main.c,549 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_get_swr129
;main.c,550 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,551 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,552 :: 		return;
	GOTO       L_end_get_swr
;main.c,553 :: 		}
L_get_swr129:
;main.c,554 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,555 :: 		draw_power(PWR);
	MOVF       _PWR+0, 0
	MOVWF      FARG_draw_power_p+0
	MOVF       _PWR+1, 0
	MOVWF      FARG_draw_power_p+1
	CALL       _draw_power+0
;main.c,556 :: 		if(tune_cnt>0) tune_cnt --;
	MOVF       _tune_cnt+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr321
	MOVF       _tune_cnt+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr321
	MOVF       _tune_cnt+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr321
	MOVF       _tune_cnt+0, 0
	SUBLW      0
L__get_swr321:
	BTFSC      STATUS+0, 0
	GOTO       L_get_swr130
	MOVLW      1
	SUBWF      _tune_cnt+0, 1
	MOVLW      0
	SUBWFB     _tune_cnt+1, 1
	SUBWFB     _tune_cnt+2, 1
	SUBWFB     _tune_cnt+3, 1
	GOTO       L_get_swr131
L_get_swr130:
;main.c,558 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,559 :: 		return;
	GOTO       L_end_get_swr
;main.c,560 :: 		}
L_get_swr131:
;main.c,561 :: 		}
	GOTO       L_get_swr127
L_get_swr128:
;main.c,563 :: 		return;
;main.c,564 :: 		}
L_end_get_swr:
	RETURN
; end of _get_swr

_get_batt:

;main.c,566 :: 		void get_batt(void){
;main.c,567 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,568 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_batt132:
	DECFSZ     R13, 1
	GOTO       L_get_batt132
	DECFSZ     R12, 1
	GOTO       L_get_batt132
	NOP
;main.c,569 :: 		Voltage = ADC_Get_Sample(Battery_input) * 11;
	MOVLW      9
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVLW      11
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Mul_16X16_U+0
	MOVF       R0, 0
	MOVWF      _Voltage+0
	MOVF       R1, 0
	MOVWF      _Voltage+1
;main.c,570 :: 		return;
;main.c,571 :: 		}
L_end_get_batt:
	RETURN
; end of _get_batt

_coarse_cap:

;main.c,573 :: 		void coarse_cap() {
;main.c,574 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_cap_step_L0+0
;main.c,578 :: 		cap = 0;
	CLRF       _cap+0
;main.c,579 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	CLRF       FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,580 :: 		get_swr();
	CALL       _get_swr+0
;main.c,581 :: 		min_swr = SWR + SWR/20;
	MOVLW      20
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       _SWR+0, 0
	MOVWF      R0
	MOVF       _SWR+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	ADDWF      _SWR+0, 0
	MOVWF      coarse_cap_min_swr_L0+0
	MOVF       R1, 0
	ADDWFC     _SWR+1, 0
	MOVWF      coarse_cap_min_swr_L0+1
;main.c,582 :: 		for(count=step; count<=31;) {
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      coarse_cap_count_L0+0
L_coarse_cap133:
	MOVF       coarse_cap_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_cap134
;main.c,583 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,584 :: 		get_swr();
	CALL       _get_swr+0
;main.c,585 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap324
	MOVF       coarse_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_cap324:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap136
;main.c,586 :: 		min_swr = SWR + SWR/20;
	MOVLW      20
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       _SWR+0, 0
	MOVWF      R0
	MOVF       _SWR+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	ADDWF      _SWR+0, 0
	MOVWF      coarse_cap_min_swr_L0+0
	MOVF       R1, 0
	ADDWFC     _SWR+1, 0
	MOVWF      coarse_cap_min_swr_L0+1
;main.c,587 :: 		cap = count;
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,588 :: 		step_cap = step;
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      _step_cap+0
;main.c,589 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap325
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_cap325:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap137
	GOTO       L_coarse_cap134
L_coarse_cap137:
;main.c,590 :: 		count += step;
	MOVF       coarse_cap_step_L0+0, 0
	ADDWF      coarse_cap_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_cap_count_L0+0
;main.c,591 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap138
	MOVLW      8
	MOVWF      coarse_cap_count_L0+0
	GOTO       L_coarse_cap139
L_coarse_cap138:
;main.c,592 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_cap_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap140
	MOVLW      16
	MOVWF      coarse_cap_count_L0+0
	MOVLW      4
	MOVWF      coarse_cap_step_L0+0
L_coarse_cap140:
L_coarse_cap139:
;main.c,593 :: 		}
	GOTO       L_coarse_cap141
L_coarse_cap136:
;main.c,594 :: 		else break;
	GOTO       L_coarse_cap134
L_coarse_cap141:
;main.c,595 :: 		}
	GOTO       L_coarse_cap133
L_coarse_cap134:
;main.c,596 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,597 :: 		return;
;main.c,598 :: 		}
L_end_coarse_cap:
	RETURN
; end of _coarse_cap

_coarse_tune:

;main.c,600 :: 		void coarse_tune() {
;main.c,601 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_tune_step_L0+0
;main.c,606 :: 		mem_cap = 0;
	CLRF       coarse_tune_mem_cap_L0+0
;main.c,607 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,608 :: 		mem_step_cap = 3;
	MOVLW      3
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,609 :: 		min_swr = SWR + SWR/20;
	MOVLW      20
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       _SWR+0, 0
	MOVWF      R0
	MOVF       _SWR+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	ADDWF      _SWR+0, 0
	MOVWF      coarse_tune_min_swr_L0+0
	MOVF       R1, 0
	ADDWFC     _SWR+1, 0
	MOVWF      coarse_tune_min_swr_L0+1
;main.c,610 :: 		for(count=step; count<=31;) {
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      coarse_tune_count_L0+0
L_coarse_tune142:
	MOVF       coarse_tune_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_tune143
;main.c,611 :: 		Relay_set(count, cap, SW);
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,612 :: 		coarse_cap();
	CALL       _coarse_cap+0
;main.c,613 :: 		get_swr();
	CALL       _get_swr+0
;main.c,614 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_tune_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune327
	MOVF       coarse_tune_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_tune327:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune145
;main.c,615 :: 		min_swr = SWR + SWR/20;
	MOVLW      20
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       _SWR+0, 0
	MOVWF      R0
	MOVF       _SWR+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	ADDWF      _SWR+0, 0
	MOVWF      coarse_tune_min_swr_L0+0
	MOVF       R1, 0
	ADDWFC     _SWR+1, 0
	MOVWF      coarse_tune_min_swr_L0+1
;main.c,616 :: 		ind = count;
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      _ind+0
;main.c,617 :: 		mem_cap = cap;
	MOVF       _cap+0, 0
	MOVWF      coarse_tune_mem_cap_L0+0
;main.c,618 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,619 :: 		mem_step_cap = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,620 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune328
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_tune328:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune146
	GOTO       L_coarse_tune143
L_coarse_tune146:
;main.c,621 :: 		count += step;
	MOVF       coarse_tune_step_L0+0, 0
	ADDWF      coarse_tune_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_tune_count_L0+0
;main.c,622 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune147
	MOVLW      8
	MOVWF      coarse_tune_count_L0+0
	GOTO       L_coarse_tune148
L_coarse_tune147:
;main.c,623 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_tune_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune149
	MOVLW      16
	MOVWF      coarse_tune_count_L0+0
	MOVLW      4
	MOVWF      coarse_tune_step_L0+0
L_coarse_tune149:
L_coarse_tune148:
;main.c,624 :: 		}
	GOTO       L_coarse_tune150
L_coarse_tune145:
;main.c,625 :: 		else break;
	GOTO       L_coarse_tune143
L_coarse_tune150:
;main.c,626 :: 		}
	GOTO       L_coarse_tune142
L_coarse_tune143:
;main.c,627 :: 		cap = mem_cap;
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      _cap+0
;main.c,628 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,629 :: 		step_cap = mem_step_cap;
	MOVF       coarse_tune_mem_step_cap_L0+0, 0
	MOVWF      _step_cap+0
;main.c,630 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_coarse_tune151:
	DECFSZ     R13, 1
	GOTO       L_coarse_tune151
	DECFSZ     R12, 1
	GOTO       L_coarse_tune151
	NOP
;main.c,631 :: 		return;
;main.c,632 :: 		}
L_end_coarse_tune:
	RETURN
; end of _coarse_tune

_sharp_cap:

;main.c,634 :: 		void sharp_cap() {
;main.c,637 :: 		range = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      sharp_cap_range_L0+0
;main.c,639 :: 		max_range = cap + range;
	MOVF       _step_cap+0, 0
	ADDWF      _cap+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_cap_max_range_L0+0
;main.c,640 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap152
	MOVLW      31
	MOVWF      sharp_cap_max_range_L0+0
L_sharp_cap152:
;main.c,641 :: 		if(cap>range) min_range = cap - range; else min_range = 0;
	MOVF       _cap+0, 0
	SUBWF      sharp_cap_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap153
	MOVF       sharp_cap_range_L0+0, 0
	SUBWF      _cap+0, 0
	MOVWF      sharp_cap_min_range_L0+0
	GOTO       L_sharp_cap154
L_sharp_cap153:
	CLRF       sharp_cap_min_range_L0+0
L_sharp_cap154:
;main.c,642 :: 		cap = min_range;
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      _cap+0
;main.c,643 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,644 :: 		get_swr();
	CALL       _get_swr+0
;main.c,645 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap330
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap330:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap155
	GOTO       L_end_sharp_cap
L_sharp_cap155:
;main.c,646 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,647 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_min_range_L0+0, 0
	MOVWF      sharp_cap_count_L0+0
L_sharp_cap156:
	MOVF       sharp_cap_count_L0+0, 0
	SUBWF      sharp_cap_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap157
;main.c,648 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,649 :: 		get_swr();
	CALL       _get_swr+0
;main.c,650 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap331
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap331:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap159
	GOTO       L_end_sharp_cap
L_sharp_cap159:
;main.c,651 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap332
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap332:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap160
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap161:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap161
	DECFSZ     R12, 1
	GOTO       L_sharp_cap161
	NOP
	CALL       _get_swr+0
L_sharp_cap160:
;main.c,652 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap333
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap333:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap162
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap163:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap163
	DECFSZ     R12, 1
	GOTO       L_sharp_cap163
	NOP
	CALL       _get_swr+0
L_sharp_cap162:
;main.c,653 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap334
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap334:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap164
;main.c,654 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,655 :: 		cap = count;
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,656 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap335
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_cap335:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap165
	GOTO       L_sharp_cap157
L_sharp_cap165:
;main.c,657 :: 		}
	GOTO       L_sharp_cap166
L_sharp_cap164:
;main.c,658 :: 		else break;
	GOTO       L_sharp_cap157
L_sharp_cap166:
;main.c,647 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_count_L0+0, 1
;main.c,659 :: 		}
	GOTO       L_sharp_cap156
L_sharp_cap157:
;main.c,660 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,661 :: 		return;
;main.c,662 :: 		}
L_end_sharp_cap:
	RETURN
; end of _sharp_cap

_sharp_ind:

;main.c,664 :: 		void sharp_ind() {
;main.c,667 :: 		range = step_ind;
	MOVF       _step_ind+0, 0
	MOVWF      sharp_ind_range_L0+0
;main.c,669 :: 		max_range = ind + range;
	MOVF       _step_ind+0, 0
	ADDWF      _ind+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_ind_max_range_L0+0
;main.c,670 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind167
	MOVLW      31
	MOVWF      sharp_ind_max_range_L0+0
L_sharp_ind167:
;main.c,671 :: 		if(ind>range) min_range = ind - range; else min_range = 0;
	MOVF       _ind+0, 0
	SUBWF      sharp_ind_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind168
	MOVF       sharp_ind_range_L0+0, 0
	SUBWF      _ind+0, 0
	MOVWF      sharp_ind_min_range_L0+0
	GOTO       L_sharp_ind169
L_sharp_ind168:
	CLRF       sharp_ind_min_range_L0+0
L_sharp_ind169:
;main.c,672 :: 		ind = min_range;
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      _ind+0
;main.c,673 :: 		Relay_set(ind, cap, SW);
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,674 :: 		get_swr();
	CALL       _get_swr+0
;main.c,675 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind337
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind337:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind170
	GOTO       L_end_sharp_ind
L_sharp_ind170:
;main.c,676 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,677 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_min_range_L0+0, 0
	MOVWF      sharp_ind_count_L0+0
L_sharp_ind171:
	MOVF       sharp_ind_count_L0+0, 0
	SUBWF      sharp_ind_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind172
;main.c,678 :: 		Relay_set(count, cap, SW);
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,679 :: 		get_swr();
	CALL       _get_swr+0
;main.c,680 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind338
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind338:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind174
	GOTO       L_end_sharp_ind
L_sharp_ind174:
;main.c,681 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind339
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind339:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind175
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind176:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind176
	DECFSZ     R12, 1
	GOTO       L_sharp_ind176
	NOP
	CALL       _get_swr+0
L_sharp_ind175:
;main.c,682 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind340
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind340:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind177
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind178:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind178
	DECFSZ     R12, 1
	GOTO       L_sharp_ind178
	NOP
	CALL       _get_swr+0
L_sharp_ind177:
;main.c,683 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind341
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind341:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind179
;main.c,684 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,685 :: 		ind = count;
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      _ind+0
;main.c,686 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind342
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_ind342:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind180
	GOTO       L_sharp_ind172
L_sharp_ind180:
;main.c,687 :: 		}
	GOTO       L_sharp_ind181
L_sharp_ind179:
;main.c,688 :: 		else break;
	GOTO       L_sharp_ind172
L_sharp_ind181:
;main.c,677 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_count_L0+0, 1
;main.c,689 :: 		}
	GOTO       L_sharp_ind171
L_sharp_ind172:
;main.c,690 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,691 :: 		return;
;main.c,692 :: 		}
L_end_sharp_ind:
	RETURN
; end of _sharp_ind

_tune:

;main.c,695 :: 		void tune() {
;main.c,697 :: 		asm CLRWDT;
	CLRWDT
;main.c,698 :: 		get_swr(); if(SWR<110) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune344
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune344:
	BTFSC      STATUS+0, 0
	GOTO       L_tune182
	GOTO       L_end_tune
L_tune182:
;main.c,699 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,700 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune183:
	DECFSZ     R13, 1
	GOTO       L_tune183
	DECFSZ     R12, 1
	GOTO       L_tune183
	DECFSZ     R11, 1
	GOTO       L_tune183
;main.c,701 :: 		get_swr(); if(SWR<110) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune345
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune345:
	BTFSC      STATUS+0, 0
	GOTO       L_tune184
	GOTO       L_end_tune
L_tune184:
;main.c,703 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,704 :: 		coarse_tune(); if(SWR==0) {atu_reset(); return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune346
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune346:
	BTFSS      STATUS+0, 2
	GOTO       L_tune185
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune185:
;main.c,705 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune347
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune347:
	BTFSC      STATUS+0, 0
	GOTO       L_tune186
	GOTO       L_end_tune
L_tune186:
;main.c,706 :: 		sharp_ind();  if(SWR==0) {atu_reset(); return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune348
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune348:
	BTFSS      STATUS+0, 2
	GOTO       L_tune187
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune187:
;main.c,707 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune349
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune349:
	BTFSC      STATUS+0, 0
	GOTO       L_tune188
	GOTO       L_end_tune
L_tune188:
;main.c,708 :: 		sharp_cap(); if(SWR==0) {atu_reset(); return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune350
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune350:
	BTFSS      STATUS+0, 2
	GOTO       L_tune189
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune189:
;main.c,709 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune351
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune351:
	BTFSC      STATUS+0, 0
	GOTO       L_tune190
	GOTO       L_end_tune
L_tune190:
;main.c,711 :: 		if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) return;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R1
	MOVLW      128
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune352
	MOVLW      200
	SUBWF      _SWR+0, 0
L__tune352:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      tune_swr_mem_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune353
	MOVF       tune_swr_mem_L0+0, 0
	SUBWF      _SWR+0, 0
L__tune353:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R0, 0
	ANDWF      R1, 0
	MOVWF      R3
	MOVF       _SWR+0, 0
	SUBWF      tune_swr_mem_L0+0, 0
	MOVWF      R1
	MOVF       _SWR+1, 0
	SUBWFB     tune_swr_mem_L0+1, 0
	MOVWF      R2
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune354
	MOVF       R1, 0
	SUBLW      100
L__tune354:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R3, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_tune191
	GOTO       L_end_tune
L_tune191:
;main.c,712 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,713 :: 		ind_mem = ind;
	MOVF       _ind+0, 0
	MOVWF      tune_ind_mem_L0+0
	CLRF       tune_ind_mem_L0+1
;main.c,714 :: 		cap_mem = cap;
	MOVF       _cap+0, 0
	MOVWF      tune_cap_mem_L0+0
	CLRF       tune_cap_mem_L0+1
;main.c,716 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune192
	CLRF       _SW+0
	GOTO       L_tune193
L_tune192:
	MOVLW      1
	MOVWF      _SW+0
L_tune193:
;main.c,717 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,718 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,719 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune194:
	DECFSZ     R13, 1
	GOTO       L_tune194
	DECFSZ     R12, 1
	GOTO       L_tune194
	DECFSZ     R11, 1
	GOTO       L_tune194
;main.c,720 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune355
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune355:
	BTFSC      STATUS+0, 0
	GOTO       L_tune195
	GOTO       L_end_tune
L_tune195:
;main.c,722 :: 		coarse_tune(); if(SWR==0) {atu_reset(); return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune356
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune356:
	BTFSS      STATUS+0, 2
	GOTO       L_tune196
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune196:
;main.c,723 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune357
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune357:
	BTFSC      STATUS+0, 0
	GOTO       L_tune197
	GOTO       L_end_tune
L_tune197:
;main.c,724 :: 		sharp_ind(); if(SWR==0) {atu_reset(); return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune358
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune358:
	BTFSS      STATUS+0, 2
	GOTO       L_tune198
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune198:
;main.c,725 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune359
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune359:
	BTFSC      STATUS+0, 0
	GOTO       L_tune199
	GOTO       L_end_tune
L_tune199:
;main.c,726 :: 		sharp_cap(); if(SWR==0) {atu_reset(); return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune360
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune360:
	BTFSS      STATUS+0, 2
	GOTO       L_tune200
	CALL       _atu_reset+0
	GOTO       L_end_tune
L_tune200:
;main.c,727 :: 		get_swr(); if(SWR<120) return;
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune361
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune361:
	BTFSC      STATUS+0, 0
	GOTO       L_tune201
	GOTO       L_end_tune
L_tune201:
;main.c,729 :: 		if(SWR>swr_mem) {
	MOVLW      128
	XORWF      tune_swr_mem_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _SWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune362
	MOVF       _SWR+0, 0
	SUBWF      tune_swr_mem_L0+0, 0
L__tune362:
	BTFSC      STATUS+0, 0
	GOTO       L_tune202
;main.c,730 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune203
	CLRF       _SW+0
	GOTO       L_tune204
L_tune203:
	MOVLW      1
	MOVWF      _SW+0
L_tune204:
;main.c,731 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,732 :: 		ind = ind_mem;
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      _ind+0
;main.c,733 :: 		cap = cap_mem;
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      _cap+0
;main.c,734 :: 		Relay_set(ind, cap, sw);
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,735 :: 		SWR = swr_mem;
	MOVF       tune_swr_mem_L0+0, 0
	MOVWF      _SWR+0
	MOVF       tune_swr_mem_L0+1, 0
	MOVWF      _SWR+1
;main.c,736 :: 		}
L_tune202:
;main.c,738 :: 		asm CLRWDT;
	CLRWDT
;main.c,739 :: 		return;
;main.c,740 :: 		}
L_end_tune:
	RETURN
; end of _tune

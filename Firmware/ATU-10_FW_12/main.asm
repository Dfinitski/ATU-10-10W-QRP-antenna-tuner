
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
;main.c,39 :: 		if(Tick>=btn_cnt){  // every 10ms
	MOVF       _btn_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt233
	MOVF       _btn_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt233
	MOVF       _btn_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt233
	MOVF       _btn_cnt+0, 0
	SUBWF      _Tick+0, 0
L__interupt233:
	BTFSS      STATUS+0, 0
	GOTO       L_interupt1
;main.c,40 :: 		btn_cnt += 10;
	MOVLW      10
	ADDWF      _btn_cnt+0, 1
	MOVLW      0
	ADDWFC     _btn_cnt+1, 1
	ADDWFC     _btn_cnt+2, 1
	ADDWFC     _btn_cnt+3, 1
;main.c,42 :: 		if(GetButton | Start){
	BTFSC      PORTB+0, 5
	GOTO       L__interupt234
	BSF        R4, 0
	GOTO       L__interupt235
L__interupt234:
	BCF        R4, 0
L__interupt235:
	BTFSC      PORTD+0, 1
	GOTO       L__interupt236
	BSF        3, 0
	GOTO       L__interupt237
L__interupt236:
	BCF        3, 0
L__interupt237:
	BTFSC      R4, 0
	GOTO       L__interupt238
	BTFSC      3, 0
	GOTO       L__interupt238
	BCF        R4, 0
	GOTO       L__interupt239
L__interupt238:
	BSF        R4, 0
L__interupt239:
	BTFSS      R4, 0
	GOTO       L_interupt2
;main.c,43 :: 		disp_cnt = Tick + Disp_time*1000;
	MOVF       _Disp_time+0, 0
	MOVWF      R0
	MOVF       _Disp_time+1, 0
	MOVWF      R1
	MOVF       _Disp_time+2, 0
	MOVWF      R2
	MOVF       _Disp_time+3, 0
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
	MOVWF      _disp_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _disp_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _disp_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _disp_cnt+3
;main.c,44 :: 		off_cnt = Tick + Off_time*1000;
	MOVF       _Off_time+0, 0
	MOVWF      R0
	MOVF       _Off_time+1, 0
	MOVWF      R1
	MOVF       _Off_time+2, 0
	MOVWF      R2
	MOVF       _Off_time+3, 0
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
	MOVWF      _off_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,45 :: 		}
L_interupt2:
;main.c,47 :: 		if(GetButton){  //
	BTFSC      PORTB+0, 5
	GOTO       L__interupt240
	BSF        3, 0
	GOTO       L__interupt241
L__interupt240:
	BCF        3, 0
L__interupt241:
	BTFSS      3, 0
	GOTO       L_interupt3
;main.c,48 :: 		if(btn_1_cnt<250) btn_1_cnt++;
	MOVLW      250
	SUBWF      _btn_1_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interupt4
	INCF       _btn_1_cnt+0, 1
L_interupt4:
;main.c,49 :: 		if(btn_1_cnt==25) B_long = 1;  // long pressing detected
	MOVF       _btn_1_cnt+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_interupt5
	BSF        _B_long+0, BitPos(_B_long+0)
L_interupt5:
;main.c,50 :: 		if(btn_1_cnt==250 & OLED_PWD) B_xlong = 1;  // Xtra long pressing detected
	MOVF       _btn_1_cnt+0, 0
	XORLW      250
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1
	CLRF       R0
	BTFSC      LATA4_bit+0, BitPos(LATA4_bit+0)
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt6
	BSF        _B_xlong+0, BitPos(_B_xlong+0)
L_interupt6:
;main.c,51 :: 		}
	GOTO       L_interupt7
L_interupt3:
;main.c,52 :: 		else if(btn_1_cnt>2 & btn_1_cnt<25){
	MOVF       _btn_1_cnt+0, 0
	SUBLW      2
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      25
	SUBWF      _btn_1_cnt+0, 0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt8
;main.c,53 :: 		B_short = 1;               // short pressing detected
	BSF        _B_short+0, BitPos(_B_short+0)
;main.c,54 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,55 :: 		}
	GOTO       L_interupt9
L_interupt8:
;main.c,57 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
L_interupt9:
L_interupt7:
;main.c,59 :: 		if(Start){
	BTFSC      PORTD+0, 1
	GOTO       L__interupt242
	BSF        3, 0
	GOTO       L__interupt243
L__interupt242:
	BCF        3, 0
L__interupt243:
	BTFSS      3, 0
	GOTO       L_interupt10
;main.c,60 :: 		if(btn_2_cnt<25) btn_2_cnt++;
	MOVLW      25
	SUBWF      _btn_2_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interupt11
	INCF       _btn_2_cnt+0, 1
L_interupt11:
;main.c,61 :: 		if(btn_2_cnt==20 & Key_in) E_long = 1;
	MOVF       _btn_2_cnt+0, 0
	XORLW      20
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R1
	CLRF       R0
	BTFSC      PORTD+0, 2
	INCF       R0, 1
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt12
	BSF        _E_long+0, BitPos(_E_long+0)
L_interupt12:
;main.c,62 :: 		}
	GOTO       L_interupt13
L_interupt10:
;main.c,63 :: 		else if(btn_2_cnt>1 & btn_2_cnt<10){
	MOVF       _btn_2_cnt+0, 0
	SUBLW      1
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      10
	SUBWF      _btn_2_cnt+0, 0
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_interupt14
;main.c,64 :: 		E_short = 1;
	BSF        _E_short+0, BitPos(_E_short+0)
;main.c,65 :: 		btn_2_cnt = 0;
	CLRF       _btn_2_cnt+0
;main.c,66 :: 		}
	GOTO       L_interupt15
L_interupt14:
;main.c,68 :: 		btn_2_cnt = 0;
	CLRF       _btn_2_cnt+0
L_interupt15:
L_interupt13:
;main.c,69 :: 		}
L_interupt1:
;main.c,70 :: 		return;
;main.c,71 :: 		}
L_end_interupt:
L__interupt232:
	RETFIE     %s
; end of _interupt

_main:

;main.c,74 :: 		void main() {
;main.c,75 :: 		pic_init();
	CALL       _pic_init+0
;main.c,76 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,77 :: 		Key_out = 1;
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,78 :: 		gre = 1;
	BSF        _gre+0, BitPos(_gre+0)
;main.c,79 :: 		oled_start();
	CALL       _oled_start+0
;main.c,81 :: 		ADC_Init();
	CALL       _ADC_Init+0
;main.c,82 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,83 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,84 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,85 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,86 :: 		E_short = 0;
	BCF        _E_short+0, BitPos(_E_short+0)
;main.c,87 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,89 :: 		disp_cnt = Tick + Disp_time*1000;
	MOVF       _Disp_time+0, 0
	MOVWF      R0
	MOVF       _Disp_time+1, 0
	MOVWF      R1
	MOVF       _Disp_time+2, 0
	MOVWF      R2
	MOVF       _Disp_time+3, 0
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
	MOVWF      _disp_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _disp_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _disp_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _disp_cnt+3
;main.c,90 :: 		off_cnt = Tick + Off_time*1000;
	MOVF       _Off_time+0, 0
	MOVWF      R0
	MOVF       _Off_time+1, 0
	MOVWF      R1
	MOVF       _Off_time+2, 0
	MOVWF      R2
	MOVF       _Off_time+3, 0
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
	MOVWF      _off_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,95 :: 		while(1) {
L_main16:
;main.c,96 :: 		if(Tick>=volt_cnt){   // every 3 second
	MOVF       _volt_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main245
	MOVF       _volt_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main245
	MOVF       _volt_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main245
	MOVF       _volt_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main245:
	BTFSS      STATUS+0, 0
	GOTO       L_main18
;main.c,97 :: 		volt_cnt += 3000;
	MOVLW      184
	ADDWF      _volt_cnt+0, 1
	MOVLW      11
	ADDWFC     _volt_cnt+1, 1
	MOVLW      0
	ADDWFC     _volt_cnt+2, 1
	ADDWFC     _volt_cnt+3, 1
;main.c,98 :: 		Voltage_show();
	CALL       _Voltage_show+0
;main.c,99 :: 		}
L_main18:
;main.c,101 :: 		if(Tick>=watch_cnt){   // every 300 ms    unless power off
	MOVF       _watch_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main246
	MOVF       _watch_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main246
	MOVF       _watch_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main246
	MOVF       _watch_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main246:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;main.c,102 :: 		watch_cnt += 300;
	MOVLW      44
	ADDWF      _watch_cnt+0, 1
	MOVLW      1
	ADDWFC     _watch_cnt+1, 1
	MOVLW      0
	ADDWFC     _watch_cnt+2, 1
	ADDWFC     _watch_cnt+3, 1
;main.c,103 :: 		watch_swr();
	CALL       _watch_swr+0
;main.c,104 :: 		}
L_main19:
;main.c,106 :: 		if(Tick>=disp_cnt){  // Display off
	MOVF       _disp_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main247
	MOVF       _disp_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main247
	MOVF       _disp_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main247
	MOVF       _disp_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main247:
	BTFSS      STATUS+0, 0
	GOTO       L_main20
;main.c,108 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,109 :: 		}
L_main20:
;main.c,111 :: 		if(Tick>=off_cnt){    // Go to power off
	MOVF       _off_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main248
	MOVF       _off_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main248
	MOVF       _off_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main248
	MOVF       _off_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main248:
	BTFSS      STATUS+0, 0
	GOTO       L_main21
;main.c,112 :: 		power_off();
	CALL       _power_off+0
;main.c,113 :: 		}
L_main21:
;main.c,115 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_main22
;main.c,116 :: 		if(OLED_PWD) Btn_short();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main23
	CALL       _Btn_short+0
	GOTO       L_main24
L_main23:
;main.c,117 :: 		else oled_start();
	CALL       _oled_start+0
L_main24:
;main.c,118 :: 		}
L_main22:
;main.c,119 :: 		if(B_long){
	BTFSS      _B_long+0, BitPos(_B_long+0)
	GOTO       L_main25
;main.c,120 :: 		if(OLED_PWD) Btn_long();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main26
	CALL       _Btn_long+0
	GOTO       L_main27
L_main26:
;main.c,121 :: 		else oled_start();
	CALL       _oled_start+0
L_main27:
;main.c,122 :: 		}
L_main25:
;main.c,123 :: 		if(B_xlong){
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_main28
;main.c,124 :: 		if(OLED_PWD) Btn_xlong();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main29
	CALL       _Btn_xlong+0
	GOTO       L_main30
L_main29:
;main.c,125 :: 		else oled_start();
	CALL       _oled_start+0
L_main30:
;main.c,126 :: 		}
L_main28:
;main.c,128 :: 		if(E_short){
	BTFSS      _E_short+0, BitPos(_E_short+0)
	GOTO       L_main31
;main.c,129 :: 		if(OLED_PWD==0) oled_start();
	BTFSC      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main32
	CALL       _oled_start+0
L_main32:
;main.c,130 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,131 :: 		}
L_main31:
;main.c,132 :: 		if(E_long){
	BTFSS      _E_long+0, BitPos(_E_long+0)
	GOTO       L_main33
;main.c,133 :: 		if(OLED_PWD==0) { Ext_long(); oled_start(); }
	BTFSC      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main34
	CALL       _Ext_long+0
	CALL       _oled_start+0
	GOTO       L_main35
L_main34:
;main.c,134 :: 		else Btn_long();
	CALL       _Btn_long+0
L_main35:
;main.c,135 :: 		}
L_main33:
;main.c,137 :: 		} // while(1)
	GOTO       L_main16
;main.c,138 :: 		} // main
L_end_main:
	GOTO       $+0
; end of _main

_oled_start:

;main.c,141 :: 		void oled_start(){
;main.c,142 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,144 :: 		Delay_ms(200);
	MOVLW      9
	MOVWF      R11
	MOVLW      30
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_oled_start36:
	DECFSZ     R13, 1
	GOTO       L_oled_start36
	DECFSZ     R12, 1
	GOTO       L_oled_start36
	DECFSZ     R11, 1
	GOTO       L_oled_start36
	NOP
;main.c,145 :: 		Soft_I2C_init();
	CALL       _Soft_I2C_Init+0
;main.c,146 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_oled_start37:
	DECFSZ     R13, 1
	GOTO       L_oled_start37
	DECFSZ     R12, 1
	GOTO       L_oled_start37
	NOP
;main.c,147 :: 		oled_init();
	CALL       _oled_init+0
;main.c,149 :: 		if(gre){
	BTFSS      _gre+0, BitPos(_gre+0)
	GOTO       L_oled_start38
;main.c,150 :: 		Greating();
	CALL       _Greating+0
;main.c,151 :: 		gre = 0;
	BCF        _gre+0, BitPos(_gre+0)
;main.c,152 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,153 :: 		}
L_oled_start38:
;main.c,154 :: 		oled_wr_str(0, 0, "PWR     W", 9);
	CLRF       FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr1_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,155 :: 		oled_bat();
	CALL       _oled_bat+0
;main.c,156 :: 		oled_wr_str(2, 0, "SWR      ", 9);
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
;main.c,157 :: 		oled_wr_str(0, 42, "=", 1);
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
;main.c,158 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,159 :: 		Voltage_old = 9999;
	MOVLW      15
	MOVWF      _Voltage_old+0
	MOVLW      39
	MOVWF      _Voltage_old+1
;main.c,160 :: 		SWR_fixed_old = 9999;
	MOVLW      15
	MOVWF      _SWR_fixed_old+0
	MOVLW      39
	MOVWF      _SWR_fixed_old+1
;main.c,161 :: 		PWR_fixed_old = 9999;
	MOVLW      15
	MOVWF      _PWR_fixed_old+0
	MOVLW      39
	MOVWF      _PWR_fixed_old+1
;main.c,162 :: 		SWR_ind_old = 9999;
	MOVLW      15
	MOVWF      _SWR_ind_old+0
	MOVLW      39
	MOVWF      _SWR_ind_old+1
;main.c,163 :: 		SWR_ind = 0;
	CLRF       _SWR_ind+0
	CLRF       _SWR_ind+1
;main.c,164 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,165 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,166 :: 		B_short = 0; B_long = 0; B_xlong = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
	BCF        _B_long+0, BitPos(_B_long+0)
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,167 :: 		disp_cnt = Tick + Disp_time*1000;
	MOVF       _Disp_time+0, 0
	MOVWF      R0
	MOVF       _Disp_time+1, 0
	MOVWF      R1
	MOVF       _Disp_time+2, 0
	MOVWF      R2
	MOVF       _Disp_time+3, 0
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
	MOVWF      _disp_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _disp_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _disp_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _disp_cnt+3
;main.c,168 :: 		off_cnt = Tick + Off_time*1000;
	MOVF       _Off_time+0, 0
	MOVWF      R0
	MOVF       _Off_time+1, 0
	MOVWF      R1
	MOVF       _Off_time+2, 0
	MOVWF      R2
	MOVF       _Off_time+3, 0
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
	MOVWF      _off_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,169 :: 		return;
;main.c,170 :: 		}
L_end_oled_start:
	RETURN
; end of _oled_start

_watch_swr:

;main.c,173 :: 		void watch_swr(void){
;main.c,175 :: 		int delta = Auto_delta - 100;
	MOVLW      100
	SUBWF      _Auto_delta+0, 0
	MOVWF      watch_swr_delta_L0+0
	MOVLW      0
	SUBWFB     _Auto_delta+1, 0
	MOVWF      watch_swr_delta_L0+1
;main.c,178 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_watch_swr39:
	DECFSZ     R13, 1
	GOTO       L_watch_swr39
	DECFSZ     R12, 1
	GOTO       L_watch_swr39
	DECFSZ     R11, 1
	GOTO       L_watch_swr39
;main.c,180 :: 		cnt = 600;
	MOVLW      88
	MOVWF      watch_swr_cnt_L0+0
;main.c,181 :: 		PWR_fixed = 0;
	CLRF       watch_swr_PWR_fixed_L0+0
	CLRF       watch_swr_PWR_fixed_L0+1
;main.c,182 :: 		SWR_fixed = 999;
	MOVLW      231
	MOVWF      watch_swr_SWR_fixed_L0+0
	MOVLW      3
	MOVWF      watch_swr_SWR_fixed_L0+1
;main.c,183 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	CLRF       watch_swr_peak_cnt_L0+0
L_watch_swr40:
	MOVF       watch_swr_cnt_L0+0, 0
	SUBWF      watch_swr_peak_cnt_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr41
;main.c,184 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,185 :: 		if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr251
	MOVF       _PWR+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr251:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr43
	MOVF       _PWR+0, 0
	MOVWF      watch_swr_PWR_fixed_L0+0
	MOVF       _PWR+1, 0
	MOVWF      watch_swr_PWR_fixed_L0+1
	MOVF       _SWR+0, 0
	MOVWF      watch_swr_SWR_fixed_L0+0
	MOVF       _SWR+1, 0
	MOVWF      watch_swr_SWR_fixed_L0+1
L_watch_swr43:
;main.c,186 :: 		Delay_ms(1);
	MOVLW      11
	MOVWF      R12
	MOVLW      98
	MOVWF      R13
L_watch_swr44:
	DECFSZ     R13, 1
	GOTO       L_watch_swr44
	DECFSZ     R12, 1
	GOTO       L_watch_swr44
	NOP
;main.c,183 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	INCF       watch_swr_peak_cnt_L0+0, 1
;main.c,187 :: 		}
	GOTO       L_watch_swr40
L_watch_swr41:
;main.c,189 :: 		if(PWR_fixed>0){
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr252
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBLW      0
L__watch_swr252:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr45
;main.c,190 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_watch_swr46
;main.c,191 :: 		disp_cnt = Tick + Disp_time*1000;
	MOVF       _Disp_time+0, 0
	MOVWF      R0
	MOVF       _Disp_time+1, 0
	MOVWF      R1
	MOVF       _Disp_time+2, 0
	MOVWF      R2
	MOVF       _Disp_time+3, 0
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
	MOVWF      _disp_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _disp_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _disp_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _disp_cnt+3
;main.c,192 :: 		off_cnt = Tick + Off_time*1000;
	MOVF       _Off_time+0, 0
	MOVWF      R0
	MOVF       _Off_time+1, 0
	MOVWF      R1
	MOVF       _Off_time+2, 0
	MOVWF      R2
	MOVF       _Off_time+3, 0
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
	MOVWF      _off_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,193 :: 		}
	GOTO       L_watch_swr47
L_watch_swr46:
;main.c,194 :: 		else oled_start();
	CALL       _oled_start+0
L_watch_swr47:
;main.c,195 :: 		}
L_watch_swr45:
;main.c,197 :: 		if(PWR_fixed!=PWR_fixed_old){
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	XORWF      _PWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr253
	MOVF       _PWR_fixed_old+0, 0
	XORWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr253:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr48
;main.c,198 :: 		if(Overflow)
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr49
;main.c,199 :: 		oled_wr_str(0, 42, ">", 1);
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
	GOTO       L_watch_swr50
L_watch_swr49:
;main.c,201 :: 		oled_wr_str(0, 42, "=", 1);
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
L_watch_swr50:
;main.c,202 :: 		PWR_fixed_old = PWR_fixed;
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      _PWR_fixed_old+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      _PWR_fixed_old+1
;main.c,203 :: 		draw_power(PWR_fixed);
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      FARG_draw_power+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      FARG_draw_power+1
	CALL       _draw_power+0
;main.c,204 :: 		}
L_watch_swr48:
;main.c,205 :: 		if(PWR_fixed<10)
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr254
	MOVLW      10
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr254:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr51
;main.c,206 :: 		SWR_fixed = 0;
	CLRF       watch_swr_SWR_fixed_L0+0
	CLRF       watch_swr_SWR_fixed_L0+1
L_watch_swr51:
;main.c,208 :: 		if(Overflow){
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr52
;main.c,209 :: 		for(cnt=3; cnt!=0; cnt--){
	MOVLW      3
	MOVWF      watch_swr_cnt_L0+0
L_watch_swr53:
	MOVF       watch_swr_cnt_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr54
;main.c,210 :: 		oled_wr_str(2, 6, "OVERLOAD ", 9);
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
;main.c,211 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr56:
	DECFSZ     R13, 1
	GOTO       L_watch_swr56
	DECFSZ     R12, 1
	GOTO       L_watch_swr56
	DECFSZ     R11, 1
	GOTO       L_watch_swr56
	NOP
;main.c,212 :: 		oled_wr_str(2, 0, "         ", 9);
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
;main.c,213 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr57:
	DECFSZ     R13, 1
	GOTO       L_watch_swr57
	DECFSZ     R12, 1
	GOTO       L_watch_swr57
	DECFSZ     R11, 1
	GOTO       L_watch_swr57
	NOP
;main.c,209 :: 		for(cnt=3; cnt!=0; cnt--){
	DECF       watch_swr_cnt_L0+0, 1
;main.c,214 :: 		}
	GOTO       L_watch_swr53
L_watch_swr54:
;main.c,215 :: 		oled_wr_str(2, 0, "SWR      ", 9);
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
;main.c,216 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,217 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,218 :: 		Delay_ms(500);
	MOVLW      21
	MOVWF      R11
	MOVLW      75
	MOVWF      R12
	MOVLW      190
	MOVWF      R13
L_watch_swr58:
	DECFSZ     R13, 1
	GOTO       L_watch_swr58
	DECFSZ     R12, 1
	GOTO       L_watch_swr58
	DECFSZ     R11, 1
	GOTO       L_watch_swr58
	NOP
;main.c,219 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,220 :: 		}
	GOTO       L_watch_swr59
L_watch_swr52:
;main.c,221 :: 		else if(PWR_fixed>10){
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr255
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBLW      10
L__watch_swr255:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr60
;main.c,222 :: 		if(PWR_fixed>min_for_start & PWR_fixed<max_for_start) {
	MOVLW      128
	XORWF      _min_for_start+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr256
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBWF      _min_for_start+0, 0
L__watch_swr256:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R1
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _max_for_start+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr257
	MOVF       _max_for_start+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr257:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr61
;main.c,223 :: 		if(SWR_fixed>=Auto_delta & ((SWR_fixed>SWR_fixed_old & (SWR_fixed-SWR_fixed_old)>delta) | (SWR_fixed<SWR_fixed_old & (SWR_fixed_old-SWR_fixed)>delta) | SWR_fixed_old==999))
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R5
	MOVLW      128
	XORWF      _Auto_delta+1, 0
	SUBWF      R5, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr258
	MOVF       _Auto_delta+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr258:
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
	GOTO       L__watch_swr259
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBWF      _SWR_fixed_old+0, 0
L__watch_swr259:
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
	GOTO       L__watch_swr260
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr260:
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
	GOTO       L__watch_swr261
	MOVF       _SWR_fixed_old+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr261:
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
	GOTO       L__watch_swr262
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr262:
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
	GOTO       L__watch_swr263
	MOVLW      231
	XORWF      _SWR_fixed_old+0, 0
L__watch_swr263:
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	MOVF       R5, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr62
;main.c,224 :: 		{ Btn_long(); return; }
	CALL       _Btn_long+0
	GOTO       L_end_watch_swr
L_watch_swr62:
;main.c,225 :: 		}
L_watch_swr61:
;main.c,226 :: 		if(SWR_fixed!=SWR_fixed_old){
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	XORWF      _SWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr264
	MOVF       _SWR_fixed_old+0, 0
	XORWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr264:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr63
;main.c,227 :: 		SWR_fixed_old = SWR_fixed;
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      _SWR_fixed_old+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      _SWR_fixed_old+1
;main.c,228 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,229 :: 		SWR_ind = SWR_fixed;
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      _SWR_ind+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      _SWR_ind+1
;main.c,230 :: 		}
L_watch_swr63:
;main.c,231 :: 		}
	GOTO       L_watch_swr64
L_watch_swr60:
;main.c,232 :: 		else if(SWR_ind!=SWR_ind_old){
	MOVF       _SWR_ind+1, 0
	XORWF      _SWR_ind_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr265
	MOVF       _SWR_ind_old+0, 0
	XORWF      _SWR_ind+0, 0
L__watch_swr265:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr65
;main.c,233 :: 		SWR_ind_old = SWR_ind;
	MOVF       _SWR_ind+0, 0
	MOVWF      _SWR_ind_old+0
	MOVF       _SWR_ind+1, 0
	MOVWF      _SWR_ind_old+1
;main.c,234 :: 		draw_swr(SWR_ind);
	MOVF       _SWR_ind+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       _SWR_ind+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,235 :: 		}
L_watch_swr65:
L_watch_swr64:
L_watch_swr59:
;main.c,237 :: 		return;
;main.c,238 :: 		}
L_end_watch_swr:
	RETURN
; end of _watch_swr

_draw_swr:

;main.c,240 :: 		void draw_swr(int s){
;main.c,241 :: 		if(s==0)
	MOVLW      0
	XORWF      FARG_draw_swr_s+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_swr267
	MOVLW      0
	XORWF      FARG_draw_swr_s+0, 0
L__draw_swr267:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_swr66
;main.c,242 :: 		oled_wr_str(2, 60, "0.00", 4);
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
	GOTO       L_draw_swr67
L_draw_swr66:
;main.c,244 :: 		IntToStr(s, txt_2);
	MOVF       FARG_draw_swr_s+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_swr_s+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,245 :: 		txt[0] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+0
;main.c,246 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,247 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,248 :: 		txt[3] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+3
;main.c,250 :: 		oled_wr_str(2, 60, txt, 4);
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
;main.c,251 :: 		}
L_draw_swr67:
;main.c,252 :: 		return;
;main.c,253 :: 		}
L_end_draw_swr:
	RETURN
; end of _draw_swr

_draw_power:

;main.c,255 :: 		void draw_power(int p){
;main.c,257 :: 		if(p==0){
	MOVLW      0
	XORWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power269
	MOVLW      0
	XORWF      FARG_draw_power_p+0, 0
L__draw_power269:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_power68
;main.c,258 :: 		oled_wr_str(0, 60, "0.0", 3);
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
;main.c,259 :: 		return;
	GOTO       L_end_draw_power
;main.c,260 :: 		}
L_draw_power68:
;main.c,261 :: 		else if(p<10){  // <1 W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power270
	MOVLW      10
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power270:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power70
;main.c,262 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,263 :: 		txt[0] = '0';
	MOVLW      48
	MOVWF      _txt+0
;main.c,264 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,265 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,266 :: 		}
	GOTO       L_draw_power71
L_draw_power70:
;main.c,267 :: 		else if(p<100){ // <10W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power271
	MOVLW      100
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power271:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power72
;main.c,268 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,269 :: 		txt[0] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+0
;main.c,270 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,271 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,272 :: 		}
	GOTO       L_draw_power73
L_draw_power72:
;main.c,274 :: 		p += 5;
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
;main.c,275 :: 		IntToStr(p, txt_2);
	MOVF       R0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,276 :: 		txt[0] = ' ';
	MOVLW      32
	MOVWF      _txt+0
;main.c,277 :: 		txt[1] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+1
;main.c,278 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,279 :: 		}
L_draw_power73:
L_draw_power71:
;main.c,280 :: 		oled_wr_str(0, 60, txt, 3);
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
;main.c,281 :: 		return;
;main.c,282 :: 		}
L_end_draw_power:
	RETURN
; end of _draw_power

_Voltage_show:

;main.c,284 :: 		void Voltage_show(){
;main.c,285 :: 		get_batt();
	CALL       _get_batt+0
;main.c,286 :: 		if(Voltage != Voltage_old) { Voltage_old = Voltage; oled_voltage(Voltage); }
	MOVF       _Voltage+1, 0
	XORWF      _Voltage_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show273
	MOVF       _Voltage_old+0, 0
	XORWF      _Voltage+0, 0
L__Voltage_show273:
	BTFSC      STATUS+0, 2
	GOTO       L_Voltage_show74
	MOVF       _Voltage+0, 0
	MOVWF      _Voltage_old+0
	MOVF       _Voltage+1, 0
	MOVWF      _Voltage_old+1
	MOVF       _Voltage+0, 0
	MOVWF      FARG_oled_voltage+0
	MOVF       _Voltage+1, 0
	MOVWF      FARG_oled_voltage+1
	CALL       _oled_voltage+0
L_Voltage_show74:
;main.c,288 :: 		if(Voltage>3700){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show274
	MOVF       _Voltage+0, 0
	SUBLW      116
L__Voltage_show274:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show75
;main.c,289 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,290 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,291 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show76:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show76
	DECFSZ     R12, 1
	GOTO       L_Voltage_show76
	DECFSZ     R11, 1
	GOTO       L_Voltage_show76
;main.c,292 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,293 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,294 :: 		}
	GOTO       L_Voltage_show77
L_Voltage_show75:
;main.c,295 :: 		else if(Voltage>3590){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show275
	MOVF       _Voltage+0, 0
	SUBLW      6
L__Voltage_show275:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show78
;main.c,296 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,297 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,298 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show79:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show79
	DECFSZ     R12, 1
	GOTO       L_Voltage_show79
	DECFSZ     R11, 1
	GOTO       L_Voltage_show79
;main.c,299 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,300 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,301 :: 		}
	GOTO       L_Voltage_show80
L_Voltage_show78:
;main.c,303 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,304 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,305 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show81:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show81
	DECFSZ     R12, 1
	GOTO       L_Voltage_show81
	DECFSZ     R11, 1
	GOTO       L_Voltage_show81
;main.c,306 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,307 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,308 :: 		}
L_Voltage_show80:
L_Voltage_show77:
;main.c,310 :: 		if(Voltage<3400){
	MOVLW      128
	XORWF      _Voltage+1, 0
	MOVWF      R0
	MOVLW      128
	XORLW      13
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show276
	MOVLW      72
	SUBWF      _Voltage+0, 0
L__Voltage_show276:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show82
;main.c,311 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,312 :: 		oled_wr_str(1, 0, "  LOW BATT ", 11);
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
;main.c,313 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Voltage_show83:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show83
	DECFSZ     R12, 1
	GOTO       L_Voltage_show83
	DECFSZ     R11, 1
	GOTO       L_Voltage_show83
	NOP
;main.c,314 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,315 :: 		power_off();
	CALL       _power_off+0
;main.c,316 :: 		}
L_Voltage_show82:
;main.c,317 :: 		return;
;main.c,318 :: 		}
L_end_Voltage_show:
	RETURN
; end of _Voltage_show

_Btn_xlong:

;main.c,320 :: 		void Btn_xlong(){
;main.c,321 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,322 :: 		btn_cnt = 0;
	CLRF       _btn_cnt+0
	CLRF       _btn_cnt+1
	CLRF       _btn_cnt+2
	CLRF       _btn_cnt+3
;main.c,323 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,324 :: 		oled_wr_str(1, 0, " POWER OFF ", 11);
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr14_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr14_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      11
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,325 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Btn_xlong84:
	DECFSZ     R13, 1
	GOTO       L_Btn_xlong84
	DECFSZ     R12, 1
	GOTO       L_Btn_xlong84
	DECFSZ     R11, 1
	GOTO       L_Btn_xlong84
	NOP
;main.c,326 :: 		power_off();
	CALL       _power_off+0
;main.c,327 :: 		return;
;main.c,328 :: 		}
L_end_Btn_xlong:
	RETURN
; end of _Btn_xlong

_Btn_long:

;main.c,330 :: 		void Btn_long(){
;main.c,331 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,332 :: 		oled_wr_str(2, 0, "TUNE     ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr15_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr15_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,333 :: 		tune();
	CALL       _tune+0
;main.c,334 :: 		SWR_ind = SWR;
	MOVF       _SWR+0, 0
	MOVWF      _SWR_ind+0
	MOVF       _SWR+1, 0
	MOVWF      _SWR_ind+1
;main.c,335 :: 		oled_wr_str(2, 0, "SWR ", 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr16_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr16_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,336 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr17_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr17_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,337 :: 		draw_swr(SWR);
	MOVF       _SWR+0, 0
	MOVWF      FARG_draw_swr_s+0
	MOVF       _SWR+1, 0
	MOVWF      FARG_draw_swr_s+1
	CALL       _draw_swr+0
;main.c,338 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,339 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,340 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
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
;main.c,343 :: 		return;
;main.c,344 :: 		}
L_end_Btn_long:
	RETURN
; end of _Btn_long

_Ext_long:

;main.c,346 :: 		void Ext_long(){
;main.c,347 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,348 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,349 :: 		tune();
	CALL       _tune+0
;main.c,350 :: 		SWR_ind = SWR;
	MOVF       _SWR+0, 0
	MOVWF      _SWR_ind+0
	MOVF       _SWR+1, 0
	MOVWF      _SWR_ind+1
;main.c,351 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,352 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,353 :: 		return;
;main.c,354 :: 		}
L_end_Ext_long:
	RETURN
; end of _Ext_long

_Btn_short:

;main.c,356 :: 		void Btn_short(){
;main.c,357 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,358 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,359 :: 		oled_wr_str(2, 0, "RESET    ", 9);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr18_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr18_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,360 :: 		Delay_ms(600);
	MOVLW      25
	MOVWF      R11
	MOVLW      90
	MOVWF      R12
	MOVLW      177
	MOVWF      R13
L_Btn_short85:
	DECFSZ     R13, 1
	GOTO       L_Btn_short85
	DECFSZ     R12, 1
	GOTO       L_Btn_short85
	DECFSZ     R11, 1
	GOTO       L_Btn_short85
	NOP
	NOP
;main.c,361 :: 		oled_wr_str(2, 0, "SWR  ", 5);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr19_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr19_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      5
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,362 :: 		oled_wr_str(2, 42, "=", 1);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      42
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr20_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr20_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      1
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,363 :: 		oled_wr_str(2, 60, "0.00", 4);
	MOVLW      2
	MOVWF      FARG_oled_wr_str+0
	MOVLW      60
	MOVWF      FARG_oled_wr_str+0
	MOVLW      ?lstr21_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr21_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      4
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,364 :: 		Delay_ms(300);
	MOVLW      13
	MOVWF      R11
	MOVLW      45
	MOVWF      R12
	MOVLW      215
	MOVWF      R13
L_Btn_short86:
	DECFSZ     R13, 1
	GOTO       L_Btn_short86
	DECFSZ     R12, 1
	GOTO       L_Btn_short86
	DECFSZ     R11, 1
	GOTO       L_Btn_short86
	NOP
	NOP
;main.c,365 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,366 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,367 :: 		E_short = 0;
	BCF        _E_short+0, BitPos(_E_short+0)
;main.c,368 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,369 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,370 :: 		return;
;main.c,371 :: 		}
L_end_Btn_short:
	RETURN
; end of _Btn_short

_Greating:

;main.c,373 :: 		void Greating(){
;main.c,374 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,375 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,376 :: 		oled_wr_str_s(0, 0, " DESIGNED BY N7DDC", 18);
	CLRF       FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr22_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr22_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      18
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,377 :: 		oled_wr_str_s(2, 0, " FW VERSION ", 12);
	MOVLW      2
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr23_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr23_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,378 :: 		oled_wr_str_s(2, 12*7, FW_VER, 3);
	MOVLW      2
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      84
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      ?lstr24_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr24_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      3
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,379 :: 		Delay_ms(3000);
	MOVLW      122
	MOVWF      R11
	MOVLW      193
	MOVWF      R12
	MOVLW      129
	MOVWF      R13
L_Greating87:
	DECFSZ     R13, 1
	GOTO       L_Greating87
	DECFSZ     R12, 1
	GOTO       L_Greating87
	DECFSZ     R11, 1
	GOTO       L_Greating87
	NOP
	NOP
;main.c,380 :: 		while(GetButton) asm NOP;
L_Greating88:
	BTFSC      PORTB+0, 5
	GOTO       L__Greating282
	BSF        3, 0
	GOTO       L__Greating283
L__Greating282:
	BCF        3, 0
L__Greating283:
	BTFSS      3, 0
	GOTO       L_Greating89
	NOP
	GOTO       L_Greating88
L_Greating89:
;main.c,381 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,382 :: 		return;
;main.c,383 :: 		}
L_end_Greating:
	RETURN
; end of _Greating

_atu_reset:

;main.c,385 :: 		void atu_reset(){
;main.c,386 :: 		ind = 0;
	CLRF       _ind+0
;main.c,387 :: 		cap = 0;
	CLRF       _cap+0
;main.c,388 :: 		SW = 0;
	CLRF       _SW+0
;main.c,389 :: 		Relay_set(ind, cap, SW);
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CALL       _Relay_set+0
;main.c,390 :: 		return;
;main.c,391 :: 		}
L_end_atu_reset:
	RETURN
; end of _atu_reset

_Relay_set:

;main.c,393 :: 		void Relay_set(char L, char C, char I){
;main.c,394 :: 		L_010 = ~L.B0;
	BTFSC      FARG_Relay_set_L+0, 0
	GOTO       L__Relay_set286
	BSF        LATD7_bit+0, BitPos(LATD7_bit+0)
	GOTO       L__Relay_set287
L__Relay_set286:
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
L__Relay_set287:
;main.c,395 :: 		L_022 = ~L.B1;
	BTFSC      FARG_Relay_set_L+0, 1
	GOTO       L__Relay_set288
	BSF        LATD6_bit+0, BitPos(LATD6_bit+0)
	GOTO       L__Relay_set289
L__Relay_set288:
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
L__Relay_set289:
;main.c,396 :: 		L_045 = ~L.B2;
	BTFSC      FARG_Relay_set_L+0, 2
	GOTO       L__Relay_set290
	BSF        LATD5_bit+0, BitPos(LATD5_bit+0)
	GOTO       L__Relay_set291
L__Relay_set290:
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
L__Relay_set291:
;main.c,397 :: 		L_100 = ~L.B3;
	BTFSC      FARG_Relay_set_L+0, 3
	GOTO       L__Relay_set292
	BSF        LATD4_bit+0, BitPos(LATD4_bit+0)
	GOTO       L__Relay_set293
L__Relay_set292:
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
L__Relay_set293:
;main.c,398 :: 		L_220 = ~L.B4;
	BTFSC      FARG_Relay_set_L+0, 4
	GOTO       L__Relay_set294
	BSF        LATC7_bit+0, BitPos(LATC7_bit+0)
	GOTO       L__Relay_set295
L__Relay_set294:
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
L__Relay_set295:
;main.c,399 :: 		L_450 = ~L.B5;
	BTFSC      FARG_Relay_set_L+0, 5
	GOTO       L__Relay_set296
	BSF        LATC6_bit+0, BitPos(LATC6_bit+0)
	GOTO       L__Relay_set297
L__Relay_set296:
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
L__Relay_set297:
;main.c,400 :: 		L_1000 = ~L.B6;
	BTFSC      FARG_Relay_set_L+0, 6
	GOTO       L__Relay_set298
	BSF        LATC5_bit+0, BitPos(LATC5_bit+0)
	GOTO       L__Relay_set299
L__Relay_set298:
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
L__Relay_set299:
;main.c,402 :: 		C_22 = ~C.B0;
	BTFSC      FARG_Relay_set_C+0, 0
	GOTO       L__Relay_set300
	BSF        LATA5_bit+0, BitPos(LATA5_bit+0)
	GOTO       L__Relay_set301
L__Relay_set300:
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
L__Relay_set301:
;main.c,403 :: 		C_47 = ~C.B1;
	BTFSC      FARG_Relay_set_C+0, 1
	GOTO       L__Relay_set302
	BSF        LATE1_bit+0, BitPos(LATE1_bit+0)
	GOTO       L__Relay_set303
L__Relay_set302:
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
L__Relay_set303:
;main.c,404 :: 		C_100 = ~C.B2;
	BTFSC      FARG_Relay_set_C+0, 2
	GOTO       L__Relay_set304
	BSF        LATA7_bit+0, BitPos(LATA7_bit+0)
	GOTO       L__Relay_set305
L__Relay_set304:
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
L__Relay_set305:
;main.c,405 :: 		C_220 = ~C.B3;
	BTFSC      FARG_Relay_set_C+0, 3
	GOTO       L__Relay_set306
	BSF        LATA6_bit+0, BitPos(LATA6_bit+0)
	GOTO       L__Relay_set307
L__Relay_set306:
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
L__Relay_set307:
;main.c,406 :: 		C_470 = ~C.B4;
	BTFSC      FARG_Relay_set_C+0, 4
	GOTO       L__Relay_set308
	BSF        LATC0_bit+0, BitPos(LATC0_bit+0)
	GOTO       L__Relay_set309
L__Relay_set308:
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
L__Relay_set309:
;main.c,407 :: 		C_1000 = ~C.B5;
	BTFSC      FARG_Relay_set_C+0, 5
	GOTO       L__Relay_set310
	BSF        LATC1_bit+0, BitPos(LATC1_bit+0)
	GOTO       L__Relay_set311
L__Relay_set310:
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
L__Relay_set311:
;main.c,408 :: 		C_2200 = ~C.B6;
	BTFSC      FARG_Relay_set_C+0, 6
	GOTO       L__Relay_set312
	BSF        LATC2_bit+0, BitPos(LATC2_bit+0)
	GOTO       L__Relay_set313
L__Relay_set312:
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
L__Relay_set313:
;main.c,410 :: 		C_sw = I;
	BTFSC      FARG_Relay_set_I+0, 0
	GOTO       L__Relay_set314
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
	GOTO       L__Relay_set315
L__Relay_set314:
	BSF        LATE0_bit+0, BitPos(LATE0_bit+0)
L__Relay_set315:
;main.c,412 :: 		Rel_to_gnd = 1;
	BSF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,413 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,414 :: 		Rel_to_gnd = 0;
	BCF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,415 :: 		Delay_us(10);
	MOVLW      26
	MOVWF      R13
L_Relay_set90:
	DECFSZ     R13, 1
	GOTO       L_Relay_set90
	NOP
;main.c,416 :: 		Rel_to_plus_N = 0;
	BCF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,417 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,418 :: 		Rel_to_plus_N = 1;
	BSF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,419 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,421 :: 		L_010 = 0;
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
;main.c,422 :: 		L_022 = 0;
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
;main.c,423 :: 		L_045 = 0;
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
;main.c,424 :: 		L_100 = 0;
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
;main.c,425 :: 		L_220 = 0;
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
;main.c,426 :: 		L_450 = 0;
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
;main.c,427 :: 		L_1000 = 0;
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
;main.c,429 :: 		C_22 = 0;
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
;main.c,430 :: 		C_47 = 0;
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
;main.c,431 :: 		C_100 = 0;
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
;main.c,432 :: 		C_220 = 0;
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
;main.c,433 :: 		C_470 = 0;
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
;main.c,434 :: 		C_1000 = 0;
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
;main.c,435 :: 		C_2200 = 0;
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
;main.c,436 :: 		return;
;main.c,437 :: 		}
L_end_Relay_set:
	RETURN
; end of _Relay_set

_power_off:

;main.c,439 :: 		void power_off(void){
;main.c,442 :: 		GIE_bit = 0;
	BCF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,443 :: 		T0EN_bit = 0;
	BCF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,444 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;main.c,445 :: 		IOCIE_bit = 1;
	BSF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,446 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,447 :: 		IOCBN5_bit = 1;
	BSF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,449 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,450 :: 		RED = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,451 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,453 :: 		C_sw = 0;
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
;main.c,454 :: 		SYSCMD_bit = 1;
	BSF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,456 :: 		btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
;main.c,457 :: 		while(1){
L_power_off91:
;main.c,458 :: 		if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
	MOVF       power_off_btn_cnt_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_power_off93
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off94:
	DECFSZ     R13, 1
	GOTO       L_power_off94
	DECFSZ     R12, 1
	GOTO       L_power_off94
	DECFSZ     R11, 1
	GOTO       L_power_off94
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
	SLEEP
L_power_off93:
;main.c,459 :: 		asm NOP;
	NOP
;main.c,460 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off95:
	DECFSZ     R13, 1
	GOTO       L_power_off95
	DECFSZ     R12, 1
	GOTO       L_power_off95
	DECFSZ     R11, 1
	GOTO       L_power_off95
;main.c,461 :: 		if(GetButton) btn_cnt++;
	BTFSC      PORTB+0, 5
	GOTO       L__power_off317
	BSF        3, 0
	GOTO       L__power_off318
L__power_off317:
	BCF        3, 0
L__power_off318:
	BTFSS      3, 0
	GOTO       L_power_off96
	INCF       power_off_btn_cnt_L0+0, 1
	GOTO       L_power_off97
L_power_off96:
;main.c,462 :: 		else btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
L_power_off97:
;main.c,463 :: 		if(btn_cnt>25) break;
	MOVF       power_off_btn_cnt_L0+0, 0
	SUBLW      25
	BTFSC      STATUS+0, 0
	GOTO       L_power_off98
	GOTO       L_power_off92
L_power_off98:
;main.c,464 :: 		}
	GOTO       L_power_off91
L_power_off92:
;main.c,466 :: 		SYSCMD_bit = 0;
	BCF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,468 :: 		IOCIE_bit = 0;
	BCF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,469 :: 		IOCBN5_bit = 0;
	BCF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,470 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,471 :: 		T0EN_bit = 1;
	BSF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,472 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,474 :: 		gre = 1;
	BSF        _gre+0, BitPos(_gre+0)
;main.c,475 :: 		oled_start();
	CALL       _oled_start+0
;main.c,476 :: 		while(GetButton){asm NOP;}
L_power_off99:
	BTFSC      PORTB+0, 5
	GOTO       L__power_off319
	BSF        3, 0
	GOTO       L__power_off320
L__power_off319:
	BCF        3, 0
L__power_off320:
	BTFSS      3, 0
	GOTO       L_power_off100
	NOP
	GOTO       L_power_off99
L_power_off100:
;main.c,477 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,478 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,479 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,480 :: 		return;
;main.c,481 :: 		}
L_end_power_off:
	RETURN
; end of _power_off

_check_reset_flags:

;main.c,484 :: 		void check_reset_flags(void){
;main.c,485 :: 		char i = 0;
	CLRF       check_reset_flags_i_L0+0
;main.c,486 :: 		if(STKOVF_bit){oled_wr_str_s(0,  0, "Stack overflow",  14); i = 1;}
	BTFSS      STKOVF_bit+0, BitPos(STKOVF_bit+0)
	GOTO       L_check_reset_flags101
	CLRF       FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr25_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr25_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      14
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags101:
;main.c,487 :: 		if(STKUNF_bit){oled_wr_str_s(1,  0, "Stack underflow", 15); i = 1;}
	BTFSS      STKUNF_bit+0, BitPos(STKUNF_bit+0)
	GOTO       L_check_reset_flags102
	MOVLW      1
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr26_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr26_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      15
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags102:
;main.c,488 :: 		if(!nRWDT_bit){oled_wr_str_s(2,  0, "WDT overflow",    12); i = 1;}
	BTFSC      nRWDT_bit+0, BitPos(nRWDT_bit+0)
	GOTO       L_check_reset_flags103
	MOVLW      2
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
L_check_reset_flags103:
;main.c,489 :: 		if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ",    12); i = 1;}
	BTFSC      nRMCLR_bit+0, BitPos(nRMCLR_bit+0)
	GOTO       L_check_reset_flags104
	MOVLW      3
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
L_check_reset_flags104:
;main.c,490 :: 		if(!nBOR_bit){oled_wr_str_s(4,   0, "BOR reset  ",     12); i = 1;}
	BTFSC      nBOR_bit+0, BitPos(nBOR_bit+0)
	GOTO       L_check_reset_flags105
	MOVLW      4
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr29_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr29_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
	MOVLW      1
	MOVWF      check_reset_flags_i_L0+0
L_check_reset_flags105:
;main.c,491 :: 		if(i){
	MOVF       check_reset_flags_i_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_check_reset_flags106
;main.c,492 :: 		Delay_ms(5000);
	MOVLW      203
	MOVWF      R11
	MOVLW      236
	MOVWF      R12
	MOVLW      132
	MOVWF      R13
L_check_reset_flags107:
	DECFSZ     R13, 1
	GOTO       L_check_reset_flags107
	DECFSZ     R12, 1
	GOTO       L_check_reset_flags107
	DECFSZ     R11, 1
	GOTO       L_check_reset_flags107
	NOP
;main.c,493 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,494 :: 		}
L_check_reset_flags106:
;main.c,495 :: 		return;
;main.c,496 :: 		}
L_end_check_reset_flags:
	RETURN
; end of _check_reset_flags

_correction:

;main.c,498 :: 		int correction(int input) {
;main.c,499 :: 		input *= 2;
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
;main.c,501 :: 		if(input <= 588) input += 376;
	MOVLW      128
	XORLW      2
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction323
	MOVF       R1, 0
	SUBLW      76
L__correction323:
	BTFSS      STATUS+0, 0
	GOTO       L_correction108
	MOVLW      120
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction109
L_correction108:
;main.c,502 :: 		else if(input <= 882) input += 400;
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction324
	MOVF       FARG_correction_input+0, 0
	SUBLW      114
L__correction324:
	BTFSS      STATUS+0, 0
	GOTO       L_correction110
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction111
L_correction110:
;main.c,503 :: 		else if(input <= 1313) input += 476;
	MOVLW      128
	XORLW      5
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction325
	MOVF       FARG_correction_input+0, 0
	SUBLW      33
L__correction325:
	BTFSS      STATUS+0, 0
	GOTO       L_correction112
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction113
L_correction112:
;main.c,504 :: 		else if(input <= 1900) input += 514;
	MOVLW      128
	XORLW      7
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction326
	MOVF       FARG_correction_input+0, 0
	SUBLW      108
L__correction326:
	BTFSS      STATUS+0, 0
	GOTO       L_correction114
	MOVLW      2
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction115
L_correction114:
;main.c,505 :: 		else if(input <= 2414) input += 568;
	MOVLW      128
	XORLW      9
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction327
	MOVF       FARG_correction_input+0, 0
	SUBLW      110
L__correction327:
	BTFSS      STATUS+0, 0
	GOTO       L_correction116
	MOVLW      56
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction117
L_correction116:
;main.c,506 :: 		else if(input <= 2632) input += 644;
	MOVLW      128
	XORLW      10
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction328
	MOVF       FARG_correction_input+0, 0
	SUBLW      72
L__correction328:
	BTFSS      STATUS+0, 0
	GOTO       L_correction118
	MOVLW      132
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction119
L_correction118:
;main.c,507 :: 		else if(input <= 2942) input += 732;
	MOVLW      128
	XORLW      11
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction329
	MOVF       FARG_correction_input+0, 0
	SUBLW      126
L__correction329:
	BTFSS      STATUS+0, 0
	GOTO       L_correction120
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction121
L_correction120:
;main.c,508 :: 		else if(input <= 3232) input += 784;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction330
	MOVF       FARG_correction_input+0, 0
	SUBLW      160
L__correction330:
	BTFSS      STATUS+0, 0
	GOTO       L_correction122
	MOVLW      16
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction123
L_correction122:
;main.c,509 :: 		else if(input <= 3324) input += 992;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction331
	MOVF       FARG_correction_input+0, 0
	SUBLW      252
L__correction331:
	BTFSS      STATUS+0, 0
	GOTO       L_correction124
	MOVLW      224
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction125
L_correction124:
;main.c,510 :: 		else if(input <= 3720) input += 1000;
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction332
	MOVF       FARG_correction_input+0, 0
	SUBLW      136
L__correction332:
	BTFSS      STATUS+0, 0
	GOTO       L_correction126
	MOVLW      232
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction127
L_correction126:
;main.c,511 :: 		else if(input <= 4340) input += 1160;
	MOVLW      128
	XORLW      16
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction333
	MOVF       FARG_correction_input+0, 0
	SUBLW      244
L__correction333:
	BTFSS      STATUS+0, 0
	GOTO       L_correction128
	MOVLW      136
	ADDWF      FARG_correction_input+0, 1
	MOVLW      4
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction129
L_correction128:
;main.c,512 :: 		else if(input <= 4808) input += 1360;
	MOVLW      128
	XORLW      18
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction334
	MOVF       FARG_correction_input+0, 0
	SUBLW      200
L__correction334:
	BTFSS      STATUS+0, 0
	GOTO       L_correction130
	MOVLW      80
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction131
L_correction130:
;main.c,513 :: 		else if(input <= 5272) input += 1424;
	MOVLW      128
	XORLW      20
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction335
	MOVF       FARG_correction_input+0, 0
	SUBLW      152
L__correction335:
	BTFSS      STATUS+0, 0
	GOTO       L_correction132
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction133
L_correction132:
;main.c,514 :: 		else  input += 1432;
	MOVLW      152
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
L_correction133:
L_correction131:
L_correction129:
L_correction127:
L_correction125:
L_correction123:
L_correction121:
L_correction119:
L_correction117:
L_correction115:
L_correction113:
L_correction111:
L_correction109:
;main.c,516 :: 		return input;
	MOVF       FARG_correction_input+0, 0
	MOVWF      R0
	MOVF       FARG_correction_input+1, 0
	MOVWF      R1
;main.c,517 :: 		}
L_end_correction:
	RETURN
; end of _correction

_get_reverse:

;main.c,519 :: 		int get_reverse(void){
;main.c,522 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,523 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse134:
	DECFSZ     R13, 1
	GOTO       L_get_reverse134
	DECFSZ     R12, 1
	GOTO       L_get_reverse134
	NOP
;main.c,524 :: 		v = ADC_Get_Sample(REV_input);
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,525 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse337
	MOVLW      255
	XORWF      R0, 0
L__get_reverse337:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse135
;main.c,526 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,527 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse136:
	DECFSZ     R13, 1
	GOTO       L_get_reverse136
	DECFSZ     R12, 1
	GOTO       L_get_reverse136
	NOP
;main.c,528 :: 		v = ADC_Get_Sample(REV_input) * 2;
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
	LSLF       get_reverse_v_L0+0, 1
	RLF        get_reverse_v_L0+1, 1
;main.c,529 :: 		}
L_get_reverse135:
;main.c,530 :: 		if(v==1023*2){
	MOVF       get_reverse_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse338
	MOVLW      254
	XORWF      get_reverse_v_L0+0, 0
L__get_reverse338:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse137
;main.c,531 :: 		get_batt();
	CALL       _get_batt+0
;main.c,532 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,533 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse138:
	DECFSZ     R13, 1
	GOTO       L_get_reverse138
	DECFSZ     R12, 1
	GOTO       L_get_reverse138
	NOP
;main.c,534 :: 		v = ADC_Get_Sample(FWD_input);
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
;main.c,535 :: 		f = Voltage / 1024;
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
;main.c,536 :: 		v = v * f;
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
;main.c,537 :: 		}
L_get_reverse137:
;main.c,538 :: 		return v;
	MOVF       get_reverse_v_L0+0, 0
	MOVWF      R0
	MOVF       get_reverse_v_L0+1, 0
	MOVWF      R1
;main.c,539 :: 		}
L_end_get_reverse:
	RETURN
; end of _get_reverse

_get_forward:

;main.c,541 :: 		int get_forward(void){
;main.c,544 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,545 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward139:
	DECFSZ     R13, 1
	GOTO       L_get_forward139
	DECFSZ     R12, 1
	GOTO       L_get_forward139
	NOP
;main.c,546 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,547 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward340
	MOVLW      255
	XORWF      R0, 0
L__get_forward340:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward140
;main.c,548 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,549 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward141:
	DECFSZ     R13, 1
	GOTO       L_get_forward141
	DECFSZ     R12, 1
	GOTO       L_get_forward141
	NOP
;main.c,550 :: 		v = ADC_Get_Sample(FWD_input) * 2;
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
	LSLF       get_forward_v_L0+0, 1
	RLF        get_forward_v_L0+1, 1
;main.c,551 :: 		}
L_get_forward140:
;main.c,552 :: 		if(v==1023*2){
	MOVF       get_forward_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward341
	MOVLW      254
	XORWF      get_forward_v_L0+0, 0
L__get_forward341:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward142
;main.c,553 :: 		get_batt();
	CALL       _get_batt+0
;main.c,554 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,555 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward143:
	DECFSZ     R13, 1
	GOTO       L_get_forward143
	DECFSZ     R12, 1
	GOTO       L_get_forward143
	NOP
;main.c,556 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,557 :: 		if(v==1023) Overflow = 1;
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward342
	MOVLW      255
	XORWF      R0, 0
L__get_forward342:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward144
	BSF        _Overflow+0, BitPos(_Overflow+0)
L_get_forward144:
;main.c,558 :: 		f = Voltage / 1024;
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
;main.c,559 :: 		v = v * f;
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
;main.c,560 :: 		}
L_get_forward142:
;main.c,561 :: 		return v;
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R0
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R1
;main.c,562 :: 		}
L_end_get_forward:
	RETURN
; end of _get_forward

_get_pwr:

;main.c,565 :: 		void get_pwr(){
;main.c,569 :: 		Forward = get_forward();
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
;main.c,570 :: 		Reverse = get_reverse();
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
;main.c,575 :: 		p = correction(Forward);
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      FARG_correction_input+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      FARG_correction_input+1
	CALL       _correction+0
	CALL       _int2double+0
;main.c,576 :: 		P = p * 5 / 1000;
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
;main.c,577 :: 		p = p / 1.414;
	MOVLW      244
	MOVWF      R4
	MOVLW      253
	MOVWF      R5
	MOVLW      52
	MOVWF      R6
	MOVLW      127
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,578 :: 		p = p * p;
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
;main.c,579 :: 		p = p / 5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      32
	MOVWF      R6
	MOVLW      129
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,580 :: 		p += 0.5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      126
	MOVWF      R7
	CALL       _Add_32x32_FP+0
;main.c,581 :: 		PWR = p;
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      _PWR+0
	MOVF       R1, 0
	MOVWF      _PWR+1
;main.c,583 :: 		if(PWR>0){
	MOVLW      128
	MOVWF      R2
	MOVLW      128
	XORWF      R1, 0
	SUBWF      R2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr344
	MOVF       R0, 0
	SUBLW      0
L__get_pwr344:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr145
;main.c,584 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_get_pwr146
;main.c,585 :: 		disp_cnt = Tick + Disp_time*1000;
	MOVF       _Disp_time+0, 0
	MOVWF      R0
	MOVF       _Disp_time+1, 0
	MOVWF      R1
	MOVF       _Disp_time+2, 0
	MOVWF      R2
	MOVF       _Disp_time+3, 0
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
	MOVWF      _disp_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _disp_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _disp_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _disp_cnt+3
;main.c,586 :: 		off_cnt = Tick + Off_time*1000;
	MOVF       _Off_time+0, 0
	MOVWF      R0
	MOVF       _Off_time+1, 0
	MOVWF      R1
	MOVF       _Off_time+2, 0
	MOVWF      R2
	MOVF       _Off_time+3, 0
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
	MOVWF      _off_cnt+0
	MOVF       R1, 0
	ADDWFC     _Tick+1, 0
	MOVWF      _off_cnt+1
	MOVF       R2, 0
	ADDWFC     _Tick+2, 0
	MOVWF      _off_cnt+2
	MOVF       R3, 0
	ADDWFC     _Tick+3, 0
	MOVWF      _off_cnt+3
;main.c,587 :: 		}
	GOTO       L_get_pwr147
L_get_pwr146:
;main.c,588 :: 		else oled_start();
	CALL       _oled_start+0
L_get_pwr147:
;main.c,589 :: 		}
L_get_pwr145:
;main.c,591 :: 		if(Reverse >= Forward)
	MOVLW      128
	XORWF      get_pwr_Reverse_L0+3, 0
	MOVWF      R0
	MOVLW      128
	XORWF      get_pwr_Forward_L0+3, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr345
	MOVF       get_pwr_Forward_L0+2, 0
	SUBWF      get_pwr_Reverse_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr345
	MOVF       get_pwr_Forward_L0+1, 0
	SUBWF      get_pwr_Reverse_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr345
	MOVF       get_pwr_Forward_L0+0, 0
	SUBWF      get_pwr_Reverse_L0+0, 0
L__get_pwr345:
	BTFSS      STATUS+0, 0
	GOTO       L_get_pwr148
;main.c,592 :: 		Forward = 999;
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
	GOTO       L_get_pwr149
L_get_pwr148:
;main.c,594 :: 		Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
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
;main.c,595 :: 		if(Forward>999) Forward = 999;
	MOVLW      128
	MOVWF      R4
	MOVLW      128
	XORWF      R3, 0
	SUBWF      R4, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr346
	MOVF       R2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr346
	MOVF       R1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr346
	MOVF       R0, 0
	SUBLW      231
L__get_pwr346:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr150
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
L_get_pwr150:
;main.c,596 :: 		}
L_get_pwr149:
;main.c,598 :: 		SWR = Forward;
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      _SWR+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      _SWR+1
;main.c,599 :: 		return;
;main.c,600 :: 		}
L_end_get_pwr:
	RETURN
; end of _get_pwr

_get_swr:

;main.c,602 :: 		void get_swr(){
;main.c,603 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,604 :: 		tune_cnt = 500;
	MOVLW      244
	MOVWF      _tune_cnt+0
	MOVLW      1
	MOVWF      _tune_cnt+1
	CLRF       _tune_cnt+2
	CLRF       _tune_cnt+3
;main.c,605 :: 		while(PWR<min_for_start | PWR>max_for_start){   // waiting for good power
L_get_swr151:
	MOVLW      128
	XORWF      _PWR+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr348
	MOVF       _min_for_start+0, 0
	SUBWF      _PWR+0, 0
L__get_swr348:
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
	GOTO       L__get_swr349
	MOVF       _PWR+0, 0
	SUBWF      _max_for_start+0, 0
L__get_swr349:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_get_swr152
;main.c,606 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_get_swr153
;main.c,607 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,608 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,609 :: 		return;
	GOTO       L_end_get_swr
;main.c,610 :: 		}
L_get_swr153:
;main.c,611 :: 		if(B_xlong){
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_get_swr154
;main.c,612 :: 		Btn_xlong();
	CALL       _Btn_xlong+0
;main.c,613 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,614 :: 		return;
	GOTO       L_end_get_swr
;main.c,615 :: 		}
L_get_swr154:
;main.c,616 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,617 :: 		draw_power(PWR);
	MOVF       _PWR+0, 0
	MOVWF      FARG_draw_power_p+0
	MOVF       _PWR+1, 0
	MOVWF      FARG_draw_power_p+1
	CALL       _draw_power+0
;main.c,618 :: 		if(tune_cnt>0) tune_cnt --;
	MOVF       _tune_cnt+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr350
	MOVF       _tune_cnt+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr350
	MOVF       _tune_cnt+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr350
	MOVF       _tune_cnt+0, 0
	SUBLW      0
L__get_swr350:
	BTFSC      STATUS+0, 0
	GOTO       L_get_swr155
	MOVLW      1
	SUBWF      _tune_cnt+0, 1
	MOVLW      0
	SUBWFB     _tune_cnt+1, 1
	SUBWFB     _tune_cnt+2, 1
	SUBWFB     _tune_cnt+3, 1
	GOTO       L_get_swr156
L_get_swr155:
;main.c,620 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,621 :: 		return;
	GOTO       L_end_get_swr
;main.c,622 :: 		}
L_get_swr156:
;main.c,623 :: 		}
	GOTO       L_get_swr151
L_get_swr152:
;main.c,625 :: 		return;
;main.c,626 :: 		}
L_end_get_swr:
	RETURN
; end of _get_swr

_get_batt:

;main.c,628 :: 		void get_batt(void){
;main.c,629 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,630 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_batt157:
	DECFSZ     R13, 1
	GOTO       L_get_batt157
	DECFSZ     R12, 1
	GOTO       L_get_batt157
	NOP
;main.c,631 :: 		Voltage = ADC_Get_Sample(Battery_input) * 11;
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
;main.c,632 :: 		return;
;main.c,633 :: 		}
L_end_get_batt:
	RETURN
; end of _get_batt

_coarse_cap:

;main.c,635 :: 		void coarse_cap() {
;main.c,636 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_cap_step_L0+0
;main.c,640 :: 		cap = 0;
	CLRF       _cap+0
;main.c,641 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	CLRF       FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,642 :: 		get_swr();
	CALL       _get_swr+0
;main.c,643 :: 		min_swr = SWR + SWR/20;
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
;main.c,644 :: 		for(count=step; count<=31;) {
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      coarse_cap_count_L0+0
L_coarse_cap158:
	MOVF       coarse_cap_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_cap159
;main.c,645 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,646 :: 		get_swr();
	CALL       _get_swr+0
;main.c,647 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap353
	MOVF       coarse_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_cap353:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap161
;main.c,648 :: 		min_swr = SWR + SWR/20;
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
;main.c,649 :: 		cap = count;
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,650 :: 		step_cap = step;
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      _step_cap+0
;main.c,651 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap354
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_cap354:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap162
	GOTO       L_coarse_cap159
L_coarse_cap162:
;main.c,652 :: 		count += step;
	MOVF       coarse_cap_step_L0+0, 0
	ADDWF      coarse_cap_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_cap_count_L0+0
;main.c,653 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap163
	MOVLW      8
	MOVWF      coarse_cap_count_L0+0
	GOTO       L_coarse_cap164
L_coarse_cap163:
;main.c,654 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_cap_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap165
	MOVLW      16
	MOVWF      coarse_cap_count_L0+0
	MOVLW      4
	MOVWF      coarse_cap_step_L0+0
L_coarse_cap165:
L_coarse_cap164:
;main.c,655 :: 		}
	GOTO       L_coarse_cap166
L_coarse_cap161:
;main.c,656 :: 		else break;
	GOTO       L_coarse_cap159
L_coarse_cap166:
;main.c,657 :: 		}
	GOTO       L_coarse_cap158
L_coarse_cap159:
;main.c,658 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,659 :: 		return;
;main.c,660 :: 		}
L_end_coarse_cap:
	RETURN
; end of _coarse_cap

_coarse_tune:

;main.c,662 :: 		void coarse_tune() {
;main.c,663 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_tune_step_L0+0
;main.c,668 :: 		mem_cap = 0;
	CLRF       coarse_tune_mem_cap_L0+0
;main.c,669 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,670 :: 		mem_step_cap = 3;
	MOVLW      3
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,671 :: 		min_swr = SWR + SWR/20;
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
;main.c,672 :: 		for(count=step; count<=31;) {
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      coarse_tune_count_L0+0
L_coarse_tune167:
	MOVF       coarse_tune_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_tune168
;main.c,673 :: 		Relay_set(count, cap, SW);
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,674 :: 		coarse_cap();
	CALL       _coarse_cap+0
;main.c,675 :: 		get_swr();
	CALL       _get_swr+0
;main.c,676 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_tune_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune356
	MOVF       coarse_tune_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_tune356:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune170
;main.c,677 :: 		min_swr = SWR + SWR/20;
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
;main.c,678 :: 		ind = count;
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      _ind+0
;main.c,679 :: 		mem_cap = cap;
	MOVF       _cap+0, 0
	MOVWF      coarse_tune_mem_cap_L0+0
;main.c,680 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,681 :: 		mem_step_cap = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,682 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune357
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_tune357:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune171
	GOTO       L_coarse_tune168
L_coarse_tune171:
;main.c,683 :: 		count += step;
	MOVF       coarse_tune_step_L0+0, 0
	ADDWF      coarse_tune_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_tune_count_L0+0
;main.c,684 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune172
	MOVLW      8
	MOVWF      coarse_tune_count_L0+0
	GOTO       L_coarse_tune173
L_coarse_tune172:
;main.c,685 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_tune_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune174
	MOVLW      16
	MOVWF      coarse_tune_count_L0+0
	MOVLW      4
	MOVWF      coarse_tune_step_L0+0
L_coarse_tune174:
L_coarse_tune173:
;main.c,686 :: 		}
	GOTO       L_coarse_tune175
L_coarse_tune170:
;main.c,687 :: 		else break;
	GOTO       L_coarse_tune168
L_coarse_tune175:
;main.c,688 :: 		}
	GOTO       L_coarse_tune167
L_coarse_tune168:
;main.c,689 :: 		cap = mem_cap;
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      _cap+0
;main.c,690 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,691 :: 		step_cap = mem_step_cap;
	MOVF       coarse_tune_mem_step_cap_L0+0, 0
	MOVWF      _step_cap+0
;main.c,692 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_coarse_tune176:
	DECFSZ     R13, 1
	GOTO       L_coarse_tune176
	DECFSZ     R12, 1
	GOTO       L_coarse_tune176
	NOP
;main.c,693 :: 		return;
;main.c,694 :: 		}
L_end_coarse_tune:
	RETURN
; end of _coarse_tune

_sharp_cap:

;main.c,696 :: 		void sharp_cap() {
;main.c,699 :: 		range = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      sharp_cap_range_L0+0
;main.c,701 :: 		max_range = cap + range;
	MOVF       _step_cap+0, 0
	ADDWF      _cap+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_cap_max_range_L0+0
;main.c,702 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap177
	MOVLW      31
	MOVWF      sharp_cap_max_range_L0+0
L_sharp_cap177:
;main.c,703 :: 		if(cap>range) min_range = cap - range; else min_range = 0;
	MOVF       _cap+0, 0
	SUBWF      sharp_cap_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap178
	MOVF       sharp_cap_range_L0+0, 0
	SUBWF      _cap+0, 0
	MOVWF      sharp_cap_min_range_L0+0
	GOTO       L_sharp_cap179
L_sharp_cap178:
	CLRF       sharp_cap_min_range_L0+0
L_sharp_cap179:
;main.c,704 :: 		cap = min_range;
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      _cap+0
;main.c,705 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,706 :: 		get_swr();
	CALL       _get_swr+0
;main.c,707 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap359
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap359:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap180
	GOTO       L_end_sharp_cap
L_sharp_cap180:
;main.c,708 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,709 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_min_range_L0+0, 0
	MOVWF      sharp_cap_count_L0+0
L_sharp_cap181:
	MOVF       sharp_cap_count_L0+0, 0
	SUBWF      sharp_cap_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap182
;main.c,710 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,711 :: 		get_swr();
	CALL       _get_swr+0
;main.c,712 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap360
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap360:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap184
	GOTO       L_end_sharp_cap
L_sharp_cap184:
;main.c,713 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap361
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap361:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap185
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap186:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap186
	DECFSZ     R12, 1
	GOTO       L_sharp_cap186
	NOP
	CALL       _get_swr+0
L_sharp_cap185:
;main.c,714 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap362
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap362:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap187
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap188:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap188
	DECFSZ     R12, 1
	GOTO       L_sharp_cap188
	NOP
	CALL       _get_swr+0
L_sharp_cap187:
;main.c,715 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap363
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap363:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap189
;main.c,716 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,717 :: 		cap = count;
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,718 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap364
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_cap364:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap190
	GOTO       L_sharp_cap182
L_sharp_cap190:
;main.c,719 :: 		}
	GOTO       L_sharp_cap191
L_sharp_cap189:
;main.c,720 :: 		else break;
	GOTO       L_sharp_cap182
L_sharp_cap191:
;main.c,709 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_count_L0+0, 1
;main.c,721 :: 		}
	GOTO       L_sharp_cap181
L_sharp_cap182:
;main.c,722 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,723 :: 		return;
;main.c,724 :: 		}
L_end_sharp_cap:
	RETURN
; end of _sharp_cap

_sharp_ind:

;main.c,726 :: 		void sharp_ind() {
;main.c,729 :: 		range = step_ind;
	MOVF       _step_ind+0, 0
	MOVWF      sharp_ind_range_L0+0
;main.c,731 :: 		max_range = ind + range;
	MOVF       _step_ind+0, 0
	ADDWF      _ind+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_ind_max_range_L0+0
;main.c,732 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind192
	MOVLW      31
	MOVWF      sharp_ind_max_range_L0+0
L_sharp_ind192:
;main.c,733 :: 		if(ind>range) min_range = ind - range; else min_range = 0;
	MOVF       _ind+0, 0
	SUBWF      sharp_ind_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind193
	MOVF       sharp_ind_range_L0+0, 0
	SUBWF      _ind+0, 0
	MOVWF      sharp_ind_min_range_L0+0
	GOTO       L_sharp_ind194
L_sharp_ind193:
	CLRF       sharp_ind_min_range_L0+0
L_sharp_ind194:
;main.c,734 :: 		ind = min_range;
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      _ind+0
;main.c,735 :: 		Relay_set(ind, cap, SW);
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,736 :: 		get_swr();
	CALL       _get_swr+0
;main.c,737 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind366
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind366:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind195
	GOTO       L_end_sharp_ind
L_sharp_ind195:
;main.c,738 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,739 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_min_range_L0+0, 0
	MOVWF      sharp_ind_count_L0+0
L_sharp_ind196:
	MOVF       sharp_ind_count_L0+0, 0
	SUBWF      sharp_ind_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind197
;main.c,740 :: 		Relay_set(count, cap, SW);
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,741 :: 		get_swr();
	CALL       _get_swr+0
;main.c,742 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind367
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind367:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind199
	GOTO       L_end_sharp_ind
L_sharp_ind199:
;main.c,743 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind368
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind368:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind200
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind201:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind201
	DECFSZ     R12, 1
	GOTO       L_sharp_ind201
	NOP
	CALL       _get_swr+0
L_sharp_ind200:
;main.c,744 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind369
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind369:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind202
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind203:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind203
	DECFSZ     R12, 1
	GOTO       L_sharp_ind203
	NOP
	CALL       _get_swr+0
L_sharp_ind202:
;main.c,745 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind370
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind370:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind204
;main.c,746 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,747 :: 		ind = count;
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      _ind+0
;main.c,748 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind371
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_ind371:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind205
	GOTO       L_sharp_ind197
L_sharp_ind205:
;main.c,749 :: 		}
	GOTO       L_sharp_ind206
L_sharp_ind204:
;main.c,750 :: 		else break;
	GOTO       L_sharp_ind197
L_sharp_ind206:
;main.c,739 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_count_L0+0, 1
;main.c,751 :: 		}
	GOTO       L_sharp_ind196
L_sharp_ind197:
;main.c,752 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,753 :: 		return;
;main.c,754 :: 		}
L_end_sharp_ind:
	RETURN
; end of _sharp_ind

_tune:

;main.c,757 :: 		void tune() {
;main.c,759 :: 		asm CLRWDT;
	CLRWDT
;main.c,760 :: 		Key_out = 0;
	BCF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,761 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_tune207:
	DECFSZ     R13, 1
	GOTO       L_tune207
	DECFSZ     R12, 1
	GOTO       L_tune207
	DECFSZ     R11, 1
	GOTO       L_tune207
;main.c,762 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune373
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune373:
	BTFSC      STATUS+0, 0
	GOTO       L_tune208
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune208:
;main.c,763 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,764 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune209:
	DECFSZ     R13, 1
	GOTO       L_tune209
	DECFSZ     R12, 1
	GOTO       L_tune209
	DECFSZ     R11, 1
	GOTO       L_tune209
;main.c,765 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune374
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune374:
	BTFSC      STATUS+0, 0
	GOTO       L_tune210
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune210:
;main.c,767 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,768 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune375
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune375:
	BTFSS      STATUS+0, 2
	GOTO       L_tune211
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune211:
;main.c,769 :: 		get_swr(); if(SWR<120) { Key_out = 1;  return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune376
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune376:
	BTFSC      STATUS+0, 0
	GOTO       L_tune212
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune212:
;main.c,770 :: 		sharp_ind();  if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune377
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune377:
	BTFSS      STATUS+0, 2
	GOTO       L_tune213
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune213:
;main.c,771 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune378
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune378:
	BTFSC      STATUS+0, 0
	GOTO       L_tune214
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune214:
;main.c,772 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune379
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune379:
	BTFSS      STATUS+0, 2
	GOTO       L_tune215
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune215:
;main.c,773 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune380
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune380:
	BTFSC      STATUS+0, 0
	GOTO       L_tune216
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune216:
;main.c,775 :: 		if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) { Key_out = 1; return; }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R1
	MOVLW      128
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune381
	MOVLW      200
	SUBWF      _SWR+0, 0
L__tune381:
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
	GOTO       L__tune382
	MOVF       tune_swr_mem_L0+0, 0
	SUBWF      _SWR+0, 0
L__tune382:
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
	GOTO       L__tune383
	MOVF       R1, 0
	SUBLW      100
L__tune383:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R3, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_tune217
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune217:
;main.c,776 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,777 :: 		ind_mem = ind;
	MOVF       _ind+0, 0
	MOVWF      tune_ind_mem_L0+0
	CLRF       tune_ind_mem_L0+1
;main.c,778 :: 		cap_mem = cap;
	MOVF       _cap+0, 0
	MOVWF      tune_cap_mem_L0+0
	CLRF       tune_cap_mem_L0+1
;main.c,780 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune218
	CLRF       _SW+0
	GOTO       L_tune219
L_tune218:
	MOVLW      1
	MOVWF      _SW+0
L_tune219:
;main.c,781 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,782 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,783 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune220:
	DECFSZ     R13, 1
	GOTO       L_tune220
	DECFSZ     R12, 1
	GOTO       L_tune220
	DECFSZ     R11, 1
	GOTO       L_tune220
;main.c,784 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune384
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune384:
	BTFSC      STATUS+0, 0
	GOTO       L_tune221
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune221:
;main.c,786 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune385
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune385:
	BTFSS      STATUS+0, 2
	GOTO       L_tune222
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune222:
;main.c,787 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune386
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune386:
	BTFSC      STATUS+0, 0
	GOTO       L_tune223
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune223:
;main.c,788 :: 		sharp_ind(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune387
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune387:
	BTFSS      STATUS+0, 2
	GOTO       L_tune224
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune224:
;main.c,789 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune388
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune388:
	BTFSC      STATUS+0, 0
	GOTO       L_tune225
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune225:
;main.c,790 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune389
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune389:
	BTFSS      STATUS+0, 2
	GOTO       L_tune226
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune226:
;main.c,791 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune390
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune390:
	BTFSC      STATUS+0, 0
	GOTO       L_tune227
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune227:
;main.c,793 :: 		if(SWR>swr_mem) {
	MOVLW      128
	XORWF      tune_swr_mem_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _SWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune391
	MOVF       _SWR+0, 0
	SUBWF      tune_swr_mem_L0+0, 0
L__tune391:
	BTFSC      STATUS+0, 0
	GOTO       L_tune228
;main.c,794 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune229
	CLRF       _SW+0
	GOTO       L_tune230
L_tune229:
	MOVLW      1
	MOVWF      _SW+0
L_tune230:
;main.c,795 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,796 :: 		ind = ind_mem;
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      _ind+0
;main.c,797 :: 		cap = cap_mem;
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      _cap+0
;main.c,798 :: 		Relay_set(ind, cap, sw);
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,799 :: 		SWR = swr_mem;
	MOVF       tune_swr_mem_L0+0, 0
	MOVWF      _SWR+0
	MOVF       tune_swr_mem_L0+1, 0
	MOVWF      _SWR+1
;main.c,800 :: 		}
L_tune228:
;main.c,802 :: 		asm CLRWDT;
	CLRWDT
;main.c,803 :: 		Key_out = 1;
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,804 :: 		return;
;main.c,805 :: 		}
L_end_tune:
	RETURN
; end of _tune

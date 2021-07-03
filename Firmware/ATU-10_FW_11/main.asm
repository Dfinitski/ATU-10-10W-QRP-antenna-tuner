
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
	GOTO       L__interupt230
	MOVF       _btn_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt230
	MOVF       _btn_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt230
	MOVF       _btn_cnt+0, 0
	SUBWF      _Tick+0, 0
L__interupt230:
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
	GOTO       L__interupt231
	BSF        R4, 0
	GOTO       L__interupt232
L__interupt231:
	BCF        R4, 0
L__interupt232:
	BTFSC      PORTD+0, 1
	GOTO       L__interupt233
	BSF        3, 0
	GOTO       L__interupt234
L__interupt233:
	BCF        3, 0
L__interupt234:
	BTFSC      R4, 0
	GOTO       L__interupt235
	BTFSC      3, 0
	GOTO       L__interupt235
	BCF        R4, 0
	GOTO       L__interupt236
L__interupt235:
	BSF        R4, 0
L__interupt236:
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
	GOTO       L__interupt237
	BSF        3, 0
	GOTO       L__interupt238
L__interupt237:
	BCF        3, 0
L__interupt238:
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
	GOTO       L__interupt239
	BSF        3, 0
	GOTO       L__interupt240
L__interupt239:
	BCF        3, 0
L__interupt240:
	BTFSS      3, 0
	GOTO       L_interupt10
;main.c,60 :: 		if(btn_2_cnt<25) btn_2_cnt++;
	MOVLW      25
	SUBWF      _btn_2_cnt+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interupt11
	INCF       _btn_2_cnt+0, 1
L_interupt11:
;main.c,61 :: 		if(btn_2_cnt==20) E_long = 1;
	MOVF       _btn_2_cnt+0, 0
	XORLW      20
	BTFSS      STATUS+0, 2
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
L__interupt229:
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
	GOTO       L__main242
	MOVF       _volt_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main242
	MOVF       _volt_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main242
	MOVF       _volt_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main242:
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
	GOTO       L__main243
	MOVF       _watch_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main243
	MOVF       _watch_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main243
	MOVF       _watch_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main243:
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
	GOTO       L__main244
	MOVF       _disp_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main244
	MOVF       _disp_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main244
	MOVF       _disp_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main244:
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
	GOTO       L__main245
	MOVF       _off_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main245
	MOVF       _off_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main245
	MOVF       _off_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main245:
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
;main.c,162 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,163 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,164 :: 		B_short = 0; B_long = 0; B_xlong = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
	BCF        _B_long+0, BitPos(_B_long+0)
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,165 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,166 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,167 :: 		return;
;main.c,168 :: 		}
L_end_oled_start:
	RETURN
; end of _oled_start

_watch_swr:

;main.c,171 :: 		void watch_swr(void){
;main.c,173 :: 		int delta = Auto_delta - 100;
	MOVLW      100
	SUBWF      _Auto_delta+0, 0
	MOVWF      watch_swr_delta_L0+0
	MOVLW      0
	SUBWFB     _Auto_delta+1, 0
	MOVWF      watch_swr_delta_L0+1
;main.c,176 :: 		Delay_ms(50);
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
;main.c,178 :: 		cnt = 600;
	MOVLW      88
	MOVWF      watch_swr_cnt_L0+0
;main.c,179 :: 		PWR_fixed = 0;
	CLRF       watch_swr_PWR_fixed_L0+0
	CLRF       watch_swr_PWR_fixed_L0+1
;main.c,180 :: 		SWR_fixed = 999;
	MOVLW      231
	MOVWF      watch_swr_SWR_fixed_L0+0
	MOVLW      3
	MOVWF      watch_swr_SWR_fixed_L0+1
;main.c,181 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	CLRF       watch_swr_peak_cnt_L0+0
L_watch_swr40:
	MOVF       watch_swr_cnt_L0+0, 0
	SUBWF      watch_swr_peak_cnt_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr41
;main.c,182 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,183 :: 		if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr248
	MOVF       _PWR+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr248:
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
;main.c,184 :: 		Delay_ms(1);
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
;main.c,181 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	INCF       watch_swr_peak_cnt_L0+0, 1
;main.c,185 :: 		}
	GOTO       L_watch_swr40
L_watch_swr41:
;main.c,187 :: 		if(PWR_fixed>0){
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr249
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBLW      0
L__watch_swr249:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr45
;main.c,188 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_watch_swr46
;main.c,189 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,190 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,191 :: 		}
	GOTO       L_watch_swr47
L_watch_swr46:
;main.c,192 :: 		else oled_start();
	CALL       _oled_start+0
L_watch_swr47:
;main.c,193 :: 		}
L_watch_swr45:
;main.c,195 :: 		if(PWR_fixed!=PWR_fixed_old){
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	XORWF      _PWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr250
	MOVF       _PWR_fixed_old+0, 0
	XORWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr250:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr48
;main.c,196 :: 		if(Overflow)
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr49
;main.c,197 :: 		oled_wr_str(0, 42, ">", 1);
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
;main.c,199 :: 		oled_wr_str(0, 42, "=", 1);
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
;main.c,200 :: 		PWR_fixed_old = PWR_fixed;
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      _PWR_fixed_old+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      _PWR_fixed_old+1
;main.c,201 :: 		draw_power(PWR_fixed);
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      FARG_draw_power+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      FARG_draw_power+1
	CALL       _draw_power+0
;main.c,202 :: 		}
L_watch_swr48:
;main.c,203 :: 		if(PWR_fixed<10)
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr251
	MOVLW      10
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr251:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr51
;main.c,204 :: 		SWR_fixed = 0;
	CLRF       watch_swr_SWR_fixed_L0+0
	CLRF       watch_swr_SWR_fixed_L0+1
L_watch_swr51:
;main.c,205 :: 		if(Overflow){
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr52
;main.c,206 :: 		for(cnt=3; cnt!=0; cnt--){
	MOVLW      3
	MOVWF      watch_swr_cnt_L0+0
L_watch_swr53:
	MOVF       watch_swr_cnt_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr54
;main.c,207 :: 		oled_wr_str(2, 6, "OVERLOAD ", 9);
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
;main.c,208 :: 		Delay_ms(500);
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
;main.c,209 :: 		oled_wr_str(2, 0, "         ", 9);
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
;main.c,210 :: 		Delay_ms(500);
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
;main.c,206 :: 		for(cnt=3; cnt!=0; cnt--){
	DECF       watch_swr_cnt_L0+0, 1
;main.c,211 :: 		}
	GOTO       L_watch_swr53
L_watch_swr54:
;main.c,212 :: 		oled_wr_str(2, 0, "SWR      ", 9);
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
;main.c,213 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,214 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,215 :: 		Delay_ms(500);
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
;main.c,216 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,217 :: 		}
	GOTO       L_watch_swr59
L_watch_swr52:
;main.c,218 :: 		else if(SWR_fixed!=SWR_fixed_old){
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	XORWF      _SWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr252
	MOVF       _SWR_fixed_old+0, 0
	XORWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr252:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr60
;main.c,219 :: 		SWR_fixed_old = SWR_fixed;
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      _SWR_fixed_old+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      _SWR_fixed_old+1
;main.c,220 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,221 :: 		}
L_watch_swr60:
L_watch_swr59:
;main.c,224 :: 		if(PWR_fixed<min_for_start | PWR_fixed>max_for_start) return;
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr253
	MOVF       _min_for_start+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr253:
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
	GOTO       L__watch_swr254
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBWF      _max_for_start+0, 0
L__watch_swr254:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr61
	GOTO       L_end_watch_swr
L_watch_swr61:
;main.c,226 :: 		if(SWR_fixed>=Auto_delta & ((SWR_fixed>SWR_fixed_old & (SWR_fixed-SWR_fixed_old)>delta) | (SWR_fixed<SWR_fixed_old & (SWR_fixed_old-SWR_fixed)>delta) | SWR_fixed_old==999))
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R5
	MOVLW      128
	XORWF      _Auto_delta+1, 0
	SUBWF      R5, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr255
	MOVF       _Auto_delta+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr255:
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
	GOTO       L__watch_swr256
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBWF      _SWR_fixed_old+0, 0
L__watch_swr256:
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
	GOTO       L__watch_swr257
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr257:
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
	GOTO       L__watch_swr258
	MOVF       _SWR_fixed_old+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr258:
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
	GOTO       L__watch_swr259
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr259:
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
	GOTO       L__watch_swr260
	MOVLW      231
	XORWF      _SWR_fixed_old+0, 0
L__watch_swr260:
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
;main.c,227 :: 		{ Btn_long(); }
	CALL       _Btn_long+0
L_watch_swr62:
;main.c,230 :: 		return;
;main.c,231 :: 		}
L_end_watch_swr:
	RETURN
; end of _watch_swr

_draw_swr:

;main.c,233 :: 		void draw_swr(int s){
;main.c,234 :: 		if(s==0)
	MOVLW      0
	XORWF      FARG_draw_swr_s+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_swr262
	MOVLW      0
	XORWF      FARG_draw_swr_s+0, 0
L__draw_swr262:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_swr63
;main.c,235 :: 		oled_wr_str(2, 60, "0.00", 4);
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
	GOTO       L_draw_swr64
L_draw_swr63:
;main.c,237 :: 		IntToStr(s, txt_2);
	MOVF       FARG_draw_swr_s+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_swr_s+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,238 :: 		txt[0] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+0
;main.c,239 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,240 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,241 :: 		txt[3] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+3
;main.c,243 :: 		oled_wr_str(2, 60, txt, 4);
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
;main.c,244 :: 		}
L_draw_swr64:
;main.c,245 :: 		return;
;main.c,246 :: 		}
L_end_draw_swr:
	RETURN
; end of _draw_swr

_draw_power:

;main.c,248 :: 		void draw_power(int p){
;main.c,250 :: 		if(p==0){
	MOVLW      0
	XORWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power264
	MOVLW      0
	XORWF      FARG_draw_power_p+0, 0
L__draw_power264:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_power65
;main.c,251 :: 		oled_wr_str(0, 60, "0.0", 3);
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
;main.c,252 :: 		return;
	GOTO       L_end_draw_power
;main.c,253 :: 		}
L_draw_power65:
;main.c,254 :: 		else if(p<10){  // <1 W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power265
	MOVLW      10
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power265:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power67
;main.c,255 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,256 :: 		txt[0] = '0';
	MOVLW      48
	MOVWF      _txt+0
;main.c,257 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,258 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,259 :: 		}
	GOTO       L_draw_power68
L_draw_power67:
;main.c,260 :: 		else if(p<100){ // <10W
	MOVLW      128
	XORWF      FARG_draw_power_p+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power266
	MOVLW      100
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power266:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power69
;main.c,261 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,262 :: 		txt[0] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+0
;main.c,263 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,264 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,265 :: 		}
	GOTO       L_draw_power70
L_draw_power69:
;main.c,267 :: 		p += 5;
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
;main.c,268 :: 		IntToStr(p, txt_2);
	MOVF       R0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,269 :: 		txt[0] = ' ';
	MOVLW      32
	MOVWF      _txt+0
;main.c,270 :: 		txt[1] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+1
;main.c,271 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,272 :: 		}
L_draw_power70:
L_draw_power68:
;main.c,273 :: 		oled_wr_str(0, 60, txt, 3);
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
;main.c,274 :: 		return;
;main.c,275 :: 		}
L_end_draw_power:
	RETURN
; end of _draw_power

_Voltage_show:

;main.c,277 :: 		void Voltage_show(){
;main.c,278 :: 		get_batt();
	CALL       _get_batt+0
;main.c,279 :: 		if(Voltage != Voltage_old) { Voltage_old = Voltage; oled_voltage(Voltage); }
	MOVF       _Voltage+1, 0
	XORWF      _Voltage_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show268
	MOVF       _Voltage_old+0, 0
	XORWF      _Voltage+0, 0
L__Voltage_show268:
	BTFSC      STATUS+0, 2
	GOTO       L_Voltage_show71
	MOVF       _Voltage+0, 0
	MOVWF      _Voltage_old+0
	MOVF       _Voltage+1, 0
	MOVWF      _Voltage_old+1
	MOVF       _Voltage+0, 0
	MOVWF      FARG_oled_voltage+0
	MOVF       _Voltage+1, 0
	MOVWF      FARG_oled_voltage+1
	CALL       _oled_voltage+0
L_Voltage_show71:
;main.c,281 :: 		if(Voltage>3700){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show269
	MOVF       _Voltage+0, 0
	SUBLW      116
L__Voltage_show269:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show72
;main.c,282 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,283 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,284 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show73:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show73
	DECFSZ     R12, 1
	GOTO       L_Voltage_show73
	DECFSZ     R11, 1
	GOTO       L_Voltage_show73
;main.c,285 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,286 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,287 :: 		}
	GOTO       L_Voltage_show74
L_Voltage_show72:
;main.c,288 :: 		else if(Voltage>3590){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show270
	MOVF       _Voltage+0, 0
	SUBLW      6
L__Voltage_show270:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show75
;main.c,289 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,290 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
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
;main.c,296 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,297 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,298 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show78:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show78
	DECFSZ     R12, 1
	GOTO       L_Voltage_show78
	DECFSZ     R11, 1
	GOTO       L_Voltage_show78
;main.c,299 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,300 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,301 :: 		}
L_Voltage_show77:
L_Voltage_show74:
;main.c,303 :: 		if(Voltage<3400){
	MOVLW      128
	XORWF      _Voltage+1, 0
	MOVWF      R0
	MOVLW      128
	XORLW      13
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show271
	MOVLW      72
	SUBWF      _Voltage+0, 0
L__Voltage_show271:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show79
;main.c,304 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,305 :: 		oled_wr_str(1, 0, "  LOW BATT ", 11);
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
;main.c,306 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Voltage_show80:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show80
	DECFSZ     R12, 1
	GOTO       L_Voltage_show80
	DECFSZ     R11, 1
	GOTO       L_Voltage_show80
	NOP
;main.c,307 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,308 :: 		power_off();
	CALL       _power_off+0
;main.c,309 :: 		}
L_Voltage_show79:
;main.c,310 :: 		return;
;main.c,311 :: 		}
L_end_Voltage_show:
	RETURN
; end of _Voltage_show

_Btn_xlong:

;main.c,313 :: 		void Btn_xlong(){
;main.c,314 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,315 :: 		btn_cnt = 0;
	CLRF       _btn_cnt+0
	CLRF       _btn_cnt+1
	CLRF       _btn_cnt+2
	CLRF       _btn_cnt+3
;main.c,316 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,317 :: 		oled_wr_str(1, 0, " POWER OFF ", 11);
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
;main.c,318 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Btn_xlong81:
	DECFSZ     R13, 1
	GOTO       L_Btn_xlong81
	DECFSZ     R12, 1
	GOTO       L_Btn_xlong81
	DECFSZ     R11, 1
	GOTO       L_Btn_xlong81
	NOP
;main.c,319 :: 		power_off();
	CALL       _power_off+0
;main.c,320 :: 		return;
;main.c,321 :: 		}
L_end_Btn_xlong:
	RETURN
; end of _Btn_xlong

_Btn_long:

;main.c,323 :: 		void Btn_long(){
;main.c,324 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,325 :: 		oled_wr_str(2, 0, "TUNE     ", 9);
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
;main.c,326 :: 		tune();
	CALL       _tune+0
;main.c,327 :: 		oled_wr_str(2, 0, "SWR ", 4);
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
;main.c,328 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,329 :: 		draw_swr(SWR);
	MOVF       _SWR+0, 0
	MOVWF      FARG_draw_swr_s+0
	MOVF       _SWR+1, 0
	MOVWF      FARG_draw_swr_s+1
	CALL       _draw_swr+0
;main.c,330 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,331 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,332 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,333 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,334 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,335 :: 		return;
;main.c,336 :: 		}
L_end_Btn_long:
	RETURN
; end of _Btn_long

_Ext_long:

;main.c,338 :: 		void Ext_long(){
;main.c,339 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,340 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,341 :: 		tune();
	CALL       _tune+0
;main.c,342 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,343 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,344 :: 		return;
;main.c,345 :: 		}
L_end_Ext_long:
	RETURN
; end of _Ext_long

_Btn_short:

;main.c,347 :: 		void Btn_short(){
;main.c,348 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,349 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,350 :: 		oled_wr_str(2, 0, "RESET    ", 9);
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
;main.c,351 :: 		Delay_ms(600);
	MOVLW      25
	MOVWF      R11
	MOVLW      90
	MOVWF      R12
	MOVLW      177
	MOVWF      R13
L_Btn_short82:
	DECFSZ     R13, 1
	GOTO       L_Btn_short82
	DECFSZ     R12, 1
	GOTO       L_Btn_short82
	DECFSZ     R11, 1
	GOTO       L_Btn_short82
	NOP
	NOP
;main.c,352 :: 		oled_wr_str(2, 0, "SWR  ", 5);
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
;main.c,353 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,354 :: 		oled_wr_str(2, 60, "0.00", 4);
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
;main.c,355 :: 		Delay_ms(300);
	MOVLW      13
	MOVWF      R11
	MOVLW      45
	MOVWF      R12
	MOVLW      215
	MOVWF      R13
L_Btn_short83:
	DECFSZ     R13, 1
	GOTO       L_Btn_short83
	DECFSZ     R12, 1
	GOTO       L_Btn_short83
	DECFSZ     R11, 1
	GOTO       L_Btn_short83
	NOP
	NOP
;main.c,356 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,357 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,358 :: 		E_short = 0;
	BCF        _E_short+0, BitPos(_E_short+0)
;main.c,359 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,360 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,361 :: 		return;
;main.c,362 :: 		}
L_end_Btn_short:
	RETURN
; end of _Btn_short

_Greating:

;main.c,364 :: 		void Greating(){
;main.c,365 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,366 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,367 :: 		oled_wr_str_s(0, 0, " DESIGNED BY N7DDC", 18);
	CLRF       FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr22_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr22_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      18
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,368 :: 		oled_wr_str_s(2, 0, " FW VERSION ", 12);
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
;main.c,369 :: 		oled_wr_str_s(2, 12*7, FW_VER, 3);
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
;main.c,370 :: 		Delay_ms(3000);
	MOVLW      122
	MOVWF      R11
	MOVLW      193
	MOVWF      R12
	MOVLW      129
	MOVWF      R13
L_Greating84:
	DECFSZ     R13, 1
	GOTO       L_Greating84
	DECFSZ     R12, 1
	GOTO       L_Greating84
	DECFSZ     R11, 1
	GOTO       L_Greating84
	NOP
	NOP
;main.c,371 :: 		while(GetButton) asm NOP;
L_Greating85:
	BTFSC      PORTB+0, 5
	GOTO       L__Greating277
	BSF        3, 0
	GOTO       L__Greating278
L__Greating277:
	BCF        3, 0
L__Greating278:
	BTFSS      3, 0
	GOTO       L_Greating86
	NOP
	GOTO       L_Greating85
L_Greating86:
;main.c,372 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,373 :: 		return;
;main.c,374 :: 		}
L_end_Greating:
	RETURN
; end of _Greating

_atu_reset:

;main.c,376 :: 		void atu_reset(){
;main.c,377 :: 		ind = 0;
	CLRF       _ind+0
;main.c,378 :: 		cap = 0;
	CLRF       _cap+0
;main.c,379 :: 		SW = 0;
	CLRF       _SW+0
;main.c,380 :: 		Relay_set(ind, cap, SW);
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CALL       _Relay_set+0
;main.c,381 :: 		return;
;main.c,382 :: 		}
L_end_atu_reset:
	RETURN
; end of _atu_reset

_Relay_set:

;main.c,384 :: 		void Relay_set(char L, char C, char I){
;main.c,385 :: 		L_010 = ~L.B0;
	BTFSC      FARG_Relay_set_L+0, 0
	GOTO       L__Relay_set281
	BSF        LATD7_bit+0, BitPos(LATD7_bit+0)
	GOTO       L__Relay_set282
L__Relay_set281:
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
L__Relay_set282:
;main.c,386 :: 		L_022 = ~L.B1;
	BTFSC      FARG_Relay_set_L+0, 1
	GOTO       L__Relay_set283
	BSF        LATD6_bit+0, BitPos(LATD6_bit+0)
	GOTO       L__Relay_set284
L__Relay_set283:
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
L__Relay_set284:
;main.c,387 :: 		L_045 = ~L.B2;
	BTFSC      FARG_Relay_set_L+0, 2
	GOTO       L__Relay_set285
	BSF        LATD5_bit+0, BitPos(LATD5_bit+0)
	GOTO       L__Relay_set286
L__Relay_set285:
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
L__Relay_set286:
;main.c,388 :: 		L_100 = ~L.B3;
	BTFSC      FARG_Relay_set_L+0, 3
	GOTO       L__Relay_set287
	BSF        LATD4_bit+0, BitPos(LATD4_bit+0)
	GOTO       L__Relay_set288
L__Relay_set287:
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
L__Relay_set288:
;main.c,389 :: 		L_220 = ~L.B4;
	BTFSC      FARG_Relay_set_L+0, 4
	GOTO       L__Relay_set289
	BSF        LATC7_bit+0, BitPos(LATC7_bit+0)
	GOTO       L__Relay_set290
L__Relay_set289:
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
L__Relay_set290:
;main.c,390 :: 		L_450 = ~L.B5;
	BTFSC      FARG_Relay_set_L+0, 5
	GOTO       L__Relay_set291
	BSF        LATC6_bit+0, BitPos(LATC6_bit+0)
	GOTO       L__Relay_set292
L__Relay_set291:
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
L__Relay_set292:
;main.c,391 :: 		L_1000 = ~L.B6;
	BTFSC      FARG_Relay_set_L+0, 6
	GOTO       L__Relay_set293
	BSF        LATC5_bit+0, BitPos(LATC5_bit+0)
	GOTO       L__Relay_set294
L__Relay_set293:
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
L__Relay_set294:
;main.c,393 :: 		C_22 = ~C.B0;
	BTFSC      FARG_Relay_set_C+0, 0
	GOTO       L__Relay_set295
	BSF        LATA5_bit+0, BitPos(LATA5_bit+0)
	GOTO       L__Relay_set296
L__Relay_set295:
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
L__Relay_set296:
;main.c,394 :: 		C_47 = ~C.B1;
	BTFSC      FARG_Relay_set_C+0, 1
	GOTO       L__Relay_set297
	BSF        LATE1_bit+0, BitPos(LATE1_bit+0)
	GOTO       L__Relay_set298
L__Relay_set297:
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
L__Relay_set298:
;main.c,395 :: 		C_100 = ~C.B2;
	BTFSC      FARG_Relay_set_C+0, 2
	GOTO       L__Relay_set299
	BSF        LATA7_bit+0, BitPos(LATA7_bit+0)
	GOTO       L__Relay_set300
L__Relay_set299:
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
L__Relay_set300:
;main.c,396 :: 		C_220 = ~C.B3;
	BTFSC      FARG_Relay_set_C+0, 3
	GOTO       L__Relay_set301
	BSF        LATA6_bit+0, BitPos(LATA6_bit+0)
	GOTO       L__Relay_set302
L__Relay_set301:
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
L__Relay_set302:
;main.c,397 :: 		C_470 = ~C.B4;
	BTFSC      FARG_Relay_set_C+0, 4
	GOTO       L__Relay_set303
	BSF        LATC0_bit+0, BitPos(LATC0_bit+0)
	GOTO       L__Relay_set304
L__Relay_set303:
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
L__Relay_set304:
;main.c,398 :: 		C_1000 = ~C.B5;
	BTFSC      FARG_Relay_set_C+0, 5
	GOTO       L__Relay_set305
	BSF        LATC1_bit+0, BitPos(LATC1_bit+0)
	GOTO       L__Relay_set306
L__Relay_set305:
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
L__Relay_set306:
;main.c,399 :: 		C_2200 = ~C.B6;
	BTFSC      FARG_Relay_set_C+0, 6
	GOTO       L__Relay_set307
	BSF        LATC2_bit+0, BitPos(LATC2_bit+0)
	GOTO       L__Relay_set308
L__Relay_set307:
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
L__Relay_set308:
;main.c,401 :: 		C_sw = I;
	BTFSC      FARG_Relay_set_I+0, 0
	GOTO       L__Relay_set309
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
	GOTO       L__Relay_set310
L__Relay_set309:
	BSF        LATE0_bit+0, BitPos(LATE0_bit+0)
L__Relay_set310:
;main.c,403 :: 		Rel_to_gnd = 1;
	BSF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,404 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,405 :: 		Rel_to_gnd = 0;
	BCF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,406 :: 		Delay_us(10);
	MOVLW      26
	MOVWF      R13
L_Relay_set87:
	DECFSZ     R13, 1
	GOTO       L_Relay_set87
	NOP
;main.c,407 :: 		Rel_to_plus_N = 0;
	BCF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,408 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,409 :: 		Rel_to_plus_N = 1;
	BSF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,410 :: 		Vdelay_ms(Rel_Del);
	MOVF       _Rel_Del+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _Rel_Del+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,412 :: 		L_010 = 0;
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
;main.c,413 :: 		L_022 = 0;
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
;main.c,414 :: 		L_045 = 0;
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
;main.c,415 :: 		L_100 = 0;
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
;main.c,416 :: 		L_220 = 0;
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
;main.c,417 :: 		L_450 = 0;
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
;main.c,418 :: 		L_1000 = 0;
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
;main.c,420 :: 		C_22 = 0;
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
;main.c,421 :: 		C_47 = 0;
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
;main.c,422 :: 		C_100 = 0;
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
;main.c,423 :: 		C_220 = 0;
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
;main.c,424 :: 		C_470 = 0;
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
;main.c,425 :: 		C_1000 = 0;
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
;main.c,426 :: 		C_2200 = 0;
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
;main.c,427 :: 		return;
;main.c,428 :: 		}
L_end_Relay_set:
	RETURN
; end of _Relay_set

_power_off:

;main.c,430 :: 		void power_off(void){
;main.c,433 :: 		GIE_bit = 0;
	BCF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,434 :: 		T0EN_bit = 0;
	BCF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,435 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;main.c,436 :: 		IOCIE_bit = 1;
	BSF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,437 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,438 :: 		IOCBN5_bit = 1;
	BSF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,440 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,441 :: 		RED = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,442 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,444 :: 		C_sw = 0;
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
;main.c,445 :: 		SYSCMD_bit = 1;
	BSF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,447 :: 		btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
;main.c,448 :: 		while(1){
L_power_off88:
;main.c,449 :: 		if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
	MOVF       power_off_btn_cnt_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_power_off90
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off91:
	DECFSZ     R13, 1
	GOTO       L_power_off91
	DECFSZ     R12, 1
	GOTO       L_power_off91
	DECFSZ     R11, 1
	GOTO       L_power_off91
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
	SLEEP
L_power_off90:
;main.c,450 :: 		asm NOP;
	NOP
;main.c,451 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off92:
	DECFSZ     R13, 1
	GOTO       L_power_off92
	DECFSZ     R12, 1
	GOTO       L_power_off92
	DECFSZ     R11, 1
	GOTO       L_power_off92
;main.c,452 :: 		if(GetButton) btn_cnt++;
	BTFSC      PORTB+0, 5
	GOTO       L__power_off312
	BSF        3, 0
	GOTO       L__power_off313
L__power_off312:
	BCF        3, 0
L__power_off313:
	BTFSS      3, 0
	GOTO       L_power_off93
	INCF       power_off_btn_cnt_L0+0, 1
	GOTO       L_power_off94
L_power_off93:
;main.c,453 :: 		else btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
L_power_off94:
;main.c,454 :: 		if(btn_cnt>25) break;
	MOVF       power_off_btn_cnt_L0+0, 0
	SUBLW      25
	BTFSC      STATUS+0, 0
	GOTO       L_power_off95
	GOTO       L_power_off89
L_power_off95:
;main.c,455 :: 		}
	GOTO       L_power_off88
L_power_off89:
;main.c,457 :: 		SYSCMD_bit = 0;
	BCF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,459 :: 		IOCIE_bit = 0;
	BCF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,460 :: 		IOCBN5_bit = 0;
	BCF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,461 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,462 :: 		T0EN_bit = 1;
	BSF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,463 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,465 :: 		gre = 1;
	BSF        _gre+0, BitPos(_gre+0)
;main.c,466 :: 		oled_start();
	CALL       _oled_start+0
;main.c,467 :: 		while(GetButton){asm NOP;}
L_power_off96:
	BTFSC      PORTB+0, 5
	GOTO       L__power_off314
	BSF        3, 0
	GOTO       L__power_off315
L__power_off314:
	BCF        3, 0
L__power_off315:
	BTFSS      3, 0
	GOTO       L_power_off97
	NOP
	GOTO       L_power_off96
L_power_off97:
;main.c,468 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,469 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,470 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,471 :: 		return;
;main.c,472 :: 		}
L_end_power_off:
	RETURN
; end of _power_off

_check_reset_flags:

;main.c,475 :: 		void check_reset_flags(void){
;main.c,476 :: 		char i = 0;
	CLRF       check_reset_flags_i_L0+0
;main.c,477 :: 		if(STKOVF_bit){oled_wr_str_s(0,  0, "Stack overflow",  14); i = 1;}
	BTFSS      STKOVF_bit+0, BitPos(STKOVF_bit+0)
	GOTO       L_check_reset_flags98
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
L_check_reset_flags98:
;main.c,478 :: 		if(STKUNF_bit){oled_wr_str_s(1,  0, "Stack underflow", 15); i = 1;}
	BTFSS      STKUNF_bit+0, BitPos(STKUNF_bit+0)
	GOTO       L_check_reset_flags99
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
L_check_reset_flags99:
;main.c,479 :: 		if(!nRWDT_bit){oled_wr_str_s(2,  0, "WDT overflow",    12); i = 1;}
	BTFSC      nRWDT_bit+0, BitPos(nRWDT_bit+0)
	GOTO       L_check_reset_flags100
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
L_check_reset_flags100:
;main.c,480 :: 		if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ",    12); i = 1;}
	BTFSC      nRMCLR_bit+0, BitPos(nRMCLR_bit+0)
	GOTO       L_check_reset_flags101
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
L_check_reset_flags101:
;main.c,481 :: 		if(!nBOR_bit){oled_wr_str_s(4,   0, "BOR reset  ",     12); i = 1;}
	BTFSC      nBOR_bit+0, BitPos(nBOR_bit+0)
	GOTO       L_check_reset_flags102
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
L_check_reset_flags102:
;main.c,482 :: 		if(i){
	MOVF       check_reset_flags_i_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_check_reset_flags103
;main.c,483 :: 		Delay_ms(5000);
	MOVLW      203
	MOVWF      R11
	MOVLW      236
	MOVWF      R12
	MOVLW      132
	MOVWF      R13
L_check_reset_flags104:
	DECFSZ     R13, 1
	GOTO       L_check_reset_flags104
	DECFSZ     R12, 1
	GOTO       L_check_reset_flags104
	DECFSZ     R11, 1
	GOTO       L_check_reset_flags104
	NOP
;main.c,484 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,485 :: 		}
L_check_reset_flags103:
;main.c,486 :: 		return;
;main.c,487 :: 		}
L_end_check_reset_flags:
	RETURN
; end of _check_reset_flags

_correction:

;main.c,489 :: 		int correction(int input) {
;main.c,490 :: 		input *= 2;
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
;main.c,492 :: 		if(input <= 588) input += 376;
	MOVLW      128
	XORLW      2
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction318
	MOVF       R1, 0
	SUBLW      76
L__correction318:
	BTFSS      STATUS+0, 0
	GOTO       L_correction105
	MOVLW      120
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction106
L_correction105:
;main.c,493 :: 		else if(input <= 882) input += 400;
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction319
	MOVF       FARG_correction_input+0, 0
	SUBLW      114
L__correction319:
	BTFSS      STATUS+0, 0
	GOTO       L_correction107
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction108
L_correction107:
;main.c,494 :: 		else if(input <= 1313) input += 476;
	MOVLW      128
	XORLW      5
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction320
	MOVF       FARG_correction_input+0, 0
	SUBLW      33
L__correction320:
	BTFSS      STATUS+0, 0
	GOTO       L_correction109
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction110
L_correction109:
;main.c,495 :: 		else if(input <= 1900) input += 514;
	MOVLW      128
	XORLW      7
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction321
	MOVF       FARG_correction_input+0, 0
	SUBLW      108
L__correction321:
	BTFSS      STATUS+0, 0
	GOTO       L_correction111
	MOVLW      2
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction112
L_correction111:
;main.c,496 :: 		else if(input <= 2414) input += 568;
	MOVLW      128
	XORLW      9
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction322
	MOVF       FARG_correction_input+0, 0
	SUBLW      110
L__correction322:
	BTFSS      STATUS+0, 0
	GOTO       L_correction113
	MOVLW      56
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction114
L_correction113:
;main.c,497 :: 		else if(input <= 2632) input += 644;
	MOVLW      128
	XORLW      10
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction323
	MOVF       FARG_correction_input+0, 0
	SUBLW      72
L__correction323:
	BTFSS      STATUS+0, 0
	GOTO       L_correction115
	MOVLW      132
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction116
L_correction115:
;main.c,498 :: 		else if(input <= 2942) input += 732;
	MOVLW      128
	XORLW      11
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction324
	MOVF       FARG_correction_input+0, 0
	SUBLW      126
L__correction324:
	BTFSS      STATUS+0, 0
	GOTO       L_correction117
	MOVLW      220
	ADDWF      FARG_correction_input+0, 1
	MOVLW      2
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction118
L_correction117:
;main.c,499 :: 		else if(input <= 3232) input += 784;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction325
	MOVF       FARG_correction_input+0, 0
	SUBLW      160
L__correction325:
	BTFSS      STATUS+0, 0
	GOTO       L_correction119
	MOVLW      16
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction120
L_correction119:
;main.c,500 :: 		else if(input <= 3324) input += 992;
	MOVLW      128
	XORLW      12
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction326
	MOVF       FARG_correction_input+0, 0
	SUBLW      252
L__correction326:
	BTFSS      STATUS+0, 0
	GOTO       L_correction121
	MOVLW      224
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction122
L_correction121:
;main.c,501 :: 		else if(input <= 3720) input += 1000;
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction327
	MOVF       FARG_correction_input+0, 0
	SUBLW      136
L__correction327:
	BTFSS      STATUS+0, 0
	GOTO       L_correction123
	MOVLW      232
	ADDWF      FARG_correction_input+0, 1
	MOVLW      3
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction124
L_correction123:
;main.c,502 :: 		else if(input <= 4340) input += 1160;
	MOVLW      128
	XORLW      16
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction328
	MOVF       FARG_correction_input+0, 0
	SUBLW      244
L__correction328:
	BTFSS      STATUS+0, 0
	GOTO       L_correction125
	MOVLW      136
	ADDWF      FARG_correction_input+0, 1
	MOVLW      4
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction126
L_correction125:
;main.c,503 :: 		else if(input <= 4808) input += 1360;
	MOVLW      128
	XORLW      18
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction329
	MOVF       FARG_correction_input+0, 0
	SUBLW      200
L__correction329:
	BTFSS      STATUS+0, 0
	GOTO       L_correction127
	MOVLW      80
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction128
L_correction127:
;main.c,504 :: 		else if(input <= 5272) input += 1424;
	MOVLW      128
	XORLW      20
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction330
	MOVF       FARG_correction_input+0, 0
	SUBLW      152
L__correction330:
	BTFSS      STATUS+0, 0
	GOTO       L_correction129
	MOVLW      144
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction130
L_correction129:
;main.c,505 :: 		else  input += 1432;
	MOVLW      152
	ADDWF      FARG_correction_input+0, 1
	MOVLW      5
	ADDWFC     FARG_correction_input+1, 1
L_correction130:
L_correction128:
L_correction126:
L_correction124:
L_correction122:
L_correction120:
L_correction118:
L_correction116:
L_correction114:
L_correction112:
L_correction110:
L_correction108:
L_correction106:
;main.c,507 :: 		return input;
	MOVF       FARG_correction_input+0, 0
	MOVWF      R0
	MOVF       FARG_correction_input+1, 0
	MOVWF      R1
;main.c,508 :: 		}
L_end_correction:
	RETURN
; end of _correction

_get_reverse:

;main.c,510 :: 		int get_reverse(void){
;main.c,513 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,514 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse131:
	DECFSZ     R13, 1
	GOTO       L_get_reverse131
	DECFSZ     R12, 1
	GOTO       L_get_reverse131
	NOP
;main.c,515 :: 		v = ADC_Get_Sample(REV_input);
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,516 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse332
	MOVLW      255
	XORWF      R0, 0
L__get_reverse332:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse132
;main.c,517 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,518 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse133:
	DECFSZ     R13, 1
	GOTO       L_get_reverse133
	DECFSZ     R12, 1
	GOTO       L_get_reverse133
	NOP
;main.c,519 :: 		v = ADC_Get_Sample(REV_input) * 2;
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
	LSLF       get_reverse_v_L0+0, 1
	RLF        get_reverse_v_L0+1, 1
;main.c,520 :: 		}
L_get_reverse132:
;main.c,521 :: 		if(v==1023*2){
	MOVF       get_reverse_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse333
	MOVLW      254
	XORWF      get_reverse_v_L0+0, 0
L__get_reverse333:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse134
;main.c,522 :: 		get_batt();
	CALL       _get_batt+0
;main.c,523 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,524 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_reverse135:
	DECFSZ     R13, 1
	GOTO       L_get_reverse135
	DECFSZ     R12, 1
	GOTO       L_get_reverse135
	NOP
;main.c,525 :: 		v = ADC_Get_Sample(FWD_input);
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
;main.c,526 :: 		f = Voltage / 1024;
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
;main.c,527 :: 		v = v * f;
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
;main.c,528 :: 		}
L_get_reverse134:
;main.c,529 :: 		return v;
	MOVF       get_reverse_v_L0+0, 0
	MOVWF      R0
	MOVF       get_reverse_v_L0+1, 0
	MOVWF      R1
;main.c,530 :: 		}
L_end_get_reverse:
	RETURN
; end of _get_reverse

_get_forward:

;main.c,532 :: 		int get_forward(void){
;main.c,535 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,536 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward136:
	DECFSZ     R13, 1
	GOTO       L_get_forward136
	DECFSZ     R12, 1
	GOTO       L_get_forward136
	NOP
;main.c,537 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,538 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward335
	MOVLW      255
	XORWF      R0, 0
L__get_forward335:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward137
;main.c,539 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,540 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward138:
	DECFSZ     R13, 1
	GOTO       L_get_forward138
	DECFSZ     R12, 1
	GOTO       L_get_forward138
	NOP
;main.c,541 :: 		v = ADC_Get_Sample(FWD_input) * 2;
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
	LSLF       get_forward_v_L0+0, 1
	RLF        get_forward_v_L0+1, 1
;main.c,542 :: 		}
L_get_forward137:
;main.c,543 :: 		if(v==1023*2){
	MOVF       get_forward_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward336
	MOVLW      254
	XORWF      get_forward_v_L0+0, 0
L__get_forward336:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward139
;main.c,544 :: 		get_batt();
	CALL       _get_batt+0
;main.c,545 :: 		ADC_Init_Advanced(_ADC_INTERNAL_REF);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,546 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward140:
	DECFSZ     R13, 1
	GOTO       L_get_forward140
	DECFSZ     R12, 1
	GOTO       L_get_forward140
	NOP
;main.c,547 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,548 :: 		if(v==1023) Overflow = 1;
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward337
	MOVLW      255
	XORWF      R0, 0
L__get_forward337:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward141
	BSF        _Overflow+0, BitPos(_Overflow+0)
L_get_forward141:
;main.c,549 :: 		f = Voltage / 1024;
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
;main.c,550 :: 		v = v * f;
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
;main.c,551 :: 		}
L_get_forward139:
;main.c,552 :: 		return v;
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R0
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R1
;main.c,553 :: 		}
L_end_get_forward:
	RETURN
; end of _get_forward

_get_pwr:

;main.c,556 :: 		void get_pwr(){
;main.c,560 :: 		Forward = get_forward();
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
;main.c,561 :: 		Reverse = get_reverse();
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
;main.c,563 :: 		p = correction(Forward);
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      FARG_correction_input+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      FARG_correction_input+1
	CALL       _correction+0
	CALL       _int2double+0
;main.c,564 :: 		P = p * 5 / 1000;
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
;main.c,565 :: 		p = p / 1.414;
	MOVLW      244
	MOVWF      R4
	MOVLW      253
	MOVWF      R5
	MOVLW      52
	MOVWF      R6
	MOVLW      127
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,566 :: 		p = p * p;
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
;main.c,567 :: 		p = p / 5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      32
	MOVWF      R6
	MOVLW      129
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,568 :: 		p += 0.5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      126
	MOVWF      R7
	CALL       _Add_32x32_FP+0
;main.c,569 :: 		PWR = p;
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      _PWR+0
	MOVF       R1, 0
	MOVWF      _PWR+1
;main.c,571 :: 		if(PWR>0){
	MOVLW      128
	MOVWF      R2
	MOVLW      128
	XORWF      R1, 0
	SUBWF      R2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr339
	MOVF       R0, 0
	SUBLW      0
L__get_pwr339:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr142
;main.c,572 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_get_pwr143
;main.c,573 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,574 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,575 :: 		}
	GOTO       L_get_pwr144
L_get_pwr143:
;main.c,576 :: 		else oled_start();
	CALL       _oled_start+0
L_get_pwr144:
;main.c,577 :: 		}
L_get_pwr142:
;main.c,579 :: 		if(Reverse >= Forward)
	MOVLW      128
	XORWF      get_pwr_Reverse_L0+3, 0
	MOVWF      R0
	MOVLW      128
	XORWF      get_pwr_Forward_L0+3, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr340
	MOVF       get_pwr_Forward_L0+2, 0
	SUBWF      get_pwr_Reverse_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr340
	MOVF       get_pwr_Forward_L0+1, 0
	SUBWF      get_pwr_Reverse_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr340
	MOVF       get_pwr_Forward_L0+0, 0
	SUBWF      get_pwr_Reverse_L0+0, 0
L__get_pwr340:
	BTFSS      STATUS+0, 0
	GOTO       L_get_pwr145
;main.c,580 :: 		Forward = 999;
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
	GOTO       L_get_pwr146
L_get_pwr145:
;main.c,582 :: 		Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
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
;main.c,583 :: 		if(Forward>999) Forward = 999;
	MOVLW      128
	MOVWF      R4
	MOVLW      128
	XORWF      R3, 0
	SUBWF      R4, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr341
	MOVF       R2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr341
	MOVF       R1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr341
	MOVF       R0, 0
	SUBLW      231
L__get_pwr341:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr147
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
L_get_pwr147:
;main.c,584 :: 		}
L_get_pwr146:
;main.c,586 :: 		SWR = Forward;
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      _SWR+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      _SWR+1
;main.c,587 :: 		return;
;main.c,588 :: 		}
L_end_get_pwr:
	RETURN
; end of _get_pwr

_get_swr:

;main.c,590 :: 		void get_swr(){
;main.c,591 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,592 :: 		tune_cnt = 1000;
	MOVLW      232
	MOVWF      _tune_cnt+0
	MOVLW      3
	MOVWF      _tune_cnt+1
	CLRF       _tune_cnt+2
	CLRF       _tune_cnt+3
;main.c,593 :: 		while(PWR<min_for_start | PWR>max_for_start){   // waiting for good power
L_get_swr148:
	MOVLW      128
	XORWF      _PWR+1, 0
	MOVWF      R1
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr343
	MOVF       _min_for_start+0, 0
	SUBWF      _PWR+0, 0
L__get_swr343:
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
	GOTO       L__get_swr344
	MOVF       _PWR+0, 0
	SUBWF      _max_for_start+0, 0
L__get_swr344:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R1, 0
	IORWF       R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_get_swr149
;main.c,594 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_get_swr150
;main.c,595 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,596 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,597 :: 		return;
	GOTO       L_end_get_swr
;main.c,598 :: 		}
L_get_swr150:
;main.c,599 :: 		if(B_xlong){
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_get_swr151
;main.c,600 :: 		Btn_xlong();
	CALL       _Btn_xlong+0
;main.c,601 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,602 :: 		return;
	GOTO       L_end_get_swr
;main.c,603 :: 		}
L_get_swr151:
;main.c,604 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,605 :: 		draw_power(PWR);
	MOVF       _PWR+0, 0
	MOVWF      FARG_draw_power_p+0
	MOVF       _PWR+1, 0
	MOVWF      FARG_draw_power_p+1
	CALL       _draw_power+0
;main.c,606 :: 		if(tune_cnt>0) tune_cnt --;
	MOVF       _tune_cnt+3, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr345
	MOVF       _tune_cnt+2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr345
	MOVF       _tune_cnt+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr345
	MOVF       _tune_cnt+0, 0
	SUBLW      0
L__get_swr345:
	BTFSC      STATUS+0, 0
	GOTO       L_get_swr152
	MOVLW      1
	SUBWF      _tune_cnt+0, 1
	MOVLW      0
	SUBWFB     _tune_cnt+1, 1
	SUBWFB     _tune_cnt+2, 1
	SUBWFB     _tune_cnt+3, 1
	GOTO       L_get_swr153
L_get_swr152:
;main.c,608 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,609 :: 		return;
	GOTO       L_end_get_swr
;main.c,610 :: 		}
L_get_swr153:
;main.c,611 :: 		}
	GOTO       L_get_swr148
L_get_swr149:
;main.c,613 :: 		return;
;main.c,614 :: 		}
L_end_get_swr:
	RETURN
; end of _get_swr

_get_batt:

;main.c,616 :: 		void get_batt(void){
;main.c,617 :: 		ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,618 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_batt154:
	DECFSZ     R13, 1
	GOTO       L_get_batt154
	DECFSZ     R12, 1
	GOTO       L_get_batt154
	NOP
;main.c,619 :: 		Voltage = ADC_Get_Sample(Battery_input) * 11;
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
;main.c,620 :: 		return;
;main.c,621 :: 		}
L_end_get_batt:
	RETURN
; end of _get_batt

_coarse_cap:

;main.c,623 :: 		void coarse_cap() {
;main.c,624 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_cap_step_L0+0
;main.c,628 :: 		cap = 0;
	CLRF       _cap+0
;main.c,629 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	CLRF       FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,630 :: 		get_swr();
	CALL       _get_swr+0
;main.c,631 :: 		min_swr = SWR + SWR/20;
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
;main.c,632 :: 		for(count=step; count<=31;) {
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      coarse_cap_count_L0+0
L_coarse_cap155:
	MOVF       coarse_cap_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_cap156
;main.c,633 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,634 :: 		get_swr();
	CALL       _get_swr+0
;main.c,635 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap348
	MOVF       coarse_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_cap348:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap158
;main.c,636 :: 		min_swr = SWR + SWR/20;
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
;main.c,637 :: 		cap = count;
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,638 :: 		step_cap = step;
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      _step_cap+0
;main.c,639 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap349
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_cap349:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap159
	GOTO       L_coarse_cap156
L_coarse_cap159:
;main.c,640 :: 		count += step;
	MOVF       coarse_cap_step_L0+0, 0
	ADDWF      coarse_cap_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_cap_count_L0+0
;main.c,641 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap160
	MOVLW      8
	MOVWF      coarse_cap_count_L0+0
	GOTO       L_coarse_cap161
L_coarse_cap160:
;main.c,642 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_cap_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap162
	MOVLW      16
	MOVWF      coarse_cap_count_L0+0
	MOVLW      4
	MOVWF      coarse_cap_step_L0+0
L_coarse_cap162:
L_coarse_cap161:
;main.c,643 :: 		}
	GOTO       L_coarse_cap163
L_coarse_cap158:
;main.c,644 :: 		else break;
	GOTO       L_coarse_cap156
L_coarse_cap163:
;main.c,645 :: 		}
	GOTO       L_coarse_cap155
L_coarse_cap156:
;main.c,646 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,647 :: 		return;
;main.c,648 :: 		}
L_end_coarse_cap:
	RETURN
; end of _coarse_cap

_coarse_tune:

;main.c,650 :: 		void coarse_tune() {
;main.c,651 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_tune_step_L0+0
;main.c,656 :: 		mem_cap = 0;
	CLRF       coarse_tune_mem_cap_L0+0
;main.c,657 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,658 :: 		mem_step_cap = 3;
	MOVLW      3
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,659 :: 		min_swr = SWR + SWR/20;
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
;main.c,660 :: 		for(count=step; count<=31;) {
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      coarse_tune_count_L0+0
L_coarse_tune164:
	MOVF       coarse_tune_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_tune165
;main.c,661 :: 		Relay_set(count, cap, SW);
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,662 :: 		coarse_cap();
	CALL       _coarse_cap+0
;main.c,663 :: 		get_swr();
	CALL       _get_swr+0
;main.c,664 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_tune_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune351
	MOVF       coarse_tune_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_tune351:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune167
;main.c,665 :: 		min_swr = SWR + SWR/20;
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
;main.c,666 :: 		ind = count;
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      _ind+0
;main.c,667 :: 		mem_cap = cap;
	MOVF       _cap+0, 0
	MOVWF      coarse_tune_mem_cap_L0+0
;main.c,668 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,669 :: 		mem_step_cap = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,670 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune352
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_tune352:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune168
	GOTO       L_coarse_tune165
L_coarse_tune168:
;main.c,671 :: 		count += step;
	MOVF       coarse_tune_step_L0+0, 0
	ADDWF      coarse_tune_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_tune_count_L0+0
;main.c,672 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune169
	MOVLW      8
	MOVWF      coarse_tune_count_L0+0
	GOTO       L_coarse_tune170
L_coarse_tune169:
;main.c,673 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_tune_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune171
	MOVLW      16
	MOVWF      coarse_tune_count_L0+0
	MOVLW      4
	MOVWF      coarse_tune_step_L0+0
L_coarse_tune171:
L_coarse_tune170:
;main.c,674 :: 		}
	GOTO       L_coarse_tune172
L_coarse_tune167:
;main.c,675 :: 		else break;
	GOTO       L_coarse_tune165
L_coarse_tune172:
;main.c,676 :: 		}
	GOTO       L_coarse_tune164
L_coarse_tune165:
;main.c,677 :: 		cap = mem_cap;
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      _cap+0
;main.c,678 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,679 :: 		step_cap = mem_step_cap;
	MOVF       coarse_tune_mem_step_cap_L0+0, 0
	MOVWF      _step_cap+0
;main.c,680 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_coarse_tune173:
	DECFSZ     R13, 1
	GOTO       L_coarse_tune173
	DECFSZ     R12, 1
	GOTO       L_coarse_tune173
	NOP
;main.c,681 :: 		return;
;main.c,682 :: 		}
L_end_coarse_tune:
	RETURN
; end of _coarse_tune

_sharp_cap:

;main.c,684 :: 		void sharp_cap() {
;main.c,687 :: 		range = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      sharp_cap_range_L0+0
;main.c,689 :: 		max_range = cap + range;
	MOVF       _step_cap+0, 0
	ADDWF      _cap+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_cap_max_range_L0+0
;main.c,690 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap174
	MOVLW      31
	MOVWF      sharp_cap_max_range_L0+0
L_sharp_cap174:
;main.c,691 :: 		if(cap>range) min_range = cap - range; else min_range = 0;
	MOVF       _cap+0, 0
	SUBWF      sharp_cap_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap175
	MOVF       sharp_cap_range_L0+0, 0
	SUBWF      _cap+0, 0
	MOVWF      sharp_cap_min_range_L0+0
	GOTO       L_sharp_cap176
L_sharp_cap175:
	CLRF       sharp_cap_min_range_L0+0
L_sharp_cap176:
;main.c,692 :: 		cap = min_range;
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      _cap+0
;main.c,693 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,694 :: 		get_swr();
	CALL       _get_swr+0
;main.c,695 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap354
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap354:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap177
	GOTO       L_end_sharp_cap
L_sharp_cap177:
;main.c,696 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,697 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_min_range_L0+0, 0
	MOVWF      sharp_cap_count_L0+0
L_sharp_cap178:
	MOVF       sharp_cap_count_L0+0, 0
	SUBWF      sharp_cap_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap179
;main.c,698 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,699 :: 		get_swr();
	CALL       _get_swr+0
;main.c,700 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap355
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap355:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap181
	GOTO       L_end_sharp_cap
L_sharp_cap181:
;main.c,701 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap356
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap356:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap182
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap183:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap183
	DECFSZ     R12, 1
	GOTO       L_sharp_cap183
	NOP
	CALL       _get_swr+0
L_sharp_cap182:
;main.c,702 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap357
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap357:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap184
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap185:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap185
	DECFSZ     R12, 1
	GOTO       L_sharp_cap185
	NOP
	CALL       _get_swr+0
L_sharp_cap184:
;main.c,703 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap358
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap358:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap186
;main.c,704 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,705 :: 		cap = count;
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,706 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap359
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_cap359:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap187
	GOTO       L_sharp_cap179
L_sharp_cap187:
;main.c,707 :: 		}
	GOTO       L_sharp_cap188
L_sharp_cap186:
;main.c,708 :: 		else break;
	GOTO       L_sharp_cap179
L_sharp_cap188:
;main.c,697 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_count_L0+0, 1
;main.c,709 :: 		}
	GOTO       L_sharp_cap178
L_sharp_cap179:
;main.c,710 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,711 :: 		return;
;main.c,712 :: 		}
L_end_sharp_cap:
	RETURN
; end of _sharp_cap

_sharp_ind:

;main.c,714 :: 		void sharp_ind() {
;main.c,717 :: 		range = step_ind;
	MOVF       _step_ind+0, 0
	MOVWF      sharp_ind_range_L0+0
;main.c,719 :: 		max_range = ind + range;
	MOVF       _step_ind+0, 0
	ADDWF      _ind+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_ind_max_range_L0+0
;main.c,720 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind189
	MOVLW      31
	MOVWF      sharp_ind_max_range_L0+0
L_sharp_ind189:
;main.c,721 :: 		if(ind>range) min_range = ind - range; else min_range = 0;
	MOVF       _ind+0, 0
	SUBWF      sharp_ind_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind190
	MOVF       sharp_ind_range_L0+0, 0
	SUBWF      _ind+0, 0
	MOVWF      sharp_ind_min_range_L0+0
	GOTO       L_sharp_ind191
L_sharp_ind190:
	CLRF       sharp_ind_min_range_L0+0
L_sharp_ind191:
;main.c,722 :: 		ind = min_range;
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      _ind+0
;main.c,723 :: 		Relay_set(ind, cap, SW);
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,724 :: 		get_swr();
	CALL       _get_swr+0
;main.c,725 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind361
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind361:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind192
	GOTO       L_end_sharp_ind
L_sharp_ind192:
;main.c,726 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,727 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_min_range_L0+0, 0
	MOVWF      sharp_ind_count_L0+0
L_sharp_ind193:
	MOVF       sharp_ind_count_L0+0, 0
	SUBWF      sharp_ind_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind194
;main.c,728 :: 		Relay_set(count, cap, SW);
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,729 :: 		get_swr();
	CALL       _get_swr+0
;main.c,730 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind362
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind362:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind196
	GOTO       L_end_sharp_ind
L_sharp_ind196:
;main.c,731 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind363
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind363:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind197
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind198:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind198
	DECFSZ     R12, 1
	GOTO       L_sharp_ind198
	NOP
	CALL       _get_swr+0
L_sharp_ind197:
;main.c,732 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind364
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind364:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind199
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind200:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind200
	DECFSZ     R12, 1
	GOTO       L_sharp_ind200
	NOP
	CALL       _get_swr+0
L_sharp_ind199:
;main.c,733 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind365
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind365:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind201
;main.c,734 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,735 :: 		ind = count;
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      _ind+0
;main.c,736 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind366
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_ind366:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind202
	GOTO       L_sharp_ind194
L_sharp_ind202:
;main.c,737 :: 		}
	GOTO       L_sharp_ind203
L_sharp_ind201:
;main.c,738 :: 		else break;
	GOTO       L_sharp_ind194
L_sharp_ind203:
;main.c,727 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_count_L0+0, 1
;main.c,739 :: 		}
	GOTO       L_sharp_ind193
L_sharp_ind194:
;main.c,740 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,741 :: 		return;
;main.c,742 :: 		}
L_end_sharp_ind:
	RETURN
; end of _sharp_ind

_tune:

;main.c,745 :: 		void tune() {
;main.c,747 :: 		asm CLRWDT;
	CLRWDT
;main.c,748 :: 		Key_out = 0;
	BCF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,749 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_tune204:
	DECFSZ     R13, 1
	GOTO       L_tune204
	DECFSZ     R12, 1
	GOTO       L_tune204
	DECFSZ     R11, 1
	GOTO       L_tune204
;main.c,750 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune368
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune368:
	BTFSC      STATUS+0, 0
	GOTO       L_tune205
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune205:
;main.c,751 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,752 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune206:
	DECFSZ     R13, 1
	GOTO       L_tune206
	DECFSZ     R12, 1
	GOTO       L_tune206
	DECFSZ     R11, 1
	GOTO       L_tune206
;main.c,753 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune369
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune369:
	BTFSC      STATUS+0, 0
	GOTO       L_tune207
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune207:
;main.c,755 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,756 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune370
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune370:
	BTFSS      STATUS+0, 2
	GOTO       L_tune208
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune208:
;main.c,757 :: 		get_swr(); if(SWR<120) { Key_out = 1;  return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune371
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune371:
	BTFSC      STATUS+0, 0
	GOTO       L_tune209
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune209:
;main.c,758 :: 		sharp_ind();  if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune372
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune372:
	BTFSS      STATUS+0, 2
	GOTO       L_tune210
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune210:
;main.c,759 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune373
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune373:
	BTFSC      STATUS+0, 0
	GOTO       L_tune211
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune211:
;main.c,760 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune374
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune374:
	BTFSS      STATUS+0, 2
	GOTO       L_tune212
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune212:
;main.c,761 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune375
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune375:
	BTFSC      STATUS+0, 0
	GOTO       L_tune213
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune213:
;main.c,763 :: 		if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) { Key_out = 1; return; }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R1
	MOVLW      128
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune376
	MOVLW      200
	SUBWF      _SWR+0, 0
L__tune376:
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
	GOTO       L__tune377
	MOVF       tune_swr_mem_L0+0, 0
	SUBWF      _SWR+0, 0
L__tune377:
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
	GOTO       L__tune378
	MOVF       R1, 0
	SUBLW      100
L__tune378:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R3, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_tune214
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune214:
;main.c,764 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,765 :: 		ind_mem = ind;
	MOVF       _ind+0, 0
	MOVWF      tune_ind_mem_L0+0
	CLRF       tune_ind_mem_L0+1
;main.c,766 :: 		cap_mem = cap;
	MOVF       _cap+0, 0
	MOVWF      tune_cap_mem_L0+0
	CLRF       tune_cap_mem_L0+1
;main.c,768 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune215
	CLRF       _SW+0
	GOTO       L_tune216
L_tune215:
	MOVLW      1
	MOVWF      _SW+0
L_tune216:
;main.c,769 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,770 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,771 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune217:
	DECFSZ     R13, 1
	GOTO       L_tune217
	DECFSZ     R12, 1
	GOTO       L_tune217
	DECFSZ     R11, 1
	GOTO       L_tune217
;main.c,772 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune379
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune379:
	BTFSC      STATUS+0, 0
	GOTO       L_tune218
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune218:
;main.c,774 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune380
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune380:
	BTFSS      STATUS+0, 2
	GOTO       L_tune219
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune219:
;main.c,775 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune381
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune381:
	BTFSC      STATUS+0, 0
	GOTO       L_tune220
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune220:
;main.c,776 :: 		sharp_ind(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune382
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune382:
	BTFSS      STATUS+0, 2
	GOTO       L_tune221
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune221:
;main.c,777 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune383
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune383:
	BTFSC      STATUS+0, 0
	GOTO       L_tune222
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune222:
;main.c,778 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune384
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune384:
	BTFSS      STATUS+0, 2
	GOTO       L_tune223
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune223:
;main.c,779 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune385
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune385:
	BTFSC      STATUS+0, 0
	GOTO       L_tune224
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune224:
;main.c,781 :: 		if(SWR>swr_mem) {
	MOVLW      128
	XORWF      tune_swr_mem_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _SWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune386
	MOVF       _SWR+0, 0
	SUBWF      tune_swr_mem_L0+0, 0
L__tune386:
	BTFSC      STATUS+0, 0
	GOTO       L_tune225
;main.c,782 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune226
	CLRF       _SW+0
	GOTO       L_tune227
L_tune226:
	MOVLW      1
	MOVWF      _SW+0
L_tune227:
;main.c,783 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,784 :: 		ind = ind_mem;
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      _ind+0
;main.c,785 :: 		cap = cap_mem;
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      _cap+0
;main.c,786 :: 		Relay_set(ind, cap, sw);
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,787 :: 		SWR = swr_mem;
	MOVF       tune_swr_mem_L0+0, 0
	MOVWF      _SWR+0
	MOVF       tune_swr_mem_L0+1, 0
	MOVWF      _SWR+1
;main.c,788 :: 		}
L_tune225:
;main.c,790 :: 		asm CLRWDT;
	CLRWDT
;main.c,791 :: 		Key_out = 1;
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,792 :: 		return;
;main.c,793 :: 		}
L_end_tune:
	RETURN
; end of _tune

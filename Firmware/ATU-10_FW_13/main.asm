
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
	GOTO       L__interupt242
	MOVF       _btn_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt242
	MOVF       _btn_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__interupt242
	MOVF       _btn_cnt+0, 0
	SUBWF      _Tick+0, 0
L__interupt242:
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
	GOTO       L__interupt243
	BSF        R4, 0
	GOTO       L__interupt244
L__interupt243:
	BCF        R4, 0
L__interupt244:
	BTFSC      PORTD+0, 1
	GOTO       L__interupt245
	BSF        3, 0
	GOTO       L__interupt246
L__interupt245:
	BCF        3, 0
L__interupt246:
	BTFSC      R4, 0
	GOTO       L__interupt247
	BTFSC      3, 0
	GOTO       L__interupt247
	BCF        R4, 0
	GOTO       L__interupt248
L__interupt247:
	BSF        R4, 0
L__interupt248:
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
	GOTO       L__interupt249
	BSF        3, 0
	GOTO       L__interupt250
L__interupt249:
	BCF        3, 0
L__interupt250:
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
	GOTO       L__interupt251
	BSF        3, 0
	GOTO       L__interupt252
L__interupt251:
	BCF        3, 0
L__interupt252:
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
L__interupt241:
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
;main.c,93 :: 		rldl = Rel_Del;
	MOVF       _Rel_Del+0, 0
	MOVWF      _rldl+0
	MOVF       _Rel_Del+1, 0
	MOVWF      _rldl+1
;main.c,96 :: 		while(1) {
L_main16:
;main.c,97 :: 		if(Tick>=volt_cnt){   // every 3 second
	MOVF       _volt_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main254
	MOVF       _volt_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main254
	MOVF       _volt_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main254
	MOVF       _volt_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main254:
	BTFSS      STATUS+0, 0
	GOTO       L_main18
;main.c,98 :: 		volt_cnt += 3000;
	MOVLW      184
	ADDWF      _volt_cnt+0, 1
	MOVLW      11
	ADDWFC     _volt_cnt+1, 1
	MOVLW      0
	ADDWFC     _volt_cnt+2, 1
	ADDWFC     _volt_cnt+3, 1
;main.c,99 :: 		Voltage_show();
	CALL       _Voltage_show+0
;main.c,100 :: 		}
L_main18:
;main.c,102 :: 		if(Tick>=watch_cnt){   // every 300 ms    unless power off
	MOVF       _watch_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main255
	MOVF       _watch_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main255
	MOVF       _watch_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main255
	MOVF       _watch_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main255:
	BTFSS      STATUS+0, 0
	GOTO       L_main19
;main.c,103 :: 		watch_cnt += 300;
	MOVLW      44
	ADDWF      _watch_cnt+0, 1
	MOVLW      1
	ADDWFC     _watch_cnt+1, 1
	MOVLW      0
	ADDWFC     _watch_cnt+2, 1
	ADDWFC     _watch_cnt+3, 1
;main.c,104 :: 		watch_swr();
	CALL       _watch_swr+0
;main.c,105 :: 		}
L_main19:
;main.c,107 :: 		if(Tick>=disp_cnt){  // Display off
	MOVF       _disp_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main256
	MOVF       _disp_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main256
	MOVF       _disp_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main256
	MOVF       _disp_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main256:
	BTFSS      STATUS+0, 0
	GOTO       L_main20
;main.c,109 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,110 :: 		}
L_main20:
;main.c,112 :: 		if(Tick>=off_cnt){    // Go to power off
	MOVF       _off_cnt+3, 0
	SUBWF      _Tick+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main257
	MOVF       _off_cnt+2, 0
	SUBWF      _Tick+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main257
	MOVF       _off_cnt+1, 0
	SUBWF      _Tick+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main257
	MOVF       _off_cnt+0, 0
	SUBWF      _Tick+0, 0
L__main257:
	BTFSS      STATUS+0, 0
	GOTO       L_main21
;main.c,113 :: 		power_off();
	CALL       _power_off+0
;main.c,114 :: 		}
L_main21:
;main.c,116 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_main22
;main.c,117 :: 		if(OLED_PWD) Btn_short();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main23
	CALL       _Btn_short+0
	GOTO       L_main24
L_main23:
;main.c,118 :: 		else oled_start();
	CALL       _oled_start+0
L_main24:
;main.c,119 :: 		}
L_main22:
;main.c,120 :: 		if(B_long){
	BTFSS      _B_long+0, BitPos(_B_long+0)
	GOTO       L_main25
;main.c,121 :: 		if(OLED_PWD) Btn_long();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main26
	CALL       _Btn_long+0
	GOTO       L_main27
L_main26:
;main.c,122 :: 		else oled_start();
	CALL       _oled_start+0
L_main27:
;main.c,123 :: 		}
L_main25:
;main.c,124 :: 		if(B_xlong){
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_main28
;main.c,125 :: 		if(OLED_PWD) Btn_xlong();
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main29
	CALL       _Btn_xlong+0
	GOTO       L_main30
L_main29:
;main.c,126 :: 		else oled_start();
	CALL       _oled_start+0
L_main30:
;main.c,127 :: 		}
L_main28:
;main.c,129 :: 		if(E_short){
	BTFSS      _E_short+0, BitPos(_E_short+0)
	GOTO       L_main31
;main.c,130 :: 		if(OLED_PWD==0) oled_start();
	BTFSC      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main32
	CALL       _oled_start+0
L_main32:
;main.c,131 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,132 :: 		}
L_main31:
;main.c,133 :: 		if(E_long){
	BTFSS      _E_long+0, BitPos(_E_long+0)
	GOTO       L_main33
;main.c,134 :: 		if(OLED_PWD==0) { Ext_long(); oled_start(); }
	BTFSC      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_main34
	CALL       _Ext_long+0
	CALL       _oled_start+0
	GOTO       L_main35
L_main34:
;main.c,135 :: 		else Btn_long();
	CALL       _Btn_long+0
L_main35:
;main.c,136 :: 		}
L_main33:
;main.c,138 :: 		} // while(1)
	GOTO       L_main16
;main.c,139 :: 		} // main
L_end_main:
	GOTO       $+0
; end of _main

_oled_start:

;main.c,142 :: 		void oled_start(){
;main.c,143 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,145 :: 		Delay_ms(200);
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
;main.c,146 :: 		Soft_I2C_init();
	CALL       _Soft_I2C_Init+0
;main.c,147 :: 		Delay_ms(10);
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
;main.c,148 :: 		oled_init();
	CALL       _oled_init+0
;main.c,150 :: 		if(gre){
	BTFSS      _gre+0, BitPos(_gre+0)
	GOTO       L_oled_start38
;main.c,151 :: 		Greating();
	CALL       _Greating+0
;main.c,152 :: 		gre = 0;
	BCF        _gre+0, BitPos(_gre+0)
;main.c,153 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,154 :: 		}
L_oled_start38:
;main.c,155 :: 		oled_wr_str(0, 0, "PWR     W", 9);
	CLRF       FARG_oled_wr_str+0
	CLRF       FARG_oled_wr_str+0
	MOVLW      ?lstr1_main+0
	MOVWF      FARG_oled_wr_str+0
	MOVLW      hi_addr(?lstr1_main+0)
	MOVWF      FARG_oled_wr_str+1
	MOVLW      9
	MOVWF      FARG_oled_wr_str+0
	CALL       _oled_wr_str+0
;main.c,156 :: 		oled_bat();
	CALL       _oled_bat+0
;main.c,157 :: 		oled_wr_str(2, 0, "SWR      ", 9);
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
;main.c,158 :: 		oled_wr_str(0, 42, "=", 1);
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
;main.c,159 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,160 :: 		Voltage_old = 9999;
	MOVLW      15
	MOVWF      _Voltage_old+0
	MOVLW      39
	MOVWF      _Voltage_old+1
;main.c,161 :: 		SWR_fixed_old = 100;
	MOVLW      100
	MOVWF      _SWR_fixed_old+0
	MOVLW      0
	MOVWF      _SWR_fixed_old+1
;main.c,162 :: 		PWR_fixed_old = 9999;
	MOVLW      15
	MOVWF      _PWR_fixed_old+0
	MOVLW      39
	MOVWF      _PWR_fixed_old+1
;main.c,163 :: 		SWR_ind = 0;
	CLRF       _SWR_ind+0
	CLRF       _SWR_ind+1
;main.c,164 :: 		draw_swr(SWR_ind);
	CLRF       FARG_draw_swr+0
	CLRF       FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,165 :: 		volt_cnt = Tick + 1;
	MOVLW      1
	ADDWF      _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVLW      0
	ADDWFC     _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVLW      0
	ADDWFC     _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVLW      0
	ADDWFC     _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,166 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,167 :: 		B_short = 0; B_long = 0; B_xlong = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
	BCF        _B_long+0, BitPos(_B_long+0)
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,168 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,169 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,170 :: 		return;
;main.c,171 :: 		}
L_end_oled_start:
	RETURN
; end of _oled_start

_watch_swr:

;main.c,174 :: 		void watch_swr(void){
;main.c,176 :: 		int delta = Auto_delta - 100;
	MOVLW      100
	SUBWF      _Auto_delta+0, 0
	MOVWF      watch_swr_delta_L0+0
	MOVLW      0
	SUBWFB     _Auto_delta+1, 0
	MOVWF      watch_swr_delta_L0+1
;main.c,179 :: 		Delay_ms(50);
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
;main.c,181 :: 		cnt = 600;
	MOVLW      88
	MOVWF      watch_swr_cnt_L0+0
;main.c,182 :: 		PWR_fixed = 0;
	CLRF       watch_swr_PWR_fixed_L0+0
	CLRF       watch_swr_PWR_fixed_L0+1
;main.c,183 :: 		SWR_fixed = 0;
	CLRF       watch_swr_SWR_fixed_L0+0
	CLRF       watch_swr_SWR_fixed_L0+1
;main.c,184 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	CLRF       watch_swr_peak_cnt_L0+0
L_watch_swr40:
	MOVF       watch_swr_cnt_L0+0, 0
	SUBWF      watch_swr_peak_cnt_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr41
;main.c,185 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,186 :: 		if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr260
	MOVF       _PWR+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr260:
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
;main.c,187 :: 		Delay_ms(1);
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
;main.c,184 :: 		for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
	INCF       watch_swr_peak_cnt_L0+0, 1
;main.c,188 :: 		}
	GOTO       L_watch_swr40
L_watch_swr41:
;main.c,190 :: 		if(PWR_fixed>0){
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr261
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	SUBLW      0
L__watch_swr261:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr45
;main.c,191 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_watch_swr46
;main.c,192 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,193 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,194 :: 		}
	GOTO       L_watch_swr47
L_watch_swr46:
;main.c,195 :: 		else oled_start();
	CALL       _oled_start+0
L_watch_swr47:
;main.c,196 :: 		};
L_watch_swr45:
;main.c,198 :: 		if(PWR_fixed!=PWR_fixed_old){
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	XORWF      _PWR_fixed_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr262
	MOVF       _PWR_fixed_old+0, 0
	XORWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr262:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr48
;main.c,199 :: 		if(Overflow)
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr49
;main.c,200 :: 		oled_wr_str(0, 42, ">", 1);
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
;main.c,202 :: 		oled_wr_str(0, 42, "=", 1);
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
;main.c,203 :: 		PWR_fixed_old = PWR_fixed;
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      _PWR_fixed_old+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      _PWR_fixed_old+1
;main.c,204 :: 		draw_power(PWR_fixed);
	MOVF       watch_swr_PWR_fixed_L0+0, 0
	MOVWF      FARG_draw_power+0
	MOVF       watch_swr_PWR_fixed_L0+1, 0
	MOVWF      FARG_draw_power+1
	CALL       _draw_power+0
;main.c,205 :: 		}
L_watch_swr48:
;main.c,207 :: 		if(PWR_fixed<10){
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr263
	MOVLW      10
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr263:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr51
;main.c,208 :: 		SWR_fixed = 0;
	CLRF       watch_swr_SWR_fixed_L0+0
	CLRF       watch_swr_SWR_fixed_L0+1
;main.c,210 :: 		draw_swr(SWR_ind);
	MOVF       _SWR_ind+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       _SWR_ind+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,211 :: 		return;
	GOTO       L_end_watch_swr
;main.c,212 :: 		}
L_watch_swr51:
;main.c,214 :: 		if(Overflow){
	BTFSS      _Overflow+0, BitPos(_Overflow+0)
	GOTO       L_watch_swr52
;main.c,215 :: 		for(cnt=3; cnt!=0; cnt--){
	MOVLW      3
	MOVWF      watch_swr_cnt_L0+0
L_watch_swr53:
	MOVF       watch_swr_cnt_L0+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr54
;main.c,216 :: 		oled_wr_str(2, 6, "OVERLOAD ", 9);
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
;main.c,217 :: 		Delay_ms(500);
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
;main.c,218 :: 		oled_wr_str(2, 0, "         ", 9);
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
;main.c,219 :: 		Delay_ms(500);
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
;main.c,215 :: 		for(cnt=3; cnt!=0; cnt--){
	DECF       watch_swr_cnt_L0+0, 1
;main.c,220 :: 		}
	GOTO       L_watch_swr53
L_watch_swr54:
;main.c,221 :: 		oled_wr_str(2, 0, "SWR      ", 9);
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
;main.c,222 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,223 :: 		draw_swr(SWR_fixed);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,224 :: 		Delay_ms(500);
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
;main.c,225 :: 		Overflow = 0;
	BCF        _Overflow+0, BitPos(_Overflow+0)
;main.c,226 :: 		}
	GOTO       L_watch_swr59
L_watch_swr52:
;main.c,228 :: 		else if(PWR_fixed>=min_for_start && PWR_fixed<max_for_start && SWR_fixed>=Auto_delta  || SWR_Fixed>900 ) {
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr264
	MOVF       _min_for_start+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr264:
	BTFSS      STATUS+0, 0
	GOTO       L__watch_swr238
	MOVLW      128
	XORWF      watch_swr_PWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _max_for_start+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr265
	MOVF       _max_for_start+0, 0
	SUBWF      watch_swr_PWR_fixed_L0+0, 0
L__watch_swr265:
	BTFSC      STATUS+0, 0
	GOTO       L__watch_swr238
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _Auto_delta+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr266
	MOVF       _Auto_delta+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr266:
	BTFSS      STATUS+0, 0
	GOTO       L__watch_swr238
	GOTO       L__watch_swr237
L__watch_swr238:
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr267
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBLW      132
L__watch_swr267:
	BTFSS      STATUS+0, 0
	GOTO       L__watch_swr237
	GOTO       L_watch_swr64
L__watch_swr237:
;main.c,229 :: 		if(  (SWR_fixed>SWR_fixed_old && (SWR_fixed-SWR_fixed_old)>delta) || (SWR_fixed<SWR_fixed_old && (SWR_fixed_old-SWR_fixed)>delta) || SWR_Fixed>900  ) {
	MOVLW      128
	XORWF      _SWR_fixed_old+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr268
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBWF      _SWR_fixed_old+0, 0
L__watch_swr268:
	BTFSC      STATUS+0, 0
	GOTO       L__watch_swr236
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
	GOTO       L__watch_swr269
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr269:
	BTFSC      STATUS+0, 0
	GOTO       L__watch_swr236
	GOTO       L__watch_swr234
L__watch_swr236:
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _SWR_fixed_old+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr270
	MOVF       _SWR_fixed_old+0, 0
	SUBWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr270:
	BTFSC      STATUS+0, 0
	GOTO       L__watch_swr235
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
	GOTO       L__watch_swr271
	MOVF       R1, 0
	SUBWF      watch_swr_delta_L0+0, 0
L__watch_swr271:
	BTFSC      STATUS+0, 0
	GOTO       L__watch_swr235
	GOTO       L__watch_swr234
L__watch_swr235:
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr272
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBLW      132
L__watch_swr272:
	BTFSS      STATUS+0, 0
	GOTO       L__watch_swr234
	GOTO       L_watch_swr71
L__watch_swr234:
;main.c,230 :: 		Btn_long();
	CALL       _Btn_long+0
;main.c,231 :: 		return;
	GOTO       L_end_watch_swr
;main.c,232 :: 		}
L_watch_swr71:
;main.c,233 :: 		}
L_watch_swr64:
L_watch_swr59:
;main.c,235 :: 		if(SWR_fixed>99 && SWR_fixed!=SWR_ind){
	MOVLW      128
	MOVWF      R0
	MOVLW      128
	XORWF      watch_swr_SWR_fixed_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr273
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	SUBLW      99
L__watch_swr273:
	BTFSC      STATUS+0, 0
	GOTO       L_watch_swr74
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	XORWF      _SWR_ind+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__watch_swr274
	MOVF       _SWR_ind+0, 0
	XORWF      watch_swr_SWR_fixed_L0+0, 0
L__watch_swr274:
	BTFSC      STATUS+0, 2
	GOTO       L_watch_swr74
L__watch_swr233:
;main.c,236 :: 		SWR_ind = SWR_fixed;
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      _SWR_ind+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      _SWR_ind+1
;main.c,237 :: 		draw_swr(SWR_ind);
	MOVF       watch_swr_SWR_fixed_L0+0, 0
	MOVWF      FARG_draw_swr+0
	MOVF       watch_swr_SWR_fixed_L0+1, 0
	MOVWF      FARG_draw_swr+1
	CALL       _draw_swr+0
;main.c,238 :: 		}
L_watch_swr74:
;main.c,240 :: 		return;
;main.c,241 :: 		}
L_end_watch_swr:
	RETURN
; end of _watch_swr

_draw_swr:

;main.c,243 :: 		void draw_swr(unsigned int s){
;main.c,244 :: 		if(s==0)
	MOVLW      0
	XORWF      FARG_draw_swr_s+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_swr276
	MOVLW      0
	XORWF      FARG_draw_swr_s+0, 0
L__draw_swr276:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_swr75
;main.c,245 :: 		oled_wr_str(2, 60, "0.00", 4);
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
	GOTO       L_draw_swr76
L_draw_swr75:
;main.c,247 :: 		IntToStr(s, txt_2);
	MOVF       FARG_draw_swr_s+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_swr_s+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,248 :: 		txt[0] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+0
;main.c,249 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,250 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,251 :: 		txt[3] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+3
;main.c,253 :: 		oled_wr_str(2, 60, txt, 4);
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
;main.c,254 :: 		}
L_draw_swr76:
;main.c,255 :: 		return;
;main.c,256 :: 		}
L_end_draw_swr:
	RETURN
; end of _draw_swr

_draw_power:

;main.c,258 :: 		void draw_power(unsigned int p){
;main.c,260 :: 		if(p==0){
	MOVLW      0
	XORWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power278
	MOVLW      0
	XORWF      FARG_draw_power_p+0, 0
L__draw_power278:
	BTFSS      STATUS+0, 2
	GOTO       L_draw_power77
;main.c,261 :: 		oled_wr_str(0, 60, "0.0", 3);
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
;main.c,262 :: 		return;
	GOTO       L_end_draw_power
;main.c,263 :: 		}
L_draw_power77:
;main.c,264 :: 		else if(p<10){  // <1 W
	MOVLW      0
	SUBWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power279
	MOVLW      10
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power279:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power79
;main.c,265 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,266 :: 		txt[0] = '0';
	MOVLW      48
	MOVWF      _txt+0
;main.c,267 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,268 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,269 :: 		}
	GOTO       L_draw_power80
L_draw_power79:
;main.c,270 :: 		else if(p<100){ // <10W
	MOVLW      0
	SUBWF      FARG_draw_power_p+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__draw_power280
	MOVLW      100
	SUBWF      FARG_draw_power_p+0, 0
L__draw_power280:
	BTFSC      STATUS+0, 0
	GOTO       L_draw_power81
;main.c,271 :: 		IntToStr(p, txt_2);
	MOVF       FARG_draw_power_p+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       FARG_draw_power_p+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,272 :: 		txt[0] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+0
;main.c,273 :: 		txt[1] = '.';
	MOVLW      46
	MOVWF      _txt+1
;main.c,274 :: 		txt[2] = txt_2[5];
	MOVF       _txt_2+5, 0
	MOVWF      _txt+2
;main.c,275 :: 		}
	GOTO       L_draw_power82
L_draw_power81:
;main.c,277 :: 		p += 5;
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
;main.c,278 :: 		IntToStr(p, txt_2);
	MOVF       R0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _txt_2+0
	MOVWF      FARG_IntToStr_output+0
	MOVLW      hi_addr(_txt_2+0)
	MOVWF      FARG_IntToStr_output+1
	CALL       _IntToStr+0
;main.c,279 :: 		txt[0] = ' ';
	MOVLW      32
	MOVWF      _txt+0
;main.c,280 :: 		txt[1] = txt_2[3];
	MOVF       _txt_2+3, 0
	MOVWF      _txt+1
;main.c,281 :: 		txt[2] = txt_2[4];
	MOVF       _txt_2+4, 0
	MOVWF      _txt+2
;main.c,282 :: 		}
L_draw_power82:
L_draw_power80:
;main.c,283 :: 		oled_wr_str(0, 60, txt, 3);
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
;main.c,284 :: 		return;
;main.c,285 :: 		}
L_end_draw_power:
	RETURN
; end of _draw_power

_Voltage_show:

;main.c,287 :: 		void Voltage_show(){
;main.c,288 :: 		get_batt();
	CALL       _get_batt+0
;main.c,289 :: 		if(Voltage != Voltage_old) { Voltage_old = Voltage; oled_voltage(Voltage); }
	MOVF       _Voltage+1, 0
	XORWF      _Voltage_old+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show282
	MOVF       _Voltage_old+0, 0
	XORWF      _Voltage+0, 0
L__Voltage_show282:
	BTFSC      STATUS+0, 2
	GOTO       L_Voltage_show83
	MOVF       _Voltage+0, 0
	MOVWF      _Voltage_old+0
	MOVF       _Voltage+1, 0
	MOVWF      _Voltage_old+1
	MOVF       _Voltage+0, 0
	MOVWF      FARG_oled_voltage+0
	MOVF       _Voltage+1, 0
	MOVWF      FARG_oled_voltage+1
	CALL       _oled_voltage+0
L_Voltage_show83:
;main.c,292 :: 		if(Voltage>3700){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show283
	MOVF       _Voltage+0, 0
	SUBLW      116
L__Voltage_show283:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show84
;main.c,293 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,294 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,295 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show85:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show85
	DECFSZ     R12, 1
	GOTO       L_Voltage_show85
	DECFSZ     R11, 1
	GOTO       L_Voltage_show85
;main.c,296 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,297 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,298 :: 		}
	GOTO       L_Voltage_show86
L_Voltage_show84:
;main.c,299 :: 		else if(Voltage>3590){
	MOVLW      128
	XORLW      14
	MOVWF      R0
	MOVLW      128
	XORWF      _Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show284
	MOVF       _Voltage+0, 0
	SUBLW      6
L__Voltage_show284:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show87
;main.c,300 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,301 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,302 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show88:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show88
	DECFSZ     R12, 1
	GOTO       L_Voltage_show88
	DECFSZ     R11, 1
	GOTO       L_Voltage_show88
;main.c,303 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,304 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,305 :: 		}
	GOTO       L_Voltage_show89
L_Voltage_show87:
;main.c,307 :: 		Red = 0;
	BCF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,308 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,309 :: 		Delay_ms(30);
	MOVLW      2
	MOVWF      R11
	MOVLW      56
	MOVWF      R12
	MOVLW      173
	MOVWF      R13
L_Voltage_show90:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show90
	DECFSZ     R12, 1
	GOTO       L_Voltage_show90
	DECFSZ     R11, 1
	GOTO       L_Voltage_show90
;main.c,310 :: 		Red = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,311 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,312 :: 		}
L_Voltage_show89:
L_Voltage_show86:
;main.c,314 :: 		if(Voltage<3400){
	MOVLW      128
	XORWF      _Voltage+1, 0
	MOVWF      R0
	MOVLW      128
	XORLW      13
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__Voltage_show285
	MOVLW      72
	SUBWF      _Voltage+0, 0
L__Voltage_show285:
	BTFSC      STATUS+0, 0
	GOTO       L_Voltage_show91
;main.c,315 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,316 :: 		oled_wr_str(1, 0, "  LOW BATT ", 11);
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
;main.c,317 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Voltage_show92:
	DECFSZ     R13, 1
	GOTO       L_Voltage_show92
	DECFSZ     R12, 1
	GOTO       L_Voltage_show92
	DECFSZ     R11, 1
	GOTO       L_Voltage_show92
	NOP
;main.c,318 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,319 :: 		power_off();
	CALL       _power_off+0
;main.c,320 :: 		}
L_Voltage_show91:
;main.c,321 :: 		return;
;main.c,322 :: 		}
L_end_Voltage_show:
	RETURN
; end of _Voltage_show

_Btn_xlong:

;main.c,324 :: 		void Btn_xlong(){
;main.c,325 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,326 :: 		btn_cnt = 0;
	CLRF       _btn_cnt+0
	CLRF       _btn_cnt+1
	CLRF       _btn_cnt+2
	CLRF       _btn_cnt+3
;main.c,327 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,328 :: 		oled_wr_str(1, 0, " POWER OFF ", 11);
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
;main.c,329 :: 		Delay_ms(2000);
	MOVLW      82
	MOVWF      R11
	MOVLW      43
	MOVWF      R12
	MOVLW      0
	MOVWF      R13
L_Btn_xlong93:
	DECFSZ     R13, 1
	GOTO       L_Btn_xlong93
	DECFSZ     R12, 1
	GOTO       L_Btn_xlong93
	DECFSZ     R11, 1
	GOTO       L_Btn_xlong93
	NOP
;main.c,330 :: 		power_off();
	CALL       _power_off+0
;main.c,331 :: 		return;
;main.c,332 :: 		}
L_end_Btn_xlong:
	RETURN
; end of _Btn_xlong

_Btn_long:

;main.c,334 :: 		void Btn_long(){
;main.c,335 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,336 :: 		oled_wr_str(2, 0, "TUNE     ", 9);
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
;main.c,337 :: 		tune();
	CALL       _tune+0
;main.c,338 :: 		SWR_ind = SWR;
	MOVF       _SWR+0, 0
	MOVWF      _SWR_ind+0
	MOVF       _SWR+1, 0
	MOVWF      _SWR_ind+1
;main.c,339 :: 		SWR_fixed_old = SWR;
	MOVF       _SWR+0, 0
	MOVWF      _SWR_fixed_old+0
	MOVF       _SWR+1, 0
	MOVWF      _SWR_fixed_old+1
;main.c,340 :: 		oled_wr_str(2, 0, "SWR ", 4);
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
;main.c,341 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,342 :: 		draw_swr(SWR_ind);
	MOVF       _SWR_ind+0, 0
	MOVWF      FARG_draw_swr_s+0
	MOVF       _SWR_ind+1, 0
	MOVWF      FARG_draw_swr_s+1
	CALL       _draw_swr+0
;main.c,343 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,344 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,345 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,346 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,347 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,348 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,349 :: 		return;
;main.c,350 :: 		}
L_end_Btn_long:
	RETURN
; end of _Btn_long

_Ext_long:

;main.c,352 :: 		void Ext_long(){
;main.c,353 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,354 :: 		OLED_PWD = 1;
	BSF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,355 :: 		tune();
	CALL       _tune+0
;main.c,356 :: 		SWR_ind = SWR;
	MOVF       _SWR+0, 0
	MOVWF      _SWR_ind+0
	MOVF       _SWR+1, 0
	MOVWF      _SWR_ind+1
;main.c,357 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,358 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,359 :: 		return;
;main.c,360 :: 		}
L_end_Ext_long:
	RETURN
; end of _Ext_long

_Btn_short:

;main.c,362 :: 		void Btn_short(){
;main.c,363 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,364 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,365 :: 		oled_wr_str(2, 0, "RESET    ", 9);
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
;main.c,366 :: 		Delay_ms(600);
	MOVLW      25
	MOVWF      R11
	MOVLW      90
	MOVWF      R12
	MOVLW      177
	MOVWF      R13
L_Btn_short94:
	DECFSZ     R13, 1
	GOTO       L_Btn_short94
	DECFSZ     R12, 1
	GOTO       L_Btn_short94
	DECFSZ     R11, 1
	GOTO       L_Btn_short94
	NOP
	NOP
;main.c,367 :: 		oled_wr_str(2, 0, "SWR  ", 5);
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
;main.c,368 :: 		oled_wr_str(2, 42, "=", 1);
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
;main.c,369 :: 		oled_wr_str(2, 60, "0.00", 4);
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
;main.c,370 :: 		SWR_fixed_old = 100;
	MOVLW      100
	MOVWF      _SWR_fixed_old+0
	MOVLW      0
	MOVWF      _SWR_fixed_old+1
;main.c,371 :: 		Delay_ms(300);
	MOVLW      13
	MOVWF      R11
	MOVLW      45
	MOVWF      R12
	MOVLW      215
	MOVWF      R13
L_Btn_short95:
	DECFSZ     R13, 1
	GOTO       L_Btn_short95
	DECFSZ     R12, 1
	GOTO       L_Btn_short95
	DECFSZ     R11, 1
	GOTO       L_Btn_short95
	NOP
	NOP
;main.c,372 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,373 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,374 :: 		E_short = 0;
	BCF        _E_short+0, BitPos(_E_short+0)
;main.c,375 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,376 :: 		volt_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _volt_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _volt_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _volt_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _volt_cnt+3
;main.c,377 :: 		watch_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      _watch_cnt+0
	MOVF       _Tick+1, 0
	MOVWF      _watch_cnt+1
	MOVF       _Tick+2, 0
	MOVWF      _watch_cnt+2
	MOVF       _Tick+3, 0
	MOVWF      _watch_cnt+3
;main.c,378 :: 		return;
;main.c,379 :: 		}
L_end_Btn_short:
	RETURN
; end of _Btn_short

_Greating:

;main.c,381 :: 		void Greating(){
;main.c,382 :: 		Green = 0;
	BCF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,383 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,384 :: 		oled_wr_str_s(1, 0, " DESIGNED BY N7DDC", 18);
	MOVLW      1
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr22_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr22_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      18
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,385 :: 		oled_wr_str_s(3, 0, " FW VERSION ", 12);
	MOVLW      3
	MOVWF      FARG_oled_wr_str_s+0
	CLRF       FARG_oled_wr_str_s+0
	MOVLW      ?lstr23_main+0
	MOVWF      FARG_oled_wr_str_s+0
	MOVLW      hi_addr(?lstr23_main+0)
	MOVWF      FARG_oled_wr_str_s+1
	MOVLW      12
	MOVWF      FARG_oled_wr_str_s+0
	CALL       _oled_wr_str_s+0
;main.c,386 :: 		oled_wr_str_s(3, 12*7, FW_VER, 3);
	MOVLW      3
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
;main.c,387 :: 		Delay_ms(3000);
	MOVLW      122
	MOVWF      R11
	MOVLW      193
	MOVWF      R12
	MOVLW      129
	MOVWF      R13
L_Greating96:
	DECFSZ     R13, 1
	GOTO       L_Greating96
	DECFSZ     R12, 1
	GOTO       L_Greating96
	DECFSZ     R11, 1
	GOTO       L_Greating96
	NOP
	NOP
;main.c,388 :: 		while(GetButton) asm NOP;
L_Greating97:
	BTFSC      PORTB+0, 5
	GOTO       L__Greating291
	BSF        3, 0
	GOTO       L__Greating292
L__Greating291:
	BCF        3, 0
L__Greating292:
	BTFSS      3, 0
	GOTO       L_Greating98
	NOP
	GOTO       L_Greating97
L_Greating98:
;main.c,389 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,390 :: 		return;
;main.c,391 :: 		}
L_end_Greating:
	RETURN
; end of _Greating

_atu_reset:

;main.c,393 :: 		void atu_reset(){
;main.c,394 :: 		ind = 0;
	CLRF       _ind+0
;main.c,395 :: 		cap = 0;
	CLRF       _cap+0
;main.c,396 :: 		SW = 0;
	CLRF       _SW+0
;main.c,397 :: 		Relay_set(ind, cap, SW);
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CLRF       FARG_Relay_set+0
	CALL       _Relay_set+0
;main.c,398 :: 		return;
;main.c,399 :: 		}
L_end_atu_reset:
	RETURN
; end of _atu_reset

_Relay_set:

;main.c,401 :: 		void Relay_set(char L, char C, char I){
;main.c,402 :: 		L_010 = ~L.B0;
	BTFSC      FARG_Relay_set_L+0, 0
	GOTO       L__Relay_set295
	BSF        LATD7_bit+0, BitPos(LATD7_bit+0)
	GOTO       L__Relay_set296
L__Relay_set295:
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
L__Relay_set296:
;main.c,403 :: 		L_022 = ~L.B1;
	BTFSC      FARG_Relay_set_L+0, 1
	GOTO       L__Relay_set297
	BSF        LATD6_bit+0, BitPos(LATD6_bit+0)
	GOTO       L__Relay_set298
L__Relay_set297:
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
L__Relay_set298:
;main.c,404 :: 		L_045 = ~L.B2;
	BTFSC      FARG_Relay_set_L+0, 2
	GOTO       L__Relay_set299
	BSF        LATD5_bit+0, BitPos(LATD5_bit+0)
	GOTO       L__Relay_set300
L__Relay_set299:
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
L__Relay_set300:
;main.c,405 :: 		L_100 = ~L.B3;
	BTFSC      FARG_Relay_set_L+0, 3
	GOTO       L__Relay_set301
	BSF        LATD4_bit+0, BitPos(LATD4_bit+0)
	GOTO       L__Relay_set302
L__Relay_set301:
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
L__Relay_set302:
;main.c,406 :: 		L_220 = ~L.B4;
	BTFSC      FARG_Relay_set_L+0, 4
	GOTO       L__Relay_set303
	BSF        LATC7_bit+0, BitPos(LATC7_bit+0)
	GOTO       L__Relay_set304
L__Relay_set303:
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
L__Relay_set304:
;main.c,407 :: 		L_450 = ~L.B5;
	BTFSC      FARG_Relay_set_L+0, 5
	GOTO       L__Relay_set305
	BSF        LATC6_bit+0, BitPos(LATC6_bit+0)
	GOTO       L__Relay_set306
L__Relay_set305:
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
L__Relay_set306:
;main.c,408 :: 		L_1000 = ~L.B6;
	BTFSC      FARG_Relay_set_L+0, 6
	GOTO       L__Relay_set307
	BSF        LATC5_bit+0, BitPos(LATC5_bit+0)
	GOTO       L__Relay_set308
L__Relay_set307:
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
L__Relay_set308:
;main.c,410 :: 		C_22 = ~C.B0;
	BTFSC      FARG_Relay_set_C+0, 0
	GOTO       L__Relay_set309
	BSF        LATA5_bit+0, BitPos(LATA5_bit+0)
	GOTO       L__Relay_set310
L__Relay_set309:
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
L__Relay_set310:
;main.c,411 :: 		C_47 = ~C.B1;
	BTFSC      FARG_Relay_set_C+0, 1
	GOTO       L__Relay_set311
	BSF        LATE1_bit+0, BitPos(LATE1_bit+0)
	GOTO       L__Relay_set312
L__Relay_set311:
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
L__Relay_set312:
;main.c,412 :: 		C_100 = ~C.B2;
	BTFSC      FARG_Relay_set_C+0, 2
	GOTO       L__Relay_set313
	BSF        LATA7_bit+0, BitPos(LATA7_bit+0)
	GOTO       L__Relay_set314
L__Relay_set313:
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
L__Relay_set314:
;main.c,413 :: 		C_220 = ~C.B3;
	BTFSC      FARG_Relay_set_C+0, 3
	GOTO       L__Relay_set315
	BSF        LATA6_bit+0, BitPos(LATA6_bit+0)
	GOTO       L__Relay_set316
L__Relay_set315:
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
L__Relay_set316:
;main.c,414 :: 		C_470 = ~C.B4;
	BTFSC      FARG_Relay_set_C+0, 4
	GOTO       L__Relay_set317
	BSF        LATC0_bit+0, BitPos(LATC0_bit+0)
	GOTO       L__Relay_set318
L__Relay_set317:
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
L__Relay_set318:
;main.c,415 :: 		C_1000 = ~C.B5;
	BTFSC      FARG_Relay_set_C+0, 5
	GOTO       L__Relay_set319
	BSF        LATC1_bit+0, BitPos(LATC1_bit+0)
	GOTO       L__Relay_set320
L__Relay_set319:
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
L__Relay_set320:
;main.c,416 :: 		C_2200 = ~C.B6;
	BTFSC      FARG_Relay_set_C+0, 6
	GOTO       L__Relay_set321
	BSF        LATC2_bit+0, BitPos(LATC2_bit+0)
	GOTO       L__Relay_set322
L__Relay_set321:
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
L__Relay_set322:
;main.c,418 :: 		C_sw = I;
	BTFSC      FARG_Relay_set_I+0, 0
	GOTO       L__Relay_set323
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
	GOTO       L__Relay_set324
L__Relay_set323:
	BSF        LATE0_bit+0, BitPos(LATE0_bit+0)
L__Relay_set324:
;main.c,420 :: 		Rel_to_gnd = 1;
	BSF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,421 :: 		Vdelay_ms(rldl);
	MOVF       _rldl+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _rldl+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,422 :: 		Rel_to_gnd = 0;
	BCF        LATD3_bit+0, BitPos(LATD3_bit+0)
;main.c,423 :: 		Delay_us(10);
	MOVLW      26
	MOVWF      R13
L_Relay_set99:
	DECFSZ     R13, 1
	GOTO       L_Relay_set99
	NOP
;main.c,424 :: 		Rel_to_plus_N = 0;
	BCF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,425 :: 		Vdelay_ms(rldl);
	MOVF       _rldl+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _rldl+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,426 :: 		Rel_to_plus_N = 1;
	BSF        LATC4_bit+0, BitPos(LATC4_bit+0)
;main.c,427 :: 		Vdelay_ms(rldl);
	MOVF       _rldl+0, 0
	MOVWF      FARG_VDelay_ms_Time_ms+0
	MOVF       _rldl+1, 0
	MOVWF      FARG_VDelay_ms_Time_ms+1
	CALL       _VDelay_ms+0
;main.c,429 :: 		L_010 = 0;
	BCF        LATD7_bit+0, BitPos(LATD7_bit+0)
;main.c,430 :: 		L_022 = 0;
	BCF        LATD6_bit+0, BitPos(LATD6_bit+0)
;main.c,431 :: 		L_045 = 0;
	BCF        LATD5_bit+0, BitPos(LATD5_bit+0)
;main.c,432 :: 		L_100 = 0;
	BCF        LATD4_bit+0, BitPos(LATD4_bit+0)
;main.c,433 :: 		L_220 = 0;
	BCF        LATC7_bit+0, BitPos(LATC7_bit+0)
;main.c,434 :: 		L_450 = 0;
	BCF        LATC6_bit+0, BitPos(LATC6_bit+0)
;main.c,435 :: 		L_1000 = 0;
	BCF        LATC5_bit+0, BitPos(LATC5_bit+0)
;main.c,437 :: 		C_22 = 0;
	BCF        LATA5_bit+0, BitPos(LATA5_bit+0)
;main.c,438 :: 		C_47 = 0;
	BCF        LATE1_bit+0, BitPos(LATE1_bit+0)
;main.c,439 :: 		C_100 = 0;
	BCF        LATA7_bit+0, BitPos(LATA7_bit+0)
;main.c,440 :: 		C_220 = 0;
	BCF        LATA6_bit+0, BitPos(LATA6_bit+0)
;main.c,441 :: 		C_470 = 0;
	BCF        LATC0_bit+0, BitPos(LATC0_bit+0)
;main.c,442 :: 		C_1000 = 0;
	BCF        LATC1_bit+0, BitPos(LATC1_bit+0)
;main.c,443 :: 		C_2200 = 0;
	BCF        LATC2_bit+0, BitPos(LATC2_bit+0)
;main.c,445 :: 		C_sw = 0;
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
;main.c,446 :: 		return;
;main.c,447 :: 		}
L_end_Relay_set:
	RETURN
; end of _Relay_set

_power_off:

;main.c,449 :: 		void power_off(void){
;main.c,452 :: 		GIE_bit = 0;
	BCF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,453 :: 		T0EN_bit = 0;
	BCF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,454 :: 		TMR0IF_bit = 0;
	BCF        TMR0IF_bit+0, BitPos(TMR0IF_bit+0)
;main.c,455 :: 		IOCIE_bit = 1;
	BSF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,456 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,457 :: 		IOCBN5_bit = 1;
	BSF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,459 :: 		OLED_PWD = 0;
	BCF        LATA4_bit+0, BitPos(LATA4_bit+0)
;main.c,460 :: 		RED = 1;
	BSF        LATB4_bit+0, BitPos(LATB4_bit+0)
;main.c,461 :: 		Green = 1;
	BSF        LATB3_bit+0, BitPos(LATB3_bit+0)
;main.c,463 :: 		C_sw = 0;
	BCF        LATE0_bit+0, BitPos(LATE0_bit+0)
;main.c,464 :: 		SYSCMD_bit = 1;
	BSF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,466 :: 		btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
;main.c,467 :: 		while(1){
L_power_off100:
;main.c,468 :: 		if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
	MOVF       power_off_btn_cnt_L0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_power_off102
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off103:
	DECFSZ     R13, 1
	GOTO       L_power_off103
	DECFSZ     R12, 1
	GOTO       L_power_off103
	DECFSZ     R11, 1
	GOTO       L_power_off103
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
	SLEEP
L_power_off102:
;main.c,469 :: 		asm NOP;
	NOP
;main.c,470 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_power_off104:
	DECFSZ     R13, 1
	GOTO       L_power_off104
	DECFSZ     R12, 1
	GOTO       L_power_off104
	DECFSZ     R11, 1
	GOTO       L_power_off104
;main.c,471 :: 		if(GetButton) btn_cnt++;
	BTFSC      PORTB+0, 5
	GOTO       L__power_off326
	BSF        3, 0
	GOTO       L__power_off327
L__power_off326:
	BCF        3, 0
L__power_off327:
	BTFSS      3, 0
	GOTO       L_power_off105
	INCF       power_off_btn_cnt_L0+0, 1
	GOTO       L_power_off106
L_power_off105:
;main.c,472 :: 		else btn_cnt = 0;
	CLRF       power_off_btn_cnt_L0+0
L_power_off106:
;main.c,473 :: 		if(btn_cnt>15) break;
	MOVF       power_off_btn_cnt_L0+0, 0
	SUBLW      15
	BTFSC      STATUS+0, 0
	GOTO       L_power_off107
	GOTO       L_power_off101
L_power_off107:
;main.c,474 :: 		}
	GOTO       L_power_off100
L_power_off101:
;main.c,476 :: 		SYSCMD_bit = 0;
	BCF        SYSCMD_bit+0, BitPos(SYSCMD_bit+0)
;main.c,478 :: 		IOCIE_bit = 0;
	BCF        IOCIE_bit+0, BitPos(IOCIE_bit+0)
;main.c,479 :: 		IOCBN5_bit = 0;
	BCF        IOCBN5_bit+0, BitPos(IOCBN5_bit+0)
;main.c,480 :: 		IOCBF5_bit = 0;
	BCF        IOCBF5_bit+0, BitPos(IOCBF5_bit+0)
;main.c,481 :: 		T0EN_bit = 1;
	BSF        T0EN_bit+0, BitPos(T0EN_bit+0)
;main.c,482 :: 		GIE_bit = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;main.c,484 :: 		gre = 1;
	BSF        _gre+0, BitPos(_gre+0)
;main.c,485 :: 		oled_start();
	CALL       _oled_start+0
;main.c,486 :: 		while(GetButton){asm NOP;}
L_power_off108:
	BTFSC      PORTB+0, 5
	GOTO       L__power_off328
	BSF        3, 0
	GOTO       L__power_off329
L__power_off328:
	BCF        3, 0
L__power_off329:
	BTFSS      3, 0
	GOTO       L_power_off109
	NOP
	GOTO       L_power_off108
L_power_off109:
;main.c,487 :: 		B_short = 0;
	BCF        _B_short+0, BitPos(_B_short+0)
;main.c,488 :: 		B_long = 0;
	BCF        _B_long+0, BitPos(_B_long+0)
;main.c,489 :: 		B_xlong = 0;
	BCF        _B_xlong+0, BitPos(_B_xlong+0)
;main.c,490 :: 		E_long = 0;
	BCF        _E_long+0, BitPos(_E_long+0)
;main.c,491 :: 		btn_1_cnt = 0;
	CLRF       _btn_1_cnt+0
;main.c,492 :: 		btn_cnt = Tick;
	MOVF       _Tick+0, 0
	MOVWF      power_off_btn_cnt_L0+0
;main.c,493 :: 		return;
;main.c,494 :: 		}
L_end_power_off:
	RETURN
; end of _power_off

_check_reset_flags:

;main.c,497 :: 		void check_reset_flags(void){
;main.c,498 :: 		char i = 0;
	CLRF       check_reset_flags_i_L0+0
;main.c,499 :: 		if(STKOVF_bit){oled_wr_str_s(0,  0, "Stack overflow",  14); i = 1;}
	BTFSS      STKOVF_bit+0, BitPos(STKOVF_bit+0)
	GOTO       L_check_reset_flags110
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
L_check_reset_flags110:
;main.c,500 :: 		if(STKUNF_bit){oled_wr_str_s(1,  0, "Stack underflow", 15); i = 1;}
	BTFSS      STKUNF_bit+0, BitPos(STKUNF_bit+0)
	GOTO       L_check_reset_flags111
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
L_check_reset_flags111:
;main.c,501 :: 		if(!nRWDT_bit){oled_wr_str_s(2,  0, "WDT overflow",    12); i = 1;}
	BTFSC      nRWDT_bit+0, BitPos(nRWDT_bit+0)
	GOTO       L_check_reset_flags112
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
L_check_reset_flags112:
;main.c,502 :: 		if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ",    12); i = 1;}
	BTFSC      nRMCLR_bit+0, BitPos(nRMCLR_bit+0)
	GOTO       L_check_reset_flags113
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
L_check_reset_flags113:
;main.c,503 :: 		if(!nBOR_bit){oled_wr_str_s(4,   0, "BOR reset  ",     12); i = 1;}
	BTFSC      nBOR_bit+0, BitPos(nBOR_bit+0)
	GOTO       L_check_reset_flags114
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
L_check_reset_flags114:
;main.c,504 :: 		if(i){
	MOVF       check_reset_flags_i_L0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_check_reset_flags115
;main.c,505 :: 		Delay_ms(5000);
	MOVLW      203
	MOVWF      R11
	MOVLW      236
	MOVWF      R12
	MOVLW      132
	MOVWF      R13
L_check_reset_flags116:
	DECFSZ     R13, 1
	GOTO       L_check_reset_flags116
	DECFSZ     R12, 1
	GOTO       L_check_reset_flags116
	DECFSZ     R11, 1
	GOTO       L_check_reset_flags116
	NOP
;main.c,506 :: 		oled_clear();
	CALL       _oled_clear+0
;main.c,507 :: 		}
L_check_reset_flags115:
;main.c,508 :: 		return;
;main.c,509 :: 		}
L_end_check_reset_flags:
	RETURN
; end of _check_reset_flags

_correction:

;main.c,511 :: 		int correction(int input) {
;main.c,512 :: 		input *= 2;
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
;main.c,514 :: 		if(input <= 543) input += 256;
	MOVLW      128
	XORLW      2
	MOVWF      R0
	MOVLW      128
	XORWF      R2, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction332
	MOVF       R1, 0
	SUBLW      31
L__correction332:
	BTFSS      STATUS+0, 0
	GOTO       L_correction117
	MOVLW      0
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction118
L_correction117:
;main.c,515 :: 		else if(input <= 791) input += 274;
	MOVLW      128
	XORLW      3
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction333
	MOVF       FARG_correction_input+0, 0
	SUBLW      23
L__correction333:
	BTFSS      STATUS+0, 0
	GOTO       L_correction119
	MOVLW      18
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction120
L_correction119:
;main.c,516 :: 		else if(input <= 1225) input += 288;
	MOVLW      128
	XORLW      4
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction334
	MOVF       FARG_correction_input+0, 0
	SUBLW      201
L__correction334:
	BTFSS      STATUS+0, 0
	GOTO       L_correction121
	MOVLW      32
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction122
L_correction121:
;main.c,517 :: 		else if(input <= 1991) input += 286;
	MOVLW      128
	XORLW      7
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction335
	MOVF       FARG_correction_input+0, 0
	SUBLW      199
L__correction335:
	BTFSS      STATUS+0, 0
	GOTO       L_correction123
	MOVLW      30
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction124
L_correction123:
;main.c,518 :: 		else if(input <= 2766) input += 288;
	MOVLW      128
	XORLW      10
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction336
	MOVF       FARG_correction_input+0, 0
	SUBLW      206
L__correction336:
	BTFSS      STATUS+0, 0
	GOTO       L_correction125
	MOVLW      32
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction126
L_correction125:
;main.c,519 :: 		else if(input <= 3970) input += 260;
	MOVLW      128
	XORLW      15
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction337
	MOVF       FARG_correction_input+0, 0
	SUBLW      130
L__correction337:
	BTFSS      STATUS+0, 0
	GOTO       L_correction127
	MOVLW      4
	ADDWF      FARG_correction_input+0, 1
	MOVLW      1
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction128
L_correction127:
;main.c,520 :: 		else if(input <= 5100) input += 250;
	MOVLW      128
	XORLW      19
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_correction_input+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__correction338
	MOVF       FARG_correction_input+0, 0
	SUBLW      236
L__correction338:
	BTFSS      STATUS+0, 0
	GOTO       L_correction129
	MOVLW      250
	ADDWF      FARG_correction_input+0, 1
	MOVLW      0
	ADDWFC     FARG_correction_input+1, 1
	GOTO       L_correction130
L_correction129:
;main.c,521 :: 		else  input += 240;
	MOVLW      240
	ADDWF      FARG_correction_input+0, 1
	MOVLW      0
	ADDWFC     FARG_correction_input+1, 1
L_correction130:
L_correction128:
L_correction126:
L_correction124:
L_correction122:
L_correction120:
L_correction118:
;main.c,523 :: 		return input;
	MOVF       FARG_correction_input+0, 0
	MOVWF      R0
	MOVF       FARG_correction_input+1, 0
	MOVWF      R1
;main.c,524 :: 		}
L_end_correction:
	RETURN
; end of _correction

_get_reverse:

;main.c,526 :: 		int get_reverse(void){
;main.c,529 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,530 :: 		Delay_us(100);
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
;main.c,531 :: 		v = ADC_Get_Sample(REV_input);
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,532 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse340
	MOVLW      255
	XORWF      R0, 0
L__get_reverse340:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse132
;main.c,533 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,534 :: 		Delay_us(100);
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
;main.c,535 :: 		v = ADC_Get_Sample(REV_input) * 2;
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
	LSLF       get_reverse_v_L0+0, 1
	RLF        get_reverse_v_L0+1, 1
;main.c,536 :: 		}
L_get_reverse132:
;main.c,537 :: 		if(v==2046){
	MOVF       get_reverse_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse341
	MOVLW      254
	XORWF      get_reverse_v_L0+0, 0
L__get_reverse341:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse134
;main.c,538 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_VREFH);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,539 :: 		Delay_us(100);
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
;main.c,540 :: 		v = ADC_Get_Sample(REV_input);
	MOVLW      10
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R1, 0
	MOVWF      get_reverse_v_L0+1
;main.c,541 :: 		if(v==1023) Overflow = 1;
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_reverse342
	MOVLW      255
	XORWF      R0, 0
L__get_reverse342:
	BTFSS      STATUS+0, 2
	GOTO       L_get_reverse136
	BSF        _Overflow+0, BitPos(_Overflow+0)
L_get_reverse136:
;main.c,542 :: 		get_batt();
	CALL       _get_batt+0
;main.c,543 :: 		d = (long)v * (long)Voltage;
	MOVF       get_reverse_v_L0+0, 0
	MOVWF      R4
	MOVF       get_reverse_v_L0+1, 0
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	MOVF       _Voltage+0, 0
	MOVWF      R0
	MOVF       _Voltage+1, 0
	MOVWF      R1
	MOVLW      0
	BTFSC      R1, 7
	MOVLW      255
	MOVWF      R2
	MOVWF      R3
	CALL       _Mul_32x32_U+0
;main.c,544 :: 		d = d / 1024;
	MOVLW      10
	MOVWF      R8
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	MOVF       R8, 0
L__get_reverse343:
	BTFSC      STATUS+0, 2
	GOTO       L__get_reverse344
	LSRF       R7, 1
	RRF        R6, 1
	RRF        R5, 1
	RRF        R4, 1
	ADDLW      255
	GOTO       L__get_reverse343
L__get_reverse344:
;main.c,545 :: 		v = (int)d;
	MOVF       R4, 0
	MOVWF      get_reverse_v_L0+0
	MOVF       R5, 0
	MOVWF      get_reverse_v_L0+1
;main.c,546 :: 		}
L_get_reverse134:
;main.c,547 :: 		return v;
	MOVF       get_reverse_v_L0+0, 0
	MOVWF      R0
	MOVF       get_reverse_v_L0+1, 0
	MOVWF      R1
;main.c,548 :: 		}
L_end_get_reverse:
	RETURN
; end of _get_reverse

_get_forward:

;main.c,550 :: 		int get_forward(void){
;main.c,553 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,554 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_forward137:
	DECFSZ     R13, 1
	GOTO       L_get_forward137
	DECFSZ     R12, 1
	GOTO       L_get_forward137
	NOP
;main.c,555 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,556 :: 		if(v==1023){
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward346
	MOVLW      255
	XORWF      R0, 0
L__get_forward346:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward138
;main.c,557 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH2);
	MOVLW      131
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,558 :: 		Delay_us(100);
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
;main.c,559 :: 		v = ADC_Get_Sample(FWD_input) * 2;
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
	LSLF       get_forward_v_L0+0, 1
	RLF        get_forward_v_L0+1, 1
;main.c,560 :: 		}
L_get_forward138:
;main.c,561 :: 		if(v==2046){
	MOVF       get_forward_v_L0+1, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward347
	MOVLW      254
	XORWF      get_forward_v_L0+0, 0
L__get_forward347:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward140
;main.c,562 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_VREFH);
	CLRF       FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,563 :: 		Delay_us(100);
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
;main.c,564 :: 		v = ADC_Get_Sample(FWD_input);
	MOVLW      8
	MOVWF      FARG_ADC_Get_Sample_channel+0
	CALL       _ADC_Get_Sample+0
	MOVF       R0, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R1, 0
	MOVWF      get_forward_v_L0+1
;main.c,565 :: 		if(v==1023) Overflow = 1;
	MOVF       R1, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_forward348
	MOVLW      255
	XORWF      R0, 0
L__get_forward348:
	BTFSS      STATUS+0, 2
	GOTO       L_get_forward142
	BSF        _Overflow+0, BitPos(_Overflow+0)
L_get_forward142:
;main.c,566 :: 		get_batt();
	CALL       _get_batt+0
;main.c,567 :: 		d = (long)v * (long)Voltage;
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R4
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R5
	CLRF       R6
	CLRF       R7
	MOVF       _Voltage+0, 0
	MOVWF      R0
	MOVF       _Voltage+1, 0
	MOVWF      R1
	MOVLW      0
	BTFSC      R1, 7
	MOVLW      255
	MOVWF      R2
	MOVWF      R3
	CALL       _Mul_32x32_U+0
;main.c,568 :: 		d = d / 1024;
	MOVLW      10
	MOVWF      R8
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	MOVF       R8, 0
L__get_forward349:
	BTFSC      STATUS+0, 2
	GOTO       L__get_forward350
	LSRF       R7, 1
	RRF        R6, 1
	RRF        R5, 1
	RRF        R4, 1
	ADDLW      255
	GOTO       L__get_forward349
L__get_forward350:
;main.c,569 :: 		v = (int)d;
	MOVF       R4, 0
	MOVWF      get_forward_v_L0+0
	MOVF       R5, 0
	MOVWF      get_forward_v_L0+1
;main.c,570 :: 		}
L_get_forward140:
;main.c,571 :: 		return v;
	MOVF       get_forward_v_L0+0, 0
	MOVWF      R0
	MOVF       get_forward_v_L0+1, 0
	MOVWF      R1
;main.c,572 :: 		}
L_end_get_forward:
	RETURN
; end of _get_forward

_get_pwr:

;main.c,575 :: 		void get_pwr(){
;main.c,579 :: 		Forward = get_forward();
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
;main.c,580 :: 		Reverse = get_reverse();
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
;main.c,582 :: 		p = correction(Forward);
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      FARG_correction_input+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      FARG_correction_input+1
	CALL       _correction+0
	CALL       _int2double+0
;main.c,583 :: 		P = p * 5 / 1000;
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
;main.c,584 :: 		p = p / 1.414;
	MOVLW      244
	MOVWF      R4
	MOVLW      253
	MOVWF      R5
	MOVLW      52
	MOVWF      R6
	MOVLW      127
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,585 :: 		p = p * p;
	MOVF       R0, 0
	MOVWF      R4
	MOVF       R1, 0
	MOVWF      R5
	MOVF       R2, 0
	MOVWF      R6
	MOVF       R3, 0
	MOVWF      R7
	CALL       _Mul_32x32_FP+0
;main.c,586 :: 		p = p / 5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      32
	MOVWF      R6
	MOVLW      129
	MOVWF      R7
	CALL       _Div_32x32_FP+0
;main.c,587 :: 		p += 0.5;
	MOVLW      0
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVLW      0
	MOVWF      R6
	MOVLW      126
	MOVWF      R7
	CALL       _Add_32x32_FP+0
;main.c,588 :: 		PWR = p;
	CALL       _double2int+0
	MOVF       R0, 0
	MOVWF      _PWR+0
	MOVF       R1, 0
	MOVWF      _PWR+1
;main.c,590 :: 		if(PWR>0){
	MOVLW      128
	MOVWF      R2
	MOVLW      128
	XORWF      R1, 0
	SUBWF      R2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr352
	MOVF       R0, 0
	SUBLW      0
L__get_pwr352:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr143
;main.c,591 :: 		if(OLED_PWD){
	BTFSS      LATA4_bit+0, BitPos(LATA4_bit+0)
	GOTO       L_get_pwr144
;main.c,592 :: 		disp_cnt = Tick + Disp_time*1000;
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
;main.c,593 :: 		off_cnt = Tick + Off_time*1000;
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
;main.c,594 :: 		}
	GOTO       L_get_pwr145
L_get_pwr144:
;main.c,595 :: 		else oled_start();
	CALL       _oled_start+0
L_get_pwr145:
;main.c,596 :: 		}
L_get_pwr143:
;main.c,598 :: 		if(Reverse >= Forward)
	MOVLW      128
	XORWF      get_pwr_Reverse_L0+3, 0
	MOVWF      R0
	MOVLW      128
	XORWF      get_pwr_Forward_L0+3, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr353
	MOVF       get_pwr_Forward_L0+2, 0
	SUBWF      get_pwr_Reverse_L0+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr353
	MOVF       get_pwr_Forward_L0+1, 0
	SUBWF      get_pwr_Reverse_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr353
	MOVF       get_pwr_Forward_L0+0, 0
	SUBWF      get_pwr_Reverse_L0+0, 0
L__get_pwr353:
	BTFSS      STATUS+0, 0
	GOTO       L_get_pwr146
;main.c,599 :: 		Forward = 999;
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
	GOTO       L_get_pwr147
L_get_pwr146:
;main.c,601 :: 		Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
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
;main.c,602 :: 		if(Forward>999) Forward = 999;
	MOVLW      128
	MOVWF      R4
	MOVLW      128
	XORWF      R3, 0
	SUBWF      R4, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr354
	MOVF       R2, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr354
	MOVF       R1, 0
	SUBLW      3
	BTFSS      STATUS+0, 2
	GOTO       L__get_pwr354
	MOVF       R0, 0
	SUBLW      231
L__get_pwr354:
	BTFSC      STATUS+0, 0
	GOTO       L_get_pwr148
	MOVLW      231
	MOVWF      get_pwr_Forward_L0+0
	MOVLW      3
	MOVWF      get_pwr_Forward_L0+1
	CLRF       get_pwr_Forward_L0+2
	CLRF       get_pwr_Forward_L0+3
L_get_pwr148:
;main.c,603 :: 		}
L_get_pwr147:
;main.c,605 :: 		SWR = Forward;
	MOVF       get_pwr_Forward_L0+0, 0
	MOVWF      _SWR+0
	MOVF       get_pwr_Forward_L0+1, 0
	MOVWF      _SWR+1
;main.c,606 :: 		return;
;main.c,607 :: 		}
L_end_get_pwr:
	RETURN
; end of _get_pwr

_get_swr:

;main.c,609 :: 		void get_swr(){
;main.c,610 :: 		unsigned int tune_cnt = 300;
	MOVLW      44
	MOVWF      get_swr_tune_cnt_L0+0
	MOVLW      1
	MOVWF      get_swr_tune_cnt_L0+1
	CLRF       get_swr_PWR_max_L0+0
	CLRF       get_swr_PWR_max_L0+1
;main.c,612 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,613 :: 		while(PWR<min_for_start || PWR>max_for_start){   // waiting for good power
L_get_swr149:
	MOVLW      128
	XORWF      _PWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _min_for_start+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr356
	MOVF       _min_for_start+0, 0
	SUBWF      _PWR+0, 0
L__get_swr356:
	BTFSS      STATUS+0, 0
	GOTO       L__get_swr239
	MOVLW      128
	XORWF      _max_for_start+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _PWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr357
	MOVF       _PWR+0, 0
	SUBWF      _max_for_start+0, 0
L__get_swr357:
	BTFSS      STATUS+0, 0
	GOTO       L__get_swr239
	GOTO       L_get_swr150
L__get_swr239:
;main.c,614 :: 		if(B_short){
	BTFSS      _B_short+0, BitPos(_B_short+0)
	GOTO       L_get_swr153
;main.c,615 :: 		Btn_short();
	CALL       _Btn_short+0
;main.c,616 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,617 :: 		break;
	GOTO       L_get_swr150
;main.c,618 :: 		}
L_get_swr153:
;main.c,619 :: 		if(B_xlong){
	BTFSS      _B_xlong+0, BitPos(_B_xlong+0)
	GOTO       L_get_swr154
;main.c,621 :: 		SWR = 0;
	CLRF       _SWR+0
	CLRF       _SWR+1
;main.c,622 :: 		break;
	GOTO       L_get_swr150
;main.c,623 :: 		}
L_get_swr154:
;main.c,625 :: 		get_pwr();
	CALL       _get_pwr+0
;main.c,626 :: 		if(tune_cnt>0){
	MOVF       get_swr_tune_cnt_L0+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr358
	MOVF       get_swr_tune_cnt_L0+0, 0
	SUBLW      0
L__get_swr358:
	BTFSC      STATUS+0, 0
	GOTO       L_get_swr155
;main.c,627 :: 		tune_cnt --;
	MOVLW      1
	SUBWF      get_swr_tune_cnt_L0+0, 1
	MOVLW      0
	SUBWFB     get_swr_tune_cnt_L0+1, 1
;main.c,628 :: 		if(PWR>PWR_max)
	MOVF       _PWR+1, 0
	SUBWF      get_swr_PWR_max_L0+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__get_swr359
	MOVF       _PWR+0, 0
	SUBWF      get_swr_PWR_max_L0+0, 0
L__get_swr359:
	BTFSC      STATUS+0, 0
	GOTO       L_get_swr156
;main.c,629 :: 		PWR_max = PWR;
	MOVF       _PWR+0, 0
	MOVWF      get_swr_PWR_max_L0+0
	MOVF       _PWR+1, 0
	MOVWF      get_swr_PWR_max_L0+1
L_get_swr156:
;main.c,630 :: 		}
	GOTO       L_get_swr157
L_get_swr155:
;main.c,632 :: 		draw_power(PWR_max);
	MOVF       get_swr_PWR_max_L0+0, 0
	MOVWF      FARG_draw_power_p+0
	MOVF       get_swr_PWR_max_L0+1, 0
	MOVWF      FARG_draw_power_p+1
	CALL       _draw_power+0
;main.c,633 :: 		PWR_max = 0;
	CLRF       get_swr_PWR_max_L0+0
	CLRF       get_swr_PWR_max_L0+1
;main.c,634 :: 		tune_cnt = 300;
	MOVLW      44
	MOVWF      get_swr_tune_cnt_L0+0
	MOVLW      1
	MOVWF      get_swr_tune_cnt_L0+1
;main.c,635 :: 		Delay_ms(1);
	MOVLW      11
	MOVWF      R12
	MOVLW      98
	MOVWF      R13
L_get_swr158:
	DECFSZ     R13, 1
	GOTO       L_get_swr158
	DECFSZ     R12, 1
	GOTO       L_get_swr158
	NOP
;main.c,636 :: 		}
L_get_swr157:
;main.c,637 :: 		}
	GOTO       L_get_swr149
L_get_swr150:
;main.c,639 :: 		return;
;main.c,640 :: 		}
L_end_get_swr:
	RETURN
; end of _get_swr

_get_batt:

;main.c,642 :: 		void get_batt(void){
;main.c,643 :: 		ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
	MOVLW      67
	MOVWF      FARG_ADC_Init_Advanced_reference+0
	CALL       _ADC_Init_Advanced+0
;main.c,644 :: 		Delay_us(100);
	MOVLW      2
	MOVWF      R12
	MOVLW      8
	MOVWF      R13
L_get_batt159:
	DECFSZ     R13, 1
	GOTO       L_get_batt159
	DECFSZ     R12, 1
	GOTO       L_get_batt159
	NOP
;main.c,645 :: 		Voltage = ADC_Get_Sample(Battery_input) * 11;
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
;main.c,646 :: 		return;
;main.c,647 :: 		}
L_end_get_batt:
	RETURN
; end of _get_batt

_coarse_cap:

;main.c,649 :: 		void coarse_cap() {
;main.c,650 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_cap_step_L0+0
;main.c,654 :: 		cap = 0;
	CLRF       _cap+0
;main.c,655 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	CLRF       FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,656 :: 		get_swr();
	CALL       _get_swr+0
;main.c,657 :: 		min_swr = SWR + SWR/20;
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
;main.c,658 :: 		for(count=step; count<=31;) {
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      coarse_cap_count_L0+0
L_coarse_cap160:
	MOVF       coarse_cap_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_cap161
;main.c,659 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,660 :: 		get_swr();
	CALL       _get_swr+0
;main.c,661 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap362
	MOVF       coarse_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_cap362:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap163
;main.c,662 :: 		min_swr = SWR + SWR/20;
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
;main.c,663 :: 		cap = count;
	MOVF       coarse_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,664 :: 		step_cap = step;
	MOVF       coarse_cap_step_L0+0, 0
	MOVWF      _step_cap+0
;main.c,665 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_cap363
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_cap363:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_cap164
	GOTO       L_coarse_cap161
L_coarse_cap164:
;main.c,666 :: 		count += step;
	MOVF       coarse_cap_step_L0+0, 0
	ADDWF      coarse_cap_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_cap_count_L0+0
;main.c,667 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap165
	MOVLW      8
	MOVWF      coarse_cap_count_L0+0
	GOTO       L_coarse_cap166
L_coarse_cap165:
;main.c,668 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_cap_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_cap167
	MOVLW      16
	MOVWF      coarse_cap_count_L0+0
	MOVLW      4
	MOVWF      coarse_cap_step_L0+0
L_coarse_cap167:
L_coarse_cap166:
;main.c,669 :: 		}
	GOTO       L_coarse_cap168
L_coarse_cap163:
;main.c,670 :: 		else break;
	GOTO       L_coarse_cap161
L_coarse_cap168:
;main.c,671 :: 		}
	GOTO       L_coarse_cap160
L_coarse_cap161:
;main.c,672 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,673 :: 		return;
;main.c,674 :: 		}
L_end_coarse_cap:
	RETURN
; end of _coarse_cap

_coarse_tune:

;main.c,676 :: 		void coarse_tune() {
;main.c,677 :: 		char step = 3;
	MOVLW      3
	MOVWF      coarse_tune_step_L0+0
;main.c,682 :: 		mem_cap = 0;
	CLRF       coarse_tune_mem_cap_L0+0
;main.c,683 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,684 :: 		mem_step_cap = 3;
	MOVLW      3
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,685 :: 		min_swr = SWR + SWR/20;
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
;main.c,686 :: 		for(count=step; count<=31;) {
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      coarse_tune_count_L0+0
L_coarse_tune169:
	MOVF       coarse_tune_count_L0+0, 0
	SUBLW      31
	BTFSS      STATUS+0, 0
	GOTO       L_coarse_tune170
;main.c,687 :: 		Relay_set(count, cap, SW);
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,688 :: 		coarse_cap();
	CALL       _coarse_cap+0
;main.c,689 :: 		get_swr();
	CALL       _get_swr+0
;main.c,690 :: 		if(SWR < min_swr) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      coarse_tune_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune365
	MOVF       coarse_tune_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__coarse_tune365:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune172
;main.c,691 :: 		min_swr = SWR + SWR/20;
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
;main.c,692 :: 		ind = count;
	MOVF       coarse_tune_count_L0+0, 0
	MOVWF      _ind+0
;main.c,693 :: 		mem_cap = cap;
	MOVF       _cap+0, 0
	MOVWF      coarse_tune_mem_cap_L0+0
;main.c,694 :: 		step_ind = step;
	MOVF       coarse_tune_step_L0+0, 0
	MOVWF      _step_ind+0
;main.c,695 :: 		mem_step_cap = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      coarse_tune_mem_step_cap_L0+0
;main.c,696 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__coarse_tune366
	MOVLW      120
	SUBWF      _SWR+0, 0
L__coarse_tune366:
	BTFSC      STATUS+0, 0
	GOTO       L_coarse_tune173
	GOTO       L_coarse_tune170
L_coarse_tune173:
;main.c,697 :: 		count += step;
	MOVF       coarse_tune_step_L0+0, 0
	ADDWF      coarse_tune_count_L0+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      coarse_tune_count_L0+0
;main.c,698 :: 		if(count==9) count = 8;
	MOVF       R1, 0
	XORLW      9
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune174
	MOVLW      8
	MOVWF      coarse_tune_count_L0+0
	GOTO       L_coarse_tune175
L_coarse_tune174:
;main.c,699 :: 		else if(count==17) {count = 16; step = 4;}
	MOVF       coarse_tune_count_L0+0, 0
	XORLW      17
	BTFSS      STATUS+0, 2
	GOTO       L_coarse_tune176
	MOVLW      16
	MOVWF      coarse_tune_count_L0+0
	MOVLW      4
	MOVWF      coarse_tune_step_L0+0
L_coarse_tune176:
L_coarse_tune175:
;main.c,700 :: 		}
	GOTO       L_coarse_tune177
L_coarse_tune172:
;main.c,701 :: 		else break;
	GOTO       L_coarse_tune170
L_coarse_tune177:
;main.c,702 :: 		}
	GOTO       L_coarse_tune169
L_coarse_tune170:
;main.c,703 :: 		cap = mem_cap;
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      _cap+0
;main.c,704 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       coarse_tune_mem_cap_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,705 :: 		step_cap = mem_step_cap;
	MOVF       coarse_tune_mem_step_cap_L0+0, 0
	MOVWF      _step_cap+0
;main.c,706 :: 		Delay_ms(10);
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_coarse_tune178:
	DECFSZ     R13, 1
	GOTO       L_coarse_tune178
	DECFSZ     R12, 1
	GOTO       L_coarse_tune178
	NOP
;main.c,707 :: 		return;
;main.c,708 :: 		}
L_end_coarse_tune:
	RETURN
; end of _coarse_tune

_sharp_cap:

;main.c,710 :: 		void sharp_cap() {
;main.c,713 :: 		range = step_cap;
	MOVF       _step_cap+0, 0
	MOVWF      sharp_cap_range_L0+0
;main.c,715 :: 		max_range = cap + range;
	MOVF       _step_cap+0, 0
	ADDWF      _cap+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_cap_max_range_L0+0
;main.c,716 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap179
	MOVLW      31
	MOVWF      sharp_cap_max_range_L0+0
L_sharp_cap179:
;main.c,717 :: 		if(cap>range) min_range = cap - range; else min_range = 0;
	MOVF       _cap+0, 0
	SUBWF      sharp_cap_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap180
	MOVF       sharp_cap_range_L0+0, 0
	SUBWF      _cap+0, 0
	MOVWF      sharp_cap_min_range_L0+0
	GOTO       L_sharp_cap181
L_sharp_cap180:
	CLRF       sharp_cap_min_range_L0+0
L_sharp_cap181:
;main.c,718 :: 		cap = min_range;
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      _cap+0
;main.c,719 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,720 :: 		get_swr();
	CALL       _get_swr+0
;main.c,721 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap368
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap368:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap182
	GOTO       L_end_sharp_cap
L_sharp_cap182:
;main.c,722 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,723 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_min_range_L0+0, 0
	MOVWF      sharp_cap_count_L0+0
L_sharp_cap183:
	MOVF       sharp_cap_count_L0+0, 0
	SUBWF      sharp_cap_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap184
;main.c,724 :: 		Relay_set(ind, count, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,725 :: 		get_swr();
	CALL       _get_swr+0
;main.c,726 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap369
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_cap369:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_cap186
	GOTO       L_end_sharp_cap
L_sharp_cap186:
;main.c,727 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap370
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap370:
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
;main.c,728 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap371
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap371:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_cap189
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_cap190:
	DECFSZ     R13, 1
	GOTO       L_sharp_cap190
	DECFSZ     R12, 1
	GOTO       L_sharp_cap190
	NOP
	CALL       _get_swr+0
L_sharp_cap189:
;main.c,729 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_cap_min_swr_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap372
	MOVF       sharp_cap_min_swr_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_cap372:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap191
;main.c,730 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_cap_min_swr_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_cap_min_swr_L0+1
;main.c,731 :: 		cap = count;
	MOVF       sharp_cap_count_L0+0, 0
	MOVWF      _cap+0
;main.c,732 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_cap373
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_cap373:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_cap192
	GOTO       L_sharp_cap184
L_sharp_cap192:
;main.c,733 :: 		}
	GOTO       L_sharp_cap193
L_sharp_cap191:
;main.c,734 :: 		else break;
	GOTO       L_sharp_cap184
L_sharp_cap193:
;main.c,723 :: 		for(count=min_range+1; count<=max_range; count++)  {
	INCF       sharp_cap_count_L0+0, 1
;main.c,735 :: 		}
	GOTO       L_sharp_cap183
L_sharp_cap184:
;main.c,736 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,737 :: 		return;
;main.c,738 :: 		}
L_end_sharp_cap:
	RETURN
; end of _sharp_cap

_sharp_ind:

;main.c,740 :: 		void sharp_ind() {
;main.c,743 :: 		range = step_ind;
	MOVF       _step_ind+0, 0
	MOVWF      sharp_ind_range_L0+0
;main.c,745 :: 		max_range = ind + range;
	MOVF       _step_ind+0, 0
	ADDWF      _ind+0, 0
	MOVWF      R1
	MOVF       R1, 0
	MOVWF      sharp_ind_max_range_L0+0
;main.c,746 :: 		if(max_range>31) max_range = 31;
	MOVF       R1, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind194
	MOVLW      31
	MOVWF      sharp_ind_max_range_L0+0
L_sharp_ind194:
;main.c,747 :: 		if(ind>range) min_range = ind - range; else min_range = 0;
	MOVF       _ind+0, 0
	SUBWF      sharp_ind_range_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind195
	MOVF       sharp_ind_range_L0+0, 0
	SUBWF      _ind+0, 0
	MOVWF      sharp_ind_min_range_L0+0
	GOTO       L_sharp_ind196
L_sharp_ind195:
	CLRF       sharp_ind_min_range_L0+0
L_sharp_ind196:
;main.c,748 :: 		ind = min_range;
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      _ind+0
;main.c,749 :: 		Relay_set(ind, cap, SW);
	MOVF       sharp_ind_min_range_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,750 :: 		get_swr();
	CALL       _get_swr+0
;main.c,751 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind375
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind375:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind197
	GOTO       L_end_sharp_ind
L_sharp_ind197:
;main.c,752 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,753 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_min_range_L0+0, 0
	MOVWF      sharp_ind_count_L0+0
L_sharp_ind198:
	MOVF       sharp_ind_count_L0+0, 0
	SUBWF      sharp_ind_max_range_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind199
;main.c,754 :: 		Relay_set(count, cap, SW);
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,755 :: 		get_swr();
	CALL       _get_swr+0
;main.c,756 :: 		if(SWR==0) return;
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind376
	MOVLW      0
	XORWF      _SWR+0, 0
L__sharp_ind376:
	BTFSS      STATUS+0, 2
	GOTO       L_sharp_ind201
	GOTO       L_end_sharp_ind
L_sharp_ind201:
;main.c,757 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind377
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind377:
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
;main.c,758 :: 		if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind378
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind378:
	BTFSS      STATUS+0, 0
	GOTO       L_sharp_ind204
	MOVLW      104
	MOVWF      R12
	MOVLW      228
	MOVWF      R13
L_sharp_ind205:
	DECFSZ     R13, 1
	GOTO       L_sharp_ind205
	DECFSZ     R12, 1
	GOTO       L_sharp_ind205
	NOP
	CALL       _get_swr+0
L_sharp_ind204:
;main.c,759 :: 		if(SWR < min_SWR) {
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      sharp_ind_min_SWR_L0+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind379
	MOVF       sharp_ind_min_SWR_L0+0, 0
	SUBWF      _SWR+0, 0
L__sharp_ind379:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind206
;main.c,760 :: 		min_SWR = SWR;
	MOVF       _SWR+0, 0
	MOVWF      sharp_ind_min_SWR_L0+0
	MOVF       _SWR+1, 0
	MOVWF      sharp_ind_min_SWR_L0+1
;main.c,761 :: 		ind = count;
	MOVF       sharp_ind_count_L0+0, 0
	MOVWF      _ind+0
;main.c,762 :: 		if(SWR<120) break;
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__sharp_ind380
	MOVLW      120
	SUBWF      _SWR+0, 0
L__sharp_ind380:
	BTFSC      STATUS+0, 0
	GOTO       L_sharp_ind207
	GOTO       L_sharp_ind199
L_sharp_ind207:
;main.c,763 :: 		}
	GOTO       L_sharp_ind208
L_sharp_ind206:
;main.c,764 :: 		else break;
	GOTO       L_sharp_ind199
L_sharp_ind208:
;main.c,753 :: 		for(count=min_range+1; count<=max_range; count++) {
	INCF       sharp_ind_count_L0+0, 1
;main.c,765 :: 		}
	GOTO       L_sharp_ind198
L_sharp_ind199:
;main.c,766 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,767 :: 		return;
;main.c,768 :: 		}
L_end_sharp_ind:
	RETURN
; end of _sharp_ind

_tune:

;main.c,771 :: 		void tune() {
;main.c,773 :: 		asm CLRWDT;
	CLRWDT
;main.c,774 :: 		Key_out = 0;
	BCF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,775 :: 		Delay_ms(100);
	MOVLW      5
	MOVWF      R11
	MOVLW      15
	MOVWF      R12
	MOVLW      241
	MOVWF      R13
L_tune209:
	DECFSZ     R13, 1
	GOTO       L_tune209
	DECFSZ     R12, 1
	GOTO       L_tune209
	DECFSZ     R11, 1
	GOTO       L_tune209
;main.c,776 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune382
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune382:
	BTFSC      STATUS+0, 0
	GOTO       L_tune210
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune210:
;main.c,777 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,778 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune211:
	DECFSZ     R13, 1
	GOTO       L_tune211
	DECFSZ     R12, 1
	GOTO       L_tune211
	DECFSZ     R11, 1
	GOTO       L_tune211
;main.c,779 :: 		get_swr(); if(SWR<110) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune383
	MOVLW      110
	SUBWF      _SWR+0, 0
L__tune383:
	BTFSC      STATUS+0, 0
	GOTO       L_tune212
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune212:
;main.c,781 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,782 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune384
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune384:
	BTFSS      STATUS+0, 2
	GOTO       L_tune213
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune213:
;main.c,783 :: 		get_swr(); if(SWR<120) { Key_out = 1;  return; }
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
	GOTO       L_tune214
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune214:
;main.c,784 :: 		sharp_ind();  if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune386
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune386:
	BTFSS      STATUS+0, 2
	GOTO       L_tune215
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune215:
;main.c,785 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune387
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune387:
	BTFSC      STATUS+0, 0
	GOTO       L_tune216
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune216:
;main.c,786 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune388
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune388:
	BTFSS      STATUS+0, 2
	GOTO       L_tune217
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune217:
;main.c,787 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune389
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune389:
	BTFSC      STATUS+0, 0
	GOTO       L_tune218
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune218:
;main.c,789 :: 		if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) { Key_out = 1; return; }
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R1
	MOVLW      128
	SUBWF      R1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune390
	MOVLW      200
	SUBWF      _SWR+0, 0
L__tune390:
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
	GOTO       L__tune391
	MOVF       tune_swr_mem_L0+0, 0
	SUBWF      _SWR+0, 0
L__tune391:
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
	GOTO       L__tune392
	MOVF       R1, 0
	SUBLW      100
L__tune392:
	MOVLW      1
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0
	MOVF       R3, 0
	ANDWF      R0, 1
	BTFSC      STATUS+0, 2
	GOTO       L_tune219
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune219:
;main.c,790 :: 		swr_mem = SWR;
	MOVF       _SWR+0, 0
	MOVWF      tune_swr_mem_L0+0
	MOVF       _SWR+1, 0
	MOVWF      tune_swr_mem_L0+1
;main.c,791 :: 		ind_mem = ind;
	MOVF       _ind+0, 0
	MOVWF      tune_ind_mem_L0+0
	CLRF       tune_ind_mem_L0+1
;main.c,792 :: 		cap_mem = cap;
	MOVF       _cap+0, 0
	MOVWF      tune_cap_mem_L0+0
	CLRF       tune_cap_mem_L0+1
;main.c,794 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune220
	CLRF       _SW+0
	GOTO       L_tune221
L_tune220:
	MOVLW      1
	MOVWF      _SW+0
L_tune221:
;main.c,795 :: 		atu_reset();
	CALL       _atu_reset+0
;main.c,796 :: 		Relay_set(ind, cap, SW);
	MOVF       _ind+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       _cap+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,797 :: 		Delay_ms(50);
	MOVLW      3
	MOVWF      R11
	MOVLW      8
	MOVWF      R12
	MOVLW      119
	MOVWF      R13
L_tune222:
	DECFSZ     R13, 1
	GOTO       L_tune222
	DECFSZ     R12, 1
	GOTO       L_tune222
	DECFSZ     R11, 1
	GOTO       L_tune222
;main.c,798 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune393
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune393:
	BTFSC      STATUS+0, 0
	GOTO       L_tune223
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune223:
;main.c,800 :: 		coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _coarse_tune+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune394
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune394:
	BTFSS      STATUS+0, 2
	GOTO       L_tune224
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune224:
;main.c,801 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune395
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune395:
	BTFSC      STATUS+0, 0
	GOTO       L_tune225
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune225:
;main.c,802 :: 		sharp_ind(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_ind+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune396
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune396:
	BTFSS      STATUS+0, 2
	GOTO       L_tune226
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune226:
;main.c,803 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune397
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune397:
	BTFSC      STATUS+0, 0
	GOTO       L_tune227
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune227:
;main.c,804 :: 		sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
	CALL       _sharp_cap+0
	MOVLW      0
	XORWF      _SWR+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune398
	MOVLW      0
	XORWF      _SWR+0, 0
L__tune398:
	BTFSS      STATUS+0, 2
	GOTO       L_tune228
	CALL       _atu_reset+0
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune228:
;main.c,805 :: 		get_swr(); if(SWR<120) { Key_out = 1; return; }
	CALL       _get_swr+0
	MOVLW      128
	XORWF      _SWR+1, 0
	MOVWF      R0
	MOVLW      128
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune399
	MOVLW      120
	SUBWF      _SWR+0, 0
L__tune399:
	BTFSC      STATUS+0, 0
	GOTO       L_tune229
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
	GOTO       L_end_tune
L_tune229:
;main.c,807 :: 		if(SWR>swr_mem) {
	MOVLW      128
	XORWF      tune_swr_mem_L0+1, 0
	MOVWF      R0
	MOVLW      128
	XORWF      _SWR+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__tune400
	MOVF       _SWR+0, 0
	SUBWF      tune_swr_mem_L0+0, 0
L__tune400:
	BTFSC      STATUS+0, 0
	GOTO       L_tune230
;main.c,808 :: 		if(SW==1) SW = 0; else SW = 1;
	MOVF       _SW+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_tune231
	CLRF       _SW+0
	GOTO       L_tune232
L_tune231:
	MOVLW      1
	MOVWF      _SW+0
L_tune232:
;main.c,809 :: 		ind = ind_mem;
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      _ind+0
;main.c,810 :: 		cap = cap_mem;
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      _cap+0
;main.c,811 :: 		Relay_set(ind, cap, sw);
	MOVF       tune_ind_mem_L0+0, 0
	MOVWF      FARG_Relay_set_L+0
	MOVF       tune_cap_mem_L0+0, 0
	MOVWF      FARG_Relay_set_C+0
	MOVF       _SW+0, 0
	MOVWF      FARG_Relay_set_I+0
	CALL       _Relay_set+0
;main.c,812 :: 		}
L_tune230:
;main.c,814 :: 		asm CLRWDT;
	CLRWDT
;main.c,815 :: 		get_SWR();
	CALL       _get_swr+0
;main.c,816 :: 		Key_out = 1;
	BSF        LATD2_bit+0, BitPos(LATD2_bit+0)
;main.c,817 :: 		return;
;main.c,818 :: 		}
L_end_tune:
	RETURN
; end of _tune

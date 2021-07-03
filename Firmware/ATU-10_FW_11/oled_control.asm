
_oled_disp_on:

;oled_control.c,4 :: 		void oled_disp_on() {
;oled_control.c,5 :: 		send_command(0xAF); //  display ON
	MOVLW      175
	MOVWF      FARG_send_command+0
	CALL       _send_command+0
;oled_control.c,6 :: 		}
L_end_oled_disp_on:
	RETURN
; end of _oled_disp_on

_oled_disp_off:

;oled_control.c,8 :: 		void oled_disp_off() {
;oled_control.c,9 :: 		send_command(0xAE); // display OFF
	MOVLW      174
	MOVWF      FARG_send_command+0
	CALL       _send_command+0
;oled_control.c,10 :: 		}
L_end_oled_disp_off:
	RETURN
; end of _oled_disp_off

_oled_init:

;oled_control.c,12 :: 		void oled_init (void) {  // OLED init
;oled_control.c,13 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,14 :: 		Soft_I2C_Write(oled_addr);             // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,15 :: 		Soft_I2C_Write(0);              // 0 - continious mode, command; 64 - Co, data
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,16 :: 		Soft_I2C_Write (0xAE); // display OFF
	MOVLW      174
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,18 :: 		Soft_I2C_Write (0xD5); // clock division
	MOVLW      213
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,19 :: 		Soft_I2C_Write (0x80); // ratio
	MOVLW      128
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,21 :: 		Soft_I2C_Write (0xA8); //  multiplexer
	MOVLW      168
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,22 :: 		Soft_I2C_Write (63); //
	MOVLW      63
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,24 :: 		Soft_I2C_Write (0xD3); //  offset
	MOVLW      211
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,25 :: 		Soft_I2C_Write (shift_line); // 32 no offset for x64 !
	MOVF       oled_control_shift_line+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,27 :: 		Soft_I2C_Write (0x40); // set line, line = 0
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,29 :: 		Soft_I2C_Write (0x8D); //  charge pump
	MOVLW      141
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,30 :: 		Soft_I2C_Write (0x14); //  0x10 - external, 0x14 - internal
	MOVLW      20
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,32 :: 		Soft_I2C_Write (0x81); //  contrast
	MOVLW      129
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,33 :: 		Soft_I2C_Write (255); //   0-255
	MOVLW      255
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,35 :: 		Soft_I2C_Write (0xD9); //  pre-charge
	MOVLW      217
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,36 :: 		Soft_I2C_Write (0xF1); //  0x22 - external, 0xF1 - internal
	MOVLW      241
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,38 :: 		Soft_I2C_Write (0x20); //  memory addressing mode
	MOVLW      32
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,39 :: 		Soft_I2C_Write (0x02); //  page addressing mode   02
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,41 :: 		Soft_I2C_Write (0x21); // set column range
	MOVLW      33
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,42 :: 		Soft_I2C_Write (0);    // column start
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,43 :: 		Soft_I2C_Write (127);  // column stop
	MOVLW      127
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,45 :: 		Soft_I2C_Write (0x2E); //  stop scrolling
	MOVLW      46
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,47 :: 		if(inversion) {
	MOVF       oled_control_inversion+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_oled_init0
;oled_control.c,48 :: 		Soft_I2C_Write (0xA0); //  segment re-map, A0 - normal, A1 - remapped
	MOVLW      160
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,49 :: 		Soft_I2C_Write (0xC0); // scan direction, C0 - normal, C8 - remapped
	MOVLW      192
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,50 :: 		}
	GOTO       L_oled_init1
L_oled_init0:
;oled_control.c,52 :: 		Soft_I2C_Write (0xA1); //  segment re-map, A0 - normal, A1 - remapped
	MOVLW      161
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,53 :: 		Soft_I2C_Write (0xC8); // scan direction, C0 - normal, C8 - remapped
	MOVLW      200
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,54 :: 		}
L_oled_init1:
;oled_control.c,56 :: 		Soft_I2C_Write (0xDA); //  COM pins configure
	MOVLW      218
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,57 :: 		Soft_I2C_Write (0x02); // 02 for 32 12 for x64
	MOVLW      2
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,59 :: 		Soft_I2C_Write (0xDB); //  V-COM detect
	MOVLW      219
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,60 :: 		Soft_I2C_Write (0x40); //
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,62 :: 		Soft_I2C_Write (0xA4); //  display entire ON
	MOVLW      164
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,64 :: 		Soft_I2C_Write (0xA6); // 0xA6 - normal, 0xA7 - inverse
	MOVLW      166
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,66 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,68 :: 		oled_clear();
	CALL       _oled_clear+0
;oled_control.c,69 :: 		send_command (0xAF); //  display ON
	MOVLW      175
	MOVWF      FARG_send_command+0
	CALL       _send_command+0
;oled_control.c,70 :: 		return;
;oled_control.c,71 :: 		}
L_end_oled_init:
	RETURN
; end of _oled_init

_oled_clear:

;oled_control.c,73 :: 		void oled_clear(void){
;oled_control.c,76 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,77 :: 		Soft_I2C_Write(oled_addr);             // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,78 :: 		Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,80 :: 		for (r = 0; r <=7; r++) {
	CLRF       oled_clear_r_L0+0
L_oled_clear2:
	MOVF       oled_clear_r_L0+0, 0
	SUBLW      7
	BTFSS      STATUS+0, 0
	GOTO       L_oled_clear3
;oled_control.c,81 :: 		set_addressing (r, 0);    // clear all 8 pages
	MOVF       oled_clear_r_L0+0, 0
	MOVWF      FARG_set_addressing+0
	CLRF       FARG_set_addressing+0
	CALL       _set_addressing+0
;oled_control.c,82 :: 		for (i = 0; i < 128; i++, Soft_I2C_Write(0x00)); // clear one page pixels
	CLRF       oled_clear_i_L0+0
L_oled_clear5:
	MOVLW      128
	SUBWF      oled_clear_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_oled_clear6
	INCF       oled_clear_i_L0+0, 1
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
	GOTO       L_oled_clear5
L_oled_clear6:
;oled_control.c,80 :: 		for (r = 0; r <=7; r++) {
	INCF       oled_clear_r_L0+0, 1
;oled_control.c,83 :: 		}
	GOTO       L_oled_clear2
L_oled_clear3:
;oled_control.c,84 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,86 :: 		return;
;oled_control.c,87 :: 		}
L_end_oled_clear:
	RETURN
; end of _oled_clear

_send_command:

;oled_control.c,89 :: 		void send_command (char oled_command) {
;oled_control.c,90 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,91 :: 		Soft_I2C_Write(oled_addr);         // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,92 :: 		Soft_I2C_Write(128);              // 128 - command, 192 - data
	MOVLW      128
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,93 :: 		Soft_I2C_Write(oled_command);
	MOVF       FARG_send_command_oled_command+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,94 :: 		Soft_I2C_Stop();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,95 :: 		return;
;oled_control.c,96 :: 		}
L_end_send_command:
	RETURN
; end of _send_command

_set_addressing:

;oled_control.c,98 :: 		void set_addressing (char pagenum, char c_start) {
;oled_control.c,100 :: 		c = c_start + oled_shift;
	MOVF       oled_control_oled_shift+0, 0
	ADDWF      FARG_set_addressing_c_start+0, 0
	MOVWF      set_addressing_c_L0+0
;oled_control.c,101 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,102 :: 		Soft_I2C_Write(oled_addr);             // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,103 :: 		Soft_I2C_Write(0);              // 0 - continious mode, command; 64 - Co, data
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,104 :: 		Soft_I2C_Write(0xB0 + pagenum);  // set page number
	MOVF       FARG_set_addressing_pagenum+0, 0
	ADDLW      176
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,106 :: 		if (c <= 15) { a = c; b = 0; }
	MOVF       set_addressing_c_L0+0, 0
	SUBLW      15
	BTFSS      STATUS+0, 0
	GOTO       L_set_addressing8
	MOVF       set_addressing_c_L0+0, 0
	MOVWF      set_addressing_a_L0+0
	CLRF       set_addressing_b_L0+0
	GOTO       L_set_addressing9
L_set_addressing8:
;oled_control.c,107 :: 		else { b = c / 16; a = c - b * 16; }
	MOVF       set_addressing_c_L0+0, 0
	MOVWF      R2
	LSRF       R2, 1
	LSRF       R2, 1
	LSRF       R2, 1
	LSRF       R2, 1
	MOVF       R2, 0
	MOVWF      set_addressing_b_L0+0
	MOVF       R2, 0
	MOVWF      R0
	LSLF       R0, 1
	LSLF       R0, 1
	LSLF       R0, 1
	LSLF       R0, 1
	MOVF       R0, 0
	SUBWF      set_addressing_c_L0+0, 0
	MOVWF      set_addressing_a_L0+0
L_set_addressing9:
;oled_control.c,108 :: 		Soft_I2C_Write (a);        // set lower nibble of start address
	MOVF       set_addressing_a_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,109 :: 		Soft_I2C_Write (0x10 + b); // set higher nibble of start address
	MOVF       set_addressing_b_L0+0, 0
	ADDLW      16
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,111 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,112 :: 		Soft_I2C_Write(oled_addr);        // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,113 :: 		Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,114 :: 		return;
;oled_control.c,115 :: 		}
L_end_set_addressing:
	RETURN
; end of _set_addressing

_oled_wr_str_s:

;oled_control.c,117 :: 		void oled_wr_str_s(char page, char col, char str[], char len) {  //  128*64 OLED
;oled_control.c,119 :: 		set_addressing (page, col);
	MOVF       FARG_oled_wr_str_s_page+0, 0
	MOVWF      FARG_set_addressing_pagenum+0
	MOVF       FARG_oled_wr_str_s_col+0, 0
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,121 :: 		for (i = 0; i < len; i++) { // write string
	CLRF       oled_wr_str_s_i_L0+0
L_oled_wr_str_s10:
	MOVF       FARG_oled_wr_str_s_len+0, 0
	SUBWF      oled_wr_str_s_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_oled_wr_str_s11
;oled_control.c,122 :: 		g = str[i] - 32; // table shift
	MOVF       oled_wr_str_s_i_L0+0, 0
	ADDWF      FARG_oled_wr_str_s_str+0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     FARG_oled_wr_str_s_str+1, 0
	MOVWF      FSR0H
	MOVLW      32
	SUBWF      INDF0+0, 0
	MOVWF      oled_wr_str_s_g_L0+0
;oled_control.c,123 :: 		for (h = 0; h < 5; h++) {  // write letter
	CLRF       oled_wr_str_s_h_L0+0
L_oled_wr_str_s13:
	MOVLW      5
	SUBWF      oled_wr_str_s_h_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_oled_wr_str_s14
;oled_control.c,124 :: 		Soft_I2C_Write(font_5x8[g*5+h]);
	MOVF       oled_wr_str_s_g_L0+0, 0
	MOVWF      R0
	MOVLW      5
	MOVWF      R4
	CALL       _Mul_8X8_U+0
	MOVF       oled_wr_str_s_h_L0+0, 0
	ADDWF      R0, 1
	MOVLW      0
	ADDWFC     R1, 1
	MOVLW      oled_control_font_5x8+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(oled_control_font_5x8+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,123 :: 		for (h = 0; h < 5; h++) {  // write letter
	INCF       oled_wr_str_s_h_L0+0, 1
;oled_control.c,125 :: 		}
	GOTO       L_oled_wr_str_s13
L_oled_wr_str_s14:
;oled_control.c,126 :: 		Soft_I2C_Write (0);
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,121 :: 		for (i = 0; i < len; i++) { // write string
	INCF       oled_wr_str_s_i_L0+0, 1
;oled_control.c,127 :: 		}
	GOTO       L_oled_wr_str_s10
L_oled_wr_str_s11:
;oled_control.c,128 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,129 :: 		return;
;oled_control.c,130 :: 		}
L_end_oled_wr_str_s:
	RETURN
; end of _oled_wr_str_s

_oled_wr_str:

;oled_control.c,133 :: 		void oled_wr_str (char page, char col, char str[], char leng ) {  //
;oled_control.c,135 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,136 :: 		Soft_I2C_Write(oled_addr);       // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,137 :: 		Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,139 :: 		set_addressing (page, col);
	MOVF       FARG_oled_wr_str_page+0, 0
	MOVWF      FARG_set_addressing_pagenum+0
	MOVF       FARG_oled_wr_str_col+0, 0
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,141 :: 		for (i = 0; i < leng; i++) { // write string
	CLRF       oled_wr_str_i_L0+0
L_oled_wr_str16:
	MOVF       FARG_oled_wr_str_leng+0, 0
	SUBWF      oled_wr_str_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_oled_wr_str17
;oled_control.c,142 :: 		if (str[i] == 0) g = 0; else g = str[i] - 32; // NULL detection
	MOVF       oled_wr_str_i_L0+0, 0
	ADDWF      FARG_oled_wr_str_str+0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     FARG_oled_wr_str_str+1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_oled_wr_str19
	CLRF       oled_wr_str_g_L0+0
	GOTO       L_oled_wr_str20
L_oled_wr_str19:
	MOVF       oled_wr_str_i_L0+0, 0
	ADDWF      FARG_oled_wr_str_str+0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     FARG_oled_wr_str_str+1, 0
	MOVWF      FSR0H
	MOVLW      32
	SUBWF      INDF0+0, 0
	MOVWF      oled_wr_str_g_L0+0
L_oled_wr_str20:
;oled_control.c,143 :: 		for (h = 0; h <= 4; h++) {  // write letter
	CLRF       oled_wr_str_h_L0+0
L_oled_wr_str21:
	MOVF       oled_wr_str_h_L0+0, 0
	SUBLW      4
	BTFSS      STATUS+0, 0
	GOTO       L_oled_wr_str22
;oled_control.c,144 :: 		w1 = font_5x8[g*5+h];
	MOVF       oled_wr_str_g_L0+0, 0
	MOVWF      R0
	MOVLW      5
	MOVWF      R4
	CALL       _Mul_8X8_U+0
	MOVF       oled_wr_str_h_L0+0, 0
	ADDWF      R0, 1
	MOVLW      0
	ADDWFC     R1, 1
	MOVLW      oled_control_font_5x8+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(oled_control_font_5x8+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      oled_wr_str_w1_L0+0
;oled_control.c,145 :: 		if(page != 2) {
	MOVF       FARG_oled_wr_str_page+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_oled_wr_str24
;oled_control.c,146 :: 		w2.B7 = w1.B3;
	BTFSC      oled_wr_str_w1_L0+0, 3
	GOTO       L__oled_wr_str68
	BCF        oled_wr_str_w2_L0+0, 7
	GOTO       L__oled_wr_str69
L__oled_wr_str68:
	BSF        oled_wr_str_w2_L0+0, 7
L__oled_wr_str69:
;oled_control.c,147 :: 		w2.B6 = w1.B3;
	BTFSC      oled_wr_str_w1_L0+0, 3
	GOTO       L__oled_wr_str70
	BCF        oled_wr_str_w2_L0+0, 6
	GOTO       L__oled_wr_str71
L__oled_wr_str70:
	BSF        oled_wr_str_w2_L0+0, 6
L__oled_wr_str71:
;oled_control.c,148 :: 		w2.B5 = w1.B2;
	BTFSC      oled_wr_str_w1_L0+0, 2
	GOTO       L__oled_wr_str72
	BCF        oled_wr_str_w2_L0+0, 5
	GOTO       L__oled_wr_str73
L__oled_wr_str72:
	BSF        oled_wr_str_w2_L0+0, 5
L__oled_wr_str73:
;oled_control.c,149 :: 		w2.B4 = w1.B2;
	BTFSC      oled_wr_str_w1_L0+0, 2
	GOTO       L__oled_wr_str74
	BCF        oled_wr_str_w2_L0+0, 4
	GOTO       L__oled_wr_str75
L__oled_wr_str74:
	BSF        oled_wr_str_w2_L0+0, 4
L__oled_wr_str75:
;oled_control.c,150 :: 		w2.B3 = w1.B1;
	BTFSC      oled_wr_str_w1_L0+0, 1
	GOTO       L__oled_wr_str76
	BCF        oled_wr_str_w2_L0+0, 3
	GOTO       L__oled_wr_str77
L__oled_wr_str76:
	BSF        oled_wr_str_w2_L0+0, 3
L__oled_wr_str77:
;oled_control.c,151 :: 		w2.B2 = w1.B1;
	BTFSC      oled_wr_str_w1_L0+0, 1
	GOTO       L__oled_wr_str78
	BCF        oled_wr_str_w2_L0+0, 2
	GOTO       L__oled_wr_str79
L__oled_wr_str78:
	BSF        oled_wr_str_w2_L0+0, 2
L__oled_wr_str79:
;oled_control.c,152 :: 		w2.B1 = w1.B0;
	BTFSC      oled_wr_str_w1_L0+0, 0
	GOTO       L__oled_wr_str80
	BCF        oled_wr_str_w2_L0+0, 1
	GOTO       L__oled_wr_str81
L__oled_wr_str80:
	BSF        oled_wr_str_w2_L0+0, 1
L__oled_wr_str81:
;oled_control.c,153 :: 		w2.B0 = w1.B0; }
	BTFSC      oled_wr_str_w1_L0+0, 0
	GOTO       L__oled_wr_str82
	BCF        oled_wr_str_w2_L0+0, 0
	GOTO       L__oled_wr_str83
L__oled_wr_str82:
	BSF        oled_wr_str_w2_L0+0, 0
L__oled_wr_str83:
	GOTO       L_oled_wr_str25
L_oled_wr_str24:
;oled_control.c,155 :: 		w2.B7 = w1.B2;
	BTFSC      oled_wr_str_w1_L0+0, 2
	GOTO       L__oled_wr_str84
	BCF        oled_wr_str_w2_L0+0, 7
	GOTO       L__oled_wr_str85
L__oled_wr_str84:
	BSF        oled_wr_str_w2_L0+0, 7
L__oled_wr_str85:
;oled_control.c,156 :: 		w2.B6 = w1.B2;
	BTFSC      oled_wr_str_w1_L0+0, 2
	GOTO       L__oled_wr_str86
	BCF        oled_wr_str_w2_L0+0, 6
	GOTO       L__oled_wr_str87
L__oled_wr_str86:
	BSF        oled_wr_str_w2_L0+0, 6
L__oled_wr_str87:
;oled_control.c,157 :: 		w2.B5 = w1.B1;
	BTFSC      oled_wr_str_w1_L0+0, 1
	GOTO       L__oled_wr_str88
	BCF        oled_wr_str_w2_L0+0, 5
	GOTO       L__oled_wr_str89
L__oled_wr_str88:
	BSF        oled_wr_str_w2_L0+0, 5
L__oled_wr_str89:
;oled_control.c,158 :: 		w2.B4 = w1.B1;
	BTFSC      oled_wr_str_w1_L0+0, 1
	GOTO       L__oled_wr_str90
	BCF        oled_wr_str_w2_L0+0, 4
	GOTO       L__oled_wr_str91
L__oled_wr_str90:
	BSF        oled_wr_str_w2_L0+0, 4
L__oled_wr_str91:
;oled_control.c,159 :: 		w2.B3 = w1.B0;
	BTFSC      oled_wr_str_w1_L0+0, 0
	GOTO       L__oled_wr_str92
	BCF        oled_wr_str_w2_L0+0, 3
	GOTO       L__oled_wr_str93
L__oled_wr_str92:
	BSF        oled_wr_str_w2_L0+0, 3
L__oled_wr_str93:
;oled_control.c,160 :: 		w2.B2 = w1.B0;
	BTFSC      oled_wr_str_w1_L0+0, 0
	GOTO       L__oled_wr_str94
	BCF        oled_wr_str_w2_L0+0, 2
	GOTO       L__oled_wr_str95
L__oled_wr_str94:
	BSF        oled_wr_str_w2_L0+0, 2
L__oled_wr_str95:
;oled_control.c,161 :: 		w2.B1 = 0;
	BCF        oled_wr_str_w2_L0+0, 1
;oled_control.c,162 :: 		w2.B0 = 0;
	BCF        oled_wr_str_w2_L0+0, 0
;oled_control.c,163 :: 		}
L_oled_wr_str25:
;oled_control.c,164 :: 		Soft_I2C_Write(w2);
	MOVF       oled_wr_str_w2_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,165 :: 		Soft_I2C_Write(w2);
	MOVF       oled_wr_str_w2_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,143 :: 		for (h = 0; h <= 4; h++) {  // write letter
	INCF       oled_wr_str_h_L0+0, 1
;oled_control.c,166 :: 		}
	GOTO       L_oled_wr_str21
L_oled_wr_str22:
;oled_control.c,167 :: 		Soft_I2C_Write (0);
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,168 :: 		Soft_I2C_Write (0);
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,141 :: 		for (i = 0; i < leng; i++) { // write string
	INCF       oled_wr_str_i_L0+0, 1
;oled_control.c,169 :: 		}
	GOTO       L_oled_wr_str16
L_oled_wr_str17:
;oled_control.c,170 :: 		set_addressing (page+1, col);
	INCF       FARG_oled_wr_str_page+0, 0
	MOVWF      FARG_set_addressing_pagenum+0
	MOVF       FARG_oled_wr_str_col+0, 0
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,172 :: 		for (i = 0; i < leng; i++) { // write string
	CLRF       oled_wr_str_i_L0+0
L_oled_wr_str26:
	MOVF       FARG_oled_wr_str_leng+0, 0
	SUBWF      oled_wr_str_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_oled_wr_str27
;oled_control.c,173 :: 		if (str[i] == 0) g = 0; else g = str[i] - 32; // NULL detection
	MOVF       oled_wr_str_i_L0+0, 0
	ADDWF      FARG_oled_wr_str_str+0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     FARG_oled_wr_str_str+1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_oled_wr_str29
	CLRF       oled_wr_str_g_L0+0
	GOTO       L_oled_wr_str30
L_oled_wr_str29:
	MOVF       oled_wr_str_i_L0+0, 0
	ADDWF      FARG_oled_wr_str_str+0, 0
	MOVWF      FSR0L
	MOVLW      0
	ADDWFC     FARG_oled_wr_str_str+1, 0
	MOVWF      FSR0H
	MOVLW      32
	SUBWF      INDF0+0, 0
	MOVWF      oled_wr_str_g_L0+0
L_oled_wr_str30:
;oled_control.c,174 :: 		for (h = 0; h <= 4; h++) {  // write letter
	CLRF       oled_wr_str_h_L0+0
L_oled_wr_str31:
	MOVF       oled_wr_str_h_L0+0, 0
	SUBLW      4
	BTFSS      STATUS+0, 0
	GOTO       L_oled_wr_str32
;oled_control.c,175 :: 		w1 = font_5x8[g*5+h];
	MOVF       oled_wr_str_g_L0+0, 0
	MOVWF      R0
	MOVLW      5
	MOVWF      R4
	CALL       _Mul_8X8_U+0
	MOVF       oled_wr_str_h_L0+0, 0
	ADDWF      R0, 1
	MOVLW      0
	ADDWFC     R1, 1
	MOVLW      oled_control_font_5x8+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(oled_control_font_5x8+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      oled_wr_str_w1_L0+0
;oled_control.c,176 :: 		if(page != 2) {
	MOVF       FARG_oled_wr_str_page+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_oled_wr_str34
;oled_control.c,177 :: 		w2.B7 = w1.B7;
	BTFSC      oled_wr_str_w1_L0+0, 7
	GOTO       L__oled_wr_str96
	BCF        oled_wr_str_w2_L0+0, 7
	GOTO       L__oled_wr_str97
L__oled_wr_str96:
	BSF        oled_wr_str_w2_L0+0, 7
L__oled_wr_str97:
;oled_control.c,178 :: 		w2.B6 = w1.B7;
	BTFSC      oled_wr_str_w1_L0+0, 7
	GOTO       L__oled_wr_str98
	BCF        oled_wr_str_w2_L0+0, 6
	GOTO       L__oled_wr_str99
L__oled_wr_str98:
	BSF        oled_wr_str_w2_L0+0, 6
L__oled_wr_str99:
;oled_control.c,179 :: 		w2.B5 = w1.B6;
	BTFSC      oled_wr_str_w1_L0+0, 6
	GOTO       L__oled_wr_str100
	BCF        oled_wr_str_w2_L0+0, 5
	GOTO       L__oled_wr_str101
L__oled_wr_str100:
	BSF        oled_wr_str_w2_L0+0, 5
L__oled_wr_str101:
;oled_control.c,180 :: 		w2.B4 = w1.B6;
	BTFSC      oled_wr_str_w1_L0+0, 6
	GOTO       L__oled_wr_str102
	BCF        oled_wr_str_w2_L0+0, 4
	GOTO       L__oled_wr_str103
L__oled_wr_str102:
	BSF        oled_wr_str_w2_L0+0, 4
L__oled_wr_str103:
;oled_control.c,181 :: 		w2.B3 = w1.B5;
	BTFSC      oled_wr_str_w1_L0+0, 5
	GOTO       L__oled_wr_str104
	BCF        oled_wr_str_w2_L0+0, 3
	GOTO       L__oled_wr_str105
L__oled_wr_str104:
	BSF        oled_wr_str_w2_L0+0, 3
L__oled_wr_str105:
;oled_control.c,182 :: 		w2.B2 = w1.B5;
	BTFSC      oled_wr_str_w1_L0+0, 5
	GOTO       L__oled_wr_str106
	BCF        oled_wr_str_w2_L0+0, 2
	GOTO       L__oled_wr_str107
L__oled_wr_str106:
	BSF        oled_wr_str_w2_L0+0, 2
L__oled_wr_str107:
;oled_control.c,183 :: 		w2.B1 = w1.B4;
	BTFSC      oled_wr_str_w1_L0+0, 4
	GOTO       L__oled_wr_str108
	BCF        oled_wr_str_w2_L0+0, 1
	GOTO       L__oled_wr_str109
L__oled_wr_str108:
	BSF        oled_wr_str_w2_L0+0, 1
L__oled_wr_str109:
;oled_control.c,184 :: 		w2.B0 = w1.B4; }
	BTFSC      oled_wr_str_w1_L0+0, 4
	GOTO       L__oled_wr_str110
	BCF        oled_wr_str_w2_L0+0, 0
	GOTO       L__oled_wr_str111
L__oled_wr_str110:
	BSF        oled_wr_str_w2_L0+0, 0
L__oled_wr_str111:
	GOTO       L_oled_wr_str35
L_oled_wr_str34:
;oled_control.c,186 :: 		w2.B7 = w1.B6;
	BTFSC      oled_wr_str_w1_L0+0, 6
	GOTO       L__oled_wr_str112
	BCF        oled_wr_str_w2_L0+0, 7
	GOTO       L__oled_wr_str113
L__oled_wr_str112:
	BSF        oled_wr_str_w2_L0+0, 7
L__oled_wr_str113:
;oled_control.c,187 :: 		w2.B6 = w1.B6;
	BTFSC      oled_wr_str_w1_L0+0, 6
	GOTO       L__oled_wr_str114
	BCF        oled_wr_str_w2_L0+0, 6
	GOTO       L__oled_wr_str115
L__oled_wr_str114:
	BSF        oled_wr_str_w2_L0+0, 6
L__oled_wr_str115:
;oled_control.c,188 :: 		w2.B5 = w1.B5;
	BTFSC      oled_wr_str_w1_L0+0, 5
	GOTO       L__oled_wr_str116
	BCF        oled_wr_str_w2_L0+0, 5
	GOTO       L__oled_wr_str117
L__oled_wr_str116:
	BSF        oled_wr_str_w2_L0+0, 5
L__oled_wr_str117:
;oled_control.c,189 :: 		w2.B4 = w1.B5;
	BTFSC      oled_wr_str_w1_L0+0, 5
	GOTO       L__oled_wr_str118
	BCF        oled_wr_str_w2_L0+0, 4
	GOTO       L__oled_wr_str119
L__oled_wr_str118:
	BSF        oled_wr_str_w2_L0+0, 4
L__oled_wr_str119:
;oled_control.c,190 :: 		w2.B3 = w1.B4;
	BTFSC      oled_wr_str_w1_L0+0, 4
	GOTO       L__oled_wr_str120
	BCF        oled_wr_str_w2_L0+0, 3
	GOTO       L__oled_wr_str121
L__oled_wr_str120:
	BSF        oled_wr_str_w2_L0+0, 3
L__oled_wr_str121:
;oled_control.c,191 :: 		w2.B2 = w1.B4;
	BTFSC      oled_wr_str_w1_L0+0, 4
	GOTO       L__oled_wr_str122
	BCF        oled_wr_str_w2_L0+0, 2
	GOTO       L__oled_wr_str123
L__oled_wr_str122:
	BSF        oled_wr_str_w2_L0+0, 2
L__oled_wr_str123:
;oled_control.c,192 :: 		w2.B1 = w1.B3;
	BTFSC      oled_wr_str_w1_L0+0, 3
	GOTO       L__oled_wr_str124
	BCF        oled_wr_str_w2_L0+0, 1
	GOTO       L__oled_wr_str125
L__oled_wr_str124:
	BSF        oled_wr_str_w2_L0+0, 1
L__oled_wr_str125:
;oled_control.c,193 :: 		w2.B0 = w1.B3;
	BTFSC      oled_wr_str_w1_L0+0, 3
	GOTO       L__oled_wr_str126
	BCF        oled_wr_str_w2_L0+0, 0
	GOTO       L__oled_wr_str127
L__oled_wr_str126:
	BSF        oled_wr_str_w2_L0+0, 0
L__oled_wr_str127:
;oled_control.c,194 :: 		}
L_oled_wr_str35:
;oled_control.c,195 :: 		Soft_I2C_Write(w2);
	MOVF       oled_wr_str_w2_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,196 :: 		Soft_I2C_Write(w2);
	MOVF       oled_wr_str_w2_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,174 :: 		for (h = 0; h <= 4; h++) {  // write letter
	INCF       oled_wr_str_h_L0+0, 1
;oled_control.c,197 :: 		}
	GOTO       L_oled_wr_str31
L_oled_wr_str32:
;oled_control.c,198 :: 		Soft_I2C_Write (0);
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,199 :: 		Soft_I2C_Write (0);
	CLRF       FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,172 :: 		for (i = 0; i < leng; i++) { // write string
	INCF       oled_wr_str_i_L0+0, 1
;oled_control.c,200 :: 		}
	GOTO       L_oled_wr_str26
L_oled_wr_str27:
;oled_control.c,201 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,202 :: 		}
L_end_oled_wr_str:
	RETURN
; end of _oled_wr_str

_oled_bat:

;oled_control.c,205 :: 		void oled_bat () {
;oled_control.c,207 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,208 :: 		Soft_I2C_Write(oled_addr);       // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,209 :: 		Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,212 :: 		for(g=0; g<=3; g++) {     // batt drawing
	CLRF       oled_bat_g_L0+0
L_oled_bat36:
	MOVF       oled_bat_g_L0+0, 0
	SUBLW      3
	BTFSS      STATUS+0, 0
	GOTO       L_oled_bat37
;oled_control.c,213 :: 		set_addressing (g, 115);
	MOVF       oled_bat_g_L0+0, 0
	MOVWF      FARG_set_addressing_pagenum+0
	MOVLW      115
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,214 :: 		for(i=0; i<=10; i++) { Soft_I2C_Write(batt[g*11+i]); }
	CLRF       oled_bat_i_L0+0
L_oled_bat39:
	MOVF       oled_bat_i_L0+0, 0
	SUBLW      10
	BTFSS      STATUS+0, 0
	GOTO       L_oled_bat40
	MOVF       oled_bat_g_L0+0, 0
	MOVWF      R0
	MOVLW      11
	MOVWF      R4
	CALL       _Mul_8X8_U+0
	MOVF       oled_bat_i_L0+0, 0
	ADDWF      R0, 1
	MOVLW      0
	ADDWFC     R1, 1
	MOVLW      oled_control_batt+0
	ADDWF      R0, 0
	MOVWF      FSR0L
	MOVLW      hi_addr(oled_control_batt+0)
	ADDWFC     R1, 0
	MOVWF      FSR0H
	MOVF       INDF0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
	INCF       oled_bat_i_L0+0, 1
	GOTO       L_oled_bat39
L_oled_bat40:
;oled_control.c,212 :: 		for(g=0; g<=3; g++) {     // batt drawing
	INCF       oled_bat_g_L0+0, 1
;oled_control.c,215 :: 		}
	GOTO       L_oled_bat36
L_oled_bat37:
;oled_control.c,216 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,217 :: 		return;
;oled_control.c,218 :: 		}
L_end_oled_bat:
	RETURN
; end of _oled_bat

_oled_voltage:

;oled_control.c,221 :: 		void oled_voltage(int Voltage) {
;oled_control.c,223 :: 		Soft_I2C_Start();
	CALL       _Soft_I2C_Start+0
;oled_control.c,224 :: 		Soft_I2C_Write(oled_addr);       // device addres
	MOVF       oled_control_oled_addr+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,225 :: 		Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
	MOVLW      64
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,227 :: 		Voltage /= 10;
	MOVLW      10
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	MOVF       FARG_oled_voltage_Voltage+0, 0
	MOVWF      R0
	MOVF       FARG_oled_voltage_Voltage+1, 0
	MOVWF      R1
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	MOVWF      FARG_oled_voltage_Voltage+0
	MOVF       R1, 0
	MOVWF      FARG_oled_voltage_Voltage+1
;oled_control.c,228 :: 		if(Voltage < 300) Voltage = 300;
	MOVLW      128
	XORWF      R1, 0
	MOVWF      R2
	MOVLW      128
	XORLW      1
	SUBWF      R2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__oled_voltage130
	MOVLW      44
	SUBWF      R0, 0
L__oled_voltage130:
	BTFSC      STATUS+0, 0
	GOTO       L_oled_voltage42
	MOVLW      44
	MOVWF      FARG_oled_voltage_Voltage+0
	MOVLW      1
	MOVWF      FARG_oled_voltage_Voltage+1
	GOTO       L_oled_voltage43
L_oled_voltage42:
;oled_control.c,229 :: 		else if(Voltage > 420) Voltage = 420;
	MOVLW      128
	XORLW      1
	MOVWF      R0
	MOVLW      128
	XORWF      FARG_oled_voltage_Voltage+1, 0
	SUBWF      R0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__oled_voltage131
	MOVF       FARG_oled_voltage_Voltage+0, 0
	SUBLW      164
L__oled_voltage131:
	BTFSC      STATUS+0, 0
	GOTO       L_oled_voltage44
	MOVLW      164
	MOVWF      FARG_oled_voltage_Voltage+0
	MOVLW      1
	MOVWF      FARG_oled_voltage_Voltage+1
L_oled_voltage44:
L_oled_voltage43:
;oled_control.c,230 :: 		Voltage = Voltage - 300; // 0 - 120
	MOVLW      44
	SUBWF      FARG_oled_voltage_Voltage+0, 0
	MOVWF      R3
	MOVLW      1
	SUBWFB     FARG_oled_voltage_Voltage+1, 0
	MOVWF      R4
	MOVF       R3, 0
	MOVWF      FARG_oled_voltage_Voltage+0
	MOVF       R4, 0
	MOVWF      FARG_oled_voltage_Voltage+1
;oled_control.c,231 :: 		Voltage = Voltage * 32;
	MOVLW      5
	MOVWF      R2
	MOVF       R3, 0
	MOVWF      R0
	MOVF       R4, 0
	MOVWF      R1
	MOVF       R2, 0
L__oled_voltage132:
	BTFSC      STATUS+0, 2
	GOTO       L__oled_voltage133
	LSLF       R0, 1
	RLF        R1, 1
	ADDLW      255
	GOTO       L__oled_voltage132
L__oled_voltage133:
	MOVF       R0, 0
	MOVWF      FARG_oled_voltage_Voltage+0
	MOVF       R1, 0
	MOVWF      FARG_oled_voltage_Voltage+1
;oled_control.c,232 :: 		v = Voltage / 120;
	MOVLW      120
	MOVWF      R4
	MOVLW      0
	MOVWF      R5
	CALL       _Div_16x16_S+0
	MOVF       R0, 0
	MOVWF      oled_voltage_v_L0+0
;oled_control.c,235 :: 		if(v >= 25)      { u0 = v - 24; u1 = 8; u2 = 8; u3 = 8; }
	MOVLW      25
	SUBWF      R0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage45
	MOVLW      24
	SUBWF      oled_voltage_v_L0+0, 0
	MOVWF      oled_voltage_u0_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u1_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u2_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u3_L0+0
	GOTO       L_oled_voltage46
L_oled_voltage45:
;oled_control.c,236 :: 		else if(v >= 17) { u0 = 0; u1 = v - 16; u2 = 8; u3 = 8; }
	MOVLW      17
	SUBWF      oled_voltage_v_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage47
	CLRF       oled_voltage_u0_L0+0
	MOVLW      16
	SUBWF      oled_voltage_v_L0+0, 0
	MOVWF      oled_voltage_u1_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u2_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u3_L0+0
	GOTO       L_oled_voltage48
L_oled_voltage47:
;oled_control.c,237 :: 		else if(v >= 9 ) { u0 = 0; u1 = 0;  u2 = v - 8; u3 = 8; }
	MOVLW      9
	SUBWF      oled_voltage_v_L0+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage49
	CLRF       oled_voltage_u0_L0+0
	CLRF       oled_voltage_u1_L0+0
	MOVLW      8
	SUBWF      oled_voltage_v_L0+0, 0
	MOVWF      oled_voltage_u2_L0+0
	MOVLW      8
	MOVWF      oled_voltage_u3_L0+0
	GOTO       L_oled_voltage50
L_oled_voltage49:
;oled_control.c,238 :: 		else             { u0 = 0; u1 = 0; u2 = 0; u3 = v ; }
	CLRF       oled_voltage_u0_L0+0
	CLRF       oled_voltage_u1_L0+0
	CLRF       oled_voltage_u2_L0+0
	MOVF       oled_voltage_v_L0+0, 0
	MOVWF      oled_voltage_u3_L0+0
L_oled_voltage50:
L_oled_voltage48:
L_oled_voltage46:
;oled_control.c,240 :: 		m = 128;
	MOVLW      128
	MOVWF      oled_voltage_m_L0+0
;oled_control.c,241 :: 		m = 255 - (m >> (u0-1)) +1;
	MOVLW      1
	SUBWF      oled_voltage_u0_L0+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	SUBWFB     R1, 1
	MOVF       R0, 0
	MOVWF      R1
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      R0
	MOVF       R1, 0
L__oled_voltage134:
	BTFSC      STATUS+0, 2
	GOTO       L__oled_voltage135
	LSRF       R0, 1
	ADDLW      255
	GOTO       L__oled_voltage134
L__oled_voltage135:
	MOVF       R0, 0
	SUBLW      255
	MOVWF      oled_voltage_m_L0+0
	INCF       oled_voltage_m_L0+0, 1
;oled_control.c,242 :: 		m = m | 0b00000011;
	MOVLW      3
	IORWF       oled_voltage_m_L0+0, 1
;oled_control.c,243 :: 		set_addressing (0, 119);
	CLRF       FARG_set_addressing_pagenum+0
	MOVLW      119
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,244 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,245 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,246 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,247 :: 		m = m | 0b00011111;
	MOVLW      31
	IORWF       oled_voltage_m_L0+0, 1
;oled_control.c,248 :: 		set_addressing (0, 117);
	CLRF       FARG_set_addressing_pagenum+0
	MOVLW      117
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,249 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,250 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,251 :: 		set_addressing (0, 122);
	CLRF       FARG_set_addressing_pagenum+0
	MOVLW      122
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,252 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,253 :: 		Soft_I2C_Write(m);
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
;oled_control.c,255 :: 		m = 128;
	MOVLW      128
	MOVWF      oled_voltage_m_L0+0
;oled_control.c,256 :: 		m = 255 - (m >> (u1-1)) + 1;
	MOVLW      1
	SUBWF      oled_voltage_u1_L0+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	SUBWFB     R1, 1
	MOVF       R0, 0
	MOVWF      R1
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      R0
	MOVF       R1, 0
L__oled_voltage136:
	BTFSC      STATUS+0, 2
	GOTO       L__oled_voltage137
	LSRF       R0, 1
	ADDLW      255
	GOTO       L__oled_voltage136
L__oled_voltage137:
	MOVF       R0, 0
	SUBLW      255
	MOVWF      oled_voltage_m_L0+0
	INCF       oled_voltage_m_L0+0, 1
;oled_control.c,257 :: 		set_addressing (1, 117);
	MOVLW      1
	MOVWF      FARG_set_addressing_pagenum+0
	MOVLW      117
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,258 :: 		for(i=0; i<=6; i++) Soft_I2C_Write(m);
	CLRF       oled_voltage_i_L0+0
L_oled_voltage51:
	MOVF       oled_voltage_i_L0+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage52
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
	INCF       oled_voltage_i_L0+0, 1
	GOTO       L_oled_voltage51
L_oled_voltage52:
;oled_control.c,260 :: 		m = 128;
	MOVLW      128
	MOVWF      oled_voltage_m_L0+0
;oled_control.c,261 :: 		m = 255 - (m >> (u2-1)) + 1;
	MOVLW      1
	SUBWF      oled_voltage_u2_L0+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	SUBWFB     R1, 1
	MOVF       R0, 0
	MOVWF      R1
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      R0
	MOVF       R1, 0
L__oled_voltage138:
	BTFSC      STATUS+0, 2
	GOTO       L__oled_voltage139
	LSRF       R0, 1
	ADDLW      255
	GOTO       L__oled_voltage138
L__oled_voltage139:
	MOVF       R0, 0
	SUBLW      255
	MOVWF      oled_voltage_m_L0+0
	INCF       oled_voltage_m_L0+0, 1
;oled_control.c,262 :: 		set_addressing (2, 117);
	MOVLW      2
	MOVWF      FARG_set_addressing_pagenum+0
	MOVLW      117
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,263 :: 		for(i=0; i<=6; i++) Soft_I2C_Write(m);
	CLRF       oled_voltage_i_L0+0
L_oled_voltage54:
	MOVF       oled_voltage_i_L0+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage55
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
	INCF       oled_voltage_i_L0+0, 1
	GOTO       L_oled_voltage54
L_oled_voltage55:
;oled_control.c,265 :: 		m = 128;
	MOVLW      128
	MOVWF      oled_voltage_m_L0+0
;oled_control.c,266 :: 		m = 255 - (m >> (u3-1)) +1;
	MOVLW      1
	SUBWF      oled_voltage_u3_L0+0, 0
	MOVWF      R0
	CLRF       R1
	MOVLW      0
	SUBWFB     R1, 1
	MOVF       R0, 0
	MOVWF      R1
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      R0
	MOVF       R1, 0
L__oled_voltage140:
	BTFSC      STATUS+0, 2
	GOTO       L__oled_voltage141
	LSRF       R0, 1
	ADDLW      255
	GOTO       L__oled_voltage140
L__oled_voltage141:
	MOVF       R0, 0
	SUBLW      255
	MOVWF      oled_voltage_m_L0+0
	INCF       oled_voltage_m_L0+0, 1
;oled_control.c,267 :: 		m = m | 0b11000000;
	MOVLW      192
	IORWF       oled_voltage_m_L0+0, 1
;oled_control.c,268 :: 		set_addressing (3, 117);
	MOVLW      3
	MOVWF      FARG_set_addressing_pagenum+0
	MOVLW      117
	MOVWF      FARG_set_addressing_c_start+0
	CALL       _set_addressing+0
;oled_control.c,269 :: 		for(i=0; i<=6; i++) Soft_I2C_Write(m);
	CLRF       oled_voltage_i_L0+0
L_oled_voltage57:
	MOVF       oled_voltage_i_L0+0, 0
	SUBLW      6
	BTFSS      STATUS+0, 0
	GOTO       L_oled_voltage58
	MOVF       oled_voltage_m_L0+0, 0
	MOVWF      FARG_Soft_I2C_Write+0
	CALL       _Soft_I2C_Write+0
	INCF       oled_voltage_i_L0+0, 1
	GOTO       L_oled_voltage57
L_oled_voltage58:
;oled_control.c,271 :: 		Soft_I2C_Stop ();
	CALL       _Soft_I2C_Stop+0
;oled_control.c,272 :: 		return;
;oled_control.c,273 :: 		}
L_end_oled_voltage:
	RETURN
; end of _oled_voltage

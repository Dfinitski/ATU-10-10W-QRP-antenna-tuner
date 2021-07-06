#line 1 "D:/Projects/ATU-10/Firmware_1.2/main.c"
#line 1 "d:/projects/atu-10/firmware_1.2/pic_init.h"




sbit Red at LATB4_bit;
sbit Green at LATB3_bit;
sbit OLED_PWD at LATA4_bit;
sbit C_sw at LATE0_bit;
sbit L_010 at LATD7_bit;
sbit L_022 at LATD6_bit;
sbit L_045 at LATD5_bit;
sbit L_100 at LATD4_bit;
sbit L_220 at LATC7_bit;
sbit L_450 at LATC6_bit;
sbit L_1000 at LATC5_bit;
sbit C_22 at LATA5_bit;
sbit C_47 at LATE1_bit;
sbit C_100 at LATA7_bit;
sbit C_220 at LATA6_bit;
sbit C_470 at LATC0_bit;
sbit C_1000 at LATC1_bit;
sbit C_2200 at LATC2_bit;
sbit Rel_to_gnd at LATD3_bit;
sbit Rel_to_plus_N at LATC4_bit;
#line 1 "d:/projects/atu-10/firmware_1.2/main.h"

void pic_init(void);
void Btn_long(void);
void Btn_short(void);
void Btn_xlong(void);
void check_reset_flags(void);
void Voltage_show(void);
void Relay_set(char, char, char);
int get_reverse(void);
int get_forward(void);
void get_pwr(void);
void get_swr(void);
void get_batt(void);
void watch_swr(void);
void coarse_cap(void);
void coarse_tune(void);
void sharp_cap(void);
void sharp_ind(void);
void sub_tune(void);
void tune(void);
int correction(int);
void atu_reset(void);
void draw_swr(int);
void draw_power(int);
void oled_start(void);
void power_off(void);
void Greating(void);
void Ext_long(void);
#line 1 "d:/projects/atu-10/firmware_1.2/oled_control.h"
#line 1 "d:/projects/atu-10/firmware_1.2/font_5x8.h"
 static const code char font_5x8[] = {

0x00, 0x00, 0x00, 0x00, 0x00,
0x00, 0x00, 0x5F, 0x00, 0x00,
0x00, 0x07, 0x00, 0x07, 0x00,
0x14, 0x7F, 0x14, 0x7F, 0x14,
0x24, 0x2A, 0x7F, 0x2A, 0x12,
0x23, 0x13, 0x08, 0x64, 0x62,
0x36, 0x49, 0x55, 0x22, 0x50,
0x00, 0x05, 0x03, 0x00, 0x00,
0x00, 0x1C, 0x22, 0x41, 0x00,
0x00, 0x41, 0x22, 0x1C, 0x00,
0x08, 0x2A, 0x1C, 0x2A, 0x08,
0x08, 0x08, 0x3E, 0x08, 0x08,
0x00, 0x50, 0x30, 0x00, 0x00,
0x08, 0x08, 0x08, 0x08, 0x08,
0x00, 0x30, 0x30, 0x00, 0x00,
0x20, 0x10, 0x08, 0x04, 0x02,
0x3E, 0x51, 0x49, 0x45, 0x3E,
0x00, 0x42, 0x7F, 0x40, 0x00,
0x42, 0x61, 0x51, 0x49, 0x46,
0x21, 0x41, 0x45, 0x4B, 0x31,
0x18, 0x14, 0x12, 0x7F, 0x10,
0x27, 0x45, 0x45, 0x45, 0x39,
0x3C, 0x4A, 0x49, 0x49, 0x30,
0x01, 0x71, 0x09, 0x05, 0x03,
0x36, 0x49, 0x49, 0x49, 0x36,
0x06, 0x49, 0x49, 0x29, 0x1E,
0x00, 0x36, 0x36, 0x00, 0x00,
0x00, 0x56, 0x36, 0x00, 0x00,
0x00, 0x08, 0x14, 0x22, 0x41,
0x14, 0x14, 0x14, 0x14, 0x14,
0x41, 0x22, 0x14, 0x08, 0x00,
0x02, 0x01, 0x51, 0x09, 0x06,
0x32, 0x49, 0x79, 0x41, 0x3E,
0x7E, 0x11, 0x11, 0x11, 0x7E,
0x7F, 0x49, 0x49, 0x49, 0x36,
0x3E, 0x41, 0x41, 0x41, 0x22,
0x7F, 0x41, 0x41, 0x22, 0x1C,
0x7F, 0x49, 0x49, 0x49, 0x41,
0x7F, 0x09, 0x09, 0x01, 0x01,
0x3E, 0x41, 0x41, 0x51, 0x32,
0x7F, 0x08, 0x08, 0x08, 0x7F,
0x00, 0x41, 0x7F, 0x41, 0x00,
0x20, 0x40, 0x41, 0x3F, 0x01,
0x7F, 0x08, 0x14, 0x22, 0x41,
0x7F, 0x40, 0x40, 0x40, 0x40,
0x7F, 0x02, 0x04, 0x02, 0x7F,
0x7F, 0x04, 0x08, 0x10, 0x7F,
0x3E, 0x41, 0x41, 0x41, 0x3E,
0x7F, 0x09, 0x09, 0x09, 0x06,
0x3E, 0x41, 0x51, 0x21, 0x5E,
0x7F, 0x09, 0x19, 0x29, 0x46,
0x46, 0x49, 0x49, 0x49, 0x31,
0x01, 0x01, 0x7F, 0x01, 0x01,
0x3F, 0x40, 0x40, 0x40, 0x3F,
0x1F, 0x20, 0x40, 0x20, 0x1F,
0x7F, 0x20, 0x18, 0x20, 0x7F,
0x63, 0x14, 0x08, 0x14, 0x63,
0x03, 0x04, 0x78, 0x04, 0x03,
0x61, 0x51, 0x49, 0x45, 0x43,
0x00, 0x00, 0x7F, 0x41, 0x41,
0x02, 0x04, 0x08, 0x10, 0x20,
0x41, 0x41, 0x7F, 0x00, 0x00,
0x04, 0x02, 0x01, 0x02, 0x04,
0x40, 0x40, 0x40, 0x40, 0x40,
0x00, 0x01, 0x02, 0x04, 0x00,
0x20, 0x54, 0x54, 0x54, 0x78,
0x7F, 0x48, 0x44, 0x44, 0x38,
0x38, 0x44, 0x44, 0x44, 0x20,
0x38, 0x44, 0x44, 0x48, 0x7F,
0x38, 0x54, 0x54, 0x54, 0x18,
0x08, 0x7E, 0x09, 0x01, 0x02,
0x08, 0x14, 0x54, 0x54, 0x3C,
0x7F, 0x08, 0x04, 0x04, 0x78,
0x00, 0x44, 0x7D, 0x40, 0x00,
0x20, 0x40, 0x44, 0x3D, 0x00,
0x00, 0x7F, 0x10, 0x28, 0x44,
0x00, 0x41, 0x7F, 0x40, 0x00,
0x7C, 0x04, 0x18, 0x04, 0x78,
0x7C, 0x08, 0x04, 0x04, 0x78,
0x38, 0x44, 0x44, 0x44, 0x38,
0x7C, 0x14, 0x14, 0x14, 0x08,
0x08, 0x14, 0x14, 0x18, 0x7C,
0x7C, 0x08, 0x04, 0x04, 0x08,
0x48, 0x54, 0x54, 0x54, 0x20,
0x04, 0x3F, 0x44, 0x40, 0x20,
0x3C, 0x40, 0x40, 0x20, 0x7C,
0x1C, 0x20, 0x40, 0x20, 0x1C,
0x3C, 0x40, 0x30, 0x40, 0x3C,
0x44, 0x28, 0x10, 0x28, 0x44,
0x0C, 0x50, 0x50, 0x50, 0x3C,
0x44, 0x64, 0x54, 0x4C, 0x44,
0x00, 0x08, 0x36, 0x41, 0x00,
0x00, 0x00, 0x7F, 0x00, 0x00,
0x00, 0x41, 0x36, 0x08, 0x00,
0x08, 0x08, 0x2A, 0x1C, 0x08,
0x08, 0x1C, 0x2A, 0x08, 0x08
};
#line 3 "d:/projects/atu-10/firmware_1.2/oled_control.h"
static oled_addr = 0x78;
static char shift_line = 64;
static char oled_shift = 2;
static char inversion = 1;

void oled_init (void);
void oled_clear(void);
void send_command (char);
void set_addressing (char, char);
void oled_wr_str_s(char, char, char*, char);
void oled_wr_str(char, char, char*, char);
void oled_bat (void);
void oled_voltage (int);
void oled_clear (void);


static const char batt[] = {
 0B11111000,
 0B11111000,

 0B00011111,
 0B00011111,
 0B00000011,
 0B00000011,
 0B00000011,
 0B00011111,
 0B00011111,

 0B11111000,
 0B11111000,

 0B11111111,
 0B11111111,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B11111111,
 0B11111111,

 0B11111111,
 0B11111111,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B00000000,
 0B11111111,
 0B11111111,

 0B11111111,
 0B11111111,
 0B11000000,
 0B11000000,
 0B11000000,
 0B11000000,
 0B11000000,
 0B11000000,
 0B11000000,
 0B11111111,
 0B11111111
 };
#line 1 "d:/projects/atu-10/firmware_1.2/soft_i2c.h"

void Soft_I2C_Init(void);
void Soft_I2C_Start(void);
char Soft_I2C_Write(char);
char Soft_I2C_Read(void);
void Soft_I2C_ACK(void);
void Soft_I2C_NACK(void);
void Soft_I2C_Stop(void);
#line 12 "D:/Projects/ATU-10/Firmware_1.2/main.c"
char txt[8], txt_2[8];
unsigned long Tick = 0;
int Voltage, Voltage_old = 0;
char btn_1_cnt = 0, btn_2_cnt = 0;
unsigned long volt_cnt = 0, watch_cnt = 0, btn_cnt = 0, off_cnt, disp_cnt, tune_cnt;
int PWR, SWR, SWR_ind = 0, SWR_ind_old = 9999, SWR_fixed_old = 9999, PWR_fixed_old = 9999;
char ind = 0, cap = 0, SW = 0, step_cap = 0, step_ind = 0, L_linear = 0, C_linear = 0;
bit Overflow, B_short, B_long, B_xlong, gre, E_short, E_long;

int Rel_Del = 5, min_for_start = 10, max_for_start = 150;
int Auto_delta = 130;

unsigned long Disp_time = 300;
unsigned long Off_time = 1800;




void interupt() iv 0x0004 {

 if(TMR0IF_bit) {
 TMR0IF_bit = 0;
 Tick++;
 TMR0L = 0xC0;
 TMR0H = 0xE0;
 }

 if(Tick>=btn_cnt){
 btn_cnt += 10;

 if( ~ PORTB.B5  |  ~PORTD.B1 ){
 disp_cnt = Tick + Disp_time*1000;
 off_cnt = Tick + Off_time*1000;
 }

 if( ~ PORTB.B5 ){
 if(btn_1_cnt<250) btn_1_cnt++;
 if(btn_1_cnt==25) B_long = 1;
 if(btn_1_cnt==250 & OLED_PWD) B_xlong = 1;
 }
 else if(btn_1_cnt>2 & btn_1_cnt<25){
 B_short = 1;
 btn_1_cnt = 0;
 }
 else
 btn_1_cnt = 0;

 if( ~PORTD.B1 ){
 if(btn_2_cnt<25) btn_2_cnt++;
 if(btn_2_cnt==20 &  PORTD.B2 ) E_long = 1;
 }
 else if(btn_2_cnt>1 & btn_2_cnt<10){
 E_short = 1;
 btn_2_cnt = 0;
 }
 else
 btn_2_cnt = 0;
 }
 return;
}


void main() {
 pic_init();
 Red = 1;
  LATD2_bit  = 1;
 gre = 1;
 oled_start();

 ADC_Init();
 Overflow = 0;
 B_short = 0;
 B_long = 0;
 B_xlong = 0;
 E_short = 0;
 E_long = 0;

 disp_cnt = Tick + Disp_time*1000;
 off_cnt = Tick + Off_time*1000;




 while(1) {
 if(Tick>=volt_cnt){
 volt_cnt += 3000;
 Voltage_show();
 }

 if(Tick>=watch_cnt){
 watch_cnt += 300;
 watch_swr();
 }

 if(Tick>=disp_cnt){

 OLED_PWD = 0;
 }

 if(Tick>=off_cnt){
 power_off();
 }

 if(B_short){
 if(OLED_PWD) Btn_short();
 else oled_start();
 }
 if(B_long){
 if(OLED_PWD) Btn_long();
 else oled_start();
 }
 if(B_xlong){
 if(OLED_PWD) Btn_xlong();
 else oled_start();
 }

 if(E_short){
 if(OLED_PWD==0) oled_start();
 Btn_short();
 }
 if(E_long){
 if(OLED_PWD==0) { Ext_long(); oled_start(); }
 else Btn_long();
 }

 }
}


void oled_start(){
 OLED_PWD = 1;

 Delay_ms(200);
 Soft_I2C_init();
 Delay_ms(10);
 oled_init();

 if(gre){
 Greating();
 gre = 0;
 oled_clear();
 }
 oled_wr_str(0, 0, "PWR     W", 9);
 oled_bat();
 oled_wr_str(2, 0, "SWR      ", 9);
 oled_wr_str(0, 42, "=", 1);
 oled_wr_str(2, 42, "=", 1);
 Voltage_old = 9999;
 SWR_fixed_old = 9999;
 PWR_fixed_old = 9999;
 SWR_ind_old = 9999;
 SWR_ind = 0;
 volt_cnt = Tick;
 watch_cnt = Tick;
 B_short = 0; B_long = 0; B_xlong = 0;
 disp_cnt = Tick + Disp_time*1000;
 off_cnt = Tick + Off_time*1000;
 return;
}


void watch_swr(void){
 char peak_cnt, cnt;
 int delta = Auto_delta - 100;
 int PWR_fixed, SWR_fixed;

 Delay_ms(50);

 cnt = 600;
 PWR_fixed = 0;
 SWR_fixed = 999;
 for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
 get_pwr();
 if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
 Delay_ms(1);
 }

 if(PWR_fixed>0){
 if(OLED_PWD){
 disp_cnt = Tick + Disp_time*1000;
 off_cnt = Tick + Off_time*1000;
 }
 else oled_start();
 }

 if(PWR_fixed!=PWR_fixed_old){
 if(Overflow)
 oled_wr_str(0, 42, ">", 1);
 else
 oled_wr_str(0, 42, "=", 1);
 PWR_fixed_old = PWR_fixed;
 draw_power(PWR_fixed);
 }
 if(PWR_fixed<10)
 SWR_fixed = 0;

 if(Overflow){
 for(cnt=3; cnt!=0; cnt--){
 oled_wr_str(2, 6, "OVERLOAD ", 9);
 Delay_ms(500);
 oled_wr_str(2, 0, "         ", 9);
 Delay_ms(500);
 }
 oled_wr_str(2, 0, "SWR      ", 9);
 oled_wr_str(2, 42, "=", 1);
 draw_swr(SWR_fixed);
 Delay_ms(500);
 Overflow = 0;
 }
 else if(PWR_fixed>10){
 if(PWR_fixed>min_for_start & PWR_fixed<max_for_start) {
 if(SWR_fixed>=Auto_delta & ((SWR_fixed>SWR_fixed_old & (SWR_fixed-SWR_fixed_old)>delta) | (SWR_fixed<SWR_fixed_old & (SWR_fixed_old-SWR_fixed)>delta) | SWR_fixed_old==999))
 { Btn_long(); return; }
 }
 if(SWR_fixed!=SWR_fixed_old){
 SWR_fixed_old = SWR_fixed;
 draw_swr(SWR_fixed);
 SWR_ind = SWR_fixed;
 }
 }
 else if(SWR_ind!=SWR_ind_old){
 SWR_ind_old = SWR_ind;
 draw_swr(SWR_ind);
 }

 return;
}

void draw_swr(int s){
 if(s==0)
 oled_wr_str(2, 60, "0.00", 4);
 else {
 IntToStr(s, txt_2);
 txt[0] = txt_2[3];
 txt[1] = '.';
 txt[2] = txt_2[4];
 txt[3] = txt_2[5];

 oled_wr_str(2, 60, txt, 4);
 }
 return;
}

void draw_power(int p){

 if(p==0){
 oled_wr_str(0, 60, "0.0", 3);
 return;
 }
 else if(p<10){
 IntToStr(p, txt_2);
 txt[0] = '0';
 txt[1] = '.';
 txt[2] = txt_2[5];
 }
 else if(p<100){
 IntToStr(p, txt_2);
 txt[0] = txt_2[4];
 txt[1] = '.';
 txt[2] = txt_2[5];
 }
 else{
 p += 5;
 IntToStr(p, txt_2);
 txt[0] = ' ';
 txt[1] = txt_2[3];
 txt[2] = txt_2[4];
 }
 oled_wr_str(0, 60, txt, 3);
 return;
}

void Voltage_show(){
 get_batt();
 if(Voltage != Voltage_old) { Voltage_old = Voltage; oled_voltage(Voltage); }

 if(Voltage>3700){
 Green = 0;
 Red = 1;
 Delay_ms(30);
 Green = 1;
 Red = 1;
 }
 else if(Voltage>3590){
 Green = 0;
 Red = 0;
 Delay_ms(30);
 Green = 1;
 Red = 1;
 }
 else {
 Red = 0;
 Green = 1;
 Delay_ms(30);
 Red = 1;
 Green = 1;
 }

 if(Voltage<3400){
 oled_clear();
 oled_wr_str(1, 0, "  LOW BATT ", 11);
 Delay_ms(2000);
 OLED_PWD = 0;
 power_off();
 }
 return;
}

void Btn_xlong(){
 B_xlong = 0;
 btn_cnt = 0;
 oled_clear();
 oled_wr_str(1, 0, " POWER OFF ", 11);
 Delay_ms(2000);
 power_off();
 return;
}

void Btn_long(){
 Green = 0;
 oled_wr_str(2, 0, "TUNE     ", 9);
 tune();
 SWR_ind = SWR;
 oled_wr_str(2, 0, "SWR ", 4);
 oled_wr_str(2, 42, "=", 1);
 draw_swr(SWR);
 Green = 1;
 B_long = 0;
 E_long = 0;
 volt_cnt = Tick;
 watch_cnt = Tick;
 return;
}

void Ext_long(){
 Green = 0;
 OLED_PWD = 1;
 tune();
 SWR_ind = SWR;
 Green = 1;
 E_long = 0;
 return;
}

void Btn_short(){
 Green = 0;
 atu_reset();
 oled_wr_str(2, 0, "RESET    ", 9);
 Delay_ms(600);
 oled_wr_str(2, 0, "SWR  ", 5);
 oled_wr_str(2, 42, "=", 1);
 oled_wr_str(2, 60, "0.00", 4);
 Delay_ms(300);
 Green = 1;
 B_short = 0;
 E_short = 0;
 volt_cnt = Tick;
 watch_cnt = Tick;
 return;
}

void Greating(){
 Green = 0;
 oled_clear();
 oled_wr_str_s(0, 0, " DESIGNED BY N7DDC", 18);
 oled_wr_str_s(2, 0, " FW VERSION ", 12);
 oled_wr_str_s(2, 12*7,  "1.2" , 3);
 Delay_ms(3000);
 while( ~ PORTB.B5 ) asm NOP;
 Green = 1;
 return;
}

void atu_reset(){
 ind = 0;
 cap = 0;
 SW = 0;
 Relay_set(ind, cap, SW);
 return;
}

void Relay_set(char L, char C, char I){
 L_010 = ~L.B0;
 L_022 = ~L.B1;
 L_045 = ~L.B2;
 L_100 = ~L.B3;
 L_220 = ~L.B4;
 L_450 = ~L.B5;
 L_1000 = ~L.B6;

 C_22 = ~C.B0;
 C_47 = ~C.B1;
 C_100 = ~C.B2;
 C_220 = ~C.B3;
 C_470 = ~C.B4;
 C_1000 = ~C.B5;
 C_2200 = ~C.B6;

 C_sw = I;

 Rel_to_gnd = 1;
 Vdelay_ms(Rel_Del);
 Rel_to_gnd = 0;
 Delay_us(10);
 Rel_to_plus_N = 0;
 Vdelay_ms(Rel_Del);
 Rel_to_plus_N = 1;
 Vdelay_ms(Rel_Del);

 L_010 = 0;
 L_022 = 0;
 L_045 = 0;
 L_100 = 0;
 L_220 = 0;
 L_450 = 0;
 L_1000 = 0;

 C_22 = 0;
 C_47 = 0;
 C_100 = 0;
 C_220 = 0;
 C_470 = 0;
 C_1000 = 0;
 C_2200 = 0;
 return;
}

void power_off(void){
 char btn_cnt;

 GIE_bit = 0;
 T0EN_bit = 0;
 TMR0IF_bit = 0;
 IOCIE_bit = 1;
 IOCBF5_bit = 0;
 IOCBN5_bit = 1;

 OLED_PWD = 0;
 RED = 1;
 Green = 1;

 C_sw = 0;
 SYSCMD_bit = 1;

 btn_cnt = 0;
 while(1){
 if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
 asm NOP;
 Delay_ms(100);
 if( ~ PORTB.B5 ) btn_cnt++;
 else btn_cnt = 0;
 if(btn_cnt>25) break;
 }

 SYSCMD_bit = 0;

 IOCIE_bit = 0;
 IOCBN5_bit = 0;
 IOCBF5_bit = 0;
 T0EN_bit = 1;
 GIE_bit = 1;

 gre = 1;
 oled_start();
 while( ~ PORTB.B5 ){asm NOP;}
 B_short = 0;
 B_long = 0;
 B_xlong = 0;
 return;
}


void check_reset_flags(void){
 char i = 0;
 if(STKOVF_bit){oled_wr_str_s(0, 0, "Stack overflow", 14); i = 1;}
 if(STKUNF_bit){oled_wr_str_s(1, 0, "Stack underflow", 15); i = 1;}
 if(!nRWDT_bit){oled_wr_str_s(2, 0, "WDT overflow", 12); i = 1;}
 if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ", 12); i = 1;}
 if(!nBOR_bit){oled_wr_str_s(4, 0, "BOR reset  ", 12); i = 1;}
 if(i){
 Delay_ms(5000);
 oled_clear();
 }
 return;
}

int correction(int input) {
 input *= 2;

 if(input <= 588) input += 376;
 else if(input <= 882) input += 400;
 else if(input <= 1313) input += 476;
 else if(input <= 1900) input += 514;
 else if(input <= 2414) input += 568;
 else if(input <= 2632) input += 644;
 else if(input <= 2942) input += 732;
 else if(input <= 3232) input += 784;
 else if(input <= 3324) input += 992;
 else if(input <= 3720) input += 1000;
 else if(input <= 4340) input += 1160;
 else if(input <= 4808) input += 1360;
 else if(input <= 5272) input += 1424;
 else input += 1432;

 return input;
}

int get_reverse(void){
 int v;
 float f;
 ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
 Delay_us(100);
 v = ADC_Get_Sample( 10 );
 if(v==1023){
 ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
 Delay_us(100);
 v = ADC_Get_Sample( 10 ) * 2;
 }
 if(v==1023*2){
 get_batt();
 ADC_Init_Advanced(_ADC_INTERNAL_REF);
 Delay_us(100);
 v = ADC_Get_Sample( 8 );
 f = Voltage / 1024;
 v = v * f;
 }
 return v;
}

int get_forward(void){
 int v;
 float f;
 ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
 Delay_us(100);
 v = ADC_Get_Sample( 8 );
 if(v==1023){
 ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
 Delay_us(100);
 v = ADC_Get_Sample( 8 ) * 2;
 }
 if(v==1023*2){
 get_batt();
 ADC_Init_Advanced(_ADC_INTERNAL_REF);
 Delay_us(100);
 v = ADC_Get_Sample( 8 );
 if(v==1023) Overflow = 1;
 f = Voltage / 1024;
 v = v * f;
 }
 return v;
}


void get_pwr(){
 long Forward, Reverse;
 float p;

 Forward = get_forward();
 Reverse = get_reverse();




 p = correction(Forward);
 P = p * 5 / 1000;
 p = p / 1.414;
 p = p * p;
 p = p / 5;
 p += 0.5;
 PWR = p;

 if(PWR>0){
 if(OLED_PWD){
 disp_cnt = Tick + Disp_time*1000;
 off_cnt = Tick + Off_time*1000;
 }
 else oled_start();
 }

 if(Reverse >= Forward)
 Forward = 999;
 else {
 Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
 if(Forward>999) Forward = 999;
 }

 SWR = Forward;
 return;
}

void get_swr(){
 get_pwr();
 tune_cnt = 500;
 while(PWR<min_for_start | PWR>max_for_start){
 if(B_short){
 Btn_short();
 SWR = 0;
 return;
 }
 if(B_xlong){
 Btn_xlong();
 SWR = 0;
 return;
 }
 get_pwr();
 draw_power(PWR);
 if(tune_cnt>0) tune_cnt --;
 else {
 SWR = 0;
 return;
 }
 }

 return;
}

void get_batt(void){
 ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
 Delay_us(100);
 Voltage = ADC_Get_Sample( 9 ) * 11;
 return;
}

 void coarse_cap() {
 char step = 3;
 char count;
 int min_swr;

 cap = 0;
 Relay_set(ind, cap, SW);
 get_swr();
 min_swr = SWR + SWR/20;
 for(count=step; count<=31;) {
 Relay_set(ind, count, SW);
 get_swr();
 if(SWR < min_swr) {
 min_swr = SWR + SWR/20;
 cap = count;
 step_cap = step;
 if(SWR<120) break;
 count += step;
 if(count==9) count = 8;
 else if(count==17) {count = 16; step = 4;}
 }
 else break;
 }
 Relay_set(ind, cap, SW);
 return;
}

void coarse_tune() {
 char step = 3;
 char count;
 char mem_cap, mem_step_cap;
 int min_swr;

 mem_cap = 0;
 step_ind = step;
 mem_step_cap = 3;
 min_swr = SWR + SWR/20;
 for(count=step; count<=31;) {
 Relay_set(count, cap, SW);
 coarse_cap();
 get_swr();
 if(SWR < min_swr) {
 min_swr = SWR + SWR/20;
 ind = count;
 mem_cap = cap;
 step_ind = step;
 mem_step_cap = step_cap;
 if(SWR<120) break;
 count += step;
 if(count==9) count = 8;
 else if(count==17) {count = 16; step = 4;}
 }
 else break;
 }
 cap = mem_cap;
 Relay_set(ind, cap, SW);
 step_cap = mem_step_cap;
 Delay_ms(10);
 return;
}

void sharp_cap() {
 char range, count, max_range, min_range;
 int min_swr;
 range = step_cap;

 max_range = cap + range;
 if(max_range>31) max_range = 31;
 if(cap>range) min_range = cap - range; else min_range = 0;
 cap = min_range;
 Relay_set(ind, cap, SW);
 get_swr();
 if(SWR==0) return;
 min_SWR = SWR;
 for(count=min_range+1; count<=max_range; count++) {
 Relay_set(ind, count, SW);
 get_swr();
 if(SWR==0) return;
 if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
 if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
 if(SWR < min_SWR) {
 min_SWR = SWR;
 cap = count;
 if(SWR<120) break;
 }
 else break;
 }
 Relay_set(ind, cap, SW);
 return;
}

void sharp_ind() {
 char range, count, max_range, min_range;
 int min_SWR;
 range = step_ind;

 max_range = ind + range;
 if(max_range>31) max_range = 31;
 if(ind>range) min_range = ind - range; else min_range = 0;
 ind = min_range;
 Relay_set(ind, cap, SW);
 get_swr();
 if(SWR==0) return;
 min_SWR = SWR;
 for(count=min_range+1; count<=max_range; count++) {
 Relay_set(count, cap, SW);
 get_swr();
 if(SWR==0) return;
 if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
 if(SWR>=min_SWR) { Delay_ms(10); get_swr(); }
 if(SWR < min_SWR) {
 min_SWR = SWR;
 ind = count;
 if(SWR<120) break;
 }
 else break;
 }
 Relay_set(ind, cap, SW);
 return;
}


void tune() {
 int swr_mem, ind_mem, cap_mem;
 asm CLRWDT;
  LATD2_bit  = 0;
 Delay_ms(100);
 get_swr(); if(SWR<110) {  LATD2_bit  = 1; return; }
 atu_reset();
 Delay_ms(50);
 get_swr(); if(SWR<110) {  LATD2_bit  = 1; return; }

 swr_mem = SWR;
 coarse_tune(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }
 sharp_ind(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }
 sharp_cap(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }

 if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) {  LATD2_bit  = 1; return; }
 swr_mem = SWR;
 ind_mem = ind;
 cap_mem = cap;

 if(SW==1) SW = 0; else SW = 1;
 atu_reset();
 Relay_set(ind, cap, SW);
 Delay_ms(50);
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }

 coarse_tune(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }
 sharp_ind(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }
 sharp_cap(); if(SWR==0) {atu_reset();  LATD2_bit  = 1; return;}
 get_swr(); if(SWR<120) {  LATD2_bit  = 1; return; }

 if(SWR>swr_mem) {
 if(SW==1) SW = 0; else SW = 1;
 Relay_set(ind, cap, SW);
 ind = ind_mem;
 cap = cap_mem;
 Relay_set(ind, cap, sw);
 SWR = swr_mem;
 }

 asm CLRWDT;
  LATD2_bit  = 1;
 return;
}

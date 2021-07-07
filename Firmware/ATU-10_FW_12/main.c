// X-202 HF FM AM SSB Receiver
// David Fainitski, N7DDC
// 2020

#include "pic_init.h"
#include "main.h"
#include "oled_control.h"
#include "Soft_I2C.h"


// global variables
char txt[8], txt_2[8];
unsigned long Tick = 0; // ms system tick
int Voltage, Voltage_old = 0;
char btn_1_cnt = 0, btn_2_cnt = 0;
unsigned long volt_cnt = 0, watch_cnt = 0, btn_cnt = 0, off_cnt, disp_cnt, tune_cnt;
int PWR, SWR, SWR_ind = 0, SWR_ind_old = 9999, SWR_fixed_old = 9999, PWR_fixed_old = 9999;
char ind = 0, cap = 0, SW = 0, step_cap = 0, step_ind = 0, L_linear = 0, C_linear = 0;
bit Overflow, B_short, B_long, B_xlong, gre, E_short, E_long;

int Rel_Del = 5, min_for_start = 10, max_for_start = 150;
int Auto_delta = 130; // 1.3 SWR

unsigned long Disp_time = 300; //  Time in seconds
unsigned long Off_time = 1800; //  Time in seconds

#define FW_VER "1.2"

// interrupt processing
void interupt() iv 0x0004  {
   //
   if(TMR0IF_bit) {   // Timer0
      TMR0IF_bit = 0;
      Tick++;
      TMR0L = 0xC0;   // 80_000 cycles to OF
      TMR0H = 0xE0;
   }
   //
   if(Tick>=btn_cnt){  // every 10ms
      btn_cnt += 10;
      //
      if(GetButton | Start){
         disp_cnt = Tick + Disp_time*1000;
         off_cnt = Tick + Off_time*1000;
      }
      //
      if(GetButton){  //
         if(btn_1_cnt<250) btn_1_cnt++;
         if(btn_1_cnt==25) B_long = 1;  // long pressing detected
         if(btn_1_cnt==250 & OLED_PWD) B_xlong = 1;  // Xtra long pressing detected
      }
      else if(btn_1_cnt>2 & btn_1_cnt<25){
         B_short = 1;               // short pressing detected
         btn_1_cnt = 0;
      }
      else
         btn_1_cnt = 0;
      //  External interface
      if(Start){
         if(btn_2_cnt<25) btn_2_cnt++;
         if(btn_2_cnt==20 & Key_in) E_long = 1;
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
   Key_out = 1;
   gre = 1;
   oled_start();
   //if(Debug) check_reset_flags();
   ADC_Init();
   Overflow = 0;
   B_short = 0;
   B_long = 0;
   B_xlong = 0;
   E_short = 0;
   E_long = 0;
   //
   disp_cnt = Tick + Disp_time*1000;
   off_cnt = Tick + Off_time*1000;

   //
   //Relay_set(0, 0, 0);
   //
   while(1) {
      if(Tick>=volt_cnt){   // every 3 second
         volt_cnt += 3000;
         Voltage_show();
      }
      //
      if(Tick>=watch_cnt){   // every 300 ms    unless power off
         watch_cnt += 300;
         watch_swr();
      }
      //
      if(Tick>=disp_cnt){  // Display off
         //Disp = 0;
         OLED_PWD = 0;
      }
      //
      if(Tick>=off_cnt){    // Go to power off
         power_off();
      }
      //
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
      // External interface
      if(E_short){
         if(OLED_PWD==0) oled_start();
         Btn_short();
      }
      if(E_long){
         if(OLED_PWD==0) { Ext_long(); oled_start(); }
         else Btn_long();
      }
    
  } // while(1)
} // main


void oled_start(){
   OLED_PWD = 1;
   //Disp = 1;
   Delay_ms(200);
   Soft_I2C_init();
   Delay_ms(10);
   oled_init();
   //
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
   volt_cnt = Tick + 1;
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
   //
   Delay_ms(50);
   // peak detector
   cnt = 600;
   PWR_fixed = 0;
   SWR_fixed = 999;
   for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
      get_pwr();
      if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
      Delay_ms(1);
   }
   //
   if(PWR_fixed>0){
      if(OLED_PWD){
         disp_cnt = Tick + Disp_time*1000;
         off_cnt = Tick + Off_time*1000;
      }
      else oled_start();
   }
   //
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
   //
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
   //
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
      //
      oled_wr_str(2, 60, txt, 4);
   }
   return;
}

void draw_power(int p){
   //
   if(p==0){
      oled_wr_str(0, 60, "0.0", 3);
      return;
   }
   else if(p<10){  // <1 W
      IntToStr(p, txt_2);
      txt[0] = '0';
      txt[1] = '.';
      txt[2] = txt_2[5];
   }
   else if(p<100){ // <10W
      IntToStr(p, txt_2);
      txt[0] = txt_2[4];
      txt[1] = '.';
      txt[2] = txt_2[5];
   }
   else{  // >10W
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
   //               4.2 - 3.4
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
   else { // <3.7V
      Red = 0;
      Green = 1;
      Delay_ms(30);
      Red = 1;
      Green = 1;
   }
   //
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
   oled_wr_str_s(2, 12*7, FW_VER, 3);
   Delay_ms(3000);
   while(GetButton) asm NOP;
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
   //
   C_22 = ~C.B0;
   C_47 = ~C.B1;
   C_100 = ~C.B2;
   C_220 = ~C.B3;
   C_470 = ~C.B4;
   C_1000 = ~C.B5;
   C_2200 = ~C.B6;
   //
   C_sw = I;
   //
   Rel_to_gnd = 1;
   Vdelay_ms(Rel_Del);
   Rel_to_gnd = 0;
   Delay_us(10);
   Rel_to_plus_N = 0;
   Vdelay_ms(Rel_Del);
   Rel_to_plus_N = 1;
   Vdelay_ms(Rel_Del);
   //
   L_010 = 0;
   L_022 = 0;
   L_045 = 0;
   L_100 = 0;
   L_220 = 0;
   L_450 = 0;
   L_1000 = 0;
   //
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
   // Disable interrupts
   GIE_bit = 0;
   T0EN_bit = 0;
   TMR0IF_bit = 0;
   IOCIE_bit = 1;
   IOCBF5_bit = 0;
   IOCBN5_bit = 1;
   // Power saving
   OLED_PWD = 0;
   RED = 1;
   Green = 1;
   //
   C_sw = 0;
   SYSCMD_bit = 1;
   //
   btn_cnt = 0;
   while(1){
      if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
      asm NOP;
      Delay_ms(100);
      if(GetButton) btn_cnt++;
      else btn_cnt = 0;
      if(btn_cnt>15) break;
   }
   // Power saving
   SYSCMD_bit = 0;
   // Enable interrupts
   IOCIE_bit = 0;
   IOCBN5_bit = 0;
   IOCBF5_bit = 0;
   T0EN_bit = 1;
   GIE_bit = 1;
   // Return to work
   gre = 1;
   oled_start();
   while(GetButton){asm NOP;}
   B_short = 0;
   B_long = 0;
   B_xlong = 0;
   E_long = 0;
   return;
}


void check_reset_flags(void){
   char i = 0;
   if(STKOVF_bit){oled_wr_str_s(0,  0, "Stack overflow",  14); i = 1;}
   if(STKUNF_bit){oled_wr_str_s(1,  0, "Stack underflow", 15); i = 1;}
   if(!nRWDT_bit){oled_wr_str_s(2,  0, "WDT overflow",    12); i = 1;}
   if(!nRMCLR_bit){oled_wr_str_s(3, 0, "MCLR reset  ",    12); i = 1;}
   if(!nBOR_bit){oled_wr_str_s(4,   0, "BOR reset  ",     12); i = 1;}
   if(i){
      Delay_ms(5000);
      oled_clear();
   }
   return;
}

int correction(int input) {
     input *= 2;
     //
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
     else  input += 1432;
     //
     return input;
}

int get_reverse(void){
   int v;
   float f;
   ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
   Delay_us(100);
   v = ADC_Get_Sample(REV_input);
   if(v==1023){
      ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
      Delay_us(100);
      v = ADC_Get_Sample(REV_input) * 2;
   }
   if(v==1023*2){
      get_batt();
      ADC_Init_Advanced(_ADC_INTERNAL_REF);
      Delay_us(100);
      v = ADC_Get_Sample(FWD_input);
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
   v = ADC_Get_Sample(FWD_input);
   if(v==1023){
      ADC_Init_Advanced(_ADC_INTERNAL_FVRH2);
      Delay_us(100);
      v = ADC_Get_Sample(FWD_input) * 2;
   }
   if(v==1023*2){
      get_batt();
      ADC_Init_Advanced(_ADC_INTERNAL_REF);
      Delay_us(100);
      v = ADC_Get_Sample(FWD_input);
      if(v==1023) Overflow = 1;
      f = Voltage / 1024;
      v = v * f;
   }
   return v;
}


void get_pwr(){
   long Forward, Reverse;
   float p;
   //
   Forward = get_forward();
   Reverse = get_reverse();
   //Forward = correction(Forward);
   //Reverse = correction(Reverse);
   // p = Forward;
   //
   p = correction(Forward);
   P = p * 5 / 1000;
   p = p / 1.414;
   p = p * p;
   p = p / 5;
   p += 0.5;
   PWR = p;
   //
   if(PWR>0){
      if(OLED_PWD){
         disp_cnt = Tick + Disp_time*1000;
         off_cnt = Tick + Off_time*1000;
      }
      else oled_start();
   }
   //
   if(Reverse >= Forward)
      Forward = 999;
   else {
      Forward = ((Forward + Reverse) * 100) / (Forward - Reverse);
      if(Forward>999) Forward = 999;
   }
   //
   SWR = Forward;
   return;
}

void get_swr(){
   get_pwr();
   tune_cnt = 200;
   while(PWR<min_for_start | PWR>max_for_start){   // waiting for good power
      if(B_short){
         Btn_short();
         SWR = 0;
         return;
      }
      if(B_xlong){
         //Btn_xlong();
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
   //  good power
   return;
}

void get_batt(void){
   ADC_Init_Advanced(_ADC_INTERNAL_FVRH1);
   Delay_us(100);
   Voltage = ADC_Get_Sample(Battery_input) * 11;
   return;
}

 void coarse_cap() {
   char step = 3;
   char count;
   int min_swr;
   //
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
   //
   max_range = cap + range;
   if(max_range>31) max_range = 31;
   if(cap>range) min_range = cap - range; else min_range = 0;
   cap = min_range;
   Relay_set(ind, cap, SW);
   get_swr();
   if(SWR==0) return;
   min_SWR = SWR;
   for(count=min_range+1; count<=max_range; count++)  {
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
   //
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
   Key_out = 0;
   Delay_ms(100);
   get_swr(); if(SWR<110) { Key_out = 1; return; }
   atu_reset();
   Delay_ms(50);
   get_swr(); if(SWR<110) { Key_out = 1; return; }
   //
   swr_mem = SWR;
   coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1;  return; }
   sharp_ind();  if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   //
   if(SWR<200 & SWR<swr_mem & (swr_mem-SWR)>100) { Key_out = 1; return; }
   swr_mem = SWR;
   ind_mem = ind;
   cap_mem = cap;
   //
   if(SW==1) SW = 0; else SW = 1;
   atu_reset();
   Relay_set(ind, cap, SW);
   Delay_ms(50);
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   //
   coarse_tune(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   sharp_ind(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   sharp_cap(); if(SWR==0) {atu_reset(); Key_out = 1; return;}
   get_swr(); if(SWR<120) { Key_out = 1; return; }
   //
   if(SWR>swr_mem) {
      if(SW==1) SW = 0; else SW = 1;
      Relay_set(ind, cap, SW);
      ind = ind_mem;
      cap = cap_mem;
      Relay_set(ind, cap, sw);
      SWR = swr_mem;
   }
   //
   asm CLRWDT;
   Key_out = 1;
   return;
}
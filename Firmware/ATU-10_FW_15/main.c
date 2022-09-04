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
unsigned long volt_cnt = 0, watch_cnt = 0, btn_cnt = 0, off_cnt = 10, disp_cnt=10;
int PWR, SWR, SWR_ind = 0, SWR_fixed_old = 100, PWR_fixed_old = 9999;
char ind = 0, cap = 0, SW = 0;
bit Overflow, B_short, B_long, B_xlong, gre, E_short, E_long;

int Rel_Del = 8, rldl, min_for_start = 10, max_for_start = 150;
int Auto_delta = 130; // 1.3 SWR

#define Disp_time 300000 //  Time in milliseconds  0 to always on
#define Off_time  0 //1800000 //  Time in milliseconds  0 to always on

#define FW_VER "1.5"

// interrupt processing
void interupt() iv 0x0004  {
   //
   if(TMR0IF_bit) {   // Timer0   every 1ms
      TMR0IF_bit = 0;
      Tick++;
      if(disp_cnt!=0) disp_cnt--;
      if(off_cnt!=0) off_cnt--;
      TMR0L = 0xC0;   // 8_000 cycles to OF
      TMR0H = 0xE0;
      //
      if(Tick>=btn_cnt){  // every 10ms
         btn_cnt += 10;
         //
         if(GetButton | Start){
            disp_cnt = Disp_time;
            off_cnt = Off_time;
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
   //
   disp_cnt = Disp_time;
   off_cnt = Off_time;

   //
   rldl = Rel_Del;
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
      if(Disp_time!=0 && disp_cnt==0){  // Display off
         //Disp = 0;
         OLED_PWD = 0;
      }
      //
      if(Off_time!=0 && off_cnt==0){    // Go to power off
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
//
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
   SWR_fixed_old = 100;
   PWR_fixed_old = 9999;
   SWR_ind = 0;
   draw_swr(SWR_ind);
   volt_cnt = Tick + 1;
   watch_cnt = Tick;
   B_short = 0; B_long = 0; B_xlong = 0, E_short = 0; E_long = 0;
   disp_cnt = Disp_time;
   off_cnt = Off_time;
   return;
}
//
void watch_swr(void){
   char peak_cnt, cnt;
   int delta = Auto_delta - 100;
   int PWR_fixed, SWR_fixed;
   //
   Delay_ms(50);
   // peak detector
   cnt = 600;
   PWR_fixed = 0;
   SWR_fixed = 0;
   for(peak_cnt=0; peak_cnt<cnt; peak_cnt++){
      get_pwr();
      if(PWR>PWR_fixed) {PWR_fixed = PWR; SWR_fixed = SWR;}
      Delay_ms(1);
   }
   //
   if(PWR_fixed>0){   // Turn on the display
      if(OLED_PWD){
         disp_cnt = Disp_time;
         off_cnt = Off_time;
      }
      else oled_start();
   };
   //
   if(PWR_fixed!=PWR_fixed_old){
      if(Overflow)
         oled_wr_str(0, 42, ">", 1);
      else
         oled_wr_str(0, 42, "=", 1);
      PWR_fixed_old = PWR_fixed;
      draw_power(PWR_fixed);
   }
    //
   if(SWR_fixed>99 && SWR_fixed!=SWR_ind){
      SWR_ind = SWR_fixed;
      if(PWR_fixed<10){
         SWR_fixed = 0;
         //SWR_ind = 0;    // Last meassured SWR on display ! not a bug
         draw_swr(SWR_ind);
         return;
      }
      else
         draw_swr(SWR_ind);
   }
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
   //

   else if(PWR_fixed>=min_for_start && PWR_fixed<max_for_start && SWR_fixed>99) {
       if(  (SWR_fixed-SWR_fixed_old)>delta || (SWR_fixed_old-SWR_fixed)>delta  ) {
           Btn_long();
           return;
       }
   }
   //
   return;
}
//
void draw_swr(unsigned int s){
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
//
void draw_power(unsigned int p){
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
//
void Voltage_show(){       //  4.2 - 3.4  4200 - 3400
   get_batt();
   if(Voltage != Voltage_old) { 
      Voltage_old = Voltage; 
      oled_voltage(Voltage); 
      if(Voltage<=3800) rldl = Rel_Del + 1;
      else rldl = Rel_Del;
   }
   //
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
   if(Voltage<3400){
      oled_clear();
      oled_wr_str(1, 0, "  LOW BATT ", 11);
      Delay_ms(2000);
      OLED_PWD = 0;
      power_off();
   }
   return;
}
//
void Btn_xlong(){
   oled_clear();
   oled_wr_str(1, 0, " POWER OFF ", 11);
   Delay_ms(2000);
   power_off();
   return;
}
//
void Btn_long(){
   Green = 0;
   oled_wr_str(2, 0, "TUNE     ", 9);
   Key_out = 0;
   get_SWR();
   if(SWR>99){
      tune();
      SWR_ind = SWR;
      SWR_fixed_old = SWR;
      oled_wr_str(2, 0, "SWR ", 4);
      oled_wr_str(2, 42, "=", 1);
      draw_swr(SWR_ind);
   }
   Key_out = 1;
   Green = 1;
   B_long = 0;
   E_long = 0;
   btn_1_cnt = 0;
   volt_cnt = Tick;
   watch_cnt = Tick;
   return;
}
//
void Ext_long(){
   Green = 0;
   OLED_PWD = 1;
   Key_out = 0;   //
   get_SWR();     //
   if(SWR>99)
      tune();
   Key_out = 1;   //
   SWR_ind = SWR;
   Green = 1;
   E_long = 0;
   return;
}
//
void Btn_short(){
   Green = 0;
   atu_reset();
   oled_wr_str(2, 0, "RESET    ", 9);
   Delay_ms(600);
   oled_wr_str(2, 0, "SWR  ", 5);
   oled_wr_str(2, 42, "=", 1);
   oled_wr_str(2, 60, "0.00", 4);
   SWR_fixed_old = 100;
   Delay_ms(300);
   Green = 1;
   B_short = 0;
   E_short = 0;
   btn_1_cnt = 0;
   volt_cnt = Tick;
   watch_cnt = Tick;
   return;
}
//
void Greating(){
   Green = 0;
   oled_clear();
   oled_wr_str_s(1, 0, " DESIGNED BY N7DDC", 18);
   oled_wr_str_s(3, 0, " FW VERSION ", 12);
   oled_wr_str_s(3, 12*7, FW_VER, 3);
   Delay_ms(3000);
   while(GetButton) asm NOP;
   Green = 1;
   return;
}
//
void atu_reset(){
   ind = 0;
   cap = 1;
   SW = 0;
   Relay_set(ind, cap, SW);
   return;
}
//
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
   Vdelay_ms(rldl);
   Rel_to_gnd = 0;
   Delay_us(10);
   Rel_to_plus_N = 0;
   Vdelay_ms(rldl);
   Rel_to_plus_N = 1;
   Vdelay_ms(rldl);
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
   //
   C_sw = 0;
   return;
}
//
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
   btn_cnt = 0;
   while(1){
      if(btn_cnt==0){ Delay_ms(100); IOCBF5_bit = 0; asm sleep; }
      asm NOP;
      Delay_ms(100);
      if(GetButton) btn_cnt++;
      else btn_cnt = 0;
      if(btn_cnt>15) break;
   }
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
   btn_1_cnt = 0;
   btn_cnt = Tick;
   return;
}
//
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
//
int correction(int input) {
     input *= 2;
     //
     if(input <= 543) input += 256;
     else if(input <= 791) input += 274;
     else if(input <= 1225) input += 288;
     else if(input <= 1991) input += 286;
     else if(input <= 2766) input += 288;
     else if(input <= 3970) input += 260;
     else if(input <= 5100) input += 250;
     else  input += 240;
     //
     return input;
}
//
int get_reverse(void){
   unsigned int v;
   unsigned long d;
   ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
   Delay_us(100);
   v = ADC_Get_Sample(REV_input);
   if(v==1023){
      ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH2);
      Delay_us(100);
      v = ADC_Get_Sample(REV_input) * 2;
   }
   if(v==2046){
      ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_VREFH);
      Delay_us(100);
      v = ADC_Get_Sample(REV_input);
      if(v==1023) Overflow = 1;
      get_batt();
      d = (long)v * (long)Voltage;
      d = d / 1024;
      v = (int)d;
   }
   return v;
}
//
int get_forward(void){
   unsigned int v;
   unsigned long d;
   ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
   Delay_us(100);
   v = ADC_Get_Sample(FWD_input);
   if(v==1023){
      ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH2);
      Delay_us(100);
      v = ADC_Get_Sample(FWD_input) * 2;
   }
   if(v==2046){
      ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_VREFH);
      Delay_us(100);
      v = ADC_Get_Sample(FWD_input);
      if(v==1023) Overflow = 1;
      get_batt();
      d = (long)v * (long)Voltage;
      d = d / 1024;
      v = (int)d;
   }
   return v;
}
//
void get_pwr(){
   long Forward, Reverse;
   float p;
   //
   Forward = get_forward();
   Reverse = get_reverse();
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
         disp_cnt = Disp_time;
         off_cnt = Off_time;
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
//
void get_swr(){
   unsigned int pwr_cnt = 300, tuneoff_cnt = 300;
   unsigned int PWR_max = 0;
   get_pwr();
   while(PWR<min_for_start || PWR>max_for_start){   // waiting for good power
      if(B_short){
         Btn_short();
         SWR = 0;
         break;
      }
      if(B_xlong){
         //Btn_xlong();
         SWR = 0;
         break;
      }
      //
      get_pwr();
      if(pwr_cnt>0){
          pwr_cnt --;
          if(PWR>PWR_max)
              PWR_max = PWR;
      }
      else {
         if(PWR_max!=PWR_fixed_old) draw_power(PWR_max);
         PWR_fixed_old = PWR_max;
         PWR_max = 0;
         pwr_cnt = 300;
         if(tuneoff_cnt>0) tuneoff_cnt--;
         else { SWR = 0; break; }
         Delay_ms(1);
      }
   }
   //  good power
   return;
}
//
void get_batt(void){
   ADC_Init_Advanced(_ADC_INTERNAL_VREFL | _ADC_INTERNAL_FVRH1);
   Delay_us(100);
   Voltage = ADC_Get_Sample(Battery_input) * 11;
   return;
}
//
void tune(void){
   int SWR_mem;
   char cap_mem, ind_mem;
   subtune();
   get_SWR();
   if(SWR<=120) return;
   SWR_mem = SWR;
   cap_mem = cap;
   ind_mem = ind;
   if(SW==1) SW = 0;
   else SW = 1;
   subtune();
   get_SWR();
   if(SWR>SWR_mem){
      if(SW==1) SW = 0;
      else SW = 1;
      cap = cap_mem;
      ind = ind_mem;
      Relay_set(ind, cap, SW);
      Delay_ms(5);
      get_SWR();
   }
   if(SWR<=120) return;
   sharp_tune();
   get_SWR();
   return;
}
//
void subtune(void){
   cap = 0;
   ind = 0;
   Relay_set(ind, cap, SW);
   delay_ms(50);
   get_SWR();
   if(SWR<=120) return;
   coarse_tune();
   get_SWR();
   if(SWR<=120) return;
   sharp_tune();
   return;
}
//
void coarse_tune(void){
   int SWR_mem1 = 10000, SWR_mem2 = 10000, SWR_mem3 = 10000;
   char ind_mem1, cap_mem1, ind_mem2, cap_mem2, ind_mem3, cap_mem3;
   coarse_cap();
   coarse_ind();
   get_SWR();
   if(SWR<=120) return;
   SWR_mem1 = SWR;
   ind_mem1 = ind;
   cap_mem1 = cap;
   if(cap<=2 & ind<=2){
      cap = 0;
      ind = 0;
      Relay_set(ind, cap, SW);
      Delay_ms(5);
      coarse_ind();
      coarse_cap();
      get_SWR();
      if(SWR<=120) return;
      SWR_mem2 = SWR;
      ind_mem2 = ind;
      cap_mem2 = cap;
   }
   if(cap<=2 & ind<=2){
      cap = 0;
      ind = 0;
      Relay_set(ind, cap, SW);
      Delay_ms(5);
      coarse_ind_cap();
      get_SWR();
      if(SWR<=120) return;
      SWR_mem3 = SWR;
      ind_mem3 = ind;
      cap_mem3 = cap;
   }
   if(SWR_mem1<=SWR_mem2 & SWR_mem1<=SWR_mem3){
      cap = cap_mem1;
      ind = ind_mem1;
   }
   else if(SWR_mem2<=SWR_mem1 & SWR_mem2<=SWR_mem3){
      cap = cap_mem2;
      ind = ind_mem2;
   }
   else if(SWR_mem3<=SWR_mem1 & SWR_mem3<=SWR_mem2){
      cap = cap_mem3;
      ind = ind_mem3;
   }
   return;
}
//
void coarse_ind_cap(void){
   int SWR_mem;
   char ind_mem;
   ind_mem = 0;
   get_swr();
   SWR_mem = SWR / 10;
   for(ind=1; ind<64; ind*=2){
      Relay_set(ind, ind, SW);
      Delay_ms(5);
      get_swr();
      SWR = SWR/10;
      if(SWR<=SWR_mem){
         ind_mem = ind;
         SWR_mem = SWR;
      }
      else
         break;
   }
   ind = ind_mem;
   cap = ind_mem;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   return;
}
//
void coarse_cap(void){
   int SWR_mem;
   char cap_mem;
   cap_mem = 0;
   get_swr();
   SWR_mem = SWR / 10;
   for(cap=1; cap<64; cap*=2){
      Relay_set(ind, cap, SW);
      Delay_ms(5);
      get_swr();
      SWR = SWR/10;
      if(SWR<=SWR_mem){
         cap_mem = cap;
         SWR_mem = SWR;
      }
      else
         break;
   }
   cap = cap_mem;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   return;
}
//
void coarse_ind(void){
   int SWR_mem;
   char ind_mem;
   ind_mem = 0;
   get_swr();
   SWR_mem = SWR / 10;
   for(ind=1; ind<64; ind*=2){
      Relay_set(ind, cap, SW);
      Delay_ms(5);
      get_swr();
      SWR = SWR/10;
      if(SWR<=SWR_mem){
         ind_mem = ind;
         SWR_mem = SWR;
      }
      else
         break;
   }
   ind = ind_mem;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   return;
}
//
void sharp_tune(void){
   if(cap>=ind){
      sharp_cap();
      sharp_ind();
   }
   else{
      sharp_ind();
      sharp_cap();
   }
   return;
}
//
void sharp_cap(void){
   int SWR_mem;
   char step, cap_mem;
   cap_mem = cap;
   step = cap / 10;
   if(step==0) step = 1;
   get_SWR();
   SWR_mem = SWR;
   cap += step;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   get_SWR();
   if(SWR<=SWR_mem){
      SWR_mem = SWR;
      cap_mem = cap;
      for(cap+=step; cap<=(127-step); cap+=step){
         Relay_set(ind, cap, SW);
         Delay_ms(5);
         get_SWR();
         if(SWR<=SWR_mem){
            cap_mem = cap;
            SWR_mem = SWR;
            step = cap / 10;
            if(step==0) step = 1;
         }
         else
            break;
      }
   }
   else{
      SWR_mem = SWR;
      for(cap-=step; cap>=step; cap-=step){
         Relay_set(ind, cap, SW);
         Delay_ms(5);
         get_SWR();
         if(SWR<=SWR_mem){
            cap_mem = cap;
            SWR_mem = SWR;
            step = cap / 10;
            if(step==0) step = 1;
         }
         else
            break;
      }
   }
   cap = cap_mem;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   return;
}
//
void sharp_ind(void){
   int SWR_mem;
   char step, ind_mem;
   ind_mem = ind;
   step = ind / 10;
   if(step==0) step = 1;
   get_SWR();
   SWR_mem = SWR;
   ind += step;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   get_SWR();
   if(SWR<=SWR_mem){
      SWR_mem = SWR;
      ind_mem = ind;
      for(ind+=step; ind<=(127-step); ind+=step){
         Relay_set(ind, cap, SW);
         Delay_ms(5);
         get_SWR();
         if(SWR<=SWR_mem){
            ind_mem = ind;
            SWR_mem = SWR;
            step = ind / 10;
            if(step==0) step = 1;
         }
         else
            break;
      }
   }
   else{
      SWR_mem = SWR;
      for(ind-=step; ind>=step; ind-=step){
         Relay_set(ind, cap, SW);
         Delay_ms(5);
         get_SWR();
         if(SWR<=SWR_mem){
            ind_mem = ind;
            SWR_mem = SWR;
            step = ind / 10;
            if(step==0) step = 1;
         }
         else
            break;
      }
   }
   ind = ind_mem;
   Relay_set(ind, cap, SW);
   Delay_ms(5);
   return;
}
//
#include "oled_control.h"
#include "Soft_I2C.h"

void oled_disp_on() {
   send_command(0xAF); //  display ON
}

void oled_disp_off() {
   send_command(0xAE); // display OFF
}

void oled_init (void) {  // OLED init
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);             // device addres
   Soft_I2C_Write(0);              // 0 - continious mode, command; 64 - Co, data
   Soft_I2C_Write (0xAE); // display OFF
   //         initialisation
   Soft_I2C_Write (0xD5); // clock division
   Soft_I2C_Write (0x80); // ratio
   //
   Soft_I2C_Write (0xA8); //  multiplexer
   Soft_I2C_Write (63); //
   //
   Soft_I2C_Write (0xD3); //  offset
   Soft_I2C_Write (shift_line); // 32 no offset for x64 !
   //
   Soft_I2C_Write (0x40); // set line, line = 0
   //
   Soft_I2C_Write (0x8D); //  charge pump
   Soft_I2C_Write (0x14); //  0x10 - external, 0x14 - internal
   //
   Soft_I2C_Write (0x81); //  contrast
   Soft_I2C_Write (255); //   0-255
   //
   Soft_I2C_Write (0xD9); //  pre-charge
   Soft_I2C_Write (0xF1); //  0x22 - external, 0xF1 - internal
   //
   Soft_I2C_Write (0x20); //  memory addressing mode
   Soft_I2C_Write (0x02); //  page addressing mode   02
   //
   Soft_I2C_Write (0x21); // set column range
   Soft_I2C_Write (0);    // column start
   Soft_I2C_Write (127);  // column stop
   //
   Soft_I2C_Write (0x2E); //  stop scrolling
   //
   if(inversion) {
      Soft_I2C_Write (0xA0); //  segment re-map, A0 - normal, A1 - remapped
      Soft_I2C_Write (0xC0); // scan direction, C0 - normal, C8 - remapped
   }
   else {
      Soft_I2C_Write (0xA1); //  segment re-map, A0 - normal, A1 - remapped
      Soft_I2C_Write (0xC8); // scan direction, C0 - normal, C8 - remapped
   }
   //
   Soft_I2C_Write (0xDA); //  COM pins configure
   Soft_I2C_Write (0x02); // 02 for 32 12 for x64
   //
   Soft_I2C_Write (0xDB); //  V-COM detect
   Soft_I2C_Write (0x40); //
   //
   Soft_I2C_Write (0xA4); //  display entire ON
   //
   Soft_I2C_Write (0xA6); // 0xA6 - normal, 0xA7 - inverse
   //
   Soft_I2C_Stop ();
   //
   oled_clear();
   send_command (0xAF); //  display ON
   return;
}

void oled_clear(void){
   char i, r;
   // ********clear OLED***********
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);             // device addres
   Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
   //
   for (r = 0; r <=7; r++) {
      set_addressing (r, 0);    // clear all 8 pages
      for (i = 0; i < 128; i++, Soft_I2C_Write(0x00)); // clear one page pixels
   }
   Soft_I2C_Stop ();
   //
   return;
}

void send_command (char oled_command) {
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);         // device addres
   Soft_I2C_Write(128);              // 128 - command, 192 - data
   Soft_I2C_Write(oled_command);
   Soft_I2C_Stop();
   return;
}

void set_addressing (char pagenum, char c_start) {
   char a, b, c;
   c = c_start + oled_shift;
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);             // device addres
   Soft_I2C_Write(0);              // 0 - continious mode, command; 64 - Co, data
   Soft_I2C_Write(0xB0 + pagenum);  // set page number
   //
   if (c <= 15) { a = c; b = 0; }
   else { b = c / 16; a = c - b * 16; }
   Soft_I2C_Write (a);        // set lower nibble of start address
   Soft_I2C_Write (0x10 + b); // set higher nibble of start address
   //
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);        // device addres
   Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
   return;
}

void oled_wr_str_s(char page, char col, char str[], char len) {  //  128*64 OLED
   char i, h, g;
   set_addressing (page, col);
   //
   for (i = 0; i < len; i++) { // write string
     g = str[i] - 32; // table shift
     for (h = 0; h < 5; h++) {  // write letter
        Soft_I2C_Write(font_5x8[g*5+h]);
     }
     Soft_I2C_Write (0);
   }
  Soft_I2C_Stop ();
  return;
}

//
void oled_wr_str (char page, char col, char str[], char leng ) {  //
  char i, h, g, w1, w2;
  Soft_I2C_Start();
  Soft_I2C_Write(oled_addr);       // device addres
  Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
  //
  set_addressing (page, col);
  //
  for (i = 0; i < leng; i++) { // write string
     if (str[i] == 0) g = 0; else g = str[i] - 32; // NULL detection
     for (h = 0; h <= 4; h++) {  // write letter
      w1 = font_5x8[g*5+h];
      if(page != 2) {
      w2.B7 = w1.B3;
      w2.B6 = w1.B3;
      w2.B5 = w1.B2;
      w2.B4 = w1.B2;
      w2.B3 = w1.B1;
      w2.B2 = w1.B1;
      w2.B1 = w1.B0;
      w2.B0 = w1.B0; }
      else {
      w2.B7 = w1.B2;
      w2.B6 = w1.B2;
      w2.B5 = w1.B1;
      w2.B4 = w1.B1;
      w2.B3 = w1.B0;
      w2.B2 = w1.B0;
      w2.B1 = 0;
      w2.B0 = 0;
      }
      Soft_I2C_Write(w2);
      Soft_I2C_Write(w2);
      }
     Soft_I2C_Write (0);
     Soft_I2C_Write (0);
  }
    set_addressing (page+1, col);
  //
  for (i = 0; i < leng; i++) { // write string
     if (str[i] == 0) g = 0; else g = str[i] - 32; // NULL detection
     for (h = 0; h <= 4; h++) {  // write letter
      w1 = font_5x8[g*5+h];
      if(page != 2) {
      w2.B7 = w1.B7;
      w2.B6 = w1.B7;
      w2.B5 = w1.B6;
      w2.B4 = w1.B6;
      w2.B3 = w1.B5;
      w2.B2 = w1.B5;
      w2.B1 = w1.B4;
      w2.B0 = w1.B4; }
      else {
      w2.B7 = w1.B6;
      w2.B6 = w1.B6;
      w2.B5 = w1.B5;
      w2.B4 = w1.B5;
      w2.B3 = w1.B4;
      w2.B2 = w1.B4;
      w2.B1 = w1.B3;
      w2.B0 = w1.B3;
      }
      Soft_I2C_Write(w2);
      Soft_I2C_Write(w2);
      }
     Soft_I2C_Write (0);
     Soft_I2C_Write (0);
  }
  Soft_I2C_Stop ();
}

//
void oled_bat () {
   char i, g;
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);       // device addres
   Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
   //

   for(g=0; g<=3; g++) {     // batt drawing
      set_addressing (g, 115);
      for(i=0; i<=10; i++) { Soft_I2C_Write(batt[g*11+i]); }
   }
   Soft_I2C_Stop ();
   return;
 }

//
void oled_voltage(int Voltage) {
   char i, v, u0, u1, u2, u3, m;
   Soft_I2C_Start();
   Soft_I2C_Write(oled_addr);       // device addres
   Soft_I2C_Write(64);              // 0 - continious mode, command; 64 - Co, data
   //
   Voltage /= 10;
   if(Voltage < 300) Voltage = 300;
   else if(Voltage > 420) Voltage = 420;
   Voltage = Voltage - 300; // 0 - 120
   Voltage = Voltage * 32;
   v = Voltage / 120;


   if(v >= 25)      { u0 = v - 24; u1 = 8; u2 = 8; u3 = 8; }
   else if(v >= 17) { u0 = 0; u1 = v - 16; u2 = 8; u3 = 8; }
   else if(v >= 9 ) { u0 = 0; u1 = 0;  u2 = v - 8; u3 = 8; }
   else             { u0 = 0; u1 = 0; u2 = 0; u3 = v ; }

      m = 128;
      m = 255 - (m >> (u0-1)) +1;
      m = m | 0b00000011;
      set_addressing (0, 119);
      Soft_I2C_Write(m);
      Soft_I2C_Write(m);
      Soft_I2C_Write(m);
      m = m | 0b00011111;
      set_addressing (0, 117);
      Soft_I2C_Write(m);
      Soft_I2C_Write(m);
      set_addressing (0, 122);
      Soft_I2C_Write(m);
      Soft_I2C_Write(m);

      m = 128;
      m = 255 - (m >> (u1-1)) + 1;
      set_addressing (1, 117);
      for(i=0; i<=6; i++) Soft_I2C_Write(m);

      m = 128;
      m = 255 - (m >> (u2-1)) + 1;
      set_addressing (2, 117);
      for(i=0; i<=6; i++) Soft_I2C_Write(m);

      m = 128;
      m = 255 - (m >> (u3-1)) +1;
      m = m | 0b11000000;
      set_addressing (3, 117);
      for(i=0; i<=6; i++) Soft_I2C_Write(m);
   //
   Soft_I2C_Stop ();
   return;
}
//
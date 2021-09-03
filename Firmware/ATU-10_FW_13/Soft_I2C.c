
#include "Soft_I2C.h"

#define Delay_I2C Delay_us(15)

// Software I2C connections
#define Soft_I2C_Scl              LATA3_bit
#define Soft_I2C_Sda              LATA2_bit
#define Soft_I2C_Sda_in           PORTA.B2
#define Soft_I2C_Scl_in           PORTA.B3

void Soft_I2C_Init(void) {
    Soft_I2C_Stop();
    return;
 }
 
 void Soft_I2C_Start() {
     Soft_I2C_Scl = 1;
     Delay_I2C;
     Soft_I2C_Sda = 1;
     Delay_I2C;
     Soft_I2C_Sda = 0;
     Delay_I2C;
     Soft_I2C_Scl = 0;
     Delay_I2C;
     return;
 }

char Soft_I2C_Write(char d) {
    char i, ack;
    for(i=0; i<8; i++) {
        Soft_I2C_Sda = d.B7;
        Delay_I2C;
        Soft_I2C_Scl = 1;
        Delay_I2C;
        Soft_I2C_Scl = 0;
        d = d << 1;
    }
    //
    Soft_I2C_Sda = 1; //ACK
    Delay_I2C;
    Soft_I2C_Scl = 1;
    ack = Soft_I2C_Sda_in;
    Delay_I2C;
    Soft_I2C_Scl = 0;
    Delay_I2C;
    return ack;
}

char Soft_I2C_Read(void){
   char i, d = 0;
   for(i=0; i<8; i++){
      d = d << 1;
      d = d + Soft_I2C_Sda_in;
      Soft_I2C_Scl = 1;
      Delay_I2C;
      Soft_I2C_Scl = 0;
      Delay_I2C;
   }
   return d;
}

void Soft_I2C_ACK(void){
   Soft_I2C_Sda = 0;
   Delay_I2C;
   Soft_I2C_Scl = 1;
   Delay_I2C;
   Soft_I2C_Scl = 0;
   Soft_I2C_Sda = 1;
   Delay_I2C;
   return;
}

void Soft_I2C_NACK(void){
   Soft_I2C_Sda = 1;
   Delay_I2C;
   Soft_I2C_Scl = 1;
   Delay_I2C;
   Soft_I2C_Scl = 0;
   Delay_I2C;
   return;
}

void Soft_I2C_Stop() {
   Soft_I2C_Sda = 0;
   Delay_I2C;
   Soft_I2C_Scl = 1;
   Delay_I2C;
   Soft_I2C_Sda = 1;
   Delay_I2C;
   return;
}
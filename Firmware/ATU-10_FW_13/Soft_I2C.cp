#line 1 "D:/Projects/ATU-10/Firmware_1.3/Soft_I2C.c"
#line 1 "d:/projects/atu-10/firmware_1.3/soft_i2c.h"

void Soft_I2C_Init(void);
void Soft_I2C_Start(void);
char Soft_I2C_Write(char);
char Soft_I2C_Read(void);
void Soft_I2C_ACK(void);
void Soft_I2C_NACK(void);
void Soft_I2C_Stop(void);
#line 12 "D:/Projects/ATU-10/Firmware_1.3/Soft_I2C.c"
void Soft_I2C_Init(void) {
 Soft_I2C_Stop();
 return;
 }

 void Soft_I2C_Start() {
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA2_bit  = 1;
  Delay_us(15) ;
  LATA2_bit  = 0;
  Delay_us(15) ;
  LATA3_bit  = 0;
  Delay_us(15) ;
 return;
 }

char Soft_I2C_Write(char d) {
 char i, ack;
 for(i=0; i<8; i++) {
  LATA2_bit  = d.B7;
  Delay_us(15) ;
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 0;
 d = d << 1;
 }

  LATA2_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 1;
 ack =  PORTA.B2 ;
  Delay_us(15) ;
  LATA3_bit  = 0;
  Delay_us(15) ;
 return ack;
}

char Soft_I2C_Read(void){
 char i, d = 0;
 for(i=0; i<8; i++){
 d = d << 1;
 d = d +  PORTA.B2 ;
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 0;
  Delay_us(15) ;
 }
 return d;
}

void Soft_I2C_ACK(void){
  LATA2_bit  = 0;
  Delay_us(15) ;
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 0;
  LATA2_bit  = 1;
  Delay_us(15) ;
 return;
}

void Soft_I2C_NACK(void){
  LATA2_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA3_bit  = 0;
  Delay_us(15) ;
 return;
}

void Soft_I2C_Stop() {
  LATA2_bit  = 0;
  Delay_us(15) ;
  LATA3_bit  = 1;
  Delay_us(15) ;
  LATA2_bit  = 1;
  Delay_us(15) ;
 return;
}

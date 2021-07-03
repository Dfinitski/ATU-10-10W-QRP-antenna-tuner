#line 1 "D:/Projects/ATU-10/Firmware_1.1/pic_init.c"




void pic_init (void) {

 ANSELA = 0;
 ANSELB = 0;
 ANSB0_bit = 1;
 ANSB1_bit = 1;
 ANSB2_bit = 1;
 ANSELC = 0;
 ANSELE = 0;
 ANSELD = 0;

 C1ON_bit = 0;
 C2ON_bit = 0;

 PORTA = 0;
 PORTB = 0;
 PORTC = 0;
 PORTD = 0;
 PORTE = 0;
 LATA = 0b00000000;
 LATB = 0b00000000;
 LATC = 0b00010000;
 LATD = 0b00000110;
 LATE = 0b00000000;
 TRISA = 0b00000000;
 TRISB = 0b00100111;
 TRISC = 0b00000000;
 TRISD = 0b00000000;
 TRISE = 0b00000000;


 ODCA2_bit = 1;
 ODCA3_bit = 1;
 ODCD1_bit = 1;
 ODCD2_bit = 1;


 T0CS0_bit = 0;
 T0CS1_bit = 1;
 T0CS2_bit = 0;
 T016BIT_bit = 1;
 TMR0L = 0xC0;
 TMR0H = 0xE0;
 TMR0IF_bit = 0;
 T0EN_bit = 1;
 TMR0IE_bit = 1;


 PMD0 = 0b00011110;
 PMD1 = 0b11111110;
 PMD2 = 0b01000111;
 PMD3 = 0b01111111;
 PMD4 = 0b1110111;
 PMD5 = 0b11011111;

 GIE_bit = 1;
 Delay_ms (100);
 return;
}

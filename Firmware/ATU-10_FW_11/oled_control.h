#include  "font_5x8.h"

static oled_addr = 0x78;
static char shift_line = 64;  // shift the image down
static char oled_shift = 2;  // shift the image left
static char inversion = 1;
//
void oled_init (void);
void oled_clear(void);
void send_command (char);
void set_addressing (char, char);
void oled_wr_str_s(char, char, char*, char);
void oled_wr_str(char, char, char*, char);
void oled_bat (void);
void oled_voltage (int);
void oled_clear (void);

//
static const char  batt[] = {
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
 //
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
 //
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
 //
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

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
void draw_swr(unsigned int);
void draw_power(unsigned int);
void oled_start(void);
void power_off(void);
void Greating(void);
void Ext_long(void);



#define ON 1
#define OFF 0
#define INT GIE_bit
#define Battery_input 9
#define FWD_input 8
#define REV_input 10
#define _AD_High ADFVR0_bit=0;ADFVR1_bit=1;
#define _AD_Low  ADFVR0_bit=1;ADFVR1_bit=0;
#define Key_out LATD2_bit
#define Key_in PORTD.B2
#define Start_out LATD1_bit
#define Start ~PORTD.B1
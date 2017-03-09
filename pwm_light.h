#ifndef PWM_LIGHT_H
#define PWM_LIGHT_H

#include <wiringPi.h>
#include <softPwm.h>

typedef struct rgb_light_t {
    uint8_t mode;
    uint8_t bits;
    uint32_t speed;
    uint16_t delay;
    int fd;
    uint8_t color[3];
} rgb_light_t;

void pabort(const char *s);
void transfer(rgb_light_t *state, uint8_t r, uint8_t g, uint8_t b);
void rgb_light_off(rgb_light_t *state);
void rgb_light_white(rgb_light_t *state);
void rgb_light_reset(rgb_light_t *state);
void init_rgb_light(rgb_light_t *state, uint8_t r, uint8_t g, uint8_t b);
void shutdown_rgb_light(rgb_light_t *state);

#endif

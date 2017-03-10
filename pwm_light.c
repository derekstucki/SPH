#include "pwm_light.h"

/*
typedef struct rgb_light_t {
    uint8_t mode;
    uint8_t bits;
    uint32_t speed;
    uint16_t delay;
    int fd;
    uint8_t color[3];
} rgb_light_t;
*/

void pabort(const char *s)
{
    perror(s);
    abort();
}

void transfer(rgb_light_t *state, uint8_t r, uint8_t g, uint8_t b)
{
    softPwmWrite(23, (uint16_t)r * 100 / 255);
    softPwmWrite(24, (uint16_t)g * 100 / 255);
    softPwmWrite(25, (uint16_t)b * 100 / 255 / 2);
}

void rgb_light_off(rgb_light_t *state)
{
    transfer(state, 0, 0, 0);
}

void rgb_light_white(rgb_light_t *state)
{
    // TODO Why 4?
    transfer(state, 4, 4, 4);
}

void rgb_light_reset(rgb_light_t *state)
{
    transfer(state, state->color[0], state->color[1], state->color[2]);
}

void init_rgb_light(rgb_light_t *state, uint8_t r, uint8_t g, uint8_t b)
{
    wiringPiSetup();
    softPwmCreate(23, 0, 100);
    softPwmCreate(24, 0, 100);
    softPwmCreate(25, 0, 100);
    transfer(state, state->color[0], state->color[1], state->color[2]);
}

void shutdown_rgb_light(rgb_light_t *state)
{
  rgb_light_off(state);
}

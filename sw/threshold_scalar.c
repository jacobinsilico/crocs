#include <stdint.h>
#include "uart.h"
#include "print.h"
#include "timer.h"
#include "util.h"
#include "image_data.h"  // input[4096]

#define N_PIXELS   4096
#define THRESHOLD  127

uint8_t output[N_PIXELS];

int main() {
    uart_init();
    printf("Running scalar threshold...\n");

    uint32_t start = get_mcycle();

    for (int i = 0; i < N_PIXELS; i++) {
        output[i] = (input[i] >= THRESHOLD) ? 255 : 0;
    }

    uint32_t end = get_mcycle();
    printf("Scalar thresholding done in %d cycles\n", end - start);

    uart_write_flush();

    return 1;  // sets eoc to 1
}
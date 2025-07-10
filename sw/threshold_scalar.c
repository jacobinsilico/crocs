#include <stdint.h>
#include "lib/inc/uart.h"
#include "lib/inc/print.h"
#include "lib/inc/timer.h"
#include "lib/inc/util.h"
#include "image_data.h"  // image_data[784]

#define N_PIXELS   196
#define THRESHOLD  127

// Explicit memory-mapped locations in SRAM
#define INPUT_ADDR  ((volatile uint8_t *) 0x10000000)
#define OUTPUT_ADDR ((volatile uint8_t *) 0x10000400)

int main() {
    uart_init();
    printf("Running scalar threshold on 28x28 image...\n");

    // Copy image from ROM (linked .rodata) into SRAM
    for (int i = 0; i < N_PIXELS; i++) {
        INPUT_ADDR[i] = image_data[i];
    }

    uint32_t start = get_mcycle();

    // Perform scalar thresholding
    for (int i = 0; i < N_PIXELS; i++) {
        uint8_t px = INPUT_ADDR[i];
        OUTPUT_ADDR[i] = (px >= THRESHOLD) ? 255 : 0;
    }

    uint32_t end = get_mcycle();

    printf("Scalar thresholding done in %d cycles\n", end - start);

    uart_write_flush();
    return 1;  // sets EOC = 1
}
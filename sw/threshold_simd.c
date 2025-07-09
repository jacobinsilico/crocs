#include <stdint.h>
#include "uart.h"
#include "print.h"
#include "timer.h"
#include "util.h"
#include "image_data.h"

#define N_PIXELS   784
#define THRESHOLD  127

// Memory-mapped addresses in SRAM
#define INPUT_ADDR   ((volatile uint8_t *) 0x10000000)
#define OUTPUT_ADDR  ((volatile uint8_t *) 0x10000400)

int main() {
    uart_init();
    printf("Running SIMD threshold on 28x28 image...\n");

    // Copy image to SRAM
    for (int i = 0; i < N_PIXELS; i++) {
        INPUT_ADDR[i] = image_data[i];
    }

    uint32_t start = get_mcycle();

    // SIMD threshold in chunks of 4 pixels (1 word)
    for (int i = 0; i < N_PIXELS; i += 4) {
        // Set up registers:
        // - x11: address of 4 input pixels (base pointer)
        // - x10: loaded 4-pixel vector
        // - x12: result of threshold operation
        // - vst writes back to OUTPUT_ADDR[i]

        register uint32_t result asm("x12");  // not strictly needed, but allows optional C-side verification

        asm volatile (
            "mv x11, %0       \n"             // x11 = address of input[i]
            ".word 0x00b5850b \n"             // vld x10, 0(x11)
            ".word 0x07f5530b \n"             // vthreshi x12, x10, 127
            ".word 0x00c5a50b \n"             // vst x12, 0(x11)
            : "=r"(result)
            : "r"(INPUT_ADDR + i)
            : "x10", "x11", "x12"
        );
    }

    uint32_t end = get_mcycle();
    printf("SIMD thresholding done in %d cycles\n", end - start);
    uart_write_flush();

    return 1;
}

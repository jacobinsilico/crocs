#include <stdint.h>
#include "uart.h"
#include "print.h"
#include "timer.h"
#include "util.h"
#include "image_data.h"

#define N_PIXELS   4096
#define THRESHOLD  127

uint32_t *input32  = (uint32_t *)input;
uint32_t output32[N_PIXELS / 4];

int main() {
    uart_init();
    printf("Running SIMD threshold...\n");

    uint32_t start = get_mcycle();

    for (int i = 0; i < N_PIXELS / 4; i++) {
        // vld x10, 0(x11)
        // x11 = address of input[i]
        register uint32_t result asm("x12");

        asm volatile (
            "mv x11, %1       \n"
            ".word 0xYOUR_VLD_ENCODING   \n"   // vld x10, 0(x11)
            ".word 0xYOUR_VTHRESHI_ENCODING \n" // vthreshi x12, x10, THRESHOLD
            ".word 0xYOUR_VST_ENCODING   \n"   // vst x12, 0(x11)  (or store to another buffer)
            : "=r"(result)
            : "r"(&input32[i])
            : "x10", "x11", "x12"
        );

        output32[i] = result;  // store locally (optional — hardware already stores via vst)
    }

    uint32_t end = get_mcycle();
    printf("SIMD thresholding done in %d cycles\n", end - start);

    uart_write_flush();
    return 1;
}

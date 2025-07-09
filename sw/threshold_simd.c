#include <stdint.h>
#include "lib/inc/uart.h"
#include "lib/inc/print.h"
#include "lib/inc/timer.h"
#include "lib/inc/util.h"
#include "image_data.h"

#define N_PIXELS   784
#define THRESHOLD  127

// Memory-mapped addresses in SRAM
#define INPUT_ADDR   ((volatile uint8_t *) 0x10000000)
#define OUTPUT_ADDR  ((volatile uint8_t *) 0x10000400)

int main() {
    uart_init();
    printf("Running SIMD threshold on 28x28 image...\n");

    // Copy image to SRAM input buffer
    for (int i = 0; i < N_PIXELS; i++) {
        INPUT_ADDR[i] = image_data[i];
    }

    uint32_t start = get_mcycle();

    for (int i = 0; i < N_PIXELS; i += 4) {
        asm volatile (
            "mv x11, %[in_addr]     \n"       // x11 = input address
            ".word 0x00b5850b        \n"       // vld x10, 0(x11)
            ".word 0x07f5530b        \n"       // vthreshi x12, x10, 127
            "mv x11, %[out_addr]    \n"       // x11 = output address
            ".word 0x00c5a50b        \n"       // vst x12, 0(x11)
            :
            : [in_addr] "r"(INPUT_ADDR + i),
              [out_addr] "r"(OUTPUT_ADDR + i)
            : "x10", "x11", "x12"
        );

        if ((i / 4) % 20 == 0) {
            printf("Processed %d pixels...\n", i + 4);
        }
    }

    uint32_t end = get_mcycle();
    printf("SIMD thresholding done in %d cycles\n", end - start);

    return 1;
}

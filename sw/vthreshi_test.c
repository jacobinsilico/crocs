#include <stdint.h>
#include "lib/inc/uart.h"
#include "lib/inc/print.h"

int main() {
    uart_init();
    printf("Starting vthreshi test...\n");

    register uint32_t input  asm("x10") = 0x7F807F20;  // [127,128,127,32]
    register uint32_t output asm("x12") = 0;

    asm volatile(
        ".word 0x07f5530b \n"   // vthreshi x12, x10, 127
        : "=r"(output)
        : "r"(input)
        : "x10", "x12"
    );

    printf("vthreshi test done. Result in x12: %08x\n", output);
    uart_write_flush();
    return 1;
}

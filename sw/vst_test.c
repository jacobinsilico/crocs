#include <stdint.h>
#include "lib/inc/uart.h"
#include "lib/inc/print.h"

int main() {
    uart_init();
    printf("Starting vst test...\n");

    register uint32_t input asm("x12") = 0xFFAA5511;
    volatile uint32_t *pixel_out = (uint32_t *)0x10000010;

    asm volatile(
        "mv x11, %[addr] \n"
        ".word 0x00c5a50b \n"   // vst x12, 0(x11)
        :
        : [addr] "r"(pixel_out), "r"(input)
        : "x11", "x12"
    );

    printf("vst test done. Output = %08x\n", *pixel_out);
    uart_write_flush();
    return 1;
}

#include <stdint.h>
#include "lib/inc/uart.h"
#include "lib/inc/print.h"

int main() {
    uart_init();
    printf("Starting vld test...\n");

    // Memory at 0x10000000 contains 4 pixels: 10, 20, 30, 40
    volatile uint32_t *pixel_mem = (uint32_t *)0x10000000;
    *pixel_mem = 0x281E140A;  // bytes = 40, 30, 20, 10

    register uint32_t result asm("x10") = 0;

    // Load 4 bytes from memory into x10 using your custom vld
    asm volatile(
        "mv x11, %[addr] \n"
        ".word 0x00b5850b \n"   // vld x10, 0(x11)
        : [out] "=r"(result)
        : [addr] "r"(pixel_mem)
        : "x10", "x11"
    );

    printf("vld test done. Result in x10: %08x\n", result);
    uart_write_flush();
    return 1;
}

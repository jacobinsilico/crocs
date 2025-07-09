oseda-2025.01:[sw]$ make bin/threshold_simd.elf
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c threshold_simd.c -o threshold_simd.c.o
threshold_simd.c: In function 'main':
threshold_simd.c:36:9: error: 'asm' specifier for variable 'result' conflicts with 'asm' clobber list
   36 |         asm volatile (
      |         ^~~
make: *** [Makefile:58: threshold_simd.c.o] Error 1

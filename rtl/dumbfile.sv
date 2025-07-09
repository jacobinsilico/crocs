oseda-2025.01:[sw]$ make test-threshold
mkdir -p bin
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c threshold_scalar.c -o threshold_scalar.c.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c crt0.S -o crt0.S.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c lib/src/gpio.c -o lib/src/gpio.c.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c lib/src/print.c -o lib/src/print.c.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c lib/src/timer.c -o lib/src/timer.c.o
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c lib/src/uart.c -o lib/src/uart.c.o
riscv64-unknown-elf-gcc -o bin/threshold_scalar.elf threshold_scalar.c.o crt0.S.o lib/src/gpio.c.o lib/src/print.c.o lib/src/timer.c.o lib/src/uart.c.o threshold_scalar.c image_data.h -static -nostartfiles -lm -lgcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Tlink.ld
/foss/tools/riscv-gnu-toolchain/lib/gcc/riscv64-unknown-elf/14.2.0/../../../../riscv64-unknown-elf/bin/ld: /tmp/ccOSFzkW.o: in function `main':
threshold_scalar.c:(.text.startup+0x0): multiple definition of `main'; threshold_scalar.c.o:threshold_scalar.c:(.text.startup+0x0): first defined here
/foss/tools/riscv-gnu-toolchain/lib/gcc/riscv64-unknown-elf/14.2.0/../../../../riscv64-unknown-elf/bin/ld: /tmp/ccOSFzkW.o:(.rodata+0x0): multiple definition of `image_data'; threshold_scalar.c.o:(.rodata+0x0): first defined here
/foss/tools/riscv-gnu-toolchain/lib/gcc/riscv64-unknown-elf/14.2.0/../../../../riscv64-unknown-elf/bin/ld: warning: bin/threshold_scalar.elf has a LOAD segment with RWX permissions
collect2: error: ld returned 1 exit status
make: *** [Makefile:64: bin/threshold_scalar.elf] Error 1
rm crt0.S.o lib/src/gpio.c.o lib/src/print.c.o lib/src/uart.c.o lib/src/timer.c.o threshold_scalar.c.o

vlsi2_21fs25@tardis-a35:~/VLSI2_Project/croc_simd/sw$ make test-threshold
mkdir -p bin
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c threshold_scalar.c -o threshold_scalar.c.o
make: riscv64-unknown-elf-gcc: Command not found
make: *** [Makefile:58: threshold_scalar.c.o] Error 127
vlsi2_21fs25@tardis-a35:~/VLSI2_Project/croc_simd/sw$ make bin/threshold_scalar.elf
riscv64-unknown-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -static -std=gnu99 -Os -nostdlib -fno-builtin -ffreestanding -Iinclude -Ilib/inc -I/home/vlsi2_21fs25/VLSI2_Project/croc_simd/sw -c threshold_scalar.c -o threshold_scalar.c.o
make: riscv64-unknown-elf-gcc: Command not found
make: *** [Makefile:58: threshold_scalar.c.o] Error 127
vlsi2_21fs25@tardis-a35:~/VLSI2_Project/croc_simd/sw$ ^C
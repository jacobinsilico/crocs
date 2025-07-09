oseda-2025.01:[verilator]$ ./obj_dir/Vtb_croc_soc +binary="../sw/bin/threshold_simd.hex"
Running program: ../sw/bin/threshold_simd.hex
ClkFrequency:         20MHz
UartRealBaudRate:     125000
@     41100ns | [JTAG] Initialization success
@     41100ns | [JTAG] Writing 0x12345678 to 0x10000000
@     93650ns | [JTAG] Read 0x12345678 from 0x10000000
@     93650ns | [JTAG] Read back correct data
@     93650ns | [JTAG] Loading binary from ../sw/bin/threshold_simd.hex
@     95950ns | [JTAG] Writing to memory @10000000 
@    148850ns | [JTAG] Writing to memory @10000058 
@    930850ns | [JTAG] Writing to memory @100005a4 
@   1443750ns | [CORE] Start fetching instructions
@   1446050ns | [JTAG] Halting hart 0... 
@   1459400ns | [JTAG] Halted
@   1461700ns | [JTAG] Resumed hart 0 
@   1461700ns | [CORE] Wait for end of code...
@   4750400ns | [UART] Running SIMD threshold on 28x28 image...
@   4750400ns | [UART] raw: '{'h52, 'h75, 'h6e, 'h6e, 'h69, 'h6e, 'h67, 'h20, 'h53, 'h49, 'h4d, 'h44, 'h20, 'h74, 'h68, 'h72, 'h65, 'h73, 'h68, 'h6f, 'h6c, 'h64, 'h20, 'h6f, 'h6e, 'h20, 'h32, 'h38, 'h78, 'h32, 'h38, 'h20, 'h69, 'h6d, 'h61, 'h67, 'h65, 'h2e, 'h2e, 'h2e, 'ha} 


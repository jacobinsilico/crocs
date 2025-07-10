oseda-2025.01:[verilator]$ ./obj_dir/Vtb_croc_soc +binary="../sw/bin/threshold_simd.hex"
Running program: ../sw/bin/threshold_simd.hex
ClkFrequency:         10MHz
UartRealBaudRate:     125000
@     82200ns | [JTAG] Initialization success
@     82200ns | [CORE] Start fetching instructions
@     86800ns | [JTAG] Halting hart 0... 
@    113500ns | [JTAG] Halted
@    113500ns | [JTAG] Writing 0x12345678 to 0x10000000
@    218600ns | [JTAG] Read 0x12345678 from 0x10000000
@    218600ns | [JTAG] Read back correct data
@    218600ns | [JTAG] Loading binary from ../sw/bin/threshold_simd.hex
@    223200ns | [JTAG] Writing to memory @10000000 
@    324400ns | [JTAG] Writing to memory @10000054 
@   2270200ns | [JTAG] Writing to memory @100006f0 
@   4243600ns | [JTAG] Resumed hart 0 
@  12399900ns | [UART] f憞������~��f��`~��fx�����`����x��x���f��xf�����������f~~��
@  12399900ns | [UART] raw: '{'h18, 'h66, 'he6, 'h86, 'h9e, 'hf8, 'h9e, 'h86, 'h9e, 'hf8, 'h9e, 'h7e, 'h6, 'h98, 'h98, 'h66, 'h98, 'he6, 'h98, 'h60, 'h6, 'h18, 'h7e, 'h80, 'h9e, 'h18, 'h66, 'h78, 'h1e, 'h6, 'h9e, 'hfe, 'h9e, 'he0, 'h9e, 'h60, 'h6, 'h98, 'h9e, 'hf8, 'h9e, 'h0, 'h18, 'h78, 'h80, 'h18, 'h86, 'h78, 'h80, 'h18, 'h98, 'h98, 'h66, 'h9e, 'h6, 'he6, 'h78, 'h66, 'h86, 'h86, 'hf8, 'h86, 'hf8, 'h86, 'h98, 'h80, 'h6, 'h86, 'he0, 'he6, 'h9e, 'h66, 'h6, 'h7e, 'h0, 'h18, 'h7e, 'hfe, 'h9e, 'h0, 'h18, 'hf8} 


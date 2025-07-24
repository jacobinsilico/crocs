// Copyright 2023 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51

// gives us the `FF(...) macro making it easy to have properly defined flip-flops
`include "common_cells/registers.svh"

// simple ROM
module user_rom #(
  /// The OBI configuration for all ports.
  parameter obi_pkg::obi_cfg_t           ObiCfg      = obi_pkg::ObiDefaultConfig,
  /// The request struct.
  parameter type                         obi_req_t   = logic,
  /// The response struct.
  parameter type                         obi_rsp_t   = logic
) (
  /// Clock
  input  logic clk_i,
  /// Active-low reset
  input  logic rst_ni,

  /// OBI request interface
  input  obi_req_t obi_req_i,
  /// OBI response interface
  output obi_rsp_t obi_rsp_o
);

  logic [ObiCfg.DataWidth-1:0] rsp_data; // data sent back
  logic obi_err;
  logic we_d, we_q;
  logic req_d, req_q;
  logic [3:0] word_addr_d, word_addr_q;  // relevant part of the word-aligned address
  logic [ObiCfg.IdWidth-1:0] id_d, id_q; // id of the request, must be same for response

  // Step 1: Request phase
  // grant the request (ROM is always ready so this can be assigned directly)
  assign obi_rsp_o.gnt = obi_req_i.req;
  // safe important info
  assign id_d          = obi_req_i.a.aid;
  assign word_addr_d   = obi_req_i.a.addr[4:2];
  assign we_d          = obi_req_i.a.we;
  assign req_d         = obi_req_i.req;

  `FF(req_q, req_d, '0, clk_i, rst_ni)
  `FF(we_q, we_d, '0, clk_i, rst_ni)
  `FF(word_addr_q, word_addr_d, '0, clk_i, rst_ni)
  `FF(id_q, id_d, '0, clk_i, rst_ni)

  // Step 2: Response phase
  // On the next cycle, send the response back with the same ID and the data
  always_comb begin
    obi_rsp_o.r.rdata      = rsp_data;
    obi_rsp_o.r.rid        = id_q;
    obi_rsp_o.r.err        = 1'b0;
    obi_rsp_o.r.r_optional = '0;
    obi_rsp_o.rvalid       = req_q;
    obi_rsp_o.r.err        = obi_err;
  end

  always_comb begin
    rsp_data = '0;
    obi_err  = '0;

    if (req_q) begin
      if (~we_q) begin
        case(word_addr_q)
          //TODO: find a cool yoshi fact instead -> Japanese Yoshi eats Dolphins?
          4'b0000: rsp_data= 32'h4A616B75; // Should be: "Jakub Szkudlarek and Aditya Kulkarni"
          4'b0001: rsp_data= 32'h6220537A;
          4'b0010: rsp_data= 32'h6B75646C;
          4'b0011: rsp_data= 32'h6172656B;
          4'b0100: rsp_data= 32'h20616E64;
          4'b0101: rsp_data= 32'h20416469;
          4'b0111: rsp_data= 32'h74796120;
          4'b1000: rsp_data= 32'h4B756C6B;
          4'b1001: rsp_data= 32'h61726E69;
          default: rsp_data= 32'hDEADBEEF;
        endcase
      end else begin
        obi_err = 1'b1;
      end
    end
  end

endmodule
module threshold_tb_common;
  // Common parameters and tasks
  localparam WIDTH = 64;
  localparam HEIGHT = 64;
  localparam THRESHOLD = 8'd128;
  
  task automatic load_image(input string filename, output reg [7:0] img[0:HEIGHT-1][0:WIDTH-1]);
    $readmemh(filename, img);
  endtask

   int f;

   
  task automatic dump_pgm(input string filename, input reg [7:0] img[0:HEIGHT-1][0:WIDTH-1]); 
    f = $fopen(filename, "w");
    $fwrite(f, "P2\n%d %d\n255\n", WIDTH, HEIGHT);
    for (int i=0; i<HEIGHT; i++) begin
      for (int j=0; j<WIDTH; j++) $fwrite(f, "%0d ", img[i][j]);
      $fwrite(f, "\n");
    end
    $fclose(f);
  endtask
endmodule

// SCALAR TESTBENCH
module threshold_scalar_tb;
  import threshold_tb_common::*;
  
  // Clock and reset
  bit clk = 0;
  always #5 clk = ~clk;
  
  // DUT Interface
  logic        scalar_start;
  logic [7:0]  scalar_pixel_in;
  logic [7:0]  scalar_pixel_out;
  logic        scalar_done;
  
  // Image storage
  reg [7:0] image_in [0:HEIGHT-1][0:WIDTH-1];
  reg [7:0] image_out [0:HEIGHT-1][0:WIDTH-1];
  
  // DUT
  threshold_scalar dut (
    .clk(clk),
    .pixel_in(scalar_pixel_in),
    .threshold(THRESHOLD),
    .pixel_out(scalar_pixel_out),
    .start(scalar_start),
    .done(scalar_done)
  );
  
  // Test
  initial begin
    load_image("image.hex", image_in);
    
    // Process image
    scalar_start = 1;
    for (int i=0; i<HEIGHT; i++) begin
      for (int j=0; j<WIDTH; j++) begin
        scalar_pixel_in = image_in[i][j];
        @(posedge clk);
        image_out[i][j] = scalar_pixel_out;
      end
    end
    scalar_start = 0;
    
    dump_pgm("scalar_out.pgm", image_out);
    $display("Scalar processing completed");
    $finish;
  end
endmodule

// SIMD TESTBENCH
module threshold_simd_tb;
  import threshold_tb_common::*;
  
  // Clock and reset
  bit clk = 0;
  always #5 clk = ~clk;
  
  // DUT Interface
  logic        simd_start;
  logic [31:0] simd_pixels_in;  // 4 pixels packed
  logic [31:0] simd_pixels_out;
  logic        simd_done;
  
  // Image storage
  reg [7:0] image_in [0:HEIGHT-1][0:WIDTH-1];
  reg [7:0] image_out [0:HEIGHT-1][0:WIDTH-1];
  
  // DUT
  threshold_simd dut (
    .clk(clk),
    .pixels_in(simd_pixels_in),
    .threshold(THRESHOLD),
    .pixels_out(simd_pixels_out),
    .start(simd_start),
    .done(simd_done)
  );
  
  // Test
  initial begin
    load_image("image.hex", image_in);
    
    // Process image
    simd_start = 1;
    for (int i=0; i<HEIGHT; i++) begin
      for (int j=0; j<WIDTH; j+=4) begin  // Step by 4 for SIMD
        // Pack 4 pixels
        simd_pixels_in = {image_in[i][j+3], image_in[i][j+2], 
                         image_in[i][j+1], image_in[i][j]};
        
        @(posedge clk);
        
        // Unpack results
        {image_out[i][j+3], image_out[i][j+2],
         image_out[i][j+1], image_out[i][j]} = simd_pixels_out;
      end
    end
    simd_start = 0;
    
    dump_pgm("simd_out.pgm", image_out);
    $display("SIMD processing completed");
    $finish;
  end
endmodule

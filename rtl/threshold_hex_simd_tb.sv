module threshold_hex_simd_tb;

  logic clk;
  int cycle_count = 0;

  // Clock generation (adjust period as needed)
  initial clk = 0;
  always #5 clk = ~clk;  // 10 time units period

  // Declare constants and parameters
  localparam int WIDTH  = 64;     // Set to original or larger if necessary
  localparam int HEIGHT = 64;    // Set to original or larger if necessary

  localparam byte THRESHOLD = 8'd128;
  localparam int SIMD_WIDTH = 4; // Number of pixels processed at once
  // we try to test timing
  vluint64_t main_time =0;
  double sc_time_stamp() {return main_time;}
  // Use unsigned for image data
  reg [7:0] image_inp [0:HEIGHT-1][0:WIDTH-1];  // Input image (unsigned 8-bit)
  reg [7:0] image_op [0:HEIGHT-1][0:WIDTH-1];   // Output image (unsigned 8-bit)

  string input_file = "image.hex";  // Path to input file

  int fp;  // File pointer used by $fopen() and related file I/O tasks

  // Count cycles
  always @(posedge clk) begin
    cycle_count++;
  end


  // Read input .hex file
  initial begin
    // Read the image from the hex file into the array
    $readmemh(input_file, image_inp);
    $display("Loaded image from %s", input_file);
  end

  // Perform thresholding using SIMD-like processing
  initial begin
    // Delay to simulate realistic processing time
    #10;

    // Iterate over each row and process SIMD_WIDTH pixels at a time
    for (int row = 0; row < HEIGHT; row++) begin
      for (int col = 0; col < WIDTH; col += SIMD_WIDTH) begin
        // Load SIMD_WIDTH pixels (8 at once)
        reg [7:0] pixels[SIMD_WIDTH-1:0];
        
        // Load pixels into the SIMD array
        for (int k = 0; k < SIMD_WIDTH; k++) begin
          pixels[k] = image_inp[row][col + k];
        end

        // Perform SIMD thresholding (compare each pixel to the threshold)
        for (int k = 0; k < SIMD_WIDTH; k++) begin
          // Apply the threshold: If the pixel is greater than the threshold, set it to 255, otherwise 0
          image_op[row][col + k] = (pixels[k] > THRESHOLD) ? 8'd255 : 8'd0;
          while (!done) {
            top->clk
          }
        end
      end
    end

    $display("SIMD-style thresholding complete.");
    dump_pgm("simd_threshold_out.pgm", image_op);  // Save the thresholded image to a .pgm file

    wait (done);  // or however your DUT signals completion

    $display("Simulation completed in %0d cycles", cycle_count);
    $finish;
  end

  int fout;
  // Dump image as ASCII PGM (Portable Grayscale Map)
  task dump_pgm(input string filename, input reg [7:0] img[0:HEIGHT-1][0:WIDTH-1]);
    fout = $fopen(filename, "w");
    if (!fout) begin
      $display("ERROR: Cannot open file %s", filename);
      return;
    end

    // Write the PGM header for the ASCII format (P2)
    $fwrite(fout, "P2\n%d %d\n255\n", WIDTH, HEIGHT);

    // Write pixel data to the file
    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        $fwrite(fout, "%0d ", img[i][j]);
      end
      $fwrite(fout, "\n");
    end

    // Close the file and display a success message
    $fclose(fout);
    $display("Output written to %s", filename);
  endtask

endmodule

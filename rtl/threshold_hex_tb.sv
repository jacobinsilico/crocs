module threshold_hex_tb;
  // Declare constants and parameters
  localparam int WIDTH  = 64;
  localparam int HEIGHT = 64;

  localparam byte THRESHOLD = 8'd128;

  // Use unsigned for image data
  reg [7:0] image_inp [0:HEIGHT-1][0:WIDTH-1];  // Input image (unsigned 8-bit)
  reg [7:0] image_op [0:HEIGHT-1][0:WIDTH-1];   // Output image (unsigned 8-bit)

  string input_file = "image.hex";

  int fp;

  initial begin
    // Load the image from the hex file into the array
    $readmemh(input_file, image_inp);

    $display("Loaded image from %s", input_file);
  end

  // Apply threshold
  initial begin
    // Delay to simulate processing time
    #10;

    // Iterate over each pixel in the image
    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        // If pixel value > threshold, set to 255 (white), otherwise 0 (black)
        image_op[i][j] = (image_inp[i][j] > THRESHOLD) ? 8'd255 : 8'd0;
      end
    end

    $display("Thresholding complete.");
    dump_pgm("threshold_out.pgm", image_op);
    $finish;
  end

  int fout;

  // Dump image as ASCII PGM (Portable Grayscale Map)
  task dump_pgm(input string filename, input reg [7:0] img[0:HEIGHT-1][0:WIDTH-1]);
    fout = $fopen(filename, "w");
    if (!fout) begin
      $display("ERROR: Cannot open output file %s", filename);
      return;
    end

    // Write PGM header (P2 format)
    $fwrite(fout, "P2\n%d %d\n255\n", WIDTH, HEIGHT);

    // Write pixel data
    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        $fwrite(fout, "%0d ", img[i][j]);
      end
      $fwrite(fout, "\n");
    end

    $fclose(fout);
    $display("Thresholded image written to %s", filename);
  endtask

endmodule

`timescale 1ns/1ps
// All delays (#) are interpreted with this resolution (1ns) and precision (1ps)

module threshold_simd_tb;
// Declares the top-level module for the testbench

  localparam int WIDTH  = 256;
  localparam int HEIGHT = 256;
  // WIDTH and HEIGHT: Dimensions of the grayscale image.

  localparam byte THRESHOLD = 8'd128;
  // THRESHOLD: The value used to binarize pixels. If a pixel is > 128, it becomes 255 (white), else 0 (black).

  localparam int SIMD_WIDTH = 8;
  // SIMD_WIDTH: number of pixels processed at once

  byte image_in [0:HEIGHT-1][0:WIDTH-1];
  byte image_out[0:HEIGHT-1][0:WIDTH-1];
  // 2D arrays of 8-bit values (byte) to store the input and output images.
  // Represent the full grayscale image as a matrix

  string input_file = "image.hex";
  // input_file: Path to the image file in hex format (each line = 1 pixel in hex).

  int fp;
  // fp: File pointer used by $fopen() and related file I/O tasks.

  // Read input .hex file
  initial begin
  // initial: Runs once at time 0 in simulation. We use it to load image data.

    fp = $fopen(input_file, "r");
    if (!fp) begin
      $display("ERROR: Cannot open file %s", input_file);
      $finish;
    end
    // Opens the image.hex file for reading.
    // If the file cannot be opened, the simulation exits with an error.


    int i = 0;
    byte val;
    // Declares a loop counter i and a temporary val to hold each pixel read.

    // Reads the file line by line
    // $fgets(line, fp): reads a line of text into line.
    // $sscanf(line, "%2x", val): parses 2-digit hex value into val.
    // The line number i is used to map to 2D coordinates:
    // i / WIDTH: row index
    // i % WIDTH: column index
    // Stores each pixel into image_in[row][col].

    while (!$feof(fp) && i < WIDTH * HEIGHT) begin
      string line;
      $fgets(line, fp);
      $sscanf(line, "%2x", val);
      image_in[i / WIDTH][i % WIDTH] = val;
      i++;
    end
    $fclose(fp);

    // Closes the file and prints how many pixels were read (should be 65536 for 256×256).

  end

  // Perform thresholding using pseudo-SIMD
  initial begin
  // This second initial block starts after 10ns of delay to simulate some realistic processing lag.
    #10;

    for (int row = 0; row < HEIGHT; row++) begin
      for (int col = 0; col < WIDTH; col += SIMD_WIDTH) begin
      // Loop over all rows
      // Inner loop processes SIMD_WIDTH (8) pixels at once per iteration

        // Load 8 pixels (SIMD load)
        byte pixels[SIMD_WIDTH];
        for (int k = 0; k < SIMD_WIDTH; k++) begin
          pixels[k] = image_in[row][col + k];
        end
        // Load 8 adjacent pixels from the row into a temporary pixels[] array

        // SIMD compare + select
        for (int k = 0; k < SIMD_WIDTH; k++) begin
          image_out[row][col + k] = (pixels[k] > THRESHOLD) ? 8'd255 : 8'd0;
        end

        // Apply thresholding to all 8 pixels:
        // If pixel > 128 → set to 255 (white)
        // Else → set to 0 (black)

        // SIMD store done automatically above
      end
    end

    $display("SIMD-style thresholding complete");
    dump_pgm("simd_threshold_out.pgm", image_out);
    $finish;
  end

  // Dump image as ASCII PGM
  task dump_pgm(input string filename, input byte img[0:HEIGHT-1][0:WIDTH-1]);
    int fout = $fopen(filename, "w");
    $fwrite(fout, "P2\n%d %d\n255\n", WIDTH, HEIGHT);
    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        $fwrite(fout, "%0d ", img[i][j]);
      end
      $fwrite(fout, "\n");
    end
  
    // Declares a task that writes a 2D grayscale image to a .pgm file.
    // P2 format = ASCII grayscale (readable in viewers like ImageMagick, GIMP, etc.).
    // Opens the output file.
    // If file cannot be opened, prints error and returns early.
  
    $fclose(fout);
    $display("Output written to %s", filename);
  endtask

  // Close the file and show confirmation

endmodule

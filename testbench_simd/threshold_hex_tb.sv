`timescale 1ns/1ps
// All delays (#) are interpreted with this resolution (1ns) and precision (1ps)


module threshold_hex_tb;
// Declares the top-level module for the testbench

  localparam int WIDTH  = 256;
  localparam int HEIGHT = 256;
  // WIDTH and HEIGHT: Dimensions of the grayscale image.

  localparam byte THRESHOLD = 8'd128;
  // THRESHOLD: The value used to binarize pixels. If a pixel is > 128, it becomes 255 (white), else 0 (black).

  byte image_in [0:HEIGHT-1][0:WIDTH-1];
  byte image_out[0:HEIGHT-1][0:WIDTH-1];
  // 2D arrays of 8-bit values (byte) to store the input and output images.
  // Represent the full grayscale image as a matrix


  string input_file = "image.hex";
  // input_file: Path to the image file in hex format (each line = 1 pixel in hex).

  int fp;
  // fp: File pointer used by $fopen() and related file I/O tasks.


  // Read .hex file
  initial begin
  // initial: Runs once at time 0 in simulation. We use it to load image data.

    fp = $fopen(input_file, "r");
    if (!fp) begin
      $display("ERROR: Cannot open input file %s", input_file);
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

    $display("Loaded %0d pixels", i);

    // Closes the file and prints how many pixels were read (should be 65536 for 256×256).

  end


  // Apply threshold
  initial begin
  // This second initial block starts after 10ns of delay to simulate some realistic processing lag.
    #10;

    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        image_out[i][j] = (image_in[i][j] > THRESHOLD) ? 8'd255 : 8'd0;
      end
    end
    
    // Performs pixel-wise thresholding:
    // If pixel > threshold → white (255)
    // Else → black (0)
    // Stores result in image_out.


    $display("Thresholding complete.");
    dump_pgm("threshold_out.pgm", image_out);
    $finish;

    // Calls dump_pgm to save the result.
    // Then ends the simulation.

  end


  // Dump image as ASCII PGM (portable grayscale map)
  task dump_pgm(input string filename, input byte img[0:HEIGHT-1][0:WIDTH-1]);
    int fout = $fopen(filename, "w");
    if (!fout) begin
      $display("ERROR: Cannot open output file %s", filename);
      return;
    end

  // Declares a task that writes a 2D grayscale image to a .pgm file.
  // P2 format = ASCII grayscale (readable in viewers like ImageMagick, GIMP, etc.).
  // Opens the output file.
  // If file cannot be opened, prints error and returns early.

    $fwrite(fout, "P2\n%d %d\n255\n", WIDTH, HEIGHT);

    // Writes the PGM header:
    // P2: ASCII grayscale
    // Dimensions
    // Max pixel value (255)

    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        $fwrite(fout, "%0d ", img[i][j]);
      end
      $fwrite(fout, "\n");
    end

    // Writes each row of pixels to the file in ASCII format.

    $fclose(fout);
    $display("Thresholded image written to %s", filename);
  endtask

  // Closes the file and prints a success message.

endmodule

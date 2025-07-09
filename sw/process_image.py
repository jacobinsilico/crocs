from PIL import Image

# Parameters
input_image = "lena.png"
output_header = "image_data.h"
width, height = 64, 64

# Load and process image
img = Image.open(input_image).convert("L")  # L = 8-bit grayscale
img = img.resize((width, height))
pixels = list(img.getdata())  # row-major order
assert len(pixels) == width * height

# Write to C header
with open(output_header, "w") as f:
    f.write("// Auto-generated image data from lena.png\n")
    f.write("#ifndef IMAGE_DATA_H_\n#define IMAGE_DATA_H_\n\n")
    f.write("#include <stdint.h>\n\n")
    f.write(f"const uint8_t input[{width * height}] = {{\n")

    for i, px in enumerate(pixels):
        f.write(f"  {px},")
        if (i + 1) % 16 == 0:
            f.write("\n")

    f.write("};\n\n#endif // IMAGE_DATA_H_\n")

print(f"[✓] Saved {width}x{height} grayscale image as {output_header}")
from PIL import Image
import numpy as np

def convert_image_to_hex(image_path, output_hex_path):
    img = Image.open(image_path).convert('L')  # Grayscale
    img = img.resize((256, 256))  # Resize to 256x256
    img_data = np.array(img, dtype=np.uint8).flatten()

    with open(output_hex_path, 'w') as f:
        for pixel in img_data:
            f.write(f"{pixel:02x}\n")  # hex format, one per line

    print("Saved 8x8 grayscale image as hex to", output_hex_path)
    return img

if __name__ == "__main__":
    img = convert_image_to_hex("test_image1.jpg", "image_256.hex")
    img.show()  # Optional preview
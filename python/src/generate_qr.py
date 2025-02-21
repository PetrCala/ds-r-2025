import qrcode
import sys

def generate_qr(data, filename="qrcode.png"):
    """Generate and save a QR code from the given data."""
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=2,
    )
    qr.add_data(data)
    qr.make(fit=True)
    img = qr.make_image(fill="black", back_color="white")
    img.save(filename)
    print(f"QR code saved as {filename}")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python generate_qr.py '<text_or_url>'")
        sys.exit(1)

    input_data = sys.argv[1]
    generate_qr(input_data)

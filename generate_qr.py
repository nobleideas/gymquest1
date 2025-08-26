import qrcode
import os

def generate_qr(link, filename="qrcode.png", directory="qrcodes"):
    # Make sure the directory exists
    os.makedirs(directory, exist_ok=True)
    
    # Full path for saving
    filepath = os.path.join(directory, filename)

    # Create QR object
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_H,
        box_size=10,
        border=4,
    )
    
    qr.add_data(link)
    qr.make(fit=True)

    # Create image
    img = qr.make_image(fill_color="black", back_color="white")
    
    # Save file
    img.save(filepath)
    print(f"QR code saved as {filepath}")

# Example usage
generate_qr("https://clerk-authentication-starter-lyart-eight.vercel.app/", "example_qr.png", directory="my_qr_codes")

#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

# Install necessary packages
pacman -S --noconfirm efitools sbsigntools

# Step 2: Create Secure Boot keys
echo "Creating Secure Boot keys..."
openssl req -newkey rsa:4096 -nodes -keyout PK.key -new -x509 -sha256 -days 3650 -subj "/CN=My Platform Key/" -out PK.crt
openssl req -newkey rsa:4096 -nodes -keyout KEK.key -new -x509 -sha256 -days 3650 -subj "/CN=My Key Exchange Key/" -out KEK.crt
openssl req -newkey rsa:4096 -nodes -keyout db.key -new -x509 -sha256 -days 3650 -subj "/CN=My Signature Database key/" -out db.crt

# Step 3: Convert the keys to ESL format
echo "Converting keys to ESL format..."
cert-to-efi-sig-list -g "$(uuidgen)" PK.crt PK.esl
cert-to-efi-sig-list -g "$(uuidgen)" KEK.crt KEK.esl
cert-to-efi-sig-list -g "$(uuidgen)" db.crt db.esl

# Step 4: Sign the ESL files
echo "Signing the ESL files..."
sign-efi-sig-list -k PK.key -c PK.crt PK PK.esl PK.auth
sign-efi-sig-list -k PK.key -c PK.crt KEK KEK.esl KEK.auth
sign-efi-sig-list -k PK.key -c PK.crt db db.esl db.auth

# Step 7: Sign bootloader and kernel
GRUB_PATH="/boot/efi/EFI/arch/grubx64.efi"  # Adjust if needed
KERNEL_PATH="/boot/vmlinuz-linux"  # Adjust if needed

echo "Signing GRUB and the Linux kernel..."
sbsign --key db.key --cert db.crt --output $GRUB_PATH $GRUB_PATH
sbsign --key db.key --cert db.crt --output $KERNEL_PATH $KERNEL_PATH

# Reminder for manual steps
echo "Script finished!"
echo "Now, manually handle the UEFI settings and key enrollment process as explained previously."

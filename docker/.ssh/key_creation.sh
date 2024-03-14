#!/bin/bash

# Set the file path
FILE_PATH="docker/.ssh/keys/ssh"

# Generate the SSH key pair
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f $FILE_PATH

# Print the public key
echo "Public key:"
cat "${FILE_PATH}.pub"
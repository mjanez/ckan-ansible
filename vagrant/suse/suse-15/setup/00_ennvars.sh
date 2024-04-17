#!/bin/bash
echo "[00_load_envvars] Loading environment variables..."
set -o allexport
# Convert .env line endings to Unix style
sed -i 's/\r$//' $HOME/.env
source <(grep -v '^#' $HOME/.env | xargs -0)
set +o allexport

# Add environment variables to .bashrc
while IFS= read -r line
do
    if [[ ! $line =~ ^# && $line = *[!\ ]* ]]; then
        echo "export $line" >> $HOME/.bashrc
    fi
done < $HOME/.env

echo "[00_load_envvars] Environment variables loaded."
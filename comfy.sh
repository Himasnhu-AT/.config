#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

WORKSPACE="$HOME/ComfyUI"
USE_COMFYUI_MANAGER=true
UPDATE_COMFY_UI=true
INSTALL_CUSTOM_NODES_DEPENDENCIES=true

# Clone ComfyUI if not already present
echo "-= Initial setup ComfyUI =-"
if [ ! -d "$WORKSPACE" ]; then
    git clone https://github.com/comfyanonymous/ComfyUI "$WORKSPACE"
fi

cd "$WORKSPACE"

# Update ComfyUI if enabled
if [ "$UPDATE_COMFY_UI" = true ]; then
    echo "-= Updating ComfyUI =-"
    git pull
fi

# Install dependencies
echo "-= Installing dependencies =-"
pip3 install --upgrade accelerate einops "transformers>=4.28.1" "safetensors>=0.4.2" aiohttp pyyaml Pillow scipy tqdm psutil "tokenizers>=0.13.3"
pip3 install --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip3 install --upgrade torchsde "kornia>=0.7.1" spandrel soundfile sentencepiece

# Install ComfyUI-Manager if enabled
if [ "$USE_COMFYUI_MANAGER" = true ]; then
    echo "-= Setting up ComfyUI-Manager =-"
    cd "$WORKSPACE/custom_nodes"
    
    if [ ! -d "ComfyUI-Manager" ]; then
        git clone https://github.com/ltdrdata/ComfyUI-Manager
    fi
    
    cd ComfyUI-Manager
    git pull
fi

cd "$WORKSPACE"

# Install custom nodes dependencies if enabled
if [ "$INSTALL_CUSTOM_NODES_DEPENDENCIES" = true ]; then
    echo "-= Installing custom nodes dependencies =-"
    pip install --upgrade GitPython
    python3 custom_nodes/ComfyUI-Manager/cm-cli.py restore-dependencies
fi

# Install and start Cloudflared
echo "-= Installing Cloudflared =-"
wget -P ~ https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
dpkg -i ~/cloudflared-linux-amd64.deb

# Start ComfyUI and Cloudflared tunnel
function start_cloudflared() {
    while ! nc -z 127.0.0.1 8188; do
        sleep 0.5
    done
    echo "\nComfyUI finished loading, trying to launch cloudflared (if it gets stuck here cloudflared is having issues)\n"
    cloudflared tunnel --url http://127.0.0.1:8188 &
}

start_cloudflared &

# Run ComfyUI
echo "-= Starting ComfyUI =-"
python3 main.py --dont-print-server

echo "-= Installation complete! =-"

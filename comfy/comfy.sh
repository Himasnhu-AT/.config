#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

WORKSPACE="$HOME/ComfyUI"
USE_COMFYUI_MANAGER=true
UPDATE_COMFY_UI=true
INSTALL_CUSTOM_NODES_DEPENDENCIES=true
VENV_DIR="$WORKSPACE/venv"

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

# Create and activate virtual environment
echo "-= Setting up virtual environment =-"
if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
source "$VENV_DIR/bin/activate"

# Install dependencies in the virtual environment
echo "-= Installing dependencies =-"
pip install --upgrade pip
pip install --upgrade accelerate einops "transformers>=4.28.1" "safetensors>=0.4.2" aiohttp pyyaml Pillow scipy tqdm psutil "tokenizers>=0.13.3"
pip install --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install --upgrade torchsde "kornia>=0.7.1" spandrel soundfile sentencepiece

# Create custom_nodes directory if it doesn't exist
mkdir -p "$WORKSPACE/custom_nodes"

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
sudo dpkg -i ~/cloudflared-linux-amd64.deb

# Download run.py from the original .config/comfy/app.py content
echo "-= Downloading run.py =-"
cat > "$WORKSPACE/run.py" << 'EOL'
import subprocess
import threading
import time
import socket
import urllib.request

def iframe_thread(port):
    while True:
        time.sleep(0.5)
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = sock.connect_ex(('127.0.0.1', port))
        if result == 0:
            break
        sock.close()
    print("\nComfyUI finished loading, trying to launch cloudflared (if it gets stuck here cloudflared is having issues)\n")

    p = subprocess.Popen(["cloudflared", "tunnel", "--url", f"http://127.0.0.1:{port}"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    for line in p.stderr:
        l = line.decode()
        if "trycloudflare.com " in l:
            print("This is the URL to access ComfyUI:", l[l.find("http"):], end='')

if __name__ == "__main__":
    threading.Thread(target=iframe_thread, daemon=True, args=(8188,)).start()
    subprocess.run(["python", "main.py", "--dont-print-server"], check=True)
EOL

echo "-= Installation complete! =-"

# Start ComfyUI with our custom launcher
echo "-= Starting ComfyUI =-"
cd "$WORKSPACE"
python run.py

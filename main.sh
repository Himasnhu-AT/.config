# install dependencies
bash deps.sh

# install rust
if [ -z "$RUSTUP_HOME" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed"
fi

# install custom tools

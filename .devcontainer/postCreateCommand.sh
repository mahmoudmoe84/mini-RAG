#!/bin/bash
# This script is executed after the container is created.
# It installs the necessary Python packages and sets up the environment.

set -e  # Exit on error

echo "Setting up Python environment..."

# Install SSL support and other dependencies
apt-get update && apt-get install -y \
    ca-certificates \
    python3-venv \
    python3-pip \
    python3-dev \
    build-essential \
    libssl-dev \
    libffi-dev \
    direnv

# Remove any existing venv
rm -rf .venv

# Create Python virtual environment using system python3
python3 -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install dependencies
pip install pre-commit
if [ -f "requirements.txt" ]; then
    echo "Installing from requirements.txt..."
    pip install -r requirements.txt
fi
if [ -f "pyproject.toml" ]; then
    echo "Installing from pyproject.toml..."
    uv sync
fi

# Install pre-commit hooks
if [ -f ".pre-commit-config.yaml" ]; then
    echo "Setting up pre-commit hooks..."
    pre-commit install
fi

# Configure direnv
echo "Setting up direnv..."

# Add direnv to shell initialization files
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
echo 'eval "$(direnv hook bash)"' >> ~/.bash_profile

# Create .envrc for automatic venv activation
cat > .envrc << 'EOF'
#!/bin/bash
# Automatically activate the virtual environment
if [[ -f .venv/bin/activate ]]; then
    source .venv/bin/activate
    export VIRTUAL_ENV_DISABLE_PROMPT=1
fi

# Load .env file if it exists
if [[ -f .env ]]; then
    set -a
    source .env
    set +a
fi
EOF

# Set proper permissions and allow direnv
chmod +x .envrc
direnv allow .

# Also add venv activation directly to bashrc as fallback
cat >> ~/.bashrc << 'EOF'

# Auto-activate Python virtual environment in /workspaces/mini-RAG
if [[ "$PWD" == "/workspaces/mini-RAG" && -f "/workspaces/mini-RAG/.venv/bin/activate" ]]; then
    source /workspaces/mini-RAG/.venv/bin/activate
    export VIRTUAL_ENV_DISABLE_PROMPT=1
fi
EOF

# Configure mise if needed
if command -v mise &> /dev/null; then
    echo "Configuring mise..."
    mise trust
    mise install
    echo 'eval "$(/usr/local/bin/mise activate bash)"' >> ~/.bashrc
fi

echo "Environment setup complete!"
echo "Virtual environment created at: $(pwd)/.venv"
echo "Python interpreter: $(which python)"
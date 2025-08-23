#!/bin/bash
set -e  # Exit on error

# Setup mise
mise trust  # Fixed typo from 'turst'
mise install

# Create and activate virtual environment
python -m venv .venv
. .venv/bin/activate

# Install core tools
pip install --upgrade pip
pip install pre-commit

# Install project dependencies
if [ -f "pyproject.toml" ]; then
    uv pip install -e .
elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# Install pre-commit hooks if configured
if [ -f ".pre-commit-config.yaml" ]; then
    pre-commit install
fi

# Add environment activation to shell startup
echo '. /workspaces/mini-RAG/.venv/bin/activate' >> ~/.bashrc

# Setup mise shell integration
echo 'eval "$(/usr/local/bin/mise activate bash)"' >> ~/.bashrc
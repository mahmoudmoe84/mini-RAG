#!/bin/bash
# This script is executed after the container is created.
# It installs the necessary Python packages and sets up the environment.
#!/bin/bash

# Install pre-commit using pip
pip install pre-commit

# Install your project dependencies
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
fi

# If using uv for package management
if [ -f "pyproject.toml" ]; then
    uv sync
fi

# Install pre-commit hooks if .pre-commit-config.yaml exists
if [ -f ".pre-commit-config.yaml" ]; then
    pre-commit install
fi

# Install and configure direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

# Create .envrc file in project root
cat << EOF > ../.envrc
# Automatically load Python virtual environment
layout python3
EOF

# Allow the .envrc file
direnv allow ../.envrc

mise turst
mise install
echo 'eval "$(/usr/local/bin/mise activate bash)"' >> ~/.bashrc
source ~/.bashrc

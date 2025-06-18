#!/bin/bash

set -e  # Exit on any error

echo "🚀 Starting Ubuntu Nix Bootstrap Setup"
echo "====================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    print_warning "This script is designed for Ubuntu. Proceeding anyway..."
fi

# Install Nix if not already installed
if ! command -v nix &> /dev/null; then
    print_status "Installing Nix package manager (single-user)..."
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
    
    # Source nix
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
    
    print_success "Nix installed successfully!"
else
    print_success "Nix is already installed"
    # Make sure we have Nix in our current session
    if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
fi

# Enable flakes and nix-command
print_status "Configuring Nix with flakes support..."
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
EOF

print_success "Nix configuration updated with flakes support"

# Get the current username
CURRENT_USER=$(whoami)
CURRENT_HOME=$(eval echo ~$CURRENT_USER)

print_status "Verifying configuration files for user: $CURRENT_USER"

# Verify the username matches in configuration files
if ! grep -q "home.username = \"$CURRENT_USER\"" home.nix; then
    print_status "Updating home.nix with your username..."
    sed -i "s/home.username = \"[^\"]*\"/home.username = \"$CURRENT_USER\"/g" home.nix
fi

if ! grep -q "home.homeDirectory = \"$CURRENT_HOME\"" home.nix; then
    print_status "Updating home.nix with your home directory..."
    sed -i "s|home.homeDirectory = \"[^\"]*\"|home.homeDirectory = \"$CURRENT_HOME\"|g" home.nix
fi

if ! grep -q "\"$CURRENT_USER\"" flake.nix; then
    print_status "Updating flake.nix with your username..."
    sed -i "s/\"diraol\"/\"$CURRENT_USER\"/g" flake.nix
fi

print_success "Configuration files verified for user: $CURRENT_USER"

# Check if Git configuration needs updating
echo
if ! grep -q "userName = \"Diego Rabatone Oliveira\"" programs/git.nix 2>/dev/null; then
    print_status "Setting up Git configuration..."
    read -p "Enter your full name for Git (or press Enter to keep current): " GIT_NAME
    read -p "Enter your email for Git (or press Enter to keep current): " GIT_EMAIL
    
    if [ -n "$GIT_NAME" ] && [ -f "programs/git.nix" ]; then
        sed -i "s/userName = \"[^\"]*\"/userName = \"$GIT_NAME\"/g" programs/git.nix
    fi
    
    if [ -n "$GIT_EMAIL" ] && [ -f "programs/git.nix" ]; then
        sed -i "s/userEmail = \"[^\"]*\"/userEmail = \"$GIT_EMAIL\"/g" programs/git.nix
    fi
    
    print_success "Git configuration updated"
else
    print_success "Git configuration already set"
fi

# Build and activate home-manager configuration
print_status "Building and activating home-manager configuration..."

# First, we need to install home-manager
nix profile install nixpkgs#home-manager

# Then activate the configuration
home-manager switch --flake .#$CURRENT_USER

print_success "Home-manager configuration activated!"

# Ask about default shell
echo
print_status "Shell configuration setup..."
echo "This configuration includes both Bash and ZSH with Powerlevel10k theme."
echo "Your current shell: $SHELL"
read -p "Do you want to set ZSH as your default shell? (y/N): " SET_ZSH_DEFAULT

if [[ $SET_ZSH_DEFAULT =~ ^[Yy]$ ]]; then
    if command -v zsh &> /dev/null; then
        print_status "Setting ZSH as default shell..."
        chsh -s $(which zsh)
        print_success "ZSH set as default shell (will take effect on next login)"
    else
        print_warning "ZSH not found in system PATH. Install it first with: sudo apt install zsh"
    fi
fi

echo
echo "🎉 Bootstrap setup complete!"
echo "=========================="
echo
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.nix-profile/etc/profile.d/nix.sh"
echo "2. Then source your shell:"
echo "   - For bash: source ~/.bashrc"
echo "   - For zsh: source ~/.zshrc (or just start a new zsh session)"
echo "3. Verify installation: nix --version"
echo "4. To update your configuration:"
echo "   - Edit programs/*.nix files as needed"
echo "   - Run: home-manager switch --flake .#$CURRENT_USER"
echo
echo "5. To update packages: nix flake update && home-manager switch --flake .#$CURRENT_USER"
echo
echo "📝 Note: This is a single-user Nix installation (no sudo required)"
echo "🐚 ZSH configuration includes Powerlevel10k theme and your custom aliases"
echo "Your Nix configuration is now ready! 🚀" 
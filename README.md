# Ubuntu Nix Dotfiles with Flakes and Home-Manager

This repository contains Diego's dotfiles setup using Nix with flakes and home-manager on Ubuntu with a **single-user (standalone) installation**. This setup migrates traditional dotfiles into a modern, reproducible Nix configuration that doesn't require sudo privileges.

## 📝 Single-User vs Multi-User Setup

This setup uses the **single-user installation** which:
- ✅ Doesn't require sudo/root privileges
- ✅ Installs Nix only for your user account
- ✅ Simpler setup and maintenance
- ✅ Perfect for personal development environments
- ❌ Only available to the installing user
- ❌ No system-wide Nix daemon

If you need a multi-user setup (system-wide), replace `--no-daemon` with `--daemon` in the installation commands.

## 🚀 Quick Start

1. **Clone this repository** (if you haven't already):
   ```bash
   git clone <your-repo-url>
   cd nix-dotfiles
   ```

2. **Run the bootstrap script**:
   ```bash
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```

3. **Set ZSH as default shell** (recommended):
   ```bash
   chmod +x set-zsh-default.sh
   ./set-zsh-default.sh
   ```

4. **Restart your terminal** or source your shell configuration:
   ```bash
   # If using bash (before shell change)
   source ~/.bashrc
   
   # If using zsh (after shell change)
   source ~/.zshrc
   ```

## 📁 File Structure

- `flake.nix` - Main flake configuration with inputs and outputs
- `home.nix` - Main home-manager configuration that imports modular configs
- `programs/` - Modular program configurations
  - `cli.nix` - Command-line tools and packages
  - `git.nix` - Git configuration (migrated from .gitconfig)
  - `shell.nix` - Bash shell configuration (migrated from .bashrc)
  - `tmux.nix` - Tmux configuration (migrated from .tmux.conf)
  - `zsh.nix` - ZSH configuration with Powerlevel10k (migrated from .zshrc/.zpreztorc)
- `config/` - **Self-contained configuration files**
  - `.zsh_aliases` - Local ZSH aliases (no external dependencies)
  - `.nurc` - Local Nubank environment configuration
  - `.p10k.zsh` - **Self-contained Powerlevel10k theme configuration**
  - `.nugitconfig` - Nubank-specific Git configuration
  - `.diraol/` - Personal tools and configurations directory
    - `scripts/` - Custom scripts and utilities
  - `.ssh/` - SSH configuration files
  - `.config/` - Desktop environment configurations (hyprland, waybar, wofi, rofi, kanshi, kitty, dunst, sway)
  - `background.jpg` - Desktop background image
- `configuration.nix` - Reference NixOS configuration (mainly for reference on Ubuntu)
- `bootstrap.sh` - Automated setup script for Ubuntu
- `README.md` - This file

## 🔄 Self-Contained Dotfiles Setup

This setup is **completely self-contained** in the nix-dotfiles repository:
- **All essential configurations** included locally (no external dependencies)
- **Self-contained Powerlevel10k configuration** (`config/.p10k.zsh`)
- **Local ZSH aliases** (`config/.zsh_aliases`)
- **Local environment configuration** (`config/.nurc`)
- **Nubank Git configuration** (`config/.nugitconfig`)
- **Personal tools and scripts** (`config/.diraol/`)
- **SSH configuration** (`config/.ssh/`)
- **Desktop environment configs** (hyprland, waybar, wofi, rofi, kanshi, kitty, dunst, sway in `config/.config/`)
- **Optional integration** with external workspace-specific configs (if available)

### 🎨 ZSH with Powerlevel10k

The ZSH configuration includes:
- **Oh My Zsh** framework with useful plugins
- **Powerlevel10k** theme properly integrated via Nix plugins system
- **Vi key bindings** (as configured in your original setup)
- **Custom aliases** migrated from your .zsh_aliases
- **Development environment** integration (NVM, nodenv, etc.)
- **Auto-completion** and **syntax highlighting**
- **Self-contained theme config**: Edit `config/.p10k.zsh` to customize your prompt

### 🪟 Hyprland Window Manager

The setup uses **Hyprland** as the primary Wayland compositor with a complete desktop environment:
- **Hyprland** - Modern Wayland compositor with advanced features
- **Waybar** - Status bar with system information
- **Wofi/Rofi** - Application launchers
- **Dunst** - Notification daemon  
- **Kitty** - Terminal emulator
- **Kanshi** - Display management
- **Sway** - Available as fallback window manager

**Key Features**:
- Smooth animations and effects
- Advanced window management
- Multi-monitor support with kanshi
- Custom keybindings and workspace management
- Background image and theme integration

**Switching Window Managers**:
- Primary: Launch with `Hyprland`
- Fallback: Launch with `sway` if needed
- Both configurations are maintained locally

### 🚀 Auto-Starting Hyprland

By default, Hyprland needs to be manually launched. Here are options for auto-start:

#### Option 1: TTY Auto-Start (Simple)
Edit `programs/zsh.nix` and uncomment the auto-start lines:
```bash
# Uncomment these lines in programs/zsh.nix initContent:
if [ "$(tty)" = "/dev/tty1" ]; then
  exec Hyprland
fi
```

#### Option 2: Systemd User Service (Recommended)
```bash
# Run the auto-start setup script
chmod +x hyprland-autostart.sh
./hyprland-autostart.sh
```

#### Option 3: Display Manager Integration
For GDM/SDDM/LightDM integration, Hyprland should appear as a session option automatically if installed system-wide.

#### Managing Auto-Start
```bash
# Check status
systemctl --user status hyprland.service

# Disable auto-start
systemctl --user disable hyprland.service

# Re-enable auto-start
systemctl --user enable hyprland.service
```

### 🎨 Customizing Your Setup

Your configuration is now **completely self-contained**:

**Powerlevel10k Theme** (`config/.p10k.zsh`):
- Fully integrated with Nix home-manager using plugins configuration  
- Edit directly to modify prompt segments
- Run `p10k configure` in ZSH to regenerate if needed
- All changes tracked in nix-dotfiles
- Uses Meslo Nerd Font for proper icon display

**ZSH Aliases** (`config/.zsh_aliases`):
- **All user aliases** are now in this single file (no duplication)
- Well-organized sections: Nix, Git, Development, System utilities
- Use `al` command to edit quickly
- Includes helpful shortcuts and space for custom additions

**Environment Variables** (`config/.nurc`):
- Modify development environment settings
- No external dependencies required

**Nubank Configuration** (`config/.nugitconfig`):
- Nubank-specific Git settings and signing keys
- Work-related Git configuration separate from personal

**Personal Tools** (`config/.diraol/`):
- Custom scripts, aliases, and environment configurations
- Personal development tools and settings
- `scripts/` - Utility scripts for system management (brightness, audio, battery, etc.)

**SSH Configuration** (`config/.ssh/`):
- SSH client configuration and settings
- Connection profiles and key management

**Desktop Environment** (`config/.config/`):
- Window manager configs (hyprland, waybar, wofi, rofi, kanshi, kitty, dunst, sway)
- Desktop environment specific settings

**Program Configurations** (`programs/*.nix`):
- Modular and easy to customize
- Use `edit-zsh` to quickly edit ZSH config

**Testing Hyprland Setup**:
```bash
# Test the configuration syntax
home-manager switch --flake .#diraol

# Launch Hyprland manually (current default)
# From TTY: 
Hyprland

# Or use display manager session if available

# Key bindings (once in Hyprland):
# Super + T          - Terminal (kitty)
# Super + Return     - App launcher (rofi)
# Super + G          - Google Chrome
# Super + E          - Emacs/Doom
# Super + Q          - File manager
# Super + X          - Close window
# Super + 1-6        - Switch workspaces
# Super + Shift + 1-6 - Move window to workspace
```

## 🐚 Setting ZSH as Default Shell

To get the full powerlevel10k experience, set zsh as your default shell:

### Option 1: Automated Script
```bash
# Make the script executable and run it
chmod +x set-zsh-default.sh
./set-zsh-default.sh
```

### Option 2: Manual Steps
```bash
# 1. Apply home-manager configuration first
home-manager switch --flake .#diraol

# 2. Find zsh path
which zsh

# 3. Add zsh to /etc/shells if not already there
echo "$(which zsh)" | sudo tee -a /etc/shells

# 4. Change your default shell
chsh -s $(which zsh)

# 5. Log out and log back in, or restart terminal
```

### Verification
```bash
# Check your default shell
echo $SHELL

# Should show something like: /nix/store/.../bin/zsh or /home/user/.nix-profile/bin/zsh
```

## 🛠️ Manual Installation

If you prefer to install manually:

### 1. Install Nix

```bash
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
```

### 2. Enable Flakes

Create `~/.config/nix/nix.conf`:
```
experimental-features = nix-command flakes
```

### 3. Update Configuration

Edit `flake.nix` and `home.nix` to replace:
- `username` with your actual username
- `/home/username` with your actual home directory
- Git name and email in `home.nix`

### 4. Install Home-Manager

```bash
nix profile install nixpkgs#home-manager
```

### 5. Activate Configuration

```bash
home-manager switch --flake .#your-username
```

## 🎯 Usage

### Installing Packages

Add packages to the `home.packages` list in `programs/cli.nix`:

```nix
home.packages = with pkgs; [
  # Add your new packages here
  firefox
  vscode
  docker
  # Uncomment existing packages as needed
  # bat         # Better cat
  # exa         # Better ls  
  # zoxide      # Smart cd
];
```

### Configuring Programs

Home-manager provides modules for many programs. Example for configuring VS Code:

```nix
programs.vscode = {
  enable = true;
  extensions = with pkgs.vscode-extensions; [
    ms-python.python
    ms-vscode.cpptools
  ];
};
```

### Updating Your Configuration

1. Edit the appropriate configuration files:
   - `programs/cli.nix` - for adding/removing packages
   - `programs/git.nix` - for Git settings
   - `programs/shell.nix` - for bash configuration
   - `programs/tmux.nix` - for tmux settings
   - `home.nix` - for general home-manager settings
2. Run: `home-manager switch --flake .#diraol`

### Updating Packages

```bash
nix flake update
home-manager switch --flake .#diraol
```

## 🔧 Customization

### Adding New Programs

Check available home-manager options:
- [Home-Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)

### Shell Configuration

The setup includes both Bash and ZSH configurations:

**ZSH Configuration**:
- **Aliases**: Edit `config/.zsh_aliases` (use `al` command)
- **Advanced config**: Edit `programs/zsh.nix` for Nix-level settings

```nix
# programs/zsh.nix - for Nix configuration
programs.zsh = {
  sessionVariables = {
    CUSTOM_VAR = "value";
  };
  
  initExtra = ''
    # Add custom ZSH initialization here
  '';
};
```

**Bash** (fallback - `programs/shell.nix`):
```nix
programs.bash = {
  bashrcExtra = ''
    # Add your custom bash configuration here
    export CUSTOM_VAR="value"
    alias myalias="command"
  '';
};
```

### Environment Variables

Set environment variables in `home.nix`:

```nix
home.sessionVariables = {
  EDITOR = "vim";
  BROWSER = "firefox";
  CUSTOM_PATH = "/path/to/something";
};
```

## 📋 Default Packages Included

- **Development**: git, gh, curl, wget, jq, nodejs, python3
- **Text Processing**: ripgrep, fd, fzf, tree, htop
- **Editors**: vim (with enhanced config), nano
- **Terminal**: tmux (with comprehensive config), tmuxinator
- **Build Tools**: gnumake, gcc
- **System Utilities**: unzip, zip, p7zip, imagemagick, openssh, rsync
- **Shell**: bash with enhanced completion, history, and custom prompt

## 🔧 Included Configurations

- **Git**: Complete Git configuration with aliases, hooks, and conditional includes
- **Bash**: Enhanced bash with history management, colored prompt, and custom aliases  
- **ZSH**: Full ZSH setup with Powerlevel10k theme, Oh My Zsh plugins, and local aliases
- **Tmux**: Full tmux configuration with custom key bindings, mouse support, and Gruvbox theme
- **Vim**: Enhanced vim configuration with sensible defaults
- **Self-contained**: All essential configs included, no external dependencies

## 🐛 Troubleshooting

### Nix Command Not Found

Restart your terminal or source the nix profile:
```bash
source ~/.nix-profile/etc/profile.d/nix.sh
```

### Home-Manager Issues

Rebuild the configuration:
```bash
home-manager switch --flake .#your-username
```

### Permission Issues

Make sure you have proper permissions:
```bash
sudo chown -R $USER:$USER ~/.config/nix
```

## 🔗 Useful Links

- [Nix Manual](https://nixos.org/manual/nix/stable/)
- [Home-Manager Manual](https://nix-community.github.io/home-manager/)
- [Nixpkgs Search](https://search.nixos.org/)
- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

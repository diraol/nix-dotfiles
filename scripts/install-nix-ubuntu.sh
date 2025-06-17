#!/usr/bin/env bash

set -ve

sudo apt update
sudo apt install -y vim git curl build-essential dkms linux-headers-"$(uname -r)" bspwm libglfw3-dev libgles2-mesa-dev libgl1-mesa-dev xorg-dev
#git clone https://github.com/ericdallo/dotfiles.git ~/.dotfiles

sudo mkdir -p /nix
sudo chown "${USERNAME:-diraol}" /nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon
source "/home/${USERNAME:-diraol}/.nix-profile/etc/profile.d/nix.sh"

NEW_PATH="${HOME}/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels"

if ! grep -q "${NEW_PATH}" ~/.bashrc ; then
	echo "export NIX_PATH=\"${NEW_PATH}:${NIX_PATH:+:$NIX_PATH}\"" >> ~/.bashrc
	echo "export NIXPKGS_ALLOW_UNFREE=1" >> ~/.bashrc
fi

nix-env -iA nixpkgs.home-manager

mkdir -p ~/.config/nix
EXP_FEAT="experimental-features = nix-command flakes"
if ! grep -q "${EXP_FEAT}" ~/.config/nix/nix.conf; then
	echo "${EXP_FEAT}" > ~/.config/nix/nix.conf
fi

cd ~/.dotfiles/nix
home-manager switch --flake .

NEW_XDG_DATA_DIRS="${HOME}/.nix-profile/share:${HOME}/.share"
if ! grep -q "${NEW_XDG_DATA_DIRS}" ~/.profile ; then
	echo "export XDG_DATA_DIRS=\"${NEW_XDG_DATA_DIRS}:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.profile
fi
if ! grep -q "${NEW_XDG_DATA_DIRS}" ~/.zprofile ; then
	echo "export XDG_DATA_DIRS=\"${NEW_XDG_DATA_DIRS}:${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}\"" >> ~/.zprofile
fi

SRC_NIX="if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ${HOME}/.nix-profile/etc/profile.d/nix.sh; fi"
if ! grep -q "${SRC_NIX}" ~/.zprofile; then
	echo "${SRC_NIX}" >> ~/.zprofile
fi

NIX_ZSH="/home/diraol/.nix-profile/bin/zsh"
if ! grep -q "${NIX_ZSH}" /etc/shells; then
	echo "${NIX_ZSH}" | sudo tee -a /etc/shells > /dev/null
fi
sudo chsh -s "${NIX_ZSH}"

# Natural scrolling
NAT_SCRL="xinput set-prop 13 324 1"
if ! grep -q "${NAT_SCRL}" ~/.profile; then
	echo "${NAT_SCRL}" >> ~/.profile
fi
if ! grep -q "${NAT_SCRL}" ~/.zprofile; then
	echo "${NAT_SCRL}" >> ~/.zprofile
fi

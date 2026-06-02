#!/usr/bin/env bash
set -euo pipefail

echo "== Alexander Dotfiles Installer =="

echo ""
echo "Erstelle Ordner..."
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin

echo ""
echo "Erstelle Backups alter Dateien..."

if [ -f ~/.tmux.conf ]; then
  cp ~/.tmux.conf ~/.tmux.conf.backup
  echo "Backup: ~/.tmux.conf.backup"
fi

if [ -f ~/.bashrc ]; then
  cp ~/.bashrc ~/.bashrc.backup
  echo "Backup: ~/.bashrc.backup"
fi

if [ -d ~/.config/nvim ]; then
  cp -r ~/.config/nvim ~/.config/nvim.backup
  echo "Backup: ~/.config/nvim.backup"
fi

echo ""
echo "Kopiere Neovim Config..."
cp -r nvim/* ~/.config/nvim/

echo "Kopiere tmux Config..."
cp tmux.conf ~/.tmux.conf

echo "Kopiere dev Skript..."
cp bin/dev ~/.local/bin/dev
chmod +x ~/.local/bin/dev

echo "Kopiere bashrc..."
cp bashrc ~/.bashrc

echo ""
echo "Fertig."
echo ""
echo "Jetzt Terminal neu starten oder ausführen:"
echo "source ~/.bashrc"
echo ""
echo "Danach Neovim starten und ausführen:"
echo ":Lazy sync"

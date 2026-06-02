# Alexander's Dotfiles

Mein persönliches Setup für:

- Neovim
- tmux
- dev-Skript
- bashrc / Aliase

## Wiederherstellen

```bash
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin

cp -r nvim/* ~/.config/nvim/
cp tmux.conf ~/.tmux.conf
cp bin/dev ~/.local/bin/dev
cp bashrc ~/.bashrc

chmod +x ~/.local/bin/dev
source ~/.bashrc


---

## 5. Install-Skript erstellen

Das macht später auf einem neuen Rechner alles einfacher:

```bash
cat > install.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

echo "Erstelle Ordner..."
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin

echo "Backup alter Dateien..."
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf ~/.tmux.conf.backup
[ -f ~/.bashrc ] && cp ~/.bashrc ~/.bashrc.backup
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim ~/.config/nvim.backup

echo "Kopiere Neovim Config..."
cp -r nvim/* ~/.config/nvim/

echo "Kopiere tmux Config..."
cp tmux.conf ~/.tmux.conf

echo "Kopiere dev Skript..."
cp bin/dev ~/.local/bin/dev
chmod +x ~/.local/bin/dev

echo "Kopiere bashrc..."
cp bashrc ~/.bashrc

echo "Fertig."
echo "Starte dein Terminal neu oder führe aus:"
echo "source ~/.bashrc"

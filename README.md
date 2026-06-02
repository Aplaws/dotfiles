# Aplaws's Dotfiles

Mein persönliches Setup für:

* Neovim
* tmux
* dev-Skript
* bashrc / Aliase

## Inhalt

```text
dotfiles/
├── bashrc
├── bin/
│   └── dev
├── nvim/
│   └── init.lua
├── tmux.conf
├── install.sh
└── README.md
```

## Wiederherstellen

Auf einem neuen Rechner:

```bash
mkdir -p ~/workspace
cd ~/workspace

git clone https://github.com/Aplaws/dotfiles.git
cd dotfiles

./install.sh
```

Danach Terminal neu starten oder ausführen:

```bash
source ~/.bashrc
```

## Neovim Plugins installieren

Nach dem ersten Start von Neovim:

```vim
:Lazy sync
```

## Manuell wiederherstellen

Falls das Install-Skript nicht benutzt werden soll:

```bash
mkdir -p ~/.config/nvim
mkdir -p ~/.local/bin

cp -r nvim/* ~/.config/nvim/
cp tmux.conf ~/.tmux.conf
cp bin/dev ~/.local/bin/dev
cp bashrc ~/.bashrc

chmod +x ~/.local/bin/dev
source ~/.bashrc
```

## Änderungen speichern

Wenn sich die echten Config-Dateien geändert haben:

```bash
cd ~/workspace/dotfiles

cp -r ~/.config/nvim/* ./nvim/
cp ~/.tmux.conf ./tmux.conf
cp ~/.local/bin/dev ./bin/dev
cp ~/.bashrc ./bashrc

git status
git add .
git commit -m "Update dotfiles"
git push
```


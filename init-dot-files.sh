#!bin/bash

sudo apt update
sudo apt install neovim -y
sudo apt install git -y
sudo apt install yadm -y
cd ~ 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
curl -fsSL https://fnm.vercel.app/install | bash # install FNM - Fast Node Manager
#zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/zsh
git clone git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/zsh
git clone git clone https://github.com/zsh-users/zsh-history-substring-search ~/zsh
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/zsh

yadm git clone https://github.com/rnfrafael/dot-files.git ~/

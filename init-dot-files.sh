#!bin/bash

if ! command -v sudo &> /dev/null; then
    echo "sudo command not found. Installing sudo..."
    if command -v apt &> /dev/null; then
        # Install sudo using apt
        sudo apt update
        sudo apt install -y sudo
        echo "sudo has been installed."
    else
        echo "apt command not found. Please install sudo manually."
    fi
else
    echo "sudo is already installed."
fi

sudo apt update
sudo apt install unzip -y
sudo apt install git -y
sudo apt install yadm -y
sudo apt install zsh -y
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
source ~/.bashrc

##Node
echo "[-] install Node [-]"
asdf plugin add nodejs
asdf install nodejs latest:18
asdf global nodejs latest:18
echo "[-] Done Node [-]"

##NeoVim
echo "[-] install NeoVim [-]"
asdf plugin add neovim
asdf install neovim 0.9.1
asdf global neovim 0.9.1
echo "[-] install Plug for nvim[-]"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
#sudo apt install neovim -y
#should run :PlugInstall inside NeoVim
echo "[-] Done NeoVim [-]"

cd ~ 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
curl -fsSL https://fnm.vercel.app/install | bash # install FNM - Fast Node Manager
#zsh Plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.zsh/zsh-you-should-use

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "[-] Download fonts [-]"
sudo apt install fontconfig -y
# https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0?permalink_comment_id=4179773#gistcomment-4179773
declare -a fonts=(
    BitstreamVeraSansMono
    CodeNewRoman
    DroidSansMono
    FiraCode
    FiraMono
    Go-Mono
    Hack
    Hermit
    JetBrainsMono
    Meslo
    Noto
    Overpass
    ProggyClean
    RobotoMono
    SourceCodePro
    SpaceMono
    Ubuntu
    UbuntuMono
)

version='2.1.0'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
    wget "$download_url"
    unzip "$zip_file" -d "$fonts_dir"
    rm "$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
echo "[-] Done download fonts [-]"

######## 1pass INIT ########
echo "[-] Install 1Password [-]"
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
sudo tee /etc/apt/sources.list.d/1password.list

sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/

curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol

sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22

curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg

sudo apt update && sudo apt install 1password-cli

echo "[-] Done install 1Password [-]"
######## END ########

yadm clone https://github.com/rnfrafael/dot-files.git
#sed -i '1iexec zsh' ~/.bashrc
exec zsh

# wget -O - https://raw.githubusercontent.com//rnfrafael/dot-files/main/init-dot-files.sh | bash

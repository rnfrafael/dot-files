#!bin/bash

echo "[----] Checking for sudo [----]"
# Check for sudo and install if necessary
if ! command -v sudo &> /dev/null; then
    echo "sudo command not found. Installing sudo..."
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y sudo
        echo "sudo has been installed."
    else
        echo "apt command not found. Please install sudo manually."
        exit 1
    fi
else
    echo "sudo is already installed."
fi
echo "[----] Finish checking for sudo [----]"
sleep 2

# Update package lists
sudo apt update
echo "[----] Package lists updated [----]"
sleep 2

echo "[----] Checking for Packages [----]"
# Packages to install
PACKAGES=(
    "unzip"
    "wget"
    "git"
    "yadm"
    "zsh"
    "curl"
)
for package in "${PACKAGES[@]}"; do
    sudo apt install -y "$package"
    if ! command -v "$package" &> /dev/null; then
        echo "Error: $package installation failed."
        exit 1
    fi
    echo "[----] $package installed successfully [----]"
    sleep 2
done
echo "[----] Finish checking for Packages [----]"
sleep 2

# Check if yadm is installed
if ! command -v yadm &> /dev/null; then
    echo "Error: yadm installation failed or not found."
    exit 1
fi
echo "[----] yadm is installed [----]"
sleep 2

# Clone asdf and add to bashrc
git clone https://github.com/asdf-vm/asdf.git ~/.asdf
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
source ~/.bashrc
echo "[----] asdf cloned and added to bashrc [----]"
sleep 2

# Check if asdf is installed
if ! command -v asdf &> /dev/null; then
    echo "Error: asdf installation failed or not found."
    exit 1
fi
echo "[----] asdf is installed [----]"
sleep 2

# Install FNM - Fast Node Manager
echo "[----] Installing FNM [----]"
curl -fsSL https://fnm.vercel.app/install | bash
if ! command -v fnm &> /dev/null; then
    echo "Error: FNM installation failed or not found."
    exit 1
fi
source ~/.bashrc
echo "[----] FNM installed [----]"
sleep 2

# Install NeoVim using asdf
echo "[----] install NeoVim [----]"
asdf plugin add neovim
asdf install neovim latest
asdf global neovim latest
if ! command -v nvim &> /dev/null; then
    echo "Error: NeoVim installation failed or not found."
    exit 1
fi
echo "[----] NeoVim installed [----]"
sleep 2

# Install Plug for nvim
echo "[----] install Plug for nvim[----]"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "[----] Plug for nvim installed [----]"
sleep 2

# Install LTS Node.js version using FNM
fnm install --lts
echo "[----] LTS Node.js version installed [----]"
sleep 2

cd ~ 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo "[----] powerlevel10k cloned [----]"
sleep 2

# Install zsh plugins
echo "[----] Installing zsh plugins [----]"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.zsh/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git ~/.zsh/zsh-you-should-use
echo "[----] zsh plugins installed [----]"
sleep 2
echo "[----] Download fonts [----]"
sudo apt install fontconfig -y
# https://gist.github.com/matthewjberger/7dd7e079f282f8138a9dc3b045ebefa0?permalink_comment_id=4179773#gistcomment-4179773
declare -a fonts=(
    #BitstreamVeraSansMono
    #CodeNewRoman
    #DroidSansMono
    #FiraCode
    FiraMono
    #Go-Mono
    #Hack
    #Hermit
    #JetBrainsMono
    #Meslo
    #Noto
    #Overpass
    #ProggyClean
    #RobotoMono
    #SourceCodePro
    #SpaceMono
    #Ubuntu
    #UbuntuMono
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
echo "[----] Done download fonts [----]"

######## 1pass INIT ########
echo "[----] Install 1Password [----]"
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

echo "[----] Done install 1Password [----]"
######## END ########

# Clone dotfiles using yadm
echo "[----] Cloning dotfiles [----]"
yadm clone https://github.com/rnfrafael/dot-files.git
#sed -i '1iexec zsh' ~/.bashrc
# Run Neovim and execute the PlugInstall command
nvim --headless -c ":PlugInstall" -c ":qa"

# Switch to zsh
sudo chsh -s $(which zsh)
exec zsh
sudo apt upgrade -y

# wget -O - https://raw.githubusercontent.com//rnfrafael/dot-files/main/init-dot-files.sh | bash

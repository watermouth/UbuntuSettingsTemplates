#!/bin/bash
set -eu # e: error exit, u: error on undefined variable 

echo "execute once this file by source command "
echo "If you did not execute by 'source', press Ctrl + c."
sleep 1
echo "wait for 10 seconds..."

##########################################################################################
echo "genereal settings"
echo "Initial sudo execution"

### https://qiita.com/h-yoshikawa/items/15653d08f917ad6e39f8
sudo apt update
sudo apt upgrade
sudo apt install -y language-pack-ja # これは元々interactiveな設定をするパッケージ
sudo update-locale LANG=ja_JP.UTF-8
# 手動設定
sudo dpkg-reconfigure tzdata

### apt-getがscript中での利用向き. aptはinteractive向け. apt-getならインストール済みは無視してくれる.
sudo apt-get install -y manpages-ja manpages-ja-dev
sudo apt-get install -y build-essential curl file git wget

# for python install
sudo apt-get install --no-install-recommends make libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

##########################################################################################
echo "Installing pyenv"
# refer to https://github.com/pyenv/pyenv#installation

if [ ! -d ~/.pyenv ]; then
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
fi

echo "export PYENV_ROOT=\$HOME/.pyenv" >> ~/.bashrc
echo "export PATH=\$PYENV_ROOT/bin:\$PATH" >> ~/.bashrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.bashrc
##########################################################################################
echo "Installing pipenv"

# .venvをdirectory直下に作るための設定
echo -e "# pipenv property" >> ~/.bashrc 
echo 'export PIPENV_VENV_IN_PROJECT=1' >> ~/.bashrc 

echo "Done. Then execute the following:"
echo "source ~/.bashrc; ./03_setup_python.sh"
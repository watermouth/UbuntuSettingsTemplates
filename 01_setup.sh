#!/bin/bash
set -eu # e: error exit, u: error on undefined variable 

CWD=`pwd`

# copy
echo "copy files"
cd ./home
cp .vimrc ~/
cp .bashrc ~/
cp .profile ~/
cp .gitconfig ~/
cp .gitattributes_template ~/
cp .inputrc ~/
# cp .setup_permission_operate ~/ # probably not necessary
cp -r .ssh ~/

# /etc/wsl.conf
echo "Make \$PATH not get Windows' %PATH% envirionment variable"
cd ../
if [ ! -e /etc/wsl.conf ]; then
    # copy
    echo "create /etc/wsl.conf by copying"
    sudo cp etc/wsl.conf /etc/wsl.conf
else
    # append
    echo "append /etc/wsl.conf "
    cat etc/wsl.conf | sudo tee -a /etc/wsl.conf
fi

sleep 1

# set authorized_keys
cd ~/
echo "set authorized_keys file, if you want."
echo create authorized_keys files
touch .ssh/authorized_keys
# cat .ssh/id_rsa.pub >> .ssh/authorized_keys
# rm .ssh/id_rsa.pub

# set permission
echo "set permission"
chmod 700 .ssh
chmod 640 .ssh/authorized_keys

# 未確認
# \\wsl$\home\your_user_id\.ssh を vscode settings で設定すれば, windows 側からも参照できる?
# .sshは基本的にpermissionが厳しいのでその中にconfigを置くと, 参照できない?
# 下のようにしておけば, windows vscode (not wsl) から直接 ssh configを参照できて、wsl と windows vscodeの両方で共有できる.
# # move ssh config for windows environment
# # configファイルを.sshと異なるところに置くと, vs code remoteで使用できる.
# mkdir ~/ssh_config
# mv ~/.ssh/config ~/ssh_config/

# create this host's key-pairs without password
echo Create ssh key pair: type enter, enter and enter, if you want.
ssh-keygen -t ed25519 -C "$USER@`hostname`"

echo "To reflect /etc/wsl.conf, "
echo "Do 'Restart-Service LxssManager' by powershell with administrator previlege. This will shutdown WSL."

# # not working.
# cd $CWD
# sudo /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -File 01_01.ps1

# for vs code execution
export PATH=\$PATH:"/mnt/c/Program Files/Microsoft VS Code/bin"


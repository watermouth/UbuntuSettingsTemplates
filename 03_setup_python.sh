#!/bin/bash
set -eu # e: error exit, u: error on undefined variable

# pyenvで使うバージョンのpythonをインストールしておく
pyenv install 3.7.5

# python commandで呼んだときに実行されるvirtualenvを指定しておく
# pyenv shell すると, global の設定が無視されるようになるので, 要注意.
pyenv global 3.7.5 # 実は必要なさそう -> 下でpyenvのpipを使うためには必要. もしかしたら pyenv shell 3.7.5 でもよい.

# 念のためpipをupdateしておく

# 最新版pipenvを, pyenvで指定した仮想環境にインストールする
pip install pipenv
#  ~/.pyenv/versions/3.7.5/bin/ に pipenv などがインストールされている.
# pip install --user pipenv とすると、 ~/.local/bin/ にインストールされ, pyenv用に設定してあるPATH (shims) に含まれないので, 別途PATHに登録する必要が出てしまい、不自然.

# ここで次のようなwarningが出る-> pip install --user pipenv とした場合は, ユーザ固有の.localにbinを保存するので、PATHが通っていないことを注意してくれる.
# のだが、--user をつけずにインストールすれば、pyenvの下にpipenvをおいてくれるので、そもそも--userをつける必要がない。
# ちなみに 一度--userをつけてインストールしてしまうと、--userをつけずにinstallしてもインストール済みになってしまうので、pip uninstall pipenv してからやり直す必要がある。
#   WARNING: The script virtualenv-clone is installed in '/home/watermouth/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   WARNING: The script virtualenv is installed in '/home/watermouth/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.
#   WARNING: The scripts pipenv and pipenv-resolver are installed in '/home/watermouth/.local/bin' which is not on PATH.
#   Consider adding this directory to PATH or, if you prefer to suppress this warning, use --no-warn-script-location.

# これでpipenvを使う準備が完了.
# 注意事項
# requirements.txt から パッケージをインストールする場合, 直接依存するパッケージ以外削除しておく.
# その後, requirements.txt を使ってパッケージをインストールする
##########################################################################################

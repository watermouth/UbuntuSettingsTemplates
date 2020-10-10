# Ubuntu環境構築

主にWSL上での環境構築を想定.

## ubuntu環境設定スクリプト&templates

### home

各種ファイルを自分の設定に置き換えて用いる。


## WSL2 - Docker

WSL2 backend の Dockerを使う.

- Docker Desktop: Windows10 home なら home用 をインストール.  
  https://docs.docker.com/docker-for-windows/install-windows-home/

- WSL Integration (自分が使うdistributionからdockerを使う)  
  https://docs.docker.com/docker-for-windows/wsl/
  の 7 番目.
  powershell で デフォルトのdistributionを自分が使うdistributionに設定しておく.
  これにより, 自分が使うdistribution上からdockerコマンドが使え, docker daemonと通信できるようになる.  
  例: distribution が Ubuntu20.04  
  ``` powershell
  wsl -s Ubuntu20.04
  ```
### troubleshooting

- /etc/wsl.conf が効かない  
  すべてのterminalを終了したのち, powershell 上で
  ``` powershell
    Restart-Service LxssManager
    ```
    を実行する必要がある. Windows側で初期化しないといけないものらしい. 編集するたびに毎回Restart-Serviceが必要なので, 要注意である.  
    wsl.confの設定値については
    https://devblogs.microsoft.com/commandline/automatically-configuring-wsl/ に記述あり.
    コメントにRestart-Serviceについて書かれている.

- Ubuntu20.04などのdistribution 上で vscodeを起動する code コマンドが実行できなくなっている.  
  ``` bash
  > code .
  Command is only available in WSL or inside a Visual Studio Code terminal. 
  ```
  現象としては、vscode-server のcodeであるコマンドライン (CLI) 版が実行されていることを示している.
  vscode-serverのコマンドラインとは, Remote-WSL (やRemote-SSH) でvscodeから接続したときに生成されるものである. 指定したdistributionのterminal上で、localのWindowsのvscode を実行しても生成される. これらはvscodeのGUIを起動し、Remote-WSLで接続するために必要なもののようである. vscodeのGUIから接続したとき, vscode中のterminalではenvを見るとPATHの先頭にvscode-serverのbinが指定されている.
  では実行すべきcodeはどれかというと, localのWindowsのvscode である. これに対するpathが通っていれば良い.
  特に何も設定していなければ自然にWindowsの%PATH%がdistributionの$PATHに引き継がれているため, codeを実行できる. 何らかの$PATHの変更処理を実施しているために生じる問題である.
  対策としては, "/mnt/c/Program Files/Microsoft VS Code/bin" をWindows上のcodeのパスとすると,
  ``` bash
  export PATH=\$PATH:"/mnt/c/Program Files/Microsoft VS Code/bin" # double quote で囲むのがポイント.
  ```
  $PATHを通せばよい. /etc/wsl.conf にて Windows の %PATH% を引き継ぐ設定にしていれば特に対応不要であるが, 恐らく引き継がない設定にしたうえで, 明示的に必要なパスを追加指定するほうが無難だろう.
  
  - ちなみにPATHのような環境変数は.profileでexportしておくのがよい. .bashrcで定義すると, vs code などのプロセスを起動した際に .bashrcで重複してexportしてしまい、環境変数が汚くなる.
  - https://stackoverflow.com/questions/45114147/how-to-set-bash-on-ubuntu-on-windows-environment-variables-from-windows-pat
  - よくわからないもの: https://github.com/Microsoft/WSL/issues/1766
  - wslpath: 何やらどこかで使えそうなもの. https://laboradian.com/wslpath-command-for-wsl/

- docker コマンドが見つからない  
  WSL2では WSL Integration の設定がされていれば, distributionのPATH上でWindows上にインストールしたdockerとおそらく等価なexeを実行できる.
  /usr/bin/docker が存在しているため.
  ``` bash
  $ which docker
  /usr/bin/docker
  ```
  ```
  $ ls -l /usr/bin/
  ...
  lrwxrwxrwx  1 root   root          48  8月  8 19:48  docker -> /mnt/wsl/docker-desktop/cli-tools/usr/bin/docker
  lrwxrwxrwx  1 root   root          56  8月  8 19:48  docker-compose -> /mnt/wsl/docker-desktop/cli-tools/usr/bin/docker-compose
  ...
  ```
  となっている. docker daemonが起動すると /mnt/wsl にファイルが配置されるようである.
  - docker daemonを起動していないと, docker コマンドは見つからない. /usr/bin/docker 自体はあるが, /mnt/wsl/docker-desktop/cli-tools/ までしか存在しないため.

## 参考文献

いろいろ参考にした結果、参考元が分からなくなっている部分があるため、必要に応じて適宜ご指摘願います。

## docker-compose 実行時にエラー

### 現象

``` bash
> docker-compose up
Creating network "hello-world_default" with the default driver
Building hello
Traceback (most recent call last):
  File "bin/docker-compose", line 6, in <module>
  File "compose/cli/main.py", line 72, in main
  File "compose/cli/main.py", line 128, in perform_command
  File "compose/cli/main.py", line 1078, in up
  File "compose/cli/main.py", line 1074, in up
  File "compose/project.py", line 548, in up
  File "compose/service.py", line 367, in ensure_image_exists
  File "compose/service.py", line 1106, in build
  File "site-packages/docker/api/build.py", line 261, in build
  File "site-packages/docker/api/build.py", line 308, in _set_auth_headers
  File "site-packages/docker/auth.py", line 301, in get_all_credentials
  File "site-packages/docker/auth.py", line 287, in _get_store_instance
  File "site-packages/docker/credentials/store.py", line 25, in __init__
docker.credentials.errors.InitializationError: docker-credential-desktop.exe not installed or not available in PATH
[2300] Failed to execute script docker-compose
```

<b>docker.credentials.errors.InitializationError: docker-credential-desktop.exe not installed or not available in PATH
</b>
ということなので, (上で明示的に追加していたvs code の他にも)PATHに追加しておく必要があった.

``` bash
export PATH=$PATH:"/mnt/c/Program Files/Microsoft VS Code/bin:/mnt/c/Program Files/Docker/Docker/resources/bin"

```

### 参考

- https://roy-n-roy.github.io/Windows/WSL%EF%BC%86%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A/DockerDesktopError/

## いつの間にかvscodeを使っていると, user/password 認証を使っているremote repository に対して git push 出来なくなった

### 現象

``` bash
watermouth@DESKTOP-RSIV4E1:~/proj/UbuntuSettingsTemplates$ git push origin master
fatal: cannot run /home/watermouth/.vscode-server/bin/91899dcef7b8110878ea59626991a18c8a6a1b3e/extensions/git/dist/askpass.sh: そのようなファイルやディレクトリはありません
Username for 'https://github.com':

watermouth@DESKTOP-RSIV4E1:~/proj/UbuntuSettingsTemplates$ ll ~/.vscode-server/bin/
合計 12
drwxr-xr-x 3 watermouth watermouth 4096  8月 22 08:43 ./
drwxr-xr-x 5 watermouth watermouth 4096  8月  8 19:30 ../
drwxr-xr-x 6 watermouth watermouth 4096  8月 22 08:43 3dd905126b34dcd4de81fa624eb3a8cbe7485f13/
```

vscode-serverの下のフォルダ名が変わっている.
今回の場合は, vscodeのバージョンを上げて, vscode-serverが更新されたことが原因と思われる.

### 対策

``` bash  
  git config --global credential.helper cache
  git push origin master # などでusername/password 認証を実行. 以後はキャッシュされるらしく, username/password入力不要になる.
```

public/private key を使うべきという話ではある.

### 参考

- https://github.com/cdr/code-server/issues/208

## docker run 時の default 実行 コマンド

DockerfileのENTRYPOINTで指定されたコマンドが実行される. imageだけ取得した場合はどうやって知るか.

``` bash
docker image history --no-trunc image_name > image_history
```

のようにするとよいらしい.


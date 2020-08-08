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

- distribution 上での code コマンドが実行できなくなっている.  
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
  export PATH=$PATH:"/mnt/c/Program Files/Microsoft VS Code/bin" # double quote で囲むのがポイント.
  ```
  $PATHを通せばよい. /etc/wsl.conf にて Windows の %PATH% を引き継ぐ設定にしていれば特に対応不要であるが, 恐らく引き継がない設定にしたうえで, 明示的に必要なパスを追加指定するほうが無難だろう.
  - https://stackoverflow.com/questions/45114147/how-to-set-bash-on-ubuntu-on-windows-environment-variables-from-windows-pat
  - よくわからないもの: https://github.com/Microsoft/WSL/issues/1766
  - wslpath: 何やらどこかで使えそうなもの. https://laboradian.com/wslpath-command-for-wsl/

- docker コマンドが見つからない?

? windows 上の docker へのパスがなくなっている (distributionからの)

? docker daemonを起動していない


## 参考文献

いろいろ参考にした結果、参考元が分からなくなっている部分があるため、必要に応じて適宜ご指摘願います。


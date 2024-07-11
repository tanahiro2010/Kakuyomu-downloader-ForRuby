# Kakuyomu Downloader

## creator
### My info
YouTube: https://youtube.com/@tanahiro2010<br>
Twitter: https://twitter.com/tanahiro2010<br>
Discord: https://discord.gg/6GF2RSK6j7<br>
Site: https://tanahiro2010.cloudfree.jp and https://tanahiro2010.zatunen.com

### Zisty's info
Twitter: https://twitter.com/TeamZisty<br>
Site: https://zisty.net<br>
Discord: https://discord.gg/jjqCGjm2Tw


## Japanese
**Kakuyomu Downloaderは、カクヨムの小説をダウンロードするためのソフトウェアです。このソフトウェアを使用すると、コマンドプロンプトまたはソフトウェア自体から小説をダウンロードすることができます。**
## 概要

- ソフト名: `kakuyomu.exe`
- コマンドプロンプトからの起動とソフトからの直接起動が可能です。

## インストール
```bash
git clone https://github.com/tanahiro2010/Kakuyomu-downloader
```

## ディレクトリ構成
```dir
Kakuyomu-downloader
│ README.md
│
├─.idea
│      .gitignore
│      Kakuymu-Installer.iml
│      modules.xml
│      workspace.xml
│
├─bin
│  │  kakuyomu.exe
│  │  userAgents.json
│  │
│  └─system
│      │  kakuyomu.rb
│      │  main.rb
│      │  bin (Folder)
│
└─src
    │  kakuyomu.rb
    │  main.rb
    │  userAgents.json
    │
    └─test
            kakuyomu.rb
            main.rb
            userAgents.json
```


## 使い方

### コマンドプロンプトからの使用

1. コマンドプロンプトを開きます。
2. 以下のコマンドを実行して小説をダウンロードします：

   ```bash
   kakuyomu install book_id
   ```
   なお、このbook_idというのは、
   ```url
   https://kakuyomu.jp/works/{Book_Id}
   ```
   のことを言います
### ソフトから
ソフトをクリックすると、上記と同じくbook_idを求められるので入力しましょう
エンターを押すと終了です。

## English

**Kakuyomu Downloader is software for downloading novels from Kakuyomu. By using this software, you can download novels either from the command prompt or directly from the software itself.**


## Overview


- Software name: `kakuyomu.exe`


- Can be launched from the command prompt or directly from the software.


## Installation


```bash
git clone https://github.com/tanahiro2010/Kakuyomu-downloader
```


## Directory Structure


```dir
Kakuyomu-downloader
│ README.md
│
├─.idea
│ .gitignore
│ Kakuymu-Installer.iml
│ modules.xml
│ workspace.xml
│
├─bin
│ │ kakuyomu.exe
│ │ userAgents.json
│ │
│ └─system
│ │ kakuyomu.rb
│ │ main.rb
│ │ bin (Folder)
│
└─src
│ kakuyomu.rb
│ main.rb
│ userAgents.json
│
└─test
kakuyomu.rb
main.rb
userAgents.json
```


## Usage


### Using from the Command Prompt


1. Open the command prompt.


2. Execute the following command to download a novel:


```bash
kakuyomu install book_id

```


Note that the `book_id` refers to the part of the URL:


```url
https://kakuyomu.jp/works/{Book_Id}

```


### From the Software


Click on the software, and you will be prompted to enter the `book_id` as mentioned above. Press Enter to finish.
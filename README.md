# dotfiles

## Installation

```bash
$ curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash
```

## 目標

最高の開発環境

具体的には ...

- 再現性
- ポータビリティ
    - AWS、GCP、Mac などの各種環境で動作する
    - BSD 系と GNU 系のコマンドがあるから難しいかも
- 開発する言語のバージョンが共存可能
- 一般的な開発に対応
    - Web、iOS、Android
- OS のバージョンアップに追従
- 高いセキュリティ

手段

- Infrastructure as Code の徹底
- 冪等
- CI

要素

- コンピューティング
    - Shell
        - dotfiles
            - Bash
                - Zsh
            - Vim
            - tmux
        - Shell Script
    - 言語の各種バージョン対応
        - asdf
        - Docker
    - IDE
        - Xcode
        - Unity
        - Android Studio
        - クラウド IDE
    - GUI
        - Ubuntu など
- ネットワーキング
- ストレージ
- 価格

---

## GCE でのセットアップ

インスタンスタイプ
e2-standard-4
月間 126 ドル程度 = 1 日 (24 h) で 4 ドル程度

起動

```
gcloud beta compute instances create \
  working-instance \
  --zone=asia-northeast1-b \
  --machine-type=e2-standard-4 \
  --image=ubuntu-2004-focal-v20200529 \
  --image-project=ubuntu-os-cloud \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-ssd
```

停止

```
gcloud beta compute instances delete \
  working-instance \
  --zone=asia-northeast1-b \
  --quiet
```

VNC 接続のため、ローカルで実行するコマンド

```bash
gcloud auth login

gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 5901:localhost:5901
```

参考

- https://blog.amedama.jp/entry/2019/03/23/151554

## git セットアップ

```bash
git config --global user.email "39944763+os1ma@users.noreply.github.com"
git config --global user.name "Yuki Oshima"
```

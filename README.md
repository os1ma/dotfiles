# dotfiles

## 対応環境

* Mac
* GCE (Ubuntu 20.04)

## Installation

### Mac

```bash
$ curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash
```

### GCE (Ubuntu 20.04)

* インスタンスタイプ
  * e2-standard-4
  * vCPU 4 コア
  * メモリ 16 GB
  * 料金
    * 月間 126 ドル程度
    * 1 日 (24 h) で 4 ドル程度

#### 起動

Cloud Shell で以下のコマンドを実行

※ startup-script 内の ${USER} が Cloud Shell のログインユーザに置き換えられた上で実行される

```bash
$ gcloud config set project \
  "$(gcloud projects list --filter 'NAME="My First Project"' --format 'value(projectId)')"
$ gcloud beta compute instances create \
  working-instance \
  --zone=asia-northeast1-b \
  --machine-type=e2-standard-4 \
  --image=ubuntu-2004-focal-v20200529 \
  --image-project=ubuntu-os-cloud \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --boot-disk-size=100GB \
  --boot-disk-type=pd-ssd \
  --metadata startup-script="
    curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/ubuntu/wait_until_user_created.sh \
      | bash -s -- ${USER} \
    && sudo -u ${USER} sh -c '
      curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash \
      && ~/dotfiles/common/main.sh
    '
  "
```

#### 起動スクリプトのログ確認

起動スクリプトの完了までは 10 分程度かかる

VM に SSH 接続し、以下のコマンドを実行することで、起動スクリプトのログを確認可能

```bash
$ tail -f -n +1 /var/log/syslog | grep startup-script
```

#### git のセットアップ

```bash
$ git config --global user.email "39944763+os1ma@users.noreply.github.com"
$ git config --global user.name "Yuki Oshima"
```

#### code-server

VM に SSH 接続し、以下のコマンドで code-server を起動

```bash
$ code-server --auth none ~
```

ローカルで以下のコマンドを実行して SSH ポートフォワード

```bash
$ gcloud auth login
$ gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 8080:localhost:8080
```

#### VNC 接続用ポートフォワード

```bash
$ gcloud auth login
$ gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 5901:localhost:5901
```

#### 停止

```
$ gcloud beta compute instances delete \
  working-instance \
  --zone=asia-northeast1-b \
  --quiet
```

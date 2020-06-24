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

インスタンスタイプ
e2-standard-4
月間 126 ドル程度 = 1 日 (24 h) で 4 ドル程度

起動

Cloud Shell で以下のコマンドを実行
※ startup-script 内の "${USER}" が Cloud Shell のログインユーザに置き換えられた上で実行される

```bash
$ gcloud beta compute instances create \
  working-instance \
  --zone=asia-northeast1-b \
  --machine-type=e2-standard-4 \
  --image=ubuntu-2004-focal-v20200529 \
  --image-project=ubuntu-os-cloud \
  --subnet=default \
  --network-tier=PREMIUM \
  --maintenance-policy=MIGRATE \
  --boot-disk-size=10GB \
  --boot-disk-type=pd-ssd \
  --metadata startup-script="
    sudo -u ${USER} sh -c '
      curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash \
      && ~/dotfiles/gce_ubuntu/main.sh
    '
  "
```

起動スクリプトのログ確認コマンド

```bash
$ tail -f -n +1 /var/log/syslog | grep startup-script
```

SSH 接続して以下のコマンドを実行

```bash
$ curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash
$ git config --global user.email "39944763+os1ma@users.noreply.github.com"
$ git config --global user.name "Yuki Oshima"
$ ~/dotfiles/gce_ubuntu/main.sh
```

VNC 接続のため、ローカルで以下のコマンドを実行

```bash
$ gcloud auth login
$ gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 5901:localhost:5901
```

停止

```
$ gcloud beta compute instances delete \
  working-instance \
  --zone=asia-northeast1-b \
  --quiet
```

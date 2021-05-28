# dotfiles

## 対応環境

* Mac
* EC2 (Amazon Linux 2)
* GCE (Ubuntu 20.04)

## Installation

### Mac

```console
curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash
```

### AWS (Amazon Linux 2)

#### 起動

```console
aws ec2 run-instances \
  --count 1 \
  --image-id ami-0ca38c7440de1749a \
  --instance-type c5a.large \
  --key-name my-key \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=working-instance}]' \
  --subnet-id subnet-a1bf0ae9 \
  --security-group-ids sg-02c3f4dc4949c90a1 \
  --associate-public-ip-address \
  --iam-instance-profile Name=EC2_development \
  --user-data '#!/bin/bash
    sudo -u ec2-user sh -c "
      cd /home/ec2-user \
      && curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash \
      && ~/dotfiles/common/main.sh
    "
  '
```

#### 状態確認

```console
aws ec2 describe-instances \
  --filters 'Name=tag:Name,Values=working-instance' \
  | jq '.Reservations[].Instances[] | .InstanceId, .State.Name, .NetworkInterfaces[].Association.PublicIp'
```

#### SSH ポートフォワード

```console
ssh -i my-key.pem -N -L 8080:localhost:8080 ec2-user@<Public IP Address>
```

#### 停止

```console
aws ec2 terminate-instances --instance-ids \
  $(aws ec2 describe-instances \
    --filters 'Name=tag:Name,Values=working-instance' \
    | jq -r '.Reservations[].Instances[].InstanceId')
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

```console
gcloud config set project \
  "$(gcloud projects list --filter 'NAME="My First Project"' --format 'value(projectId)')"
gcloud beta compute instances create \
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

VM に SSH 接続し、以下のコマンドを実行することで、起動スクリプトのログを確認可能

```console
tail -f -n +1 /var/log/syslog | grep startup-script
```

#### SSH ポートフォワード

```console
gcloud auth login
gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 8080:localhost:8080
```

#### 停止

```console
gcloud beta compute instances delete \
  working-instance \
  --zone=asia-northeast1-b \
  --quiet
```

## 関連コマンド

### git のセットアップ

```console
git config --global user.email "39944763+os1ma@users.noreply.github.com"
git config --global user.name "Yuki Oshima"
```

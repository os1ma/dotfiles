# dotfiles

## Support environment

- Mac
- EC2 (Amazon Linux 2)
- GCE (Ubuntu 20.04)

## Installation

### Mac

```console
curl -L https://raw.githubusercontent.com/os1ma/dotfiles/master/install.sh | bash
```

### AWS (Amazon Linux 2)

- Instance Type
  - c5a.large
  - 4 vCPU
  - 8 GB Memory
  - Pricing
    - $138 per month
    - $4.8 per day (24 hour)

#### Run

```console
aws ec2 run-instances \
  --count 1 \
  --image-id ami-0ca38c7440de1749a \
  --instance-type c5a.large \
  --key-name my-key \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=working-instance}]' \
  --subnet-id subnet-a1bf0ae9 \
  --security-group-ids sg-037ef5e83bff69807 \
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

#### Check status

```console
aws ec2 describe-instances \
  --filters 'Name=tag:Name,Values=working-instance' \
  | jq '.Reservations[].Instances[] | .InstanceId, .State.Name, .NetworkInterfaces[].Association.PublicIp'
```

#### SSH port forwarding

```console
ssh -i my-key.pem -N -L 8080:localhost:8080 ec2-user@<Public IP Address>
```

#### Terminate

```console
aws ec2 terminate-instances --instance-ids \
  $(aws ec2 describe-instances \
    --filters 'Name=tag:Name,Values=working-instance' \
    | jq -r '.Reservations[].Instances[].InstanceId')
```

### GCE (Ubuntu 20.04)

- Instance Type
  - e2-standard-4
  - 4 vCPU
  - 16 GB Memory
  - Pricing
    - $126 per month
    - $4 per day (24 hour)

#### Run

Run following commands on Cloud Shell.

Note: `${USER}` in the startup-script is replaced by the Cloud Shell login user before running.

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

#### Show the log of startup script

```console
tail -f -n +1 /var/log/syslog | grep startup-script
```

#### SSH port forwarding

```console
gcloud auth login
gcloud beta compute ssh \
  working-instance \
  --zone=asia-northeast1-b \
  -- -N -L 8080:localhost:8080
```

#### Terminate

```console
gcloud beta compute instances delete \
  working-instance \
  --zone=asia-northeast1-b \
  --quiet
```

## Other commands

### Setup Git

```console
setup_git.sh
```

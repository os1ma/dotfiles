# .bashrc

is_mac() {
  [[ "$(uname)" == 'Darwin' ]]
}

exist_command() {
  local command="$1"
  which "${command}" >> /dev/null
}

source_if_exist() {
  local target="$1"
  if [[ -e "${target}" ]]; then
    source "${target}"
  fi
}

# ###### #
# prompt #
# ###### #

BLACK='\[\e[0;30m\]'
RED='\[\e[0;31m\]'
GREEN='\[\e[0;32m\]'
YELLOW='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
PINK='\[\e[0;35m\]'
LIGHT_BLUE='\[\e[0;36m\]'
WHITE='\[\e[0;37m\]'
END_OF_COLOR='\[\e[m\]'
export PS1="$GREEN\w$RED\$(__git_ps1) $GREEN\$ $END_OF_COLOR"

# ## #
# ls #
# ## #

# ディレクトリを見やすくするために青のボールドに変更
export LSCOLORS='Exfxcxdxbxegedabagacad'

# ####### #
# aliases #
# ####### #

if is_mac; then
  alias ls='ls -G'
else
  alias ls='ls --color'
fi

alias mv='mv -i'
alias rm='rm -i'
alias cp='cp -i'
alias grep='grep --color'
alias git-log='git log --graph --all --format="%x09%an%x09%h %d %s"'

if is_mac; then
  alias chrome='open -a "Google Chrome"'
  alias marp='/Applications/Marp.app/Contents/MacOS/Marp'
  alias xcode='open -a /Applications/Xcode.app'
fi

# ### #
# git #
# ### #

git config --global core.editor vim

# ##################### #
# Environment Variables #
# ##################### #

export PATH="${PATH}:${HOME}/dotfiles/bin"
export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"

# JAVA_HOME
source_if_exist ~/.asdf/plugins/java/set-java-home.bash

# ########### #
# completions #
# ########### #

source_if_exist /usr/local/etc/bash_completion

# asdf
if [[ -d $HOME/.asdf ]]; then
  . $HOME/.asdf/asdf.sh
  . $HOME/.asdf/completions/asdf.bash
fi

# kubectl
if exist_command kubectl; then
  source <(kubectl completion bash)
fi

# awscli
complete -C '/usr/local/bin/aws_completer' aws

# gcloud
# Ubuntu
source_if_exist /snap/google-cloud-sdk/current/completion.bash.inc
# Mac
source_if_exist /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc

# ecsctl
if exist_command eksctl; then
  . <(eksctl completion bash)
fi

# ######### #
# functions #
# ######### #

json2yaml() {
  cat - | ruby -ryaml -rjson -e 'puts YAML.dump(JSON.parse(STDIN.read))'
}

curl-post-json() {
  local url="$1"
  local json="$2"

  curl -X POST -H "Content-Type: application/json" -d "${json}" "${url}"
}

shell_template() {
  local gist_url='https://api.github.com/gists/349072921f3cccbbc790df1019525b1f '
  curl -sS "${gist_url}" | jq -r '.files."shell-script-template.sh".content'
}

compile() {
  gcc -o ${1%.*} ${1} && ./${1%.*}
}

if is_mac; then
  idea() {
    local target_dir="$(cd "$1" && pwd)"
    /Applications/IntelliJ\ IDEA\ CE.app/Contents/MacOS/idea "${target_dir}" > /dev/null 2>&1 &
  }
fi

# ################ #
# docker functions #
# ################ #

docker-search-tags() {
  curl -s https://registry.hub.docker.com/v1/repositories/$1/tags | jq -r '.[].name'
}

docker-clean() {
  if [ $(docker container ls -aq | wc -l) -ne 0 ] ; then
    docker container rm -f $(docker container ls -aq)
  fi
  if [ $(docker volume ls -q | wc -l) -ne 0 ] ; then
    docker volume rm $(docker volume ls -q)
  fi
  if [ $(docker image ls -q | wc -l) -ne 0 ] ; then
    docker image rm -f $(docker image ls -q)
  fi
  docker system prune -f
}

docker-compose-restart() {
  docker-compose down \
    && docker-compose up -d \
    && docker-compose logs -f
}

# ################### #
# AWS & GCP functions #
# ################### #

gcp() {
  gcloud beta interactive
}

cfn-validate() {
  aws cloudformation validate-template --template-body "file://$(pwd)/$1"
}

# .bashrc

is_mac() {
  [[ "$(uname)" == 'Darwin' ]]
}

exist_command() {
  local command="$1"
  which "${command}" >> /dev/null 2>&1
}

source_if_exist() {
  local target="$1"
  if [[ -e "${target}" ]]; then
    source "${target}"
  fi
}

# ####### #
# xmodmap #
# ####### #

if exist_command xmodmap; then
  xmodmap "${HOME}/.Xmodmap"
fi

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

source_if_exist /usr/share/bash-completion/completions/git
source "${HOME}/dotfiles/downloads/git-prompt.sh"
export PS1="$LIGHT_BLUE\$(hostname) $GREEN\w$RED\$(__git_ps1) $GREEN\$ $END_OF_COLOR"

if is_mac; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

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
  alias x86='arch -x86_64'
  alias chrome='open -a "Google Chrome"'
  alias marp='/Applications/Marp.app/Contents/MacOS/Marp'
  alias xcode='open -a /Applications/Xcode.app'
fi

if exist_command xdg-open; then
  alias open='xdg-open'
fi

# ### #
# git #
# ### #

git config --global core.editor vim

# #### #
# asdf #
# #### #

if exist_command asdf; then
  export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
  . <(asdf completion bash)
fi


# ##################### #
# Environment Variables #
# ##################### #

export PATH="${PATH}:${HOME}/dotfiles/bin"
if exist_command yarn; then
  export PATH="${PATH}:$(yarn global bin)"
fi
export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"
mkdir -p "${TF_PLUGIN_CACHE_DIR}"

# JAVA_HOME
source_if_exist ~/.asdf/plugins/java/set-java-home.bash

# Homebrew
if is_mac; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
  export PATH="/opt/homebrew/opt/awscli@1/bin:$PATH"
fi

# ~/.local/bin
export PATH="~/.local/bin:${PATH}"

# ssh-agent
if is_mac; then
  if ! ssh-add -l &>/dev/null; then
    ssh-add --apple-use-keychain
  fi
fi

# ########### #
# completions #
# ########### #

source_if_exist /usr/local/etc/bash_completion

if is_mac; then
  source ~/dotfiles/downloads/git-completion.bash
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
  local template="${HOME}/dotfiles/templates/shell_script_template.sh"
  cat "${template}"
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
  docker system prune --force --all --volumes
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

# ######## #
# Anaconda #
# ######## #

enable_anaconda() {
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$("${HOME}/anaconda3/bin/conda" 'shell.bash' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "${HOME}/anaconda3/etc/profile.d/conda.sh" ]; then
          . "${HOME}/anaconda3/etc/profile.d/conda.sh"
      else
          export PATH="${HOME}/anaconda3/bin:$PATH"
      fi
  fi
  unset __conda_setup
}

# ###### #
# Fly.io #
# ###### #

export FLYCTL_INSTALL="/home/oshima/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

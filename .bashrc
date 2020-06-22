# .bashrc

is_mac() {
  [[ "$(uname)" == 'Darwin' ]]
}

exist_command() {
  local command="$1"
  which "${command}" >> /dev/null
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

alias ls='ls -G'
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

# ##################### #
# Environment Variables #
# ##################### #

export TF_PLUGIN_CACHE_DIR="${HOME}/.terraform.d/plugin-cache"

# ########### #
# completions #
# ########### #

# kubectl
if [[ -e '/usr/local/etc/bash_completion' ]]; then
  source /usr/local/etc/bash_completion
fi

# awscli
complete -C '/usr/local/bin/aws_completer' aws

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

docker-nginx() {
  local image='nginx:1.17.6-alpine'

  docker run \
    --rm \
    -p 8080:80 \
    -v "$(pwd)":/usr/share/nginx/html \
    "${image}"
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

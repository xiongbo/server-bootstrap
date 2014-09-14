#!/bin/bash

echo "-----Start bootstrap for production-----"
sudo apt-get update
sudo apt-get -y install git-core curl vim openssl libtool bison imagemagick autoconf libncurses5-dev\
  build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev\
  exuberant-ctags libsqlite3-dev sqlite3 tmux

echo "-----Install nodejs-----"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.16.0/install.sh | bash
nvm install 0.10
nvm use 0.10
echo "registry = http://registry.cnpmjs.org" >> ~/.npmrc
npm install -g express supervisor

echo "-----Install Database-----"
echo "Well you need to install mysql?(Y/N) (default: N) __"
read dorx
dorx=${dorx:=N}
if [ $dorx = Y ]; then
  sudo apt-get -y install mysql-server libmysqlclient-dev
fi

echo "Well you need to install postgresql?(Y/N) (default: N) __"
read dory
dory=${dory:=N}
if [ $dory = Y ]; then
  sudo apt-get -y install postgresql libpq-dev
fi

echo "-----Install Zsh-----"
sudo apt-get -y install zsh
wget --no-check-certificate http://install.ohmyz.sh -O - | sh
echo "Changing your shell to zsh ..."
chsh -s $(which zsh)

echo "-----Install ruby by rbenv-----"
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.zshrc
printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.zshrc

rbenv bootstrap-ubuntu-12-04
ruby_version="$(curl -sSL http://ruby.thoughtbot.com/latest)"
printf "Installing Ruby $ruby_version ..."
rbenv install -s "$ruby_version"
rbenv global "$ruby_version"
rbenv rehash

gem update --system
gem install bundler rake --no-document
rbenv rehash

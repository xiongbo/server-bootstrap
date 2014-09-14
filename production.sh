#!/bin/bash

fancy_echo() {
  printf "\n%b\n" "$1"
}

echo "-----Start bootstrap for production-----"
sudo apt-get update
sudo apt-get -y install git-core curl vim openssl libtool bison imagemagick autoconf libncurses5-dev\
  build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev

echo "-----Install nodejs-----"
sudo apt-get -y install python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs

echo "-----Install NGINX-----"
sudo apt-get -y install nginx
sudo service nginx start

echo "-----Install Database-----"
echo "Well you need to install mysql?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install mysql-server libmysqlclient-dev
fi

echo "Well you need to install postgresql?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install postgresql libpq-dev
fi

echo "-----Install ruby by rbenv-----"
curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc

rbenv bootstrap-ubuntu-12-04
ruby_version="$(curl -sSL http://ruby.thoughtbot.com/latest)"
fancy_echo "Installing Ruby $ruby_version ..."
rbenv install -s "$ruby_version"
rbenv global "$ruby_version"
rbenv rehash

gem update --system
gem install bundler rake --no-document
rbenv rehash

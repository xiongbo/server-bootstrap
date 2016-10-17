#!/bin/bash

function re_source {
  xdotool type 'source ~/.bashrc'
  xdotool key Return
}

echo "-----Start bootstrap for production-----"
sudo apt-get update
sudo apt-get -y install git-core curl vim openssl libtool bison imagemagick autoconf libncurses5-dev\
  build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libffi-dev libcurl4-openssl-dev libpq-dev

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

echo "Well you need to install postgresql-client?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install postgresql-client libpq-dev
fi

echo "-----Install Others-----"
echo "Well you need the gem of curb?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install libcurl3 libcurl3-gnutls libcurl4-openssl-dev
fi

echo "-----Install ruby by rbenv-----"
git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
echo -e 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
echo -e 'eval "$(rbenv init - --no-rehash)"' >> ~/.bashrc
sudo chown -R deploy:deploy ~/.rbenv/
. ./.bashrc

ruby_version="2.3.0"
printf "Installing Ruby $ruby_version ..."
rbenv install "$ruby_version"
rbenv global "$ruby_version"
rbenv rehash

gem update --system
gem install bundler rake --no-document
rbenv rehash

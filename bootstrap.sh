#!/bin/bash
set -e

# Overwrite env from base image
export HOME=/opt/home
export TEMP_DIR=/tmp
export TMPDIR=/tmp
export TMP_DIR=/tmp

# Other environment variables
export NVM_DIR=/opt/nvm
export PROFILE=$HOME/.profile
export DEMETEORIZER_VERSION=3.1.0
export NODE_VERSION=0.10.41
export NPM_VERSION=3.9.6

# Create $HOME/.profile and export environment variable
if [[ ! -d $HOME ]]; then
  mkdir -p $HOME
fi

touch $PROFILE

# Install nvm
mkdir -p $NVM_DIR
curl https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
source $PROFILE

# Ensure mop can use nvm, but not write to it
chown mop:mop /opt/nvm/nvm.sh
chmod g-w /opt/nvm/nvm.sh

# Setup NPM and Node versions
printf "Installing node $NODE_VERSION\n"
nvm install $NODE_VERSION > /dev/null 2>&1

printf "Installing npm $NPM_VERSION\n"
npm install npm@$NPM_VERSION --global > /dev/null 2>&1

# Install get-version
npm install -g get-version

# Install demeteorizer
npm install -g demeteorizer@$DEMETEORIZER_VERSION

nvm alias deploy $(nvm current)

# Install Meteor
curl https://install.meteor.com/ | sh

# Ensure mop can copy the Meteor distribution
chown mop:mop -R $HOME

# Clean stuff up that's no longer needed
apt-get autoclean && apt-get autoremove -y && apt-get clean

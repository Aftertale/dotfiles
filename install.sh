#!/bin/zsh

export CODEHOME=$HOME/code/src
export CODEDOTFILESHOME=$CODEHOME/github.com/aftertale/dotfiles

# Helper function to DRY things up a tad
function link() {
  FILENAME="$1"
  ln -s $CODEDOTFILESHOME/$FILENAME $HOME/.config/$FILENAME
}

# Install xcode command-line-tools (may not be necessary)
# touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
# softwareupdate -i -a
# rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

# Install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Create code directory
mkdir -p $HOME/code/src/github.com/aftertale/dotfiles/zsh/

# clone repo
git clone https://github.com/aftertale/dotfiles $HOME/code/src/github.com/aftertale/dotfiles

# Install brew bundle
brew bundle install --file=$CODEDOTFILESHOME/Brewfile

# Install oh-my-zsh
# oh-my-zsh replaces .zshrc by default, so we are installing it first
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# symlink .zshrc
rm $HOME/.zshrc
ln -s $CODEDOTFILESHOME/zsh/zshrc $HOME/.zshrc

#############
##  NVIM   ##
#############
# symlink nvim (may want to symlink entire .config folder)
link nvim

#############
# Alacritty #
#############
link alacritty

###############
# Hammerspoon #
###############
link hammerspoon

###############
#    skhd    ##
###############
link skhd



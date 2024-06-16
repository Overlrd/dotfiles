# dotfiles 

The config files of my system which consists mostly of :
 - i3wm
 - xfce4-terminal
 - neovim 

## Requirements 

Ensure you have the following packages installed :
 - git 
 - stow

check out how stow works 

```shell
$ man stow
```

## Installation

First clone this repo into your $HOME directory

```shell
$ git clone git@github.com:Overlrd/dotfiles.git
```
then use GNU Stow to create symblinks
```shell
$ stow .
```

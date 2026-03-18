#!/bin/bash

function setup () { 
    ln -nfs $(realpath $1) ~/.$1
}

setup vimrc
setup bashrc
setup bash_aliases
setup emacs.d

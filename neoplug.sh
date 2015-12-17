#!/bin/sh

trap 'rm -f plug_install.vim' EXIT ERR

[ -f ~/.vim/autoload/plug.vim ] ||
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

shebang=0
{
    for plug in neobundle*.toml
    do
        [ -f "$plug" ] || continue
        if [ $shebang -eq 0 ]; then
            echo "#!vim -S"
            shebang=1
        fi

        grep "^repository" $plug \
            | awk '{print $3}' \
            | sed -e 's/^/Plug /g'
    done | sort -u
} >plug_install.vim

if [ -s plug_install.vim ]; then
    vim -S plug_install.vim -c quit
fi

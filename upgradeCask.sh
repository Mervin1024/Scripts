#!/usr/bin/env bash

help=`brew cu --help | head -1`
if [ "brew cu [options]" = "${help}" ]; then
    brew cu -a --yes
else
    (set -x; brew update;)

    (set -x; brew cleanup;)
    (set -x; brew cask cleanup;)

    red=`tput setaf 1`
    green=`tput setaf 2`
    reset=`tput sgr0`

    casks=( $(brew cask list) )

    for cask in ${casks[@]}
    do
        version=$(brew cask info ${cask} | sed -n "s/$cask:\ \(.*\)/\1/p")
        installed=$(find "/usr/local/Caskroom/$cask" -type d -maxdepth 1 -name "$version")

        if [[ -z ${installed} ]]; then
            echo "${red}${cask}${reset} requires ${red}update${reset}."
            (set -x; brew cask uninstall ${cask} --force;)
            (set -x; brew cask install ${cask} --force;)
        else
            echo "${red}${cask}${reset} is ${green}up-to-date${reset}."
        fi
    done
fi
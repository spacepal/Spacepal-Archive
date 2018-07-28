#!/bin/bash
RED="\033[31m"
CLEAR="\033[0m"
err=false

if [ "$(which go)" = "" ]; then
		printf "\n$RED Go is not detected $CLEAR \n"
    printf " You can download it: https://golang.org/dl/ \n"
    err=true
fi

if [ "$(which ruby)" = "" ]; then
		printf "\n$RED Ruby is not detected $CLEAR \n"
    printf " You can download it: https://www.ruby-lang.org/en/downloads/ \n"
    err=true
fi

if [ "$(which bundle)" = "" ]; then
		printf "\n$RED Bundler is not detected $CLEAR \n"
    printf " You can install it: \`gem install bundler\` \n"
    err=true
fi

if [ "$(which npm)" = "" ]; then
		printf "\n$RED Node.js is not detected $CLEAR \n"
    printf " You can install it: https://nodejs.org/en/download/current/ \n"
    err=true
fi

if [ "$(which git)" = "" ]; then
		printf "\n$RED Git is not detected $CLEAR \n"
    printf " You can download it: https://git-scm.com/downloads \n"
    err=true
fi


if $err; then
  echo ""
  exit 1
fi

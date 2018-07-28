#!/bin/bash

DEFAULT_FRONTEND_PUBLIC="localhost:8080"
DEFAULT_BACKEND_PUBLIC="localhost:3000"
DEFAULT_BACKEND_LOCAL="localhost:3000"
DEFAULT_AISERVICE_LOCAL="localhost:3131"

frontend=$SPACEPAL_FRONTEND_PUBLIC
backend_public=$SPACEPAL_BACKEND_PUBLIC
backend_local=$SPACEPAL_BACKEND_LOCAL
aiservice=$SPACEPAL_AISERVICE_LOCAL

BLUE="\033[34m"
CLEAR="\033[0m"

printf "\n\n$BLUE Please, attention $CLEAR\n\n"

if [ -z $frontend ]; then
  read -p "Enter public address of frontend [$DEFAULT_FRONTEND_PUBLIC]: " frontend
  if [ -z $frontend ]; then
    frontend=$DEFAULT_FRONTEND_PUBLIC
  fi
fi

if [ -z $backend_public ]; then
  read -p "Enter public address of backend [$DEFAULT_BACKEND_PUBLIC]: " backend_public
  if [ -z $backend_public ]; then
    backend_public=$DEFAULT_BACKEND_PUBLIC
  fi
fi


if [ -z $backend_local ]; then
  read -p "Enter local address of backend [$DEFAULT_BACKEND_PUBLIC]: " backend_local
  if [ -z $backend_local ]; then
    backend_local=$DEFAULT_BACKEND_PUBLIC
  fi
fi

if [ -z $aiservice ]; then
  read -p "Enter local address of aiservice [$DEFAULT_AISERVICE_LOCAL]: " aiservice
  if [ -z $aiservice ]; then
    aiservice=$DEFAULT_AISERVICE_LOCAL
  fi
fi

echo "export SPACEPAL_FRONTEND_PUBLIC=$frontend
export SPACEPAL_BACKEND_PUBLIC=$backend_public # requires rebuild after changing
export SPACEPAL_BACKEND_LOCAL=$backend_local
export SPACEPAL_AISERVICE_LOCAL=$aiservice" > "$1"
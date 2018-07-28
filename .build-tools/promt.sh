#!/bin/bash

DEFAULT_FRONTEND="localhost:8080"
DEFAULT_BACKEND="localhost:3000"
DEFAULT_AISERVICE="localhost:3131"

frontend=$SPACEPAL_FRONTEND
backend=$SPACEPAL_BACKEND
aiservice=$SPACEPAL_AISERVICE

BLUE="\033[34m"
CLEAR="\033[0m"

printf "\n\n$BLUE Please, attention $CLEAR\n\n"

if [ -z $frontend ]; then
  read -p "Enter address of frontend [$DEFAULT_FRONTEND]: " frontend
  if [ -z $frontend ]; then
    frontend=$DEFAULT_FRONTEND
  fi
fi

if [ -z $backend ]; then
  read -p "Enter address of backend [$DEFAULT_BACKEND]: " backend
  if [ -z $backend ]; then
    backend=$DEFAULT_BACKEND
  fi
fi

if [ -z $aiservice ]; then
  read -p "Enter address of aiservice [$DEFAULT_AISERVICE]: " aiservice
  if [ -z $aiservice ]; then
    aiservice=$DEFAULT_AISERVICE
  fi
fi

echo "SPACEPAL_FRONTEND=$frontend
SPACEPAL_BACKEND=$backend
SPACEPAL_AISERVICE=$aiservice" > "$1"

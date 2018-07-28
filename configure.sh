#!/bin/bash
set -e
cd "$(dirname "$0")"

MF_VARS=./env.sh
BUILD_TOOLS=./.build-tools
BUILD_MF=$BUILD_TOOLS/_Makefile
CHECK_SCRIPT=$BUILD_TOOLS/check.sh
PROMT_SCRIPT=$BUILD_TOOLS/promt.sh

BLUE="\033[34m"
CLEAR="\033[0m"

bash "$CHECK_SCRIPT"
bash "$PROMT_SCRIPT" "$MF_VARS"
cp "$BUILD_MF" "./Makefile" -f

printf "\n\n Run ${BLUE}make${CLEAR} for build\n\n"
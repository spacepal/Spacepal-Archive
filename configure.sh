#!/bin/bash
set -e
cd "$(dirname "$0")"

MF_VARS=Makefile.variable
BUILD_TOOLS=./.build-tools
BUILD_MF=$BUILD_TOOLS/_Makefile
CHECK_SCRIPT=$BUILD_TOOLS/check.sh
PROMT_SCRIPT=$BUILD_TOOLS/promt.sh

bash "$CHECK_SCRIPT"
bash "$PROMT_SCRIPT" "$MF_VARS"
cp "$BUILD_MF" "./Makefile" -f

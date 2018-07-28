#!/bin/bash

AISERVICE_BIN=./aiservice
MICROSERVICES_DIR=Microservices
ENV=$1

cat  << EOF
#!/bin/bash
cd "\$(dirname "\$0")"
source "./$ENV"
cd "./$MICROSERVICES_DIR"
$AISERVICE_BIN -addr "\$SPACEPAL_AISERVICE_LOCAL"
EOF
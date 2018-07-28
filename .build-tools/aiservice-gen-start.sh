#!/bin/bash

AISERVICE_BIN=./aiservice
AISERVICE=$1

cat  << EOF
#!/bin/bash
cd "\$(dirname "\$0")"
$AISERVICE_BIN -addr "$AISERVICE"
EOF
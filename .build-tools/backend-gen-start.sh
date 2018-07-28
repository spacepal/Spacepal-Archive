#!/bin/bash

FRONTEND=$1
AISERVICE=$2

cat  << EOF
#!/bin/bash
export SPACEPAL_FRONTEND=$FRONTEND
export SPACEPAL_AISERVICE=$AISERVICE
cd "\$(dirname "\$0")"
rails s
EOF
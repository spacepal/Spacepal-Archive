#!/bin/bash

BACKEND_DIR=Backend
FRONTEND=$1
AISERVICE=$2
ENV=$3

cat  << EOF
#!/bin/bash
cd "\$(dirname "\$0")"
source "./$3"
LOCAL_PORT=\`echo "\$SPACEPAL_BACKEND_LOCAL" | sed -E 's/.*://'\`
LOCAL_HOST=\`echo "\$SPACEPAL_BACKEND_LOCAL" | sed -E 's/:.*//'\`
cd "./$BACKEND_DIR"
rails s -e production -p \$LOCAL_PORT -b \$LOCAL_HOST
EOF
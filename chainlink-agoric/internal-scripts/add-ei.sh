#!/bin/bash

source ./internal-scripts/common.sh

add_ei() {
  title "Adding External Initiator #$1 to Chainlink node..."

  CL_URL="http://localhost:669$1"

  login_cl "$CL_URL"

  THIS_VM_IP=$(hostname -I | cut -d' ' -f1)

  payload=$(
    cat <<EOF
{
  "name": "test-ei",
  "url": "http://$THIS_VM_IP:3000/jobs"
}
EOF
  )

  echo -n "Posting..."
  while true; do
    result=$(curl -s -b ./tmp/cookiefile -d "$payload" -X POST -H 'Content-Type: application/json' "$CL_URL/v2/external_initiators")
    [[ "$result" == null ]] || break
    echo -n .
    sleep 5
  done
  echo " done!"

  EI_IC_ACCESSKEY=$(jq -r '.data.attributes.incomingAccessKey' <<<"$result")
  EI_IC_SECRET=$(jq -r '.data.attributes.incomingSecret' <<<"$result")
  EI_CI_ACCESSKEY=$(jq -r '.data.attributes.outgoingToken' <<<"$result")
  EI_CI_SECRET=$(jq -r '.data.attributes.outgoingSecret' <<<"$result")

  tee ei-credentials.json << EOF
{
    "EI_IC_ACCESSKEY": "$EI_IC_ACCESSKEY",
    "EI_IC_SECRET": "$EI_IC_SECRET"
}
EOF

  AGORIC_SDK=$(find ~ -type d -name "agoric-sdk" | head -n 1)

  CONFIG_DIR=~/config
  CREDS_FILE=$CONFIG_DIR/ei_credentials.json

  if [ ! -d $CONFIG_DIR ]; then
        mkdir -p $CONFIG_DIR
  fi

  echo "Moving EI credentials to $CREDS_FILE"
  mv ei-credentials.json $CREDS_FILE

  echo "EI_IC_ACCESSKEY:$EI_IC_ACCESSKEY, EI_IC_SECRET:$EI_IC_SECRET"
  echo "EI has been added to Chainlink node"
  title "Done adding EI #$1"
}

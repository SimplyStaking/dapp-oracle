#!/bin/bash
set -e
source ./internal-scripts/common.sh

add_funds() {
  COSMOS_RPC_HOST=localhost
  COSMOS_RPC_PORT=26657
  echo -n "Waiting for $COSMOS_RPC_HOST:$COSMOS_RPC_PORT to come live..."
  while true; do
    block=$(curl -s http://$COSMOS_RPC_HOST:$COSMOS_RPC_PORT/status | jq -r .result.sync_info.latest_block_heigh>
    if test -z "$start"; then
      start=$block
    elif test $block -gt $start; then
      break
    fi
    echo -n '.'
    sleep 1
  done
  echo ' done!'

  HOSTPORT="localhost:689$1"
  AG_COSMOS_HELPER_OPTS=${AG_COSMOS_HELPER_OPTS-"--from=provision --keyring-dir=$PWD/../_agstate/keys --keyring->

  soloContainer=chainlink-agoric_ag-solo-node$1_1
  title "Waiting for $soloContainer..."
  while true; do
    if docker exec $soloContainer true; then
      break
    fi
    sleep 5
  done

  title "Transferring coins to ag-solo$1..."
  cmd=$(docker exec $soloContainer /usr/src/dapp-oracle/chainlink-agoric/get-transfer-command.sh $1)
  $cmd $AG_COSMOS_HELPER_OPTS --broadcast-mode block

  title "Provisioning ag-solo$1..."
  cmd=$(docker exec $soloContainer /usr/src/dapp-oracle/chainlink-agoric/get-provision-command.sh $1)
  $cmd $AG_COSMOS_HELPER_OPTS --broadcast-mode block

  echo "Funds added"
}
#!/bin/sh

THIS_DIR=$(cd `dirname $0`; pwd)

[ -z "$CONFIG_DIR" ] && CONFIG_DIR=$THIS_DIR/node-data/

[ ! -f "$CONFIG_DIR/config.generated.env" ] && touch $CONFIG_DIR/config.generated.env

. $CONFIG_DIR/config.env
. $CONFIG_DIR/config.generated.env

if [ -z "$POOL_ACCOUNT" ]; then
  echo You must create and account first
  exit 1
fi

if [ ! -f "$CONFIG_DIR/genesis.json" ]; then
  export POOL_ACCOUNT
  export CHAIN_ID
  cat $THIS_DIR/genesis.json.envsubst | envsubst > $CONFIG_DIR/genesis.json
else
  echo genesis.json already created
fi

if [ -z "$DATA_DIR" ]; then
  export DATA_DIR=$CONFIG_DIR/node1/
  [ -z "$DATA_DIR1" ] && export DATA_DIR1="$CONFIG_DIR/node1/"
  [ -z "$DATA_DIR2" ] && export DATA_DIR2="$CONFIG_DIR/node2/"
else
  if [ -z "$DATA_DIR2" -o "$DATA_DIR1" ]; then
    echo "when DATA_DIR is set, you must also set DATA_DIR{1,2}"
  fi
fi

if [ ! -f "$DATA_DIR1/geth/nodekey" ]; then
  echo "********* geth init node1"
  DATA_DIR="$DATA_DIR1" gethX init $CONFIG_DIR/genesis.json

else
  echo node1 already created
fi

if [ ! -f "$DATA_DIR2/geth/nodekey" ]; then
  echo "********* geth init node2"
  DATA_DIR="$DATA_DIR2" gethX init $CONFIG_DIR/genesis.json

else
  echo node2 already created
fi

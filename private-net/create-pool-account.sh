#!/bin/sh

THIS_DIR=$(cd `dirname $0`; pwd)

[ -z "$CONFIG_DIR" ] && CONFIG_DIR=$THIS_DIR/node-data/

mkdir -p  $CONFIG_DIR

[ -f $THIS_DIR/config.env ] && cp $THIS_DIR/config.env $CONFIG_DIR

[ ! -f "$CONFIG_DIR/config.generated.env" ] && touch $CONFIG_DIR/config.generated.env

. $CONFIG_DIR/config.generated.env


if [ ! -f $CONFIG_DIR/pass ]; then
  echo "$MASTER_PASS" > $CONFIG_DIR/pass
fi

if [ -z "$POOL_ACCOUNT" ]; then

  [ -z "$DATA_DIR" ] && export DATA_DIR=$CONFIG_DIR/node1/
  gethX account new --password $CONFIG_DIR/pass

  echo "POOL_ACCOUNT=$(gethX account list 2>/dev/null | grep -o -E  '\{[a-z0-9]{40}\}'  | sed 's/[{}]//g')" >> $CONFIG_DIR/config.generated.env

else

  echo account already created

fi
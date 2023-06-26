#!/bin/sh


mkdir -p bin/geth-dist

(
  cd bin/geth-dist
  curl -o - https://gethstore.blob.core.windows.net/builds/geth-alltools-linux-amd64-1.12.0-e501b3b0.tar.gz \
    | tar xz --strip-components=1
  chmod +x *

  cd bin/
  for i in geth-dist/[^C]*; do
    ln -sf $i $(basename $i)
  done
)


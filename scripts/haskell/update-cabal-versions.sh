#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "Supply single argument -- version to update CSL to"
    exit
fi

newVersion=$1

function updateVersion() {
  sed -E -i -e "s/^(version\:\s+)(.+)/\1$newVersion/" $1
}

updateVersion auxx/cryptokami-sl-auxx.cabal
updateVersion binary/cryptokami-sl-binary.cabal
updateVersion block/cryptokami-sl-block.cabal
updateVersion client/cryptokami-sl-client.cabal
updateVersion core/cryptokami-sl-core.cabal
updateVersion crypto/cryptokami-sl-crypto.cabal
updateVersion db/cryptokami-sl-db.cabal
updateVersion delegation/cryptokami-sl-delegation.cabal
updateVersion explorer/cryptokami-sl-explorer.cabal
updateVersion generator/cryptokami-sl-generator.cabal
updateVersion infra/cryptokami-sl-infra.cabal
updateVersion lib/cryptokami-sl.cabal
updateVersion lrc/cryptokami-sl-lrc.cabal
updateVersion node/cryptokami-sl-node.cabal
updateVersion networking/cryptokami-sl-networking.cabal
updateVersion ssc/cryptokami-sl-ssc.cabal
updateVersion tools/cryptokami-sl-tools.cabal
updateVersion txp/cryptokami-sl-txp.cabal
updateVersion update/cryptokami-sl-update.cabal
updateVersion util/cryptokami-sl-util.cabal
updateVersion wallet/cryptokami-sl-wallet.cabal

echo "Updated to version $newVersion"

#!/usr/bin/env bash
set -e
set -o pipefail

# Please see scripts/build/cryptokami-sl.sh for supported modes.

echo "Building Daedalus Bridge..."

# Cleaning node modules, bower components, etc.
./scripts/clean/daedalus-bridge.sh

# We have to build Cryptokami SL because there's a code in Haskell
# codebase that needs to be recompiled for Bridge building.
./scripts/build/cryptokami-sl.sh

echo "2. Generating types for Bridge..."
stack exec -- cryptokami-wallet-hs2purs

echo "3. Building Bridge..."
cd daedalus
npm install
npm run build:prod

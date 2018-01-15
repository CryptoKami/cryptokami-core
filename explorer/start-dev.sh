#!/usr/bin/env bash

# Remove logs
rm *.log

# Optional path for `cryptokami-sl`
cryptokami_path=${1:-../}

system_start=$((`date +%s` + 1))

./scripts/run.sh $cryptokami_path/scripts/common-functions.sh & PIDEX=$!
WALLET_TEST=1 $cryptokami_path/scripts/launch/demo-with-wallet-api.sh & PIDNODE=$!

wait $PIDEX
wait $PIDNODE

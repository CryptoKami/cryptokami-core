#!/usr/bin/env bash

# clear old data, don't remove the databases since they may contains some data
# that will help speed up the syncing process
rm -rf run/* node-* *key* *.dump

stack exec -- cryptokami-explorer \
    --system-start 1499246772 \
    --log-config log-config-prod.yaml \
    --logs-prefix "logs/qanet" \
    --db-path db-qanet \
    --kademlia-peer cryptokami-node-0.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-1.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-2.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-3.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-4.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-5.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-6.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-7.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-8.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-9.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-10.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-11.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-12.aws.iohkdev.io:3000 \
    --kademlia-peer cryptokami-node-13.aws.iohkdev.io:3000 \
    --listen 127.0.0.1:$((3000)) \
    --static-peers \
    --no-ntp \
    $@
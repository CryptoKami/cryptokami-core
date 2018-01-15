# How to Generate Blockchain

It is possible situation when blockchain is not advanced for more than `k` slots.
In this case we should generate it. Use `cryptokami-auxx` and command `generate-blocks` for it.

Launch `cryptokami-auxx`:

```
$ stack exec -- cryptokami-auxx                     \
    --system-start 0                             \
    --configuration-file node/configuration.yaml \
    --configuration-key mainnet_full             \
    --db-path some-db                            \
    repl
```

Then ensure you have all the needed keys imported (see `add-key` and 
`add-key-pool` commands). Next is running `generate-blocks <N>` command, where
`<N>` is number of blocks to generate. Transaction payload generation is 
disabled by default.

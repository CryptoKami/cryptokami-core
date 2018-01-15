# Cryptokami SL Scripts

This directory contains Bash scripts we use for different tasks (e.g. building, launching, CI).

## Build

* `build/cryptokami-sl.sh` - build Cryptokami SL, both in `dev` and `prod` modes.
* `build/daedalus-bridge.sh` - build Daedalus Bridge, for work with Daedalus wallet.

Please note that running mode depends on building mode! E.g. if you built Cryptokami SL in `dev`
mode, it will run in `dev` mode as well, and if you built it in `prod` mode, it will run in
`prod` mode as well.

## Launch

* `launch/demo.sh` - run nodes in `tmux`-session (3 nodes by default).
* `launch/demo-with-wallet-api.sh` - run nodes in `tmux`-session, with enabled wallet web API (3 nodes by default).
* `launch/kill-demo.sh` - kill `tmux`-session with running nodes.
* `launch/testnet-{public,staging}.sh` - connect one node to the cluster (testnet or testnet staging
* `launch/update-scenario.sh` - scenario for testing of update mechanism.
* `launch/wallet.sh` - helper script for `launch/update-scenario.sh`.

## Bench

* `bench/run-smart-generator.sh` - run [`cryptokami-smart-generator`](https://cryptokamidocs.com/technical/cli-options/#cryptokami-smart-generator).

## Analyze

* `analyze/blocks.sh` - analyze node logs: search information about block creation.
* `analyze/block-events.sh` - analyze node logs: search information about different block-related events.

## AVVM

* `avvm-files/full_blacklist.js` - file for `cryptokami-keygen`. It contains a list of blacklisted addresses.
* `avvm-files/utxo-dump-last-new.json` - file for `cryptokami-keygen`. It contains AVVM stakes data.

## Clean

* `clean/db.sh` - clean Cryptokami SL DB data.
* `clean/daedalus-bridge.sh` - clean Daedalus Bridge building artifacts.
* `clean/all.sh` - do previous steps and clean `.stack-work` directory as well (in this case full rebuilding is required).

## Generate

* `generate/certificates.sh` - generate certificates using [`postvend-app`](https://github.com/input-output-hk/postvend-app). Please make sure you have `postvend-cli` command in your `PATH`.
* `generate/genesis.sh` - generate keys using `cryptokami-keygen`.

## Haskell

* `haskell/lint.sh` - `hlint` command for Cryptokami SL source code. It uses `HLint.hs`-settings (from the project's root).
* `haskell/stylish.sh` - `stylish-haskell` command for Cryptokami SL source code.
* `haskell/update-cabal-versions.sh` - update Cryptokami SL version in all `.cabal`-files.
* `haskell/recover-from-stack-clean.sh` - useful if you're using Atom editor with `haskell-ghc-mod`.

## CI

Please note that these scripts are for CI only (we use Buildkite and AppVeyor). These scripts rely on specific environment variables, so manual running of these scripts on your machine is not implied.

* `ci/ci.sh` - main script for Buildkite CI.
* `ci/update-cli-docs.sh` - update [Cryptokami SL CLI Options](https://cryptokamidocs.com/technical/cli-options/) chapter.
* `ci/update-haddock.sh` - update Haddock-documentation for Cryptokami SL source code.
* `ci/update-wallet-web-api-docs.sh` - update [Cryptokami SL Wallet Web API](https://cryptokamidocs.com/technical/wallet/api/) chapter.
* `ci/update-explorer-web-api-docs.sh` - update [Cryptokami SL Explorer Web API](https://cryptokamidocs.com/technical/explorer/api/) chapter.
* `ci/appveyor-retry.cmd` - command we use in `appveyor.yml` configuration file.

## Common

* `common-functions.sh` - different Bash-functions we call in other scripts.
* `grep.sh` - search in Cryptokami SL source code.

## Log Configuration Templates

Directory `log-templates` contains different YAML-templates for logging configuration.

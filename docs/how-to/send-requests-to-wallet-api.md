# How to send requests to Wallet API

## Preparing

Clone [`cryptokami-sl`](https://github.com/CryptoKami/cryptokami-core/) repository:

```
$ git clone git@github.com:CryptoKami/cryptokami-sl.git
$ cd cryptokami-sl
```

Build it:

```
$ ./scripts/build/cryptokami-sl.sh
```

Run [`tmux`](https://github.com/tmux/tmux):

```
$ tmux
```

Then launch nodes:

```
$ ./scripts/launch/demo-with-wallet-api.sh
```

By default 3 nodes will be started.

## Send requests via curl

You can send requests via [`curl`](https://curl.haxx.se/) as well. Default port for the wallet API is `8090`.

Please note that since `cryptokami-sl-0.6` we are using TLS. This is an example of request (via SSL connection without certificate):

```
$ curl -k https://localhost:8090/api/settings/sync/progress
```

Possible response:

```
{"Right":{"_spLocalCD":{"getChainDifficulty":19273},"_spNetworkCD":{"getChainDifficulty":19273},"_spPeers":0}}
```

This is an example with the certificate:

```
curl --cacert /home/user/projects/cryptokami-core/scripts/tls-files/ca.crt http://localhost:8090/api/settings/sync/progress
```

Please see [online documentation for wallet API](https://cryptokamidocs.com/technical/wallet/api/) for complete information.

## Send requests via Postman

You can send requests using [Postman](https://www.getpostman.com/) program as well.

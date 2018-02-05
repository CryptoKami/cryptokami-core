# How to send requests to Explorer API

## Preparing

Clone [`cryptokami-sl`](https://github.com/CryptoKami/cryptokami-sl) repository:

```
$ git clone git@github.com:CryptoKami/cryptokami-sl.git
$ cd cryptokami-core/explorer
```

Build explorer:

```
$ ./scripts/build/cryptokami-sl.sh
```

Now you can run explorer in development mode.

Run [`tmux`](https://github.com/tmux/tmux):

```
$ tmux
```

Then run explorer:

```
$ ./start-dev.sh
``` 

For more details about installation and launching please see [Explorer README](https://github.com/CryptoKami/cryptokami-core/blob/master/explorer/README.md).

## Send requests via curl

You can send requests via [`curl`](https://curl.haxx.se/). Default port for explorer API is `8100`.

For example:

```
$ curl http://localhost:8100/api/blocks/pages/total
```

Possible response:

```
{"Right":0}
```

Please see [online documentation for Explorer API](https://cryptokamidocs.com/technical/explorer/api/) for complete information.

## Send requests via Postman

You can send requests using [Postman](https://www.getpostman.com/) program as well.

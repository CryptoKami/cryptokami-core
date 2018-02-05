# How to Build CryptoKami Core and Daedalus from Source Code

This manual describes how to build CryptoKami Core and Daedalus from the source code.

## CryptoKami Core and Daedalus

CryptoKami Core consists of a collection of binaries that constitute
the backend and the Electron-based wallet called “Daedalus”.

The source code of CryptoKami Core can be obtained from the
[official repository](https://github.com/CryptoKami/cryptokami-sl).

CryptoKami Core supports two ways for building itself:

-   (preferred) [Nix](https://nixos.org/nix/) package manager (backed by a binary cache by IOHK continuous integration)
-   [Stack](https://haskellstack.org) with Nix for system libraries

In any case, we strongly suggest using [Nix package manager](https://nixos.org/nix/download.html)
to get the correct dependencies for building CryptoKami Core. It will fetch the correct `openssl` version,
but won't override the system-installed version. The following commands assume that you already have
`stack` and `nix-*` programs.

### Binaries

As a result of building CryptoKami Core, you will get a set of components (binary files). This set includes
the main node for CryptoKami Core network and various helper tools. Please read
[this page of the documentation](https://cryptokamidocs.com/technical/cli-options/) for technical details.

## Common build steps

The following steps are shared between the two methods of building Cryptokami: fetching source and deciding
on a branch to be built.

Clone CryptoKami Core repository and go to the root directory:

    $ git clone https://github.com/CryptoKami/cryptokami-sl.git
    $ cd cryptokami-sl

Switch to the `master` branch:

    $ git checkout master

## Nix build mode (recommended)

First, prerequisite: install Nix (full instructions at https://nixos.org/nix/download.html):

    curl https://nixos.org/nix/install | sh

Two steps remain, then:

1.  To employ the signed IOHK binary cache:

        $ sudo mkdir -p /etc/nix
        $ sudo vi /etc/nix/nix.conf       # ..or any other editor, if you prefer

    ..and then add two following lines:

        binary-caches            = https://cache.nixos.org https://hydra.iohk.io
        binary-cache-public-keys = hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=

2.  Actually building the CryptoKami Core node (or, most likely, simply obtaining it
    from the IOHK's binary caches) can be performed by building the attribute `cryptokami-sl-static`:

        $ nix-build -A cryptokami-sl-static --cores 0 --max-jobs 2 --no-build-output --out-link master

    The build output directory will be symlinked as `master` (as specified by the command), and it will contain:

        $ ls master/bin
        cryptokami-node-simple

NOTE: the various other Cryptokami components can be obtained through other attributes:

-  `cryptokami-report-server-static`:
   - `cryptokami-report-server`
-  `cryptokami-sl-auxx`:
   - `cryptokami-auxx`
-  `cryptokami-sl-explorer-static`:
   - `cryptokami-explorer`, `cryptokami-explorer-swagger`, `cryptokami-explorer-mock`
-  `cryptokami-sl-tools-static`:
   - `cryptokami-analyzer`, `cryptokami-dht-keygen`, `cryptokami-genupdate`, `cryptokami-keygen`, `cryptokami-launcher`, `cryptokami-addr-convert`, `cryptokami-cli-docs`, `cryptokami-block-gen`, `cryptokami-post-mortem`
-  `cryptokami-sl-wallet`:
   - `cryptokami-node`, `cryptokami-swagger`

In general, for any given cabal `PACKAGE` provided by Cryptokami, there is a
corresponding Nix attribute for it -- `PACKAGE`, and sometimes, in case of
packages providing executables, the `PACKAGE-static` also provides a
statically-linked variation.

## Stack with Nix for system libraries (mixed mode)

Please, see the previous section on how to enable use of the IOHK binary cache.

Enter `nix-shell`:

    $ nix-shell

After that, in order to build CryptoKami Core with wallet capabilities, run the following script:

    [nix-shell:~/cryptokami-sl]$ ./scripts/build/cryptokami-sl.sh

Dependecy version collisions have been encountered on macOS. If you run into something
[like this](https://github.com/CryptoKami/cryptokami-core/issues/2230#issuecomment-354881696),
try running the following command from outside of a `nix-shell`

    $ nix-shell -p moreutils expect --run "unbuffer ./scripts/build/cryptokami-sl.sh | ts"

It is suggested having at least 8GB of RAM and some swap space for the build process. As the project
is fairly large and GHC parallelizes builds very effectively, memory and CPU consumption during the
build process is high. Please make sure you have enough free disk space as well.

After the project is built - it can take quite a long time -  the built binaries can be launched using
the `stack exec` command. Let's discuss important binaries briefly before proceeding to the next step.

## Stack build mode (for developers)

It is possible to build Cryptokami node with Stack only, without Nix.
Please note that in this case you have to install external dependencies
by yourself (see below).

### Install Stack

[Stack](https://docs.haskellstack.org/en/stable/README/) is a cross-platform program
for developing Haskell projects.

Recommended way, for all Unix-systems:

    $ curl -ssl https://get.haskellstack.org/ | sh

On macOS it is possible to install it with `brew`:

    $ brew install haskell-stack

### Setup Environment and Dependencies

To install Haskell compiler of required version run:

    $ stack setup

Then install C-preprocessor for Haskell:

    $ stack install cpphs

Finally install C-library for RocksDB.

On Ubuntu:

    $ sudo apt-get install librocksdb-dev

On macOS:

    $ brew install rocksdb

### Jemalloc Notice

Please make sure that you have [jemalloc](http://jemalloc.net/) package, version `4.5.0`.
If you have newer version of it - you will probably get linker errors during building.

### Building

Run the building script:

    $ cd cryptokami-sl
    [~/cryptokami-sl]$ ./scripts/build/cryptokami-sl.sh

## Daedalus Wallet

Let's proceed with building the wallet.

### Building Daedalus

Clone Daedalus repository and go to the root directory:

    [nix-shell:~/cryptokami-sl]$ cd
    [nix-shell:~]$ git clone https://github.com/CryptoKami/daedalus.git
    [nix-shell:~]$ cd daedalus
    [nix-shell:~/daedalus]$ npm install

### Running acceptance tests

To run acceptance tests one first has to have cluster running. We can run cluster on our machine with:

    $ tmux
    [nix-shell:~/cryptokami-sl]$ ./scripts/launch/demo-with-wallet-api.sh

**Important**: you have to build a node with Stack (using `./scripts/build/cryptokami-sl.sh`) to run this
script.

Then navigate to daedalus repo and run tests server with:

    [nix-shell:~/daedalus]$ npm run hot-server

and in the seperate terminal window run tests:

    [nix-shell:~/daedalus]$ npm run test

You should see acceptance tests being run for about 5 minutes. Note that acceptance tests will be actively
be taking window focus until they are finished. If it complains about `cryptokami-node.log` not existing just
create it in the path with:

    [nix-shell:~/daedalus]$ touch ~/.config/Daedalus/Logs/cryptokami-node.log

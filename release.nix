let
  fixedNixpkgs = (import ./lib.nix).fetchNixPkgs;
in
  { supportedSystems ? [ "x86_64-linux" "x86_64-darwin" ]
  , scrubJobs ? true
  , cryptokami ? { outPath = ./.; rev = "abcdef"; }
  , nixpkgsArgs ? {
      config = { allowUnfree = false; inHydra = true; };
      gitrev = cryptokami.rev;
    }
  }:

with (import (fixedNixpkgs + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
  packageSet = import ./.;
});

let
  iohkPkgs = import ./. { gitrev = cryptokami.rev; };
  stagingWalletdockerImage = (import fixedNixpkgs { config = {}; }).runCommand "${iohkPkgs.dockerImages.stagingWallet.name}-hydra" {} ''
    mkdir -pv $out/nix-support/
    cat <<EOF > $out/nix-support/hydra-build-products
    file dockerimage ${iohkPkgs.dockerImages.stagingWallet}
    EOF
  '';
  platforms = {
    cryptokami-core = supportedSystems;
    cryptokami-sl-auxx = supportedSystems;
    cryptokami-sl-node-static = supportedSystems;
    cryptokami-sl-tools = supportedSystems;
    cryptokami-sl-wallet = supportedSystems;
    cryptokami-sl-explorer-static = [ "x86_64-linux" ];
    cryptokami-report-server-static = [ "x86_64-linux" ];
    stack2nix = supportedSystems;
    purescript = supportedSystems;
    connectScripts.mainnetWallet   = [ "x86_64-linux" "x86_64-darwin" ];
    connectScripts.mainnetExplorer = [ "x86_64-linux" "x86_64-darwin" ];
    connectScripts.stagingWallet   = [ "x86_64-linux" "x86_64-darwin" ];
    connectScripts.stagingExplorer = [ "x86_64-linux" "x86_64-darwin" ];
  };
in (mapTestOn platforms) // {
  inherit stagingWalletdockerImage;
}

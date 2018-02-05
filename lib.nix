let
  # Allow overriding pinned nixpkgs for debugging purposes via cryptokami_pkgs
  fetchNixPkgs = let try = builtins.tryEval <cryptokami_pkgs>;
    in if try.success
    then builtins.trace "using host <cryptokami_pkgs>" try.value
    else import ./fetch-nixpkgs.nix;

  maybeEnv = env: default:
    let
      result = builtins.getEnv env;
    in if result != ""
       then result
       else default;

  pkgs = import fetchNixPkgs {};
  lib = pkgs.lib;
in lib // (rec {
  inherit fetchNixPkgs;
})

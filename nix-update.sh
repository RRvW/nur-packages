#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update nixpkgs-fmt
set -eu
set -o pipefail

nix-update nvc --version-regex '^r(.*)'
nix-update hdl_checker --version-regex 'v(.*)'

nixpkgs-fmt pkgs

let
  src = builtins.fetchTarball {
    # nixpkgs master as of 2021-05-07
    url = https://github.com/NixOS/nixpkgs/archive/63586475587d7e0e078291ad4b49b6f6a6885100.tar.gz;
    sha256 = "1323d6i478q9f2jbgijra7nhgkihyg7x4iyiirwjmxcr9wmzi7rs";
  };

in

import src

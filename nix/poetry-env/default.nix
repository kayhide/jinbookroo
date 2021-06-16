{ pkgs
, poetry2nix ? import ./poetry2nix.nix { pkgs = pkgs; }
}:

poetry2nix.mkPoetryEnv
{
  projectDir = ./.;
  overrides = [
    poetry2nix.defaultPoetryOverrides
    (self: super: {
      gigalixir = super.gigalixir.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          self.pytest-runner
        ];
      });
    })
  ];
}

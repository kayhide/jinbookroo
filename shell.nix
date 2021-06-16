{ overlays ? [ ]
}@args:

let
  nodejs-overlay = self: super: {
    my-nodejs = self.nodejs-14_x;
    my-yarn = super.yarn.override {
      nodejs = self.my-nodejs;
    };
  };

  poetry-env-overlay = self: super: {
    poetry-env = import ./nix/poetry-env { pkgs = self; };
  };

  env-overlay = self: super: {
    my-gigalixir = super.runCommand "my-gigalixir" { } ''
      mkdir -p $out/bin
      ln -s ${self.poetry-env}/bin/gigalixir $out/bin/gigalixir
    '';

    my-app-env = super.buildEnv {
      name = "my-app-env";
      paths = with self; [
        direnv
        docker-compose
        gnumake
        inotify-tools
        lazydocker
        overmind
        postgresql_12

        my-nodejs
        my-yarn
        my-gigalixir
      ];
    };
  };

  nixpkgs = import ./nix/nixpkgs.nix (args // {
    overlays = overlays ++ [
      nodejs-overlay
      poetry-env-overlay
      env-overlay
    ];
  });

  inherit (nixpkgs) pkgs;

in

pkgs.mkShell {
  buildInputs = with pkgs; [
    my-app-env
  ];
}

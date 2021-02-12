{ overlays ? []
}@args:

let
  inherit (nixpkgs) pkgs;

  nodejs-overlay = self: super: {
    my-nodejs = self.nodejs-14_x;
    my-yarn = super.yarn.override {
      nodejs = self.my-nodejs;
    };
  };

  env-overlay = self: super: {
    my-app-env = super.buildEnv {
      name = "my-app-env";
      paths = with self; [
        inotify-tools
        elixir

        direnv
        docker-compose
        git-lfs
        gnumake
        lazydocker
        overmind
        tmux

        my-nodejs
        my-yarn

        postgresql_12
      ];
    };
  };

  nixpkgs = import <nixpkgs> (args // {
    overlays = overlays ++ [
      nodejs-overlay
      env-overlay
    ];
  });

in

pkgs.mkShell {
  buildInputs = with pkgs; [
    my-app-env
  ];
}

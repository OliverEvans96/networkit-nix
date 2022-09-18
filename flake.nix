{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        networkit = pkgs.python3.pkgs.callPackage ./default.nix { };
        pythonEnv = pkgs.python3.withPackages (p: [ networkit p.ipython ]);
      in {
        apps.default = {
          type = "app";
          program = "${pkgs.hello}/bin/hello";
        };
        apps.ipython = {
          type = "app";
          program = "${pythonEnv}/bin/ipython";
        };
        packages.default = networkit;
      });
}

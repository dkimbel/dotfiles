{
  description = "Daniel Kimbel's complete, customized NixOS configuration";

  inputs = {
    pkgs = { url = "github:NixOS/nixpkgs/master"; };
  };

  outputs = { self, pkgs }: {
    nixosConfigurations = {
      # my personal laptop
      p51 = pkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./config.nix ];
      };
    };
  };
}

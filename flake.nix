{
  description = "Daniel Kimbel's complete, customized NixOS configuration";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/master"; };
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      # my personal laptop
      p51 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./config.nix ];
        specialArgs = { inherit self nixpkgs; };
      };
    };
  };
}

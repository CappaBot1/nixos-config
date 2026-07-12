{
  description = "CappaBot NixOS Configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    cappaos.url = "github:CappaBot1/CappaOS-Nix";
  };

  outputs = { self, nixpkgs, cappaos, ... }: {
    nixosConfigurations = {
      CameronThe3rd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./common.nix
          ./hosts/CameronThe3rd

          ./users/cappabot.nix

          cappaos.nixosModules.cinnamon
          cappaos.nixosModules.lightdm

          cappaos.nixosModules.inside-virtual-machine

          cappaos.nixosModules.base
          cappaos.nixosModules.base-graphical
          cappaos.nixosModules.development
          #cappaos.nixosModules.gaming
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./common.nix
          ./hosts/claptop

          ./users/cappabot.nix

          cappaos.nixosModules.base
          cappaos.nixosModules.base-graphical
          cappaos.nixosModules.development
          #cappaos.nixosModules.driftwm TODO: do this
          cappaos.nixosModules.cinnamon
          cappaos.nixosModules.lightdm
        ];
      };

      silver = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./common.nix
          ./hosts/silver

          ./users/cappabot.nix

          #cappaos.nixosModules.i3 # flameshot is broken so I'm not going to use i3
          #cappaos.nixosModules.ly # TODO: fix the error messages covering the password field
          cappaos.nixosModules.cinnamon
          cappaos.nixosModules.lightdm

          cappaos.nixosModules.base
          cappaos.nixosModules.base-graphical
        ];
      };

      rpi = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        modules = [
          ./common.nix
          ./hosts/rpi

          ./users/cappabot.nix

          cappaos.nixosModules.base
        ];
      };
    };
  };
}

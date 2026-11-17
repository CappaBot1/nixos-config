{ pkgs, ... }:
{
  fileSystems."/rpistorage" =
    { device = "/dev/disk/by-label/RPISTORAGE";
      fsType = "ext4";
    };

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/rpistorage/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+Rn51EQWHWelOhxCqdyjyBbOFoR3hffaHNuSoho90Q CameronThe3rd"
    ];
  };

  users.groups.git = {};
}

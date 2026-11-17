{ pkgs, ... }:
{
  fileSystems."/rpistorage" =
    { device = "/dev/disk/by-label/RPISTORAGE";
      fsType = "ext4";
    };
}

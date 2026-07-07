{ ... }:

{
  users.users = {
    "cappabot" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPasswordFile = "/etc/nixos/secrets/cappabot-password";
      description = "Casper Howse";
    };
  };
}


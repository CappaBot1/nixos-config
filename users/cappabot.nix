{ ... }:

{
  users.users = {
    "cappabot" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = "/etc/nixos/secrets/cappabot-password";
      description = "Casper Howse";
    };
  };
}


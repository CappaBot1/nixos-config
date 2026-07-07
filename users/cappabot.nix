{ lib, ... }:

let
  passwordFile = ./cappabot-password;
in
{
  users.users = {
    "cappabot" = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    }
    // (
      if builtins.pathExists passwordFile then {
        hashedPasswordFile = passwordFile;
      } else {
        
      };
    );
  };
}

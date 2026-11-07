{ ... }:

{
  users.users."guest" = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" ];
    password = "";
    description = "Guest";
  };
}


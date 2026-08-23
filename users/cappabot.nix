{ ... }:

{
  users.users."cappabot" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = "/etc/nixos/secrets/cappabot-password";
    description = "Casper Howse";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJlHerVMPtiuM2DrgOzHVb6U1NLFjRUzzqOAVpQ3mTdK usb0"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+Rn51EQWHWelOhxCqdyjyBbOFoR3hffaHNuSoho90Q CameronThe3rd"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArvh5RpBqlB+6sk6A1waJJb9DRfsosn816p+Ph3Cymz claptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICWzbDJSp36saVuayXk9feSEkYt/Muv8KH1ozBmO0waq cappaphone"
    ];
  };
}

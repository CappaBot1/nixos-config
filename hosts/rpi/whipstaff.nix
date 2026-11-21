{ pkgs, ... }:

{
  fileSystems."/rpistorage" = {
    device = "/dev/disk/by-label/RPISTORAGE";
    fsType = "ext4";
  };

  users.users.git = {
    isSystemUser = true;
    group = "git";
    home = "/rpistorage/git";
    createHome = true;
    shell = "${pkgs.git}/bin/git-shell";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHYEbLSlk3aMq9dQgqNYJO7JkUCsmwFsrACPWCoLV0JZ whipstaff@rpi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP+Rn51EQWHWelOhxCqdyjyBbOFoR3hffaHNuSoho90Q CameronThe3rd"
    ];
  };

  users.groups.git = { };

  users.users.whipstaff = {
    isSystemUser = true;
    group = "whipstaff";
    home = "/rpistorage/whipstaff-home";
    createHome = true;
  };

  users.groups.whipstaff = { };

  systemd.services.whipstaff-deploy = {
    description = "Deploy Whipstaff source code";

    requires = [ "network-online.target" ];
    after = [ "network-online.target" ];

    unitConfig.RequiresMountsFor = "/rpistorage";

    path = [
      pkgs.git
      pkgs.openssh
    ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "whipstaff";
      WorkingDirectory = "/rpistorage";

      ExecStart = pkgs.writeShellScript "whipstaff-deploy" ''
        if [ ! -d whipstaff/.git ]; then
          git clone git@localhost:whipstaff
        else
          cd whipstaff
          git pull
        fi
      '';
    };
  };

  systemd.services.whipstaff-nextjs-frontend = {
    description = "Whipstaff Next.js frontend";

    requires = [ "whipstaff-deploy.service" ];
    after = [ "whipstaff-deploy.service" ];

    path = [
      pkgs.deno
    ];

    serviceConfig = {
      Type = "simple";
      User = "whipstaff";
      WorkingDirectory = "/rpistorage/whipstaff/nextjs-frontend";

      ExecStartPre = [
        "${pkgs.deno}/bin/deno install --allow-scripts"
        "${pkgs.deno}/bin/deno task build"
      ];
      ExecStart = "${pkgs.deno}/bin/deno task start";

      Restart = "on-abnormal";
      RestartSec = 5;
    };
  };

  systemd.services.whipstaff-deno-backend = {
    description = "Whipstaff deno backend";

    requires = [ "whipstaff-deploy.service" ];
    after = [ "whipstaff-deploy.service" ];

    path = [
      pkgs.deno
    ];

    serviceConfig = {
      Type = "simple";
      User = "whipstaff";
      WorkingDirectory = "/rpistorage/whipstaff/deno-backend";

      ExecStart = "${pkgs.deno}/bin/deno task start";

      Restart = "on-abnormal";
      RestartSec = 5;
    };
  };

  systemd.targets.whipstaff = {
    description = "Whipstaff application";

    wantedBy = [ "multi-user.target" ];

    requires = [
      "whipstaff-deploy.service"
      "whipstaff-nextjs-frontend.service"
      "whipstaff-deno-backend.service"
    ];

    after = [ "whipstaff-deploy.service" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 56700 56701 ];
    allowedUDPPorts = [ 56700 56701 ];
  };
}

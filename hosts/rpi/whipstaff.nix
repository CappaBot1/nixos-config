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
    wantedBy = [ "whipstaff.target" ];

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
    description = "Whipstaff Next.js frontend server";

    requires = [ "whipstaff-deploy.service" ];
    after = [ "whipstaff-deploy.service" ];
    wantedBy = [ "whipstaff.target" ];

    path = [
      pkgs.deno
    ];

    serviceConfig = {
      Type = "simple";
      User = "whipstaff";
      WorkingDirectory = "/rpistorage/whipstaff/nextjs-frontend";

      ExecStartPre = "${pkgs.deno}/bin/deno install --allow-scripts";
      # ExecStartPre = "deno task build";
      # ExecStart = "deno task start";
      ExecStart = "${pkgs.deno}/bin/deno task dev";

      Restart = "always";
      RestartSec = 5;
      StartLimitIntervalSec = 3600;
      StartLimitBurst = 5;
    };
  };

  systemd.services.whipstaff-websocket = {
    description = "Whipstaff websocket server";

    requires = [ "whipstaff-deploy.service" ];
    after = [ "whipstaff-deploy.service" ];
    wantedBy = [ "whipstaff.target" ];

    path = [
      pkgs.deno
    ];

    serviceConfig = {
      Type = "simple";
      User = "whipstaff";
      WorkingDirectory = "/rpistorage/whipstaff/websocket";

      ExecStart = "${pkgs.deno}/bin/deno task serve";

      Restart = "always";
      RestartSec = 5;
      StartLimitIntervalSec = 3600;
      StartLimitBurst = 5;
    };
  };
}

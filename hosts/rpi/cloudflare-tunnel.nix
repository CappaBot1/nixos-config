{
  pkgs,
  config,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    cloudflared
  ];

  services.cloudflared = {
    enable = true;
    certificateFile = "/home/cappabot/.cloudflared/cert.pem";
    tunnels = {
      # to set ts up:
      # cloudflared login
      # cloudflared tunnel create pi
      # cloudflared tunnel route dns 4e26c2c9-8f94-4182-9a1d-d5230d2b93eb pi.cappabot.com
      "4e26c2c9-8f94-4182-9a1d-d5230d2b93eb" = {
        credentialsFile = "/home/cappabot/.cloudflared/4e26c2c9-8f94-4182-9a1d-d5230d2b93eb.json";
        ingress = {
          "pi.cappabot.com" = "http://localhost:8000";
          "pissh.cappabot.com" = "ssh://localhost:22";
        };
        default = "http_status:404";
      };
    };
  };
}

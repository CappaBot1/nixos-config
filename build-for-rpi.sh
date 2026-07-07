#sudo nixos-rebuild boot --target-host cappabot@192.168.88.11 --flake .#rpi --elevate=sudo --ask-elevate-password
sudo nixos-rebuild switch --target-host cappabot@192.168.88.11 --flake .#rpi --elevate=sudo --ask-elevate-password


#!/usr/bin/env bash

sudo nixos-rebuild switch --target-host cappabot@192.168.88.67 --flake .#rpi --sudo --ask-elevate-password --no-reexec


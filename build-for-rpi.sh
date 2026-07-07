#!/usr/bin/env bash

sudo nixos-rebuild switch --target-host cappabot@192.168.88.11 --flake .#rpi --sudo --ask-elevate-password --no-reexec


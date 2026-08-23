#!/usr/bin/env bash

nixos-rebuild switch --target-host cappabot@192.168.88.67 --flake .#rpi --sudo --ask-elevate-password --no-reexec


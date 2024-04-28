## Rebuild

```sh
sudo nixos-rebuild switch --flake .#desktop
```

## SOPS

### Age

```sh
# Generate private key
mkdir -p ~/.config/sops/age
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
# Generate public key
nix-shell -p ssh-to-age --run "ssh-to-age < ~/.ssh/id_ed25519.pub"
```
# nixos

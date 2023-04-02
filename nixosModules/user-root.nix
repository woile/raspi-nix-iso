{ inputs, ganix, ... }@flakeContext:
{ config, lib, pkgs, ... }:
let
  ssh_pub_files = lib.filterAttrs (k: v: v == "regular" && lib.hasSuffix ".pub" k) (builtins.readDir ../authorized_keys);
  ssh_files_list = lib.mapAttrsToList (k: v: builtins.readFile "${../authorized_keys}/${k}") ssh_pub_files;
in
{
  config = {
    users = {
      users = {
        "${ganix.username}" = {
          isNormalUser = true;
          initialPassword = "nixos";
          extraGroups = [ "wheel" "networkmanager" "docker" "podman" ];
          openssh.authorizedKeys.keys = ssh_files_list ++ ganix.ssh_key;
        };
      };
    };
  };
}

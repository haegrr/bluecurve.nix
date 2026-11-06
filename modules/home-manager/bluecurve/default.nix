{ importApply, ... }:
{
  imports = map importApply [
    # keep-sorted start case=no numeric=yes
    ./fonts.nix
    ./gtk.nix
    ./kde.nix
    ./mate.nix
    ./options.nix
    ./qt.nix
    ./xfce.nix
    # keep-sorted end
  ];
}

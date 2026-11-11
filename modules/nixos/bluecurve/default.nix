{ importApply, ... }:
{
  imports = map importApply [
    # keep-sorted start case=no numeric=yes
    ./fonts.nix
    ./lightdm.nix
    ./options.nix
    # keep-sorted end
  ];
}

{ pkgs, ... }:
let
  yaml = pkgs.formats.yaml { };
in
{
  runtimeInputs = with pkgs; [
    nixfmt
    keep-sorted
    yamlfmt
  ];

  settings = {
    formatter = {
      nixfmt = {
        command = "nixfmt";
        includes = [ "*.nix" ];
      };

      keep-sorted = {
        command = "keep-sorted";
        includes = [ "*" ];
      };

      yamlfmt =
        let
          settings.formatter = {
            retain_line_breaks = true;
            scan_folded_as_literal = true;
          };
        in
        {
          command = "yamlfmt";
          options = [
            "-conf=${yaml.generate "yamlfmt.conf" settings}"
          ];
          includes = [
            "*.yaml"
            "*.yml"
          ];
        };
    };
  };
}

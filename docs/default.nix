{ bluecurve, pkgs }:
let
  inherit (pkgs) lib;

  sourcePrefix = "${toString ./..}/";

  mkOptionDocs =
    module:
    let
      eval = lib.evalModules {
        modules = [
          module
          { _module.check = false; }
        ];
        specialArgs = { inherit pkgs; };
      };
    in
    pkgs.nixosOptionsDoc {
      options = eval.options.bluecurve;
      transformOptions =
        option:
        option
        // {
          declarations = map (
            declaration:
            let
              path = lib.removePrefix sourcePrefix (toString declaration);
            in
            {
              name = path;
              url = "https://github.com/haegrr/bluecurve.nix/blob/master/${path}";
            }
          ) option.declarations;
        };
    };

  homeManagerOptionDocs = mkOptionDocs bluecurve.homeModules.default;
  nixosOptionDocs = mkOptionDocs bluecurve.nixosModules.default;

  site =
    pkgs.runCommand "bluecurve-docs"
      {
        src = ./.;
        nativeBuildInputs = [ pkgs.zensical ];
      }
      ''
        cp -r --no-preserve=mode $src/. .
        {
          printf '# Home Manager options\n\n'
          cat ${homeManagerOptionDocs.optionsCommonMark}
        } > content/options.md
        {
          printf '# NixOS options\n\n'
          cat ${nixosOptionDocs.optionsCommonMark}
        } > content/nixos-options.md
        zensical build --strict
        mv site "$out"
      '';
in
{
  default = site;

  serve = pkgs.writeShellApplication {
    name = "bluecurve-docs-serve";
    runtimeInputs = [ pkgs.python3 ];
    text = ''
      exec python3 -m http.server --bind 127.0.0.1 --directory ${site} "$@"
    '';
  };
}

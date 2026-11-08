{ bluecurve, pkgs }:
let
  inherit (pkgs) lib;

  eval = lib.evalModules {
    modules = [
      bluecurve.homeModules.default
      { _module.check = false; }
    ];
  };

  sourcePrefix = "${toString ./..}/";

  optionDocs = pkgs.nixosOptionsDoc {
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

  site =
    pkgs.runCommand "bluecurve-docs"
      {
        src = ./.;
        nativeBuildInputs = [ pkgs.zensical ];
      }
      ''
        cp -r --no-preserve=mode $src/. .
        cp ${optionDocs.optionsCommonMark} content/options.md
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

{ lib, ... }:
let
  variants = [
    "Bluecurve"
    "Bluecurve-BerriesAndCream"
    "Bluecurve-Gnome"
    "Bluecurve-Grape"
    "Bluecurve-Lime"
    "Bluecurve-Slate"
    "Bluecurve-Strawberry"
    "Bluecurve-Tangerine"
  ];
in
{
  mkVariantOption =
    description:
    lib.mkOption {
      type = lib.types.enum variants;
      default = "Bluecurve";
      example = "Bluecurve-Slate";
      inherit description;
    };

  mkFontSizeOption = lib.mkOption {
    type = lib.types.ints.positive;
    default = 10;
    example = 12;
    description = "Point size for Bluecurve UI fonts.";
  };
}

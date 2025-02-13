{
  description = "https://github.com/filips123/PWAsForFirefox";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };
  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    lib = nixpkgs.lib;
  in {
    overlay = final: prev: {
      firefoxpwa = final.callPackage ./. {};
    };
    nixosModules = {
      default = ({overlay}: {nixpkgs.overlays = [overlay];}) {overlay = self.overlay;};
    };
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.callPackage ./. {};
      update = pkgs.writeShellApplication {
        name = "firefoxpwa-update";

        text = lib.escapeShellArgs [(lib.getExe pkgs.nix-update) "-F" "default"];
      };
    });
  };
}

{

  description = "Cloudflare setup flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        my-name = "my-script";
        my-buildInputs = with pkgs; [ cowsay ddate cloudflared ];
        my-script = (pkgs.writeScriptBin my-name
          (builtins.readFile ./run.sh)).overrideAttrs (old: {
            buildCommand = ''
              ${old.buildCommand}
               patchShebangs $out'';
          });
      in rec {
        defaultPackage = packages.my-script;
        packages.my-script = pkgs.symlinkJoin {
          name = my-name;
          paths = [ my-script ] ++ my-buildInputs;
          buildInputs = [ pkgs.makeWrapper ];
          postBuild =
            "wrapProgram $out/bin/${my-name} --prefix PATH : $out/bin";
        };       
 

devShell = with pkgs; mkShell {
          buildInputs = [ cloudflared ];
        };


        });




}


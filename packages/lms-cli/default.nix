{ stdenv, lib, fetchFromGitHub, nodejs_20, pnpm, writeShellScriptBin }:

let
  lms = fetchFromGitHub {
    owner = "lmstudio-ai";
    repo = "lms";
    rev = "v0.8.13";
    sha256 = "sha256-7JQZ9hgqzV4kXWjYpKzV4kXWjYpKzV4kXWjYpKzV4kXWjY="; # Update this after first build
  };

in stdenv.mkDerivation (
  {
    pname = "lms";
    version = "0.8.13";
    src = lms;

    meta = {
      description = "LM Studio CLI";
      homepage = "https://github.com/lmstudio-ai/lms";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ cmcraft ];
    };

    nativeBuildInputs = [ nodejs_20 pnpm ];

    buildPhase = ''
      export HOME=$PWD
      export PATH="$PATH:${nodejs_20}/bin"
      pnpm install
      pnpm run build
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp -r publish/cli/dist/index.js $out/bin/lms-cli.js
      ${writeShellScriptBin "lms" ''
        #!${nodejs_20}/bin/node
        exec ${nodejs_20}/bin/node $out/bin/lms-cli.js "$@"
      ''}
    '';
  }
)
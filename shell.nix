{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.python311Packages.virtualenv
    pkgs.azure-functions-core-tools
    pkgs.azure-cli
    pkgs.azurite
  ];

  shellHook = ''
    if [ ! -d "venv" ]; then
      virtualenv venv
    fi
    source venv/bin/activate
    pip install azure-functions grpcio
    which azurite
  '';
}

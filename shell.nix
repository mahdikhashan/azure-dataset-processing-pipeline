{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.python311
    pkgs.azure-cli
  ];

  shellHook = ''
    if [ ! -d "venv" ]; then
      virtualenv venv
    fi
    source venv/bin/activate

    pip install pre-commit ruff PyYAML
    pip install -r ./jobs/extract/requirements.txt

    ruff --version
    pre-commit install
  '';
}
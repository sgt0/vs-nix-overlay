{pkgs ? import <nixpkgs> {}}: {
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      alejandra
      nil
      nixd
    ];
  };
}

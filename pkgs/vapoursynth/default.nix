# Copyright (c) 2003-2025 Eelco Dolstra and the Nixpkgs/NixOS contributors
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
{
  lib,
  callPackage,
  vapoursynthVersions ? {},
}: let
  versions =
    {
      "67" = {
        hash = "sha256-be1NaaSks2aGXUPTCTSeaCkTnQEE7B58KZEiF1Ftv14=";
      };
      "68" = {
        hash = "sha256-PLdKaUpso0DQdEB6HzhanGk6JNgNIny0N43WoBC614Q=";
      };
      "69" = {
        hash = "sha256-T2bCVNH0dLM9lFYChXzvD6AJM3xEtOVCb2tI10tIXJs=";
      };
      "70" = {
        hash = "sha256-jkRjFKHNTekXluSKQ33QqsGRy7LKnkmG97U5WIjI6EM=";
      };
      "71" = {
        hash = "sha256-gFfkZaYIpQnDckYk6a8hGJCjBQxjjMIgzPZ4k2sVab4=";
      };
      "72" = {
        hash = "sha256-LRRz4471Rl/HwJ14zAkU/f2Acuofja8c0pGkuWihhsM=";
      };
    }
    // vapoursynthVersions;

  mkPackage = {
    version,
    hash,
  } @ args:
    callPackage ./generic.nix args;

  vapoursynthPackages =
    lib.mapAttrs' (
      version: args:
        lib.nameValuePair (lib.versions.majorMinor version) (mkPackage (args // {inherit version;}))
    )
    versions;
in
  vapoursynthPackages

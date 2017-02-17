{ stdenv, lib, fetchurl, fetchFromGitHub,
  makeRustPlatform, rustNightlyBin, rustc }:

# GIVEN UP FOR NOW. buildRustPackage requires that the source archive contains
# a `Cargo.lock` file, which the rust-clippy repository doesn't.

let

  # Clippy depends on specific nightly versions of rustc.

  nightlyVersion = "2017-02-07";
  nightlySHA256 = "1p7g594amphczqvvz3z5p6zysrvl1fgs2rrrlklg784ay9pgvrlz";

  updateDerivation = drv: lib.overrideDerivation drv (orig:
    let
      updateVersion = builtins.replaceStrings [orig.version] [nightlyVersion];
    in {
        name = updateVersion orig.name;
        version = nightlyVersion;
        src = fetchurl {
          urls = map updateVersion orig.src.urls;
          sha256 = nightlySHA256;
        };
    });

  updatePlatformComponent = name:
    lib.nameValuePair name (updateDerivation rustNightlyBin.${name});

  matchingNightly =
    lib.listToAttrs (map updatePlatformComponent ["rustc" "cargo"]);

  rustPlatform = makeRustPlatform matchingNightly;

in

rustPlatform.buildRustPackage rec {
  name = "rust-clippy-${version}";
  version = "0.0.114";

  src = fetchFromGitHub {
    owner = "Manishearth";
    repo = "rust-clippy";
    rev = "v${version}";
    sha256 = "1d8g1ihzgkgf76pq8vbva0y98h17id48lf4s1hyn0451vpmgyajm";
  };

  depsSha256 = "?";

  meta = {
    description = "A collection of lints to catch common mistakes and improve your Rust code";
    homepage = https://github.com/Manishearth/rust-clippy;
    license = stdenv.lib.licenses.mpl20;
    inherit (rustc.meta) platforms;
  };
}

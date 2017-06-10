{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  name = "azurescens-${version}";
  version = "unstable-2017-05-15";

  src = fetchFromGitHub {
    owner = "kmcallister";
    repo = "azurescens";
    rev = "1385d3d0ab4f8735c2cff2d60aa218b4bc05df5b";
    sha256 = "04k9nws26gwm4b1yk810s09s9ym2nyqkhf1hv7j1xmhb9vhbz0jm";
  };

  depsSha256 = "1y6vwz1fjxxwl3mx0szfsh396xpyc9zbaxdhvby82drnpbc4v5xa";

  buildInputs = [
    # What X11 libraries does it need?
  ];

  meta = {
    description = "A program that renders interactive fractal-like animations";
    longDescription = ''
      azurescens renders interactive fractal-like animations. Not recommended
      for people with photosensitive epilepsy! Currently it is a simple toy,
      and a platform for experimentation. It will probably grow more behaviors
      over time.
    '';
    homepage = "https://github.com/kmcallister/azurescens";
    license = with stdenv.lib.licenses; [ mit asl20 ];
    platforms = stdenv.lib.platforms.all;
  };
}

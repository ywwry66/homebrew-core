class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.11.tar.gz"
  sha256 "acc8809b457935a44c4dcaf0ee505ada23594f08aa2ae610acb6f2355afd550a"
  license "Apache-2.0"

  bottle do
    sha256 arm64_sequoia:  "251d2c9161417f983ae5a4b3ca87de9036a9ab7c79f035f844d19db6692f2c7a"
    sha256 arm64_sonoma:   "268184d4b2841c3ca7a628f46f6f3416c3b157d9a6e147919fee79d88cd3d8e4"
    sha256 arm64_ventura:  "7d74c52ec6cb707835dc2f8a8347a8f86c19734780ed1d0075498ea3e9df1e36"
    sha256 arm64_monterey: "8761f825116a80d267288ee0872b69737fc47091bae9fe8a6243890621b4fa5a"
    sha256 sonoma:         "ba482b4d958ff4a7b37ed1b253f3012f518c9a3ea490d808f2d7ad63a6c95e1b"
    sha256 ventura:        "d3f64dc8a97d7a121d9569286612701aec7d69a17c14ec935ad61817456ba7b1"
    sha256 monterey:       "85552f9371f2872315506771205d3dd07179113e05d9bd78dc8281eb1a052085"
    sha256 x86_64_linux:   "16226399f732430e271d3567bf55de6f4b346e324897d5d5f10753e2f1fad377"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin/"notcurses-info", 1)
  end
end

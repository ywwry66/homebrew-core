class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.2.8.tar.gz"
  sha256 "38b70431955c6977447eaa400d63eb78ae9adaa48649f7048461e4a675c5dcd0"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "a873612084526aa9e897100cd2f7ce60aa1f1b882b94bfa7f9748e1ab7e16726"
    sha256 arm64_sequoia: "e73e0045f46c85a525f3073da45bee47593dc3c2bf734b4efcdab3255d9d7362"
    sha256 arm64_sonoma:  "4c290189efbd517349c689a82d14759c5b86d78ebf329c9d8dff0446b9792604"
    sha256 sonoma:        "4187891ce7b2eebd74ee610978cad0dee2cac8a2405b7221def646e235cfd084"
    sha256 arm64_linux:   "d03e92b4bfcd1b7c6ad457792fd221a98757e42bcba64b1aeb8e4c4d5b4759b2"
    sha256 x86_64_linux:  "441748fcb009c5976cdbae7dc33bf50f06cd004ceec6a22c9ad8ea2fe210545b"
  end

  depends_on "pkgconf" => :build
  depends_on "chafa"
  depends_on "faad2"
  depends_on "fftw"
  depends_on "glib"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"
  depends_on "opusfile"
  depends_on "taglib"

  uses_from_macos "curl"

  on_macos do
    depends_on "gdk-pixbuf"
    depends_on "gettext"
  end

  on_linux do
    depends_on "libnotify"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "LANGDIRPREFIX=#{prefix}"
    man1.install "docs/kew.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"

    (testpath/".config/kew").mkpath
    (testpath/".config/kew/kewrc").write ""

    system bin/"kew", "path", testpath

    output = shell_output("#{bin}/kew song")
    assert_match "No Music found.\nPlease make sure the path is set correctly", output

    assert_match version.to_s, shell_output("#{bin}/kew --version")
  end
end

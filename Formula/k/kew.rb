class Kew < Formula
  desc "Command-line music player"
  homepage "https://github.com/ravachol/kew"
  url "https://github.com/ravachol/kew/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "637592254278500ddcd69bf20143818277681c7de63c06781c258f54be37dfbc"
  license "GPL-2.0-or-later"
  head "https://github.com/ravachol/kew.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "75e2950ecd5317b942cd245ca0667c1313f5faba36072ea1641630aee85bac33"
    sha256 arm64_sequoia: "ef55017b01ee4e2ed50942e7a49d50c409c7cb0fd8a5ee580d22a95fc0d97a0c"
    sha256 arm64_sonoma:  "acf70572b35016bd63fcd8dee752112cfe1a4299abf11cc224bc46d3e4ed2772"
    sha256 arm64_linux:   "af8547261f4598459de8893e405b61e56fbf915419615a8712edffd2676dcb4c"
    sha256 x86_64_linux:  "16700b8475a28fa530a3642ff8dfea1b8c1c0010e7fc03af73d2b8296c8798a5"
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

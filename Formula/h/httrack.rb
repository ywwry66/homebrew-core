class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://github.com/xroche/httrack/releases/download/3.50.0/httrack-3.50.0.tar.gz"
  sha256 "8d86694cc84cf25c00fc544c090c3c0605102be9b30020f28533ab3c4f7008fe"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "3f9b735a8f5d059152d35681f844e918e077fcc2497e9af1d2bf2f4a662538fe"
    sha256 arm64_sequoia: "17ff2c27790400d29ddaa7f5a8778faf42ef2a643fbe823ee799ab2ffd4d92ae"
    sha256 arm64_sonoma:  "7f8788b5bc114c036fb8d67e26e470b31bdf758fe6409b99d1197d63ea6bbe62"
    sha256 arm64_linux:   "ec604f4544552630ffd3076e4102966f756d3b6b277ba8c2b3f5b7fc25c43f01"
    sha256 x86_64_linux:  "89c18bc54ba52199d6ef946c277ee24538708c838a5a0c6b6ab6c48f34675b3b"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end

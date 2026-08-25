class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8317.tgz"
  version "8.317"
  sha256 "1ae551d14dac495ddfe6b344792035ebe410fe6c6004d44a335e0ece0e745adf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256  arm64_tahoe:   "1254d29f44c58c38080f054bd2341fc93656a5c109e1fca5ad5d88c66eb3f275"
    sha256  arm64_sequoia: "aaa62ca8c835af290e8fc06b6536a03b9961b0a23cced3ef7c9789748ef55b19"
    sha256  arm64_sonoma:  "fbc6e3f328264e825420de00f817fde3f9afe7ff87dd3a05f229e1147b5fa5c3"
    sha256  sonoma:        "24ebb6e7f4597424eecaeec1803205ac5b000e9fa5d7caf449e463b927e2d651"
    sha256  arm64_linux:   "a11272e81563f679c978e471ce9da285d148f19edc83ff5afbe55e0b0c7bd1b5"
    sha256  x86_64_linux:  "2a3b4b0846b766c5428bae60d3e46d62ef7c171f205ba1e44f22d75252f0ad2f"
  end

  depends_on "rsync" => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include "Pythia8/Pythia.h"

      int main() {
        Pythia8::Pythia pythia;
        return pythia.settings.mode("Beams:idA") == 2212 ? 0 : 1;
      }
    CPP

    flags = shell_output("#{bin}/pythia8-config --cxxflags --libs").split
    system ENV.cxx, "test.cc", "-o", "test", *flags
    system "./test"
  end
end

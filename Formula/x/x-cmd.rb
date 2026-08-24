class XCmd < Formula
  desc "Bootstrap 1000+ command-line tools in seconds"
  homepage "https://x-cmd.com"
  url "https://github.com/x-cmd/x-cmd/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "5d8b92690df989ef5d6f3c162e752bd11194d4233c6f31e50a85b14ae73afa3b"
  license all_of: ["Apache-2.0", "MIT", "BSD-3-Clause"]
  head "https://github.com/x-cmd/x-cmd.git", branch: "X"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cf69e30e287ebf07d5f763f09a9666baf4800c3d19a536a7d81812da83e72c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cf69e30e287ebf07d5f763f09a9666baf4800c3d19a536a7d81812da83e72c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4cf69e30e287ebf07d5f763f09a9666baf4800c3d19a536a7d81812da83e72c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2af0656b85df1fc704200e309a80b92ccbd174a3c04cddfc35fc07c4525515f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6170950334d4c71b7a4b18bdadb02e767861a7b436e20b0842921d74b17f6439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6170950334d4c71b7a4b18bdadb02e767861a7b436e20b0842921d74b17f6439"
  end

  def install
    prefix.install Dir.glob("*")
    prefix.install Dir.glob(".x-cmd")
    inreplace prefix/"mod/x-cmd/lib/bin/x-cmd", "/opt/homebrew/Cellar/x-cmd/latest", prefix.to_s
    bin.install prefix/"mod/x-cmd/lib/bin/x-cmd"
  end

  test do
    assert_match "Welcome to x-cmd", shell_output("#{bin}/x-cmd 2>&1")
    assert_match "hello", shell_output("#{bin}/x-cmd cowsay hello")
  end
end

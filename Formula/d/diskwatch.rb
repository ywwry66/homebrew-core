class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e595d7e70d729221b00709502c429d0a6b7cebc4d7b37be320c659605254f51d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbcd3362fa974a7d46d9031742685967c545cf52d452814940a86071d21b1f89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84aa0be690e8743ee554857bd7ac82e3210bf1a1be90feb7b4aff857898eab03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c81a7b626e0e9500b8de94b8cff4464a8347000161f03d2dc0c5068f81ebe928"
    sha256 cellar: :any_skip_relocation, sonoma:        "89848b0a69b78c637f09f36775619b8b6465548e5a50cc549e1603dd9667b244"
    sha256 cellar: :any,                 arm64_linux:   "8bfacd54a7732b047adf938f5fe95c912333c3bfb0a47b4905657e84d47e9f01"
    sha256 cellar: :any,                 x86_64_linux:  "81e5953751afc47fcedcde86f467b87a42d4be02d6505b93a915c58aa048fac0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end

class Asn < Formula
  desc "Organization lookup and server tool (ASN / IPv4 / IPv6 / Prefix / AS Path)"
  homepage "https://github.com/nitefood/asn"
  url "https://github.com/nitefood/asn/archive/refs/tags/v0.81.1.tar.gz"
  sha256 "43680a3b77cae81ff86210fdd42bc1c9d9e17dbec58a7c6772eb8b7b0188de25"
  license "MIT"
  head "https://github.com/nitefood/asn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "754595e170e41f17a9788994c7a9f7ed0db9aff55f62404fdf9c103c92b9b042"
  end

  depends_on "aha"
  depends_on "coreutils"
  depends_on "grepcidr"
  depends_on "ipcalc"
  depends_on "mtr"
  depends_on "nmap"

  uses_from_macos "jq", since: :sequoia
  uses_from_macos "whois"

  on_macos do
    depends_on "bash" # Bash 4.2+
  end

  on_linux do
    depends_on "bind" # for `host`
  end

  def install
    bin.install "asn"
    man1.install "asn.1"
  end

  test do
    test_ip = "8.8.8.8"
    output = shell_output("#{bin}/asn #{test_ip} 2>&1")
    assert_match "ASN lookup for #{test_ip}", output
  end
end
